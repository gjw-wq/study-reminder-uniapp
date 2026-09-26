<template>
    <view class="page" :style="{ backgroundColor: theme.bg }">
        <scroll-view class="content" scroll-y>
            <!-- 数据库概览 -->
            <text class="section-title" :style="{ color: theme.accent }">数据库概览</text>
            <view class="info-grid" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }">
                <view class="info-item">
                    <text class="info-val" :style="{ color: theme.accent }">{{ dbInfo.courses || 0 }}</text>
                    <text class="info-label" :style="{ color: theme.textSecondary }">课程</text>
                </view>
                <view class="info-item">
                    <text class="info-val" :style="{ color: theme.accent }">{{ dbInfo.habit_checks || 0 }}</text>
                    <text class="info-label" :style="{ color: theme.textSecondary }">打卡记录</text>
                </view>
                <view class="info-item">
                    <text class="info-val" :style="{ color: theme.accent }">{{ dbInfo.study_logs || 0 }}</text>
                    <text class="info-label" :style="{ color: theme.textSecondary }">复盘日志</text>
                </view>
            </view>

            <!-- 数据备份 -->
            <text class="section-title" :style="{ color: theme.accent }">数据备份</text>
            <text class="hint" :style="{ color: theme.textDim }">.db 仅含打卡/日志；JSON 含全部数据（推荐）</text>
            <view class="btn-group">
                <view class="action-btn" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }"
                      hover-class="btn-hover" @click="exportDb">
                    <text :style="{ color: theme.textPrimary }">导出打卡/日志(.db)</text>
                </view>
                <view class="action-btn" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }"
                      hover-class="btn-hover" @click="exportJsonToClipboard">
                    <text :style="{ color: theme.textPrimary }">导出到剪贴板</text>
                </view>
                <view class="action-btn" :style="{ backgroundColor: theme.bgCard, borderColor: theme.accent }"
                      hover-class="btn-hover" @click="exportJsonToFile">
                    <text :style="{ color: theme.textPrimary }">导出为JSON文件 推荐</text>
                </view>
            </view>

            <!-- 数据恢复 -->
            <text class="section-title" :style="{ color: theme.accent }">数据恢复 / 导入</text>
            <view class="btn-group">
                <view class="action-btn" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }"
                      hover-class="btn-hover" @click="importDb">
                    <text :style="{ color: theme.textPrimary }">导入打卡/日志(.db)</text>
                </view>
                <view class="action-btn" :style="{ backgroundColor: theme.bgCard, borderColor: theme.accent }"
                      hover-class="btn-hover" @click="showImportJson = true">
                    <text :style="{ color: theme.textPrimary }">导入全部(JSON) 推荐</text>
                </view>
            </view>

            <!-- 数据清空 -->
            <text class="section-title" :style="{ color: theme.accentDim }">数据清空（危险操作）</text>
            <view class="btn-group">
                <view class="action-btn danger" :style="{ backgroundColor: theme.bgCard, borderColor: theme.accentDim }"
                      hover-class="btn-hover" @click="clearTable('courses')">
                    <text :style="{ color: theme.accentDim }">清空课程</text>
                </view>
                <view class="action-btn danger" :style="{ backgroundColor: theme.bgCard, borderColor: theme.accentDim }"
                      hover-class="btn-hover" @click="clearTable('habit_checks')">
                    <text :style="{ color: theme.accentDim }">清空打卡记录</text>
                </view>
                <view class="action-btn danger" :style="{ backgroundColor: theme.bgCard, borderColor: theme.accentDim }"
                      hover-class="btn-hover" @click="clearTable('study_logs')">
                    <text :style="{ color: theme.accentDim }">清空复盘日志</text>
                </view>
            </view>

            <!-- 数据浏览 -->
            <text class="section-title" :style="{ color: theme.accent }">数据浏览</text>
            <view class="tab-row" :style="{ borderColor: theme.border }">
                <view v-for="tab in ['courses','habit_checks','study_logs']" :key="tab" class="tab-item"
                      :style="{ borderBottomColor: browseTab === tab ? theme.accent : 'transparent' }"
                      @click="switchBrowseTab(tab)">
                    <text :style="{ color: browseTab === tab ? theme.accent : theme.textDim }">{{ tabNames[tab] }}</text>
                </view>
            </view>

            <view v-if="browseData.length === 0" class="empty">
                <text :style="{ color: theme.textDim }">暂无数据</text>
            </view>
            <view v-for="(row, idx) in browseData" :key="idx" class="data-row"
                  :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }">
                <text class="data-json" :style="{ color: theme.textSecondary }">{{ formatRow(row) }}</text>
            </view>
        </scroll-view>

        <!-- 导入JSON弹窗 -->
        <view v-if="showImportJson" class="modal-mask" @click="showImportJson = false">
            <view class="modal" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }" @click.stop>
                <text class="modal-title" :style="{ color: theme.textPrimary }">导入JSON数据</text>
                <text class="hint" :style="{ color: theme.textDim }">可从文件导入，或粘贴本应用导出的JSON备份</text>

                <view class="import-tools">
                    <view class="tool-btn" :style="{ backgroundColor: theme.bgInput, borderColor: theme.accent }"
                          hover-class="btn-hover" @click="pickFile">
                        <text :style="{ color: theme.accent }">选择JSON文件</text>
                    </view>
                    <view class="tool-btn" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border }"
                          hover-class="btn-hover" @click="scanLocalFiles">
                        <text :style="{ color: theme.textPrimary }">从目录选择</text>
                    </view>
                    <view class="tool-btn" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border }"
                          hover-class="btn-hover" @click="pasteFromClipboard">
                        <text :style="{ color: theme.textPrimary }">粘贴剪贴板</text>
                    </view>
                    <view class="tool-btn" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border }"
                          hover-class="btn-hover" @click="clearImportText">
                        <text :style="{ color: theme.accentDim }">清空</text>
                    </view>
                </view>

                <view class="mode-row">
                    <view class="mode-btn" :style="{ backgroundColor: importMode === 'replace' ? theme.accent : theme.bgInput, borderColor: theme.border }"
                          @click="importMode = 'replace'">
                        <text :style="{ color: importMode === 'replace' ? theme.textOnAccent : theme.textSecondary }">覆盖导入</text>
                    </view>
                    <view class="mode-btn" :style="{ backgroundColor: importMode === 'append' ? theme.accent : theme.bgInput, borderColor: theme.border }"
                          @click="importMode = 'append'">
                        <text :style="{ color: importMode === 'append' ? theme.textOnAccent : theme.textSecondary }">追加导入</text>
                    </view>
                </view>
                <text class="hint" :style="{ color: theme.textDim }">{{ importMode === 'replace' ? '覆盖：先清空同类型数据再导入（推荐用于恢复备份）' : '追加：在现有数据基础上新增，可能产生重复' }}</text>

                <text v-if="importStatus" class="status-line" :style="{ color: theme.accent }">{{ importStatus }}</text>

                <textarea class="import-textarea" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border, color: theme.textPrimary }"
                          :value="importJsonText" @input="onImportInput" maxlength="-1" :show-confirm-bar="false"
                          placeholder="粘贴JSON数据，或用上方按钮选择 .json 文件" />

                <view class="counter-row">
                    <text class="counter" :style="{ color: theme.textDim }">{{ counterText }}</text>
                    <text v-if="importTextFull && importJsonText.length < importTextFull.length"
                          class="load-full" :style="{ color: theme.accent }" @click="loadFullText">载入原文</text>
                </view>

                <view class="modal-btns">
                    <view class="modal-btn cancel" :style="{ backgroundColor: theme.bg, borderColor: theme.border }"
                          @click="showImportJson = false">
                        <text :style="{ color: theme.textSecondary }">取消</text>
                    </view>
                    <view class="modal-btn confirm" :style="{ backgroundColor: theme.accent }"
                          @click="doImportJson">
                        <text :style="{ color: theme.textOnAccent }">导入</text>
                    </view>
                </view>
            </view>
        </view>
    </view>
