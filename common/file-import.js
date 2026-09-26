/**
 * 导入工具模块
 * ------------------------------------------------------------
 * 解决 App 端两个导入痛点：
 * 1) uni-app 的 textarea 不显式设置 maxlength 时默认为 140，长文本会被截断
 *    -> 页面层需给 textarea 加 maxlength="-1"
 * 2) App 端 uni.chooseFile 不支持选择非媒体文件
 *    -> Android 用 Native.js 调起系统文件选择器(ACTION_GET_CONTENT)
 *    -> 兜底用 plus.io 扫描常见目录自建选择列表
 *    -> 再兜底用剪贴板粘贴
 *
 * 对外方法：
 *   readFileText(path)        读取本地文本文件
 *   listJsonFiles()           扫描常见目录，返回 .json/.txt 文件列表
 *   pickJsonFile()            调起系统文件选择器读取文本（Android）
 *   readClipboardText()       读取剪贴板文本
 *   writeTextFile(dir, name, text)  写文本文件（导出用）
 *   parseCoursesText(text)    容错解析 -> 课程数组
 *   parseBackupText(text)     容错解析 -> 完整备份对象
 */

const REQ_PICK_FILE = 20240919

// 常见 JSON/文本存放目录（App 私有目录 + 公共下载目录）
const SCAN_DIRS = [
    '_downloads',
    '_doc',
    '_documents',
    'file:///storage/emulated/0/Download',
    'file:///storage/emulated/0/Documents',
    'file:///storage/emulated/0/Download/StudyReminder',
    'file:///storage/emulated/0/Backup',
    'file:///storage/emulated/0/'
]

const TEXT_EXT = ['.json', '.txt', '.js']

export function isApp() {
    return typeof plus !== 'undefined'
}

export function isAndroid() {
    return isApp() && plus.os && plus.os.name === 'Android'
}

/**
 * 读取本地文本文件内容
 * @param {String} path 支持 _doc/xxx、file:///sdcard/... 等 plus.io 可识别的路径
 * @returns {Promise<String>}
 */
export function readFileText(path) {
    return new Promise((resolve, reject) => {
        if (!isApp()) {
            reject(new Error('仅支持 App 环境读取文件'))
            return
        }
        plus.io.resolveLocalFileSystemURL(path, function (entry) {
            entry.file(function (file) {
                const reader = new plus.io.FileReader()
                reader.onloadend = function (e) {
                    const result = e && e.target ? e.target.result : ''
                    resolve(String(result || ''))
                }
                reader.onerror = function (e) {
                    reject(e || new Error('读取文件失败'))
                }
                try {
                    reader.readAsText(file, 'utf-8')
                } catch (e) {
                    reject(e)
                }
            }, function (e) {
                reject(e || new Error('获取文件失败'))
            })
        }, function (e) {
            reject(e || new Error('文件路径不存在: ' + path))
        })
    })
}

/**
 * 列出某个目录下的条目（分页读取，带轮次上限）
 */
function _readDirEntries(dirEntry) {
    return new Promise((resolve) => {
        const all = []
        let rounds = 0
        try {
            const reader = dirEntry.createReader()
            const step = function () {
                if (rounds++ > 20) {
                    resolve(all)
                    return
                }
                reader.readEntries(function (entries) {
                    if (!entries || entries.length === 0) {
                        resolve(all)
                        return
                    }
                    for (let i = 0; i < entries.length; i++) all.push(entries[i])
                    step()
                }, function () {
                    resolve(all)
                })
            }
            step()
        } catch (e) {
            resolve(all)
        }
    })
}

/**
 * 扫描常见目录，列出 JSON/文本文件
 * @returns {Promise<Array<{name:String,path:String}>>}
 */
export function listJsonFiles() {
    return new Promise((resolve) => {
        if (!isApp()) {
            resolve([])
            return
        }
        const result = []
        const seen = {}
        let pending = SCAN_DIRS.length
        const done = function () {
            pending--
            if (pending <= 0) resolve(result)
        }
        for (let i = 0; i < SCAN_DIRS.length; i++) {
            const dir = SCAN_DIRS[i]
            plus.io.resolveLocalFileSystemURL(dir, function (dirEntry) {
                _readDirEntries(dirEntry).then(function (entries) {
                    for (let j = 0; j < entries.length; j++) {
                        const entry = entries[j]
                        const name = entry.name || ''
                        const lower = name.toLowerCase()
                        let hit = false
                        for (let k = 0; k < TEXT_EXT.length; k++) {
                            if (lower.length > TEXT_EXT[k].length && lower.lastIndexOf(TEXT_EXT[k]) === lower.length - TEXT_EXT[k].length) {
                                hit = true
                                break
                            }
                        }
                        if (!hit) continue
                        const path = entry.fullPath || (dir.replace(/\/$/, '') + '/' + name)
                        if (seen[path]) continue
                        seen[path] = true
                        result.push({ name: name, path: path })
                    }
                    done()
                })
            }, function () {
                done()
            })
        }
        if (SCAN_DIRS.length === 0) resolve(result)
    })
}

