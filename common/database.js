/**
 * 数据库模块 - 基于 plus.sqlite，与桌面版 (core/database.py) 完全兼容
 * 表结构、字段名、数据类型与桌面版 SQLite 一一对应
 * 数据库文件: _doc/study_reminder.db
 */

const DB_NAME = 'study_reminder'
const DB_PATH = '_doc/study_reminder.db'

let _db = null
let _openPromise = null

/**
 * 获取数据库实例（异步，自动打开）
 */
function getDb() {
    if (_openPromise) return _openPromise
    _openPromise = new Promise((resolve, reject) => {
        if (typeof plus === 'undefined') {
            reject(new Error('plus not available'))
            return
        }
        plus.sqlite.openDatabase({
            name: DB_NAME,
            path: DB_PATH,
            success(e) {
                // 详细诊断 db 对象
                console.log('=== DB OPEN SUCCESS ===')
                console.log('e type:', typeof e)
                console.log('e keys:', Object.keys(e))
                console.log('e.target:', e.target)
                console.log('e.target type:', typeof e.target)
                console.log('typeof e.executeSql:', typeof e.executeSql)
                console.log('typeof e.selectSql:', typeof e.selectSql)
                if (e.target) {
                    console.log('typeof e.target.executeSql:', typeof e.target.executeSql)
                    console.log('typeof e.target.selectSql:', typeof e.target.selectSql)
                }
                // 尝试获取 db 对象的所有属性（包括原型链）
                let proto = e
                let depth = 0
                while (proto && depth < 3) {
                    const props = Object.getOwnPropertyNames(proto)
                    console.log(`proto[${depth}] props:`, props)
                    proto = Object.getPrototypeOf(proto)
                    depth++
                }

                _db = e.target || e
                resolve(_db)
            },
            fail(e) {
                console.error('Open database failed:', e)
                reject(e)
            }
        })
    })
    return _openPromise
}

/**
 * SQL 值转义（将参数直接嵌入 SQL 字符串，绕过 bindArgs 兼容性问题）
 */