</template>

<script>
import { getTheme } from '../../common/theme.js'
import { db } from '../../common/database.js'
import { pickJsonFile, listJsonFiles, readFileText, readClipboardText, writeTextFile, parseBackupText, extractCourses } from '../../common/file-import.js'

export default {
    data() {
        return {
            theme: getTheme(),
            dbInfo: {},
            browseTab: 'courses',
            browseData: [],
            showImportJson: false,
            importJsonText: '',
            importTextFull: '',
            importStatus: '',
            importMode: 'replace',
            tabNames: { courses: '课程', habit_checks: '打卡', study_logs: '复盘' }
        }
    },
    computed: {
        counterText() {
            const base = '已输入 ' + this.importJsonText.length + ' 字符'
            return this.importTextFull ? (base + '（原文 ' + this.importTextFull.length + ' 字符）') : base
        }
    },
    onShow() {
        this.theme = getTheme()
        this.loadInfo()
        this.switchBrowseTab(this.browseTab)
    },
    methods: {
        async loadInfo() {
            this.dbInfo = await db.getDbInfo()
        },

        async switchBrowseTab(tab) {
            this.browseTab = tab
            try {
                if (tab === 'courses') {
                    this.browseData = await db.getAllCourses()
                } else if (tab === 'habit_checks') {
                    this.browseData = await db.getHabitStatus('')
                } else {
                    this.browseData = await db.getAllStudyLogs()
                }
            } catch (e) {
                this.browseData = []
            }
        },

        formatRow(row) {
            const d = { ...row }
            delete d.created_at
            return JSON.stringify(d)
        },

        async exportDb() {
            uni.showToast({ title: '正在导出...', icon: 'loading' })
            try {
                // 导出数据库文件到可访问目录
                if (typeof plus !== 'undefined') {
                    const srcPath = db.getDbPath()
                    const dstPath = `_downloads/study_reminder_backup_${Date.now()}.db`
                    // 使用plus.io复制
                    await new Promise((resolve, reject) => {
                        plus.io.resolveLocalFileSystemURL(srcPath, entry => {
                            plus.io.resolveLocalFileSystemURL('_downloads/', dirEntry => {
                                entry.copyTo(dirEntry, `study_reminder_backup_${Date.now()}.db`, resolve, reject)
                            }, reject)
                        }, reject)
                    })
                    uni.showToast({ title: '打卡/日志已导出(课程请用JSON)', icon: 'none' })
                } else {
                    uni.showToast({ title: '仅支持真机运行', icon: 'none' })
                }
            } catch (e) {
                uni.showToast({ title: '导出失败', icon: 'none' })
            }
        },

        async exportJsonToClipboard() {
            const data = await db.exportAllData()
            const json = JSON.stringify(data, null, 2)
            uni.setClipboardData({
                data: json,
                success: () => {
                    uni.showToast({ title: 'JSON已复制到剪贴板', icon: 'success' })
                }
            })
        },

        async exportJsonToFile() {
            try {
                const data = await db.exportAllData()
                const json = JSON.stringify(data, null, 2)
                const ts = new Date()
                const pad = n => String(n).padStart(2, '0')
                const stamp = `${ts.getFullYear()}${pad(ts.getMonth() + 1)}${pad(ts.getDate())}_${pad(ts.getHours())}${pad(ts.getMinutes())}`
                const fileName = `study_reminder_${stamp}.json`
                const path = await writeTextFile('_downloads', fileName, json)
                uni.showModal({
                    title: '导出成功',
                    content: `已导出 ${json.length} 字符\n文件名：${fileName}\n路径：${path}\n（导入时可直接用「选择JSON文件」或「从目录选择」）`,
                    showCancel: false
                })
            } catch (e) {
                const msg = (e && e.message) ? e.message : '导出文件失败'
                uni.showToast({ title: msg, icon: 'none', duration: 2500 })
            }
        },

        onImportInput(e) {
            this.importJsonText = (e && e.detail && e.detail.value !== undefined) ? e.detail.value : ''
            this.refreshImportStatus()
        },

        getImportSource() {
            if (this.importTextFull && this.importJsonText.length < this.importTextFull.length) {
                return this.importTextFull
            }
            return this.importJsonText
        },

        refreshImportStatus() {
            const src = this.getImportSource()
            if (!src || !src.trim()) {
                this.importStatus = ''
                return
            }
            try {
                const data = parseBackupText(src)
                const c = (data && data.courses) ? extractCourses(data.courses).length : extractCourses(data).length
                const h = (data && data.habit_checks) ? data.habit_checks.length : 0
                const l = (data && data.study_logs) ? data.study_logs.length : 0
                this.importStatus = `解析成功：课程 ${c} 条 / 打卡 ${h} 条 / 复盘 ${l} 条`
            } catch (e) {
                this.importStatus = 'JSON 暂无法解析，请检查内容是否完整（是否被截断）'
            }
        },

        applyImportText(text, name) {
            const t = String(text || '')
            if (!t.trim()) {
                uni.showToast({ title: '内容为空', icon: 'none' })
                return
            }
            this.importTextFull = t
            if (t.length > 6000) {
                this.importJsonText = `已加载${name ? '：' + name : '内容'}\n共 ${t.length} 字符\n内容已就绪，直接点「导入」即可；如需查看或修改，点右侧「载入原文」`
            } else {
                this.importJsonText = t
            }
            this.refreshImportStatus()
        },

        loadFullText() {
            this.importJsonText = this.importTextFull
            this.importStatus = '已载入原文（' + this.importTextFull.length + ' 字符）'
        },

        clearImportText() {
            this.importJsonText = ''
            this.importTextFull = ''
            this.importStatus = ''
        },

        async pickFile() {
            try {
                uni.showToast({ title: '请选择JSON文件', icon: 'none' })
                const res = await pickJsonFile()
                this.applyImportText(res.text, res.name)
            } catch (e) {
                const msg = (e && e.message) ? e.message : '选择文件失败'
                uni.showToast({ title: msg, icon: 'none', duration: 3000 })
            }
        },

        async scanLocalFiles() {
            uni.showToast({ title: '正在扫描目录...', icon: 'loading' })
            const files = await listJsonFiles()
            if (!files || files.length === 0) {
                uni.showModal({
                    title: '未找到文件',
                    content: '未在 _downloads / Download / Documents 等目录扫描到 .json 文件。\nAndroid 11+ 限制了直接读取公共目录，建议改用「选择JSON文件」按钮（系统文件管理器）。',
                    showCancel: false
                })
                return
            }
            const items = files.slice(0, 6).map(f => f.name)
            uni.showActionSheet({
                itemList: items,
                success: async (res) => {
                    const file = files[res.tapIndex]
                    try {
                        const text = await readFileText(file.path)
                        this.applyImportText(text, file.name)
                    } catch (e) {
                        uni.showToast({ title: '读取文件失败', icon: 'none' })
                    }
                }
            })
        },

        async pasteFromClipboard() {
            try {
                const text = await readClipboardText()
                if (!text || !text.trim()) {
                    uni.showToast({ title: '剪贴板为空', icon: 'none' })
                    return
                }
                this.applyImportText(text, '剪贴板内容')
            } catch (e) {
                uni.showToast({ title: '读取剪贴板失败', icon: 'none' })
            }
        },

        async doImportJson() {
            const source = this.getImportSource()
            if (!source || !source.trim()) {
                uni.showToast({ title: '请粘贴或导入JSON数据', icon: 'none' })
                return
            }
            let data = null
            try {
                data = parseBackupText(source)
            } catch (e) {
                uni.showToast({ title: 'JSON格式错误，请检查内容', icon: 'none' })
                return
            }
            if (!data || typeof data !== 'object') {
                uni.showToast({ title: '数据格式不正确', icon: 'none' })
                return
            }

            const modeText = this.importMode === 'replace' ? '覆盖导入（会先清空现有同类数据）' : '追加导入'
            const confirmRes = await new Promise(r => {
                uni.showModal({
                    title: '确认导入',
                    content: `将执行${modeText}，确定继续吗？`,
                    success: r
                })
            })
            if (!confirmRes.confirm) return

            try {
                const summary = await db.importAllData(data, { clear: this.importMode === 'replace' })
                this.showImportJson = false
                this.clearImportText()
                uni.showModal({
                    title: '导入成功',
                    content: `课程 ${summary.courses} 条 / 打卡 ${summary.habit_checks} 条 / 复盘 ${summary.study_logs} 条`,
                    showCancel: false
                })
                this.loadInfo()
                this.switchBrowseTab(this.browseTab)
            } catch (e) {
                uni.showToast({ title: '导入失败，请重试', icon: 'none' })
            }
        },

        async importDb() {
            uni.showToast({ title: '请将.db文件放入下载目录', icon: 'none' })
            // 数据库导入需要真机文件操作
            if (typeof plus !== 'undefined') {
                try {
                    const files = await new Promise((resolve, reject) => {
                        plus.io.resolveLocalFileSystemURL('_downloads/', entry => {
                            const reader = entry.createReader()
                            reader.readEntries(resolve, reject)
                        }, reject)
                    })
                    const dbFiles = files.filter(f => f.name.endsWith('.db'))
                    if (dbFiles.length === 0) {
                        uni.showToast({ title: '下载目录中未找到.db文件', icon: 'none' })
                        return
                    }
                    const items = dbFiles.map(f => f.name)
                    uni.showActionSheet({
                        itemList: items,
                        success: async (res) => {
                            const file = dbFiles[res.tapIndex]
                            file.copyTo(
                                { fullPath: db.getDbPath() },
                                async () => {
                                    uni.showToast({ title: '打卡/日志已导入(课程请用JSON)', icon: 'none' })
                                },
                                () => {
                                    uni.showToast({ title: '导入失败', icon: 'none' })
                                }
                            )
                        }
                    })
                } catch (e) {
                    uni.showToast({ title: '导入失败: ' + e.message, icon: 'none' })
                }
            }
        },

        async clearTable(table) {
            const names = { courses: '课程', habit_checks: '打卡记录', study_logs: '复盘日志' }
            const res = await new Promise(r => {
                uni.showModal({
                    title: '危险操作',
                    content: `确定要清空所有「${names[table]}」吗？此操作不可恢复！`,
                    success: r
                })
            })
            if (res.confirm) {
                await db.clearTable(table)
                uni.showToast({ title: '已清空', icon: 'success' })
                this.loadInfo()
                this.switchBrowseTab(this.browseTab)
            }
        }
    }
}
</script>