/**
 * 通过 MediaStore 查询 content:// 的真实路径（Android 10 以下有效）
 */
function _queryDataColumn(uri) {
    try {
        plus.android.importClass('android.content.ContentResolver')
        const main = plus.android.runtimeMainActivity()
        const cr = plus.android.invoke(main, 'getContentResolver')
        const cursor = plus.android.invoke(cr, 'query', uri, ['_data'], null, null, null)
        if (!cursor) return null
        try {
            if (plus.android.invoke(cursor, 'moveToFirst')) {
                const idx = plus.android.invoke(cursor, 'getColumnIndex', '_data')
                if (idx >= 0) return plus.android.invoke(cursor, 'getString', idx)
            }
        } finally {
            try { plus.android.invoke(cursor, 'close') } catch (e) { /* ignore */ }
        }
    } catch (e) {
        /* ignore */
    }
    return null
}

/**
 * 通过 ContentResolver 流式读取 URI 文本（兜底方案，Android 10+ 分区存储适用）
 */
function _readUriByStream(uri) {
    return new Promise((resolve, reject) => {
        try {
            plus.android.importClass('android.content.ContentResolver')
            const main = plus.android.runtimeMainActivity()
            const cr = plus.android.invoke(main, 'getContentResolver')
            const input = plus.android.invoke(cr, 'openInputStream', uri)
            if (!input) {
                reject(new Error('无法打开文件流'))
                return
            }
            plus.android.importClass('java.io.InputStreamReader')
            plus.android.importClass('java.io.BufferedReader')
            const reader = plus.android.newObject('java.io.BufferedReader',
                plus.android.newObject('java.io.InputStreamReader', input, 'UTF-8'))
            const sb = plus.android.newObject('java.lang.StringBuilder')
            let line = plus.android.invoke(reader, 'readLine')
            let guard = 0
            while (line != null && guard++ < 200000) {
                plus.android.invoke(sb, 'append', line)
                plus.android.invoke(sb, 'append', '\n')
                line = plus.android.invoke(reader, 'readLine')
            }
            try { plus.android.invoke(reader, 'close') } catch (e) { /* ignore */ }
            const text = plus.android.invoke(sb, 'toString')
            resolve(String(text || ''))
        } catch (e) {
            reject(e || new Error('流式读取失败'))
        }
    })
}

/**
 * 读取 URI 指向的文本内容（多策略降级）
 */
async function _readUriText(uri) {
    const uriStr = String(plus.android.invoke(uri, 'toString'))

    // 策略1：本身是 file:// 路径
    if (uriStr.indexOf('file:') === 0) {
        try {
            return await readFileText(uriStr)
        } catch (e) { /* 继续下一策略 */ }
    }

    // 策略2：HBuilderX 3.9.12+ 提供的 URI 转路径 API
    if (typeof plus.android.resolveNativeUri === 'function') {
        try {
            const realPath = plus.android.resolveNativeUri(uri)
            if (realPath) {
                try {
                    return await readFileText(realPath)
                } catch (e) { /* 继续下一策略 */ }
            }
        } catch (e) { /* ignore */ }
    }

    // 策略3：MediaStore _data 列
    const dataPath = _queryDataColumn(uri)
    if (dataPath) {
        try {
            return await readFileText(dataPath)
        } catch (e) { /* 继续下一策略 */ }
    }

    // 策略4：plus.io 直接解析
    try {
        return await readFileText(uriStr)
    } catch (e) { /* 继续下一策略 */ }

    // 策略5：流式读取
    return await _readUriByStream(uri)
}

/**
 * 获取 URI 的展示文件名
 */