function escapeSql(val) {
    if (val === null || val === undefined) return 'NULL'
    if (typeof val === 'number') return String(val)
    return "'" + String(val).replace(/'/g, "''") + "'"
}

/**
 * 将 SQL 中的 ? 占位符替换为转义后的参数值
 */
function buildSql(sql, params) {
    if (!params || params.length === 0) return sql
    let idx = 0
    return sql.replace(/\?/g, () => escapeSql(params[idx++]))
}

/**
 * 执行 SQL（异步）—— INSERT/UPDATE/DELETE/CREATE
 * 统一使用 plus.sqlite.selectSql 执行，因为部分 HBuilder X 版本中
 * plus.sqlite.executeSql 存在静默失败的 bug（调 success 但不执行）
 */
function execSql(sql, params = []) {
    return new Promise((resolve, reject) => {
        getDb().then(db => {
            // 压缩 SQL 为单行
            const finalSql = buildSql(sql, params).replace(/\s+/g, ' ').trim()

            // 方案1：尝试 db 实例的 executeSql（位置参数形式）
            if (db && typeof db.executeSql === 'function') {
                console.log('[EXEC] Using db.executeSql (instance method)')
                db.executeSql(finalSql, [],
                    function(e) { resolve(e) },
                    function(e) {
                        console.error('SQL failed:', finalSql, e)
                        reject(e)
                    }
                )
                return
            }

            // 方案2：尝试 db 实例的 selectSql 执行写操作
            if (db && typeof db.selectSql === 'function') {
                console.log('[EXEC] Using db.selectSql (instance method)')
                db.selectSql(finalSql, [],
                    function(e) { resolve(e) },
                    function(e) {
                        console.error('SQL failed:', finalSql, e)
                        reject(e)
                    }
                )
                return
            }

            // 方案3：plus.sqlite.selectSql（部分版本可执行写操作）
            if (typeof plus.sqlite.selectSql === 'function') {
                plus.sqlite.selectSql({
                    name: DB_NAME,
                    sql: finalSql,
                    success: function(e) {
                        resolve(e)
                    },
                    fail: function(e) {
                        console.error('selectSql(exec) failed:', finalSql.substring(0, 120), e)
                        // 如果 selectSql 失败，尝试 executeSql
                        if (typeof plus.sqlite.executeSql === 'function') {
                            plus.sqlite.executeSql({
                                name: DB_NAME,
                                sql: finalSql,
                                success: function(e2) { resolve(e2) },
                                fail: function(e2) {
                                    console.error('executeSql also failed:', finalSql, e2)
                                    reject(e2)
                                }
                            })
                        } else {
                            reject(e)
                        }
                    }
                })
                return
            }

            // 方案4：plus.sqlite.executeSql
            if (typeof plus.sqlite.executeSql === 'function') {
                plus.sqlite.executeSql({
                    name: DB_NAME,
                    sql: finalSql,
                    success: function(e) { resolve(e) },
                    fail: function(e) {
                        console.error('SQL failed:', finalSql, e)
                        reject(e)
                    }
                })
                return
            }

            reject(new Error('No SQLite API available'))
        }).catch(reject)
    })
}

/**
 * 查询 SQL（返回 rows 数组）
 * 使用 plus.sqlite.selectSql —— 这是唯一正确返回 rows 的 API
 */
function querySql(sql, params = []) {
    return new Promise((resolve, reject) => {
        getDb().then(db => {
            // 压缩 SQL 为单行
            const finalSql = buildSql(sql, params).replace(/\s+/g, ' ').trim()

            // 优先使用 plus.sqlite.selectSql 静态方法（返回 rows）
            if (typeof plus.sqlite.selectSql === 'function') {
                plus.sqlite.selectSql({
                    name: DB_NAME,
                    sql: finalSql,
                    success: function(e) {
                        const rows = e && e.rows ? e.rows : []
                        resolve(rows)
                    },
                    fail: function(e) {
                        console.error('selectSql failed:', finalSql, e)
                        reject(e)
                    }
                })
            }
            // 兜底：尝试 plus.sqlite.executeSql（部分版本可能返回 rows）
            else if (typeof plus.sqlite.executeSql === 'function') {
                plus.sqlite.executeSql({
                    name: DB_NAME,
                    sql: finalSql,
                    success: function(e) {
                        const rows = e && e.rows ? e.rows : []
                        resolve(rows)
                    },
                    fail: function(e) {
                        console.error('Query failed:', finalSql, e)
                        reject(e)
                    }
                })
            }
            else {
                reject(new Error('SQL query API not available'))
            }
        }).catch(reject)
    })
}

class Database {
    constructor() {
        this._initialized = false
    }

    async initTables() {
        if (this._initialized) return
        await getDb() // 确保数据库已打开

        const sqls = [
            `CREATE TABLE IF NOT EXISTS courses (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                date TEXT NOT NULL,
                weekday TEXT NOT NULL,
                title TEXT NOT NULL,
                course_type TEXT DEFAULT 'lecture',
                start_time TEXT,
                end_time TEXT,
                description TEXT,
                is_rest INTEGER DEFAULT 0,
                is_self_study INTEGER DEFAULT 0,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )`,
            `CREATE TABLE IF NOT EXISTS habit_checks (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                habit_name TEXT NOT NULL,
                habit_index INTEGER NOT NULL,
                check_date TEXT NOT NULL,
                checked INTEGER DEFAULT 0,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                UNIQUE(habit_index, check_date)
            )`,
            `CREATE TABLE IF NOT EXISTS study_logs (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                log_date TEXT NOT NULL UNIQUE,
                gain1 TEXT,
                gain2 TEXT,
                gain3 TEXT,
                question TEXT,
                courses_today TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )`,
            `CREATE TABLE IF NOT EXISTS reminders (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                reminder_type TEXT NOT NULL,
                title TEXT NOT NULL,
                trigger_time TEXT NOT NULL,
                status TEXT DEFAULT 'pending',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )`,
            `CREATE TABLE IF NOT EXISTS app_meta (
                key TEXT PRIMARY KEY,
                value TEXT
            )`
        ]

        for (const sql of sqls) {
            await execSql(sql)
        }
        this._initialized = true
    }

    getDbPath() {
        return DB_PATH
    }

    // ==================== 课程操作 ====================

    async insertCourse(date, weekday, title, courseType, startTime, endTime, description, isRest, isSelfStudy) {
        // 课程数据走 uni.storage，不再使用 SQLite
        const arr = _loadCourses()
        const course = _normalizeCourse({
            id: _nextCourseId(arr),
            date: date,
            weekday: weekday,
            title: title,
            course_type: courseType || 'lecture',
            start_time: startTime || null,
            end_time: endTime || null,
            description: description || null,
            is_rest: isRest || 0,
            is_self_study: isSelfStudy || 0
        })
        arr.push(course)
        _saveCourses(arr)
        return course.id
    }

    async updateCourse(id, data) {
        const arr = _loadCourses()
        const idx = arr.findIndex(c => c.id === id)
        if (idx >= 0) {
            arr[idx] = _normalizeCourse(Object.assign({}, arr[idx], data, { id }))
            _saveCourses(arr)
        }
    }

    async deleteCourse(id) {
        _saveCourses(_loadCourses().filter(c => c.id !== id))
    }

    async getCoursesByDate(date) {
        return _sortCourses(_loadCourses().filter(c => c.date === date))
    }

    async getAllCourses() {
        return _sortCourses(_loadCourses())
    }

    async batchInsertCourses(courses) {
        if (!Array.isArray(courses) || courses.length === 0) return
        const arr = _loadCourses()
        for (const c of courses) {
            arr.push(_normalizeCourse({
                id: _nextCourseId(arr),
                date: c.date,
                weekday: c.weekday,
                title: c.title,
                course_type: c.course_type || 'lecture',
                start_time: c.start_time || null,
                end_time: c.end_time || null,
                description: c.description || null,
                is_rest: c.is_rest || 0,
                is_self_study: c.is_self_study || 0
            }))
        }
        _saveCourses(arr)
    }

    async clearCourses() {
        _saveCourses([])
    }

    // ==================== 习惯打卡 ====================

    async checkHabit(habitIndex, habitName, checkDate, checked) {
        // 习惯打卡走 uni.storage，不再使用 SQLite
        const arr = _loadHabits()
        const val = checked !== undefined ? checked : 1
        const idx = arr.findIndex(h => h.habit_index === habitIndex && h.check_date === checkDate)
        if (idx >= 0) {
            arr[idx].checked = val
            arr[idx].habit_name = habitName
        } else {
            arr.push({
                id: _nextHabitId(arr),
                habit_index: habitIndex,
                habit_name: habitName,
                check_date: checkDate,
                checked: val,
                created_at: new Date().toISOString()
            })
        }
        _saveHabits(arr)
    }

    async getHabitStatus(checkDate) {
        // checkDate 为空时返回全部记录（供数据管理页浏览）
        const all = _loadHabits()
        const filtered = (!checkDate) ? all : all.filter(h => h.check_date === checkDate)
        return filtered.map(h => ({
            id: h.id,
            habit_index: h.habit_index,
            habit_name: h.habit_name,
            check_date: h.check_date,
            checked: h.checked,
            created_at: h.created_at
        }))
    }

    async getStreak(habitIndex) {
        const today = getTodayStr()
        const dates = _loadHabits()
            .filter(h => h.habit_index === habitIndex && h.checked === 1 && h.check_date <= today)
            .map(h => h.check_date)
            .sort((a, b) => a < b ? 1 : (a > b ? -1 : 0))

        if (dates.length === 0) return 0

        let streak = 0
        const todayDate = new Date(today)
        for (const d of dates) {
            const rowDate = new Date(d)
            const expected = new Date(todayDate)
            expected.setDate(expected.getDate() - streak)
            if (rowDate.toDateString() === expected.toDateString()) {
                streak++
            } else {
                break
            }
        }
        return streak
    }

    async clearHabitChecks() {
        _saveHabits([])
    }

    // ==================== 学习日志 ====================

    async saveStudyLog(logDate, gain1, gain2, gain3, question, coursesToday) {
        // 学习日志走 uni.storage，不再使用 SQLite
        const arr = _loadLogs()
        const record = {
            log_date: logDate,
            gain1: gain1 || null,
            gain2: gain2 || null,
            gain3: gain3 || null,
            question: question || null,
            courses_today: coursesToday || null
        }
        const idx = arr.findIndex(l => l.log_date === logDate)
        if (idx >= 0) {
            arr[idx] = Object.assign(arr[idx], record)
        } else {
            arr.push(Object.assign({ id: _nextLogId(arr), created_at: new Date().toISOString() }, record))
        }
        _saveLogs(arr)
    }

    async getStudyLog(logDate) {
        const arr = _loadLogs()
        const found = arr.filter(l => l.log_date === logDate)
        return found.length > 0 ? found[0] : null
    }

    async getAllStudyLogs() {
        return _loadLogs().slice().sort((a, b) => a.log_date < b.log_date ? 1 : -1)
    }

    async deleteStudyLog(logDate) {
        _saveLogs(_loadLogs().filter(l => l.log_date !== logDate))
    }

    async clearStudyLogs() {
        _saveLogs([])
    }

    // ==================== 周统计 ====================

    async getWeekStats(startDate, endDate) {
        // habit_checks / study_logs 走 storage
        const habitRows = _loadHabits()
            .filter(h => h.check_date >= startDate && h.check_date <= endDate && h.checked === 1)
        const statsMap = {}
        for (const h of habitRows) {
            statsMap[h.check_date] = (statsMap[h.check_date] || 0) + 1
        }
        const habitStats = Object.keys(statsMap).map(k => ({ check_date: k, count: statsMap[k] }))
        const logCount = _loadLogs().filter(l => l.log_date >= startDate && l.log_date <= endDate).length
        return { habitStats, logCount }
    }

    // ==================== 数据库管理 ====================

    async getDbInfo() {
        const tables = ['courses', 'habit_checks', 'study_logs', 'reminders']
        const info = {}
        for (const table of tables) {
            try {
                if (table === 'courses') {
                    info[table] = _loadCourses().length
                } else if (table === 'habit_checks') {
                    info[table] = _loadHabits().length
                } else if (table === 'study_logs') {
                    info[table] = _loadLogs().length
                } else {
                    const rows = await querySql(`SELECT COUNT(*) as count FROM ${table}`)
                    info[table] = (rows && rows.length > 0) ? rows[0].count : 0
                }
            } catch (e) {
                info[table] = 0
            }
        }
        return info
    }

    async exportAllData() {
        const courses = await this.getAllCourses()
        const habits = _loadHabits().slice().sort((a, b) => {
            if (a.check_date !== b.check_date) return a.check_date < b.check_date ? 1 : -1
            return a.habit_index - b.habit_index
        })
        const logs = await this.getAllStudyLogs()
        return {
            version: '1.0',
            exportTime: new Date().toISOString(),
            courses,
            habit_checks: habits,
            study_logs: logs
        }
    }

    /**
     * 批量导入全部数据
     * @param {Object|Array} data 备份对象（或课程数组）
     * @param {Object} options { clear: true 表示先清空同类数据再导入 }
     * @returns {Promise<{courses:Number,habit_checks:Number,study_logs:Number}>}
     */
    async importAllData(data, options) {
        const opts = Object.assign({ clear: false }, options || {})
        const summary = { courses: 0, habit_checks: 0, study_logs: 0 }
        if (!data) return summary

        // 课程（支持直接传课程数组）
        const coursesList = Array.isArray(data) ? data : data.courses
        if (Array.isArray(coursesList) && coursesList.length > 0) {
            const arr = opts.clear ? [] : _loadCourses()
            let nextId = _nextCourseId(arr)
            for (const c of coursesList) {
                if (!c || !c.date || !c.title) continue
                arr.push(_normalizeCourse(Object.assign({}, c, { id: nextId++ })))
                summary.courses++
            }
            _saveCourses(arr)
        }

        // 习惯打卡
        if (Array.isArray(data.habit_checks) && data.habit_checks.length > 0) {
            const arr = opts.clear ? [] : _loadHabits()
            const byKey = {}
            for (const item of arr) byKey[item.habit_index + '_' + item.check_date] = item
            let nextId = _nextHabitId(arr)
            for (const h of data.habit_checks) {
                if (!h || !h.check_date) continue
                const idx = Number(h.habit_index != null ? h.habit_index : 0)
                const key = idx + '_' + h.check_date
                const rec = {
                    id: nextId++,
                    habit_index: idx,
                    habit_name: h.habit_name || '',
                    check_date: h.check_date,
                    checked: h.checked != null ? Number(h.checked) : 1,
                    created_at: h.created_at || new Date().toISOString()
                }
                if (byKey[key]) {
                    Object.assign(byKey[key], rec)
                } else {
                    byKey[key] = rec
                    arr.push(rec)
                }
                summary.habit_checks++
            }
            _saveHabits(arr)
        }

        // 复盘日志
        if (Array.isArray(data.study_logs) && data.study_logs.length > 0) {
            const arr = opts.clear ? [] : _loadLogs()
            const byDate = {}
            for (const item of arr) byDate[item.log_date] = item
            let nextId = _nextLogId(arr)
            for (const l of data.study_logs) {
                if (!l || !l.log_date) continue
                const rec = {
                    log_date: l.log_date,
                    gain1: l.gain1 != null ? l.gain1 : null,
                    gain2: l.gain2 != null ? l.gain2 : null,
                    gain3: l.gain3 != null ? l.gain3 : null,
                    question: l.question != null ? l.question : null,
                    courses_today: l.courses_today != null ? l.courses_today : null
                }
                const exist = byDate[rec.log_date]
                if (exist) {
                    Object.assign(exist, rec)
                } else {
                    const row = Object.assign({ id: nextId++, created_at: l.created_at || new Date().toISOString() }, rec)
                    byDate[rec.log_date] = row
                    arr.push(row)
                }
                summary.study_logs++
            }
            _saveLogs(arr)
        }

        return summary
    }

    async clearTable(tableName) {
        const allowed = ['courses', 'habit_checks', 'study_logs', 'reminders']
        if (!allowed.includes(tableName)) throw new Error('Invalid table name')
        if (tableName === 'courses') {
            _saveCourses([])
            return
        }
        if (tableName === 'habit_checks') {
            _saveHabits([])
            return
        }
        if (tableName === 'study_logs') {
            _saveLogs([])
            return
        }
        await execSql(`DELETE FROM ${tableName}`)
    }
}

function getTodayStr() {
    const now = new Date()
    const y = now.getFullYear()
    const m = String(now.getMonth() + 1).padStart(2, '0')
    const d = String(now.getDate()).padStart(2, '0')
    return `${y}-${m}-${d}`
}

// ==================== 课程数据 storage 层 ====================
// 走 uni.setStorageSync / getStorageSync，彻底绕开 plus.sqlite 的 API 兼容坑
const COURSES_STORAGE_KEY = 'courses_data'

function _loadCourses() {
    try {
        const arr = uni.getStorageSync(COURSES_STORAGE_KEY)
        return Array.isArray(arr) ? arr : []
    } catch (e) {
        console.error('loadCourses from storage failed:', e)
        return []
    }
}

function _saveCourses(arr) {
    try {
        uni.setStorageSync(COURSES_STORAGE_KEY, arr || [])
    } catch (e) {
        console.error('saveCourses to storage failed:', e)
    }
}

function _nextCourseId(arr) {
    let max = 0
    for (const c of arr) {
        if (c && typeof c.id === 'number' && c.id > max) max = c.id
    }
    return max + 1
}

function _normalizeCourse(c) {
    return {
        id: c.id,
        date: c.date,
        weekday: c.weekday,
        title: c.title,
        course_type: c.course_type || 'lecture',
        start_time: c.start_time != null ? c.start_time : null,
        end_time: c.end_time != null ? c.end_time : null,
        description: c.description != null ? c.description : null,
        is_rest: c.is_rest || 0,
        is_self_study: c.is_self_study || 0,
        created_at: c.created_at || new Date().toISOString()
    }
}

function _sortCourses(arr) {
    return arr.slice().sort((a, b) => {
        if (a.date !== b.date) return a.date < b.date ? -1 : 1
        const ta = a.start_time || '99:99'
        const tb = b.start_time || '99:99'
        return ta < tb ? -1 : (ta > tb ? 1 : 0)
    })
}

// ==================== 习惯打卡 storage 层 ====================
const HABITS_STORAGE_KEY = 'habit_checks_data'

function _loadHabits() {
    try {
        const arr = uni.getStorageSync(HABITS_STORAGE_KEY)
        return Array.isArray(arr) ? arr : []
    } catch (e) {
        console.error('loadHabits from storage failed:', e)
        return []
    }
}

function _saveHabits(arr) {
    try {
        uni.setStorageSync(HABITS_STORAGE_KEY, arr || [])
    } catch (e) {
        console.error('saveHabits to storage failed:', e)
    }
}

function _nextHabitId(arr) {
    let max = 0
    for (const h of arr) {
        if (h && typeof h.id === 'number' && h.id > max) max = h.id
    }
    return max + 1
}

// ==================== 学习日志 storage 层 ====================
const LOGS_STORAGE_KEY = 'study_logs_data'

function _loadLogs() {
    try {
        const arr = uni.getStorageSync(LOGS_STORAGE_KEY)
        return Array.isArray(arr) ? arr : []
    } catch (e) {
        console.error('loadLogs from storage failed:', e)
        return []
    }
}

function _saveLogs(arr) {
    try {
        uni.setStorageSync(LOGS_STORAGE_KEY, arr || [])
    } catch (e) {
        console.error('saveLogs to storage failed:', e)
    }
}

function _nextLogId(arr) {
    let max = 0
    for (const l of arr) {
        if (l && typeof l.id === 'number' && l.id > max) max = l.id
    }
    return max + 1
}

// 全局数据库实例
export const db = new Database()

/**
 * 初始化数据库（创建表结构）
 */
export async function initDatabase() {
    await db.initTables()
}