<style scoped>
.page {
    min-height: 100vh;
    padding: 16px;
    display: flex;
    flex-direction: column;
}

.content {
    flex: 1;
}

.section-title {
    font-size: 13px;
    font-weight: bold;
    margin: 14px 0 8px;
    display: block;
}

.info-grid {
    display: flex;
    border-radius: 8px;
    border: 1px solid;
    overflow: hidden;
}

.info-item {
    flex: 1;
    text-align: center;
    padding: 12px 6px;
}

.info-val {
    font-size: 22px;
    font-weight: bold;
    display: block;
}

.info-label {
    font-size: 11px;
    margin-top: 2px;
}

.btn-group {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
}

.action-btn {
    flex: 1;
    min-width: 120px;
    height: 38px;
    border-radius: 8px;
    border: 1px solid;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 12px;
}

.action-btn.danger {
    border-color: #dd524d;
}

.tab-row {
    display: flex;
    border-bottom: 1px solid;
    margin-bottom: 8px;
}

.tab-item {
    flex: 1;
    text-align: center;
    padding: 8px 0;
    font-size: 12px;
    border-bottom: 2px solid transparent;
}

.data-row {
    padding: 8px 10px;
    border-radius: 6px;
    border: 1px solid;
    margin-bottom: 4px;
}