function _getDisplayName(uri) {
    try {
        plus.android.importClass('android.content.ContentResolver')
        const main = plus.android.runtimeMainActivity()
        const cr = plus.android.invoke(main, 'getContentResolver')
        const cursor = plus.android.invoke(cr, 'query', uri, null, null, null, null)
        if (cursor) {
            try {
                if (plus.android.invoke(cursor, 'moveToFirst')) {
                    const idx = plus.android.invoke(cursor, 'getColumnIndex', '_display_name')
                    if (idx >= 0) {
                        const n = plus.android.invoke(cursor, 'getString', idx)
                        if (n) return String(n)
                    }
                }
            } finally {
                try { plus.android.invoke(cursor, 'close') } catch (e) { /* ignore */ }
            }
        }
    } catch (e) { /* ignore */ }
    try {
        const p = String(plus.android.invoke(uri, 'getPath'))
        if (p) return p.split('/').pop()
    } catch (e) { /* ignore */ }
    return ''
}

/**
 * Android：调起系统文件选择器选择文件并读取文本
 * @returns {Promise<{name:String,text:String,path:String}>}
 */
function _pickAndroidFile() {
    return new Promise((resolve, reject) => {
        try {
            const main = plus.android.runtimeMainActivity()
            const Intent = plus.android.importClass('android.content.Intent')
            const intent = new Intent(Intent.ACTION_GET_CONTENT)
            intent.addCategory(Intent.CATEGORY_OPENABLE)
            intent.setType('*/*')

            let settled = false
            const finish = function (fn, arg) {
                if (settled) return
                settled = true
                fn(arg)
            }

            main.onActivityResult = function (requestCode, resultCode, data) {
                if (requestCode !== REQ_PICK_FILE) return
                if (resultCode !== -1 || !data) {
                    finish(reject, new Error('未选择文件或已取消'))
                    return
                }
                try {
                    const uri = plus.android.invoke(data, 'getData')
                    if (!uri) {
                        finish(reject, new Error('未获取到文件'))
                        return
                    }
                    const name = _getDisplayName(uri)
                    _readUriText(uri).then(function (text) {
                        finish(resolve, { name: name || 'selected_file.json', text: text, path: String(plus.android.invoke(uri, 'toString')) })
                    }).catch(function (e) {
                        finish(reject, e)
                    })
                } catch (e) {
                    finish(reject, e)
                }
            }

            plus.android.invoke(main, 'startActivityForResult', intent, REQ_PICK_FILE)
        } catch (e) {
            reject(e || new Error('调起文件选择器失败'))
        }
    })
}

/**
 * 统一的文件选择入口
 * - H5：uni.chooseFile
 * - App(Android)：系统文件选择器
 * - iOS / 其它：抛错，由调用方降级到剪贴板或目录列表
 */
export function pickJsonFile() {
    // #ifdef H5
    return new Promise((resolve, reject) => {
        uni.chooseFile({
            count: 1,
            extension: ['.json', '.txt'],
            success: function (res) {
                const file = res.tempFiles && res.tempFiles[0]
                const path = (res.tempFilePaths && res.tempFilePaths[0]) || (file && file.path)
                if (!path) {
                    reject(new Error('未获取到文件路径'))
                    return
                }
                // H5 下用 FileReader 读取
                try {
                    const xhr = new XMLHttpRequest()
                    xhr.open('GET', path, true)
                    xhr.onload = function () {
                        resolve({ name: (file && file.name) || 'file.json', text: String(xhr.responseText || ''), path: path })
                    }
                    xhr.onerror = function () { reject(new Error('读取文件失败')) }
                    xhr.send()
                } catch (e) {
                    reject(e)
                }
            },
            fail: function (e) {
                reject(e || new Error('选择文件失败'))
            }
        })
    })
    // #endif

    // #ifndef H5
    if (!isApp()) {
        return Promise.reject(new Error('当前环境不支持文件选择，请改用剪贴板粘贴'))
    }
    if (!isAndroid()) {
        return Promise.reject(new Error('iOS 暂不支持系统文件选择器，请改用剪贴板粘贴'))
    }
    return _pickAndroidFile()
    // #endif
}

/**
 * 读取系统剪贴板文本
 */
export function readClipboardText() {
    return new Promise((resolve, reject) => {
        uni.getClipboardData({
            success: function (res) {
                resolve(String((res && res.data) || ''))
            },
            fail: function (e) {
                reject(e || new Error('读取剪贴板失败'))
            }
        })
    })
}

/**
 * 写入文本文件（导出用）
 * @param {String} dir 目录，如 '_downloads'
 * @param {String} fileName 文件名
 * @param {String} text 内容
 */