.data-json {
    font-size: 10px;
    font-family: monospace;
    word-break: break-all;
    line-height: 1.4;
}

.empty {
    text-align: center;
    padding: 30px;
    font-size: 13px;
}

.modal-mask {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0,0,0,0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 100;
}

.modal {
    width: 90%;
    max-height: 88vh;
    overflow-y: auto;
    border-radius: 12px;
    border: 1px solid;
    padding: 20px;
}

.modal-title {
    font-size: 16px;
    font-weight: bold;
    text-align: center;
    margin-bottom: 12px;
    display: block;
}

.hint {
    font-size: 12px;
    margin-bottom: 8px;
    display: block;
}

.import-tools {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
    margin-bottom: 8px;
}

.tool-btn {
    padding: 6px 10px;
    border-radius: 6px;
    border: 1px solid;
    font-size: 11px;
}

.mode-row {
    display: flex;
    gap: 8px;
    margin-bottom: 6px;
}

.mode-btn {
    flex: 1;
    height: 32px;
    border-radius: 6px;
    border: 1px solid;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 12px;
}

.status-line {
    font-size: 11px;
    margin: 6px 0;
    display: block;
}

.counter-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
}

.counter {
    font-size: 11px;
}

.load-full {
    font-size: 11px;
    padding: 2px 6px;
}

.import-textarea {
    width: 100%;
    height: 180px;
    border-radius: 6px;
    border: 1px solid;
    padding: 8px;
    font-size: 11px;
    margin-bottom: 6px;
    box-sizing: border-box;
}

.modal-btns {
    display: flex;
    gap: 10px;
}

.modal-btn {
    flex: 1;
    height: 38px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 13px;
}

.modal-btn.cancel {
    border: 1px solid;
}
</style>