export function writeTextFile(dir, fileName, text) {
    return new Promise((resolve, reject) => {
        if (!isApp()) {
            reject(new Error('仅支持 App 环境写入文件'))
            return
        }
        const targetDir = dir || '_downloads'
        plus.io.resolveLocalFileSystemURL(targetDir, function (dirEntry) {
            dirEntry.getFile(fileName, { create: true }, function (fileEntry) {
                fileEntry.createWriter(function (writer) {
                    writer.onwrite = function () {
                        resolve(fileEntry.fullPath || (targetDir + '/' + fileName))
                    }
                    writer.onerror = function (e) {
                        reject(e || new Error('写入文件失败'))
                    }
                    writer.write(text)
                }, function (e) {
                    reject(e || new Error('创建文件写入器失败'))
                })
            }, function (e) {
                reject(e || new Error('创建文件失败'))
            })
        }, function (e) {
            reject(e || new Error('目录不存在: ' + targetDir))
        })
    })
}

// ==================== 文本容错解析 ====================

function _pickStr(obj, keys) {
    for (let i = 0; i < keys.length; i++) {
        const v = obj[keys[i]]
        if (v !== undefined && v !== null && String(v) !== '') return v
    }
    return null
}

/**
 * 从任意 JSON 值中提取课程数组
 */
export function extractCourses(data) {
    if (!data) return []
    if (Array.isArray(data)) {
        const list = []
        for (let i = 0; i < data.length; i++) {
            const item = data[i]
            if (item && typeof item === 'object') {
                const date = _pickStr(item, ['date', 'day', '日期'])
                const title = _pickStr(item, ['title', 'name', 'course_name', '课程'])
                if (date && title) {
                    list.push({
                        date: String(date),
                        weekday: _pickStr(item, ['weekday', 'week_day', '星期']) || '',
                        title: String(title),
                        course_type: _pickStr(item, ['course_type', 'type']) || 'lecture',
                        start_time: _pickStr(item, ['start_time', 'start']),
                        end_time: _pickStr(item, ['end_time', 'end']),
                        description: _pickStr(item, ['description', 'desc']),
                        is_rest: item.is_rest || 0,
                        is_self_study: item.is_self_study || 0
                    })
                }
            }
        }
        return list
    }
    if (typeof data === 'object') {
        if (Array.isArray(data.courses)) return extractCourses(data.courses)
        const date = _pickStr(data, ['date', 'day'])
        const title = _pickStr(data, ['title', 'name', 'course_name'])
        if (date && title) return extractCourses([data])
    }
    return []
}

/**
 * 容错解析课程文本：
 * 支持 整体JSON / {courses:[]} / 完整备份 / NDJSON(每行一个对象) / 行尾带逗号的数组片段
 */
export function parseCoursesText(text) {
    if (!text || !String(text).trim()) return []
    let raw = String(text).trim()
    // 去掉 BOM
    if (raw.charCodeAt(0) === 0xFEFF) raw = raw.slice(1)
    // 常见中文引号修正
    raw = raw.replace(/[\u201c\u201d]/g, '"')

    // 1. 整体 JSON
    try {
        const data = JSON.parse(raw)
        const list = extractCourses(data)
        if (list.length > 0) return list
    } catch (e) { /* 继续 */ }

    // 2. 去掉末尾多余逗号后再试整体
    try {
        const data = JSON.parse(raw.replace(/,\s*([\]}])/g, '$1'))
        const list = extractCourses(data)
        if (list.length > 0) return list
    } catch (e) { /* 继续 */ }

    // 3. NDJSON / 每行一个对象
    const lines = raw.split(/\r?\n/)
    const list = []
    for (let i = 0; i < lines.length; i++) {
        let line = lines[i].trim()
        if (!line) continue
        line = line.replace(/,$/, '')
        try {
            const obj = JSON.parse(line)
            const got = extractCourses(obj)
            for (let j = 0; j < got.length; j++) list.push(got[j])
        } catch (e) { /* 忽略无法解析的行 */ }
    }
    if (list.length > 0) return list

    throw new Error('JSON格式错误')
}

/**
 * 容错解析完整备份对象
 */
export function parseBackupText(text) {
    if (!text || !String(text).trim()) return null
    let raw = String(text).trim()
    if (raw.charCodeAt(0) === 0xFEFF) raw = raw.slice(1)
    raw = raw.replace(/[\u201c\u201d]/g, '"')

    try {
        return JSON.parse(raw)
    } catch (e) { /* 继续 */ }

    try {
        return JSON.parse(raw.replace(/,\s*([\]}])/g, '$1'))
    } catch (e) {
        throw new Error('JSON格式错误')
    }
}
