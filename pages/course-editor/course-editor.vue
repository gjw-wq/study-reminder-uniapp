<template>
    <view class="page" :style="{ backgroundColor: theme.bg }">
        <scroll-view class="content" scroll-y>
            <!-- 课程列表 -->
            <view v-for="group in groupedCourses" :key="group.date" class="date-group">
                <view class="date-header" :style="{ backgroundColor: theme.bgCard }">
                    <text :style="{ color: theme.textSecondary }">{{ group.date }} {{ group.weekday }}</text>
                    <text class="del-date-btn" :style="{ color: theme.accent }" @click="deleteDateGroup(group.date)">删除当日</text>
                </view>
                <view v-for="course in group.courses" :key="course.id" class="course-row"
                      :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }">
                    <view class="type-tag" :style="{ backgroundColor: getTypeColor(course) }">
                        <text :style="{ color: theme.textOnAccent }">{{ getTypeTag(course) }}</text>
                    </view>
                    <text class="course-title" :style="{ color: theme.textPrimary }">{{ course.title }}</text>
                    <text class="course-time" :style="{ color: theme.textSecondary }">{{ course.start_time || '' }}~{{ course.end_time || '' }}</text>
                    <view class="row-actions">
                        <text class="edit-btn" :style="{ color: theme.accent }" @click="editCourse(course)">编辑</text>
                        <text class="del-btn" :style="{ color: theme.accentDim }" @click="deleteCourse(course.id)">删除</text>
                    </view>
                </view>
            </view>

            <view v-if="groupedCourses.length === 0" class="empty">
                <text :style="{ color: theme.textDim }">暂无课程数据，请添加或导入</text>
            </view>
        </scroll-view>

        <!-- 底部操作栏 -->
        <view class="bottom-bar" :style="{ backgroundColor: theme.bg, borderColor: theme.border }">
            <view class="bar-btn" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }"
                  hover-class="btn-hover" @click="showAddDialog = true">
                <text :style="{ color: theme.textPrimary }">+ 添加</text>
            </view>
            <view class="bar-btn" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }"
                  hover-class="btn-hover" @click="showImportDialog = true">
                <text :style="{ color: theme.textPrimary }">批量导入</text>
            </view>
            <view class="bar-btn" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }"
                  hover-class="btn-hover" @click="clearAllCourses">
                <text :style="{ color: theme.accentDim }">清空全部</text>
            </view>
        </view>

        <!-- 添加/编辑弹窗 -->
        <view v-if="showAddDialog" class="modal-mask" @click="showAddDialog = false">
            <view class="modal" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }" @click.stop>
                <text class="modal-title" :style="{ color: theme.textPrimary }">{{ editingCourse ? '编辑课程' : '添加课程' }}</text>

                <text class="field-label" :style="{ color: theme.textSecondary }">日期</text>
                <input class="field-input" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border, color: theme.textPrimary }"
                       v-model="form.date" placeholder="YYYY-MM-DD" />

                <text class="field-label" :style="{ color: theme.textSecondary }">星期</text>
                <view class="weekday-row">
                    <view v-for="wd in weekdays" :key="wd" class="weekday-btn"
                          :style="{ backgroundColor: form.weekday === wd ? theme.accent : theme.bgInput, borderColor: theme.border }"
                          @click="form.weekday = wd">
                        <text :style="{ color: form.weekday === wd ? theme.textOnAccent : theme.textSecondary }">{{ wd }}</text>
                    </view>
                </view>

                <text class="field-label" :style="{ color: theme.textSecondary }">课程名称</text>
                <input class="field-input" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border, color: theme.textPrimary }"
                       v-model="form.title" placeholder="课程名称" />

                <text class="field-label" :style="{ color: theme.textSecondary }">类型</text>
                <view class="type-row">
                    <view v-for="t in courseTypes" :key="t.value" class="type-btn"
                          :style="{ backgroundColor: form.courseType === t.value ? theme.accent : theme.bgInput, borderColor: theme.border }"
                          @click="form.courseType = t.value">
                        <text :style="{ color: form.courseType === t.value ? theme.textOnAccent : theme.textSecondary }">{{ t.label }}</text>
                    </view>
                </view>

                <text class="field-label" :style="{ color: theme.textSecondary }">开始时间</text>
                <input class="field-input" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border, color: theme.textPrimary }"
                       v-model="form.startTime" placeholder="HH:MM" />

                <text class="field-label" :style="{ color: theme.textSecondary }">结束时间</text>
                <input class="field-input" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border, color: theme.textPrimary }"
                       v-model="form.endTime" placeholder="HH:MM" />

                <view class="modal-btns">
                    <view class="modal-btn cancel" :style="{ backgroundColor: theme.bg, borderColor: theme.border }"
                          @click="showAddDialog = false">
                        <text :style="{ color: theme.textSecondary }">取消</text>
                    </view>
                    <view class="modal-btn confirm" :style="{ backgroundColor: theme.accent }"
                          @click="saveCourse">
                        <text :style="{ color: theme.textOnAccent }">保存</text>
                    </view>
                </view>
            </view>
        </view>

        <!-- 批量导入弹窗 -->
        <view v-if="showImportDialog" class="modal-mask" @click="showImportDialog = false">
            <view class="modal" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }" @click.stop>
                <text class="modal-title" :style="{ color: theme.textPrimary }">批量导入课程</text>
                <text class="hint" :style="{ color: theme.textDim }">支持：JSON数组 / {"courses":[...]} / 完整备份 / 每行一个对象</text>

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

                <text v-if="importStatus" class="status-line" :style="{ color: theme.accent }">{{ importStatus }}</text>

                <textarea class="import-textarea" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border, color: theme.textPrimary }"
                          :value="importText" @input="onImportInput" maxlength="-1" :show-confirm-bar="false"
                          placeholder='[{"date":"2026-08-03","weekday":"星期一","title":"课程名","course_type":"lecture","start_time":"08:30","end_time":"12:20"}]' />

                <view class="counter-row">
                    <text class="counter" :style="{ color: theme.textDim }">{{ counterText }}</text>
                    <text v-if="importTextFull && importText.length < importTextFull.length"
                          class="load-full" :style="{ color: theme.accent }" @click="loadFullText">载入原文</text>
                </view>

                <view class="modal-btns">
                    <view class="modal-btn cancel" :style="{ backgroundColor: theme.bg, borderColor: theme.border }"
                          @click="showImportDialog = false">
                        <text :style="{ color: theme.textSecondary }">取消</text>
                    </view>
                    <view class="modal-btn confirm" :style="{ backgroundColor: theme.accent }"
                          @click="doImport">
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
import { pickJsonFile, listJsonFiles, readFileText, readClipboardText, parseCoursesText } from '../../common/file-import.js'

const WEEKDAYS = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日']

export default {
    data() {
        return {
            theme: getTheme(),
            allCourses: [],
            groupedCourses: [],
            showAddDialog: false,
            showImportDialog: false,
            editingCourse: null,
            importText: '',
            importTextFull: '',
            importFileName: '',
            importStatus: '',
            weekdays: WEEKDAYS,
            courseTypes: [
                { label: '上课', value: 'lecture' },
                { label: '项目', value: 'project' },
                { label: '自习', value: 'self_study' },
                { label: '休息', value: 'rest' }
            ],
            form: this.getEmptyForm()
        }
    },
    computed: {
        counterText() {
            const base = '已输入 ' + this.importText.length + ' 字符'
            return this.importTextFull ? (base + '（原文 ' + this.importTextFull.length + ' 字符）') : base
        }
    },
    onShow() {
        this.theme = getTheme()
        this.loadData()
    },
    methods: {
        getEmptyForm() {
            return {
                date: '',
                weekday: '星期一',
                title: '',
                courseType: 'lecture',
                startTime: '',
                endTime: ''
            }
        },

        async loadData() {
            this.allCourses = await db.getAllCourses()
            this.groupCourses()
        },

        groupCourses() {
            const groups = []
            let currentDate = null
            let currentGroup = null
            for (const course of this.allCourses) {
                if (course.date !== currentDate) {
                    currentDate = course.date
                    currentGroup = { date: course.date, weekday: course.weekday, courses: [] }
                    groups.push(currentGroup)
                }
                currentGroup.courses.push(course)
            }
            this.groupedCourses = groups
        },

        getTypeColor(course) {
            if (course.is_rest || course.course_type === 'rest') return this.theme.accentDim
            return this.theme.accent
        },

        getTypeTag(course) {
            if (course.is_rest || course.course_type === 'rest') return '休息'
            if (course.is_self_study || course.course_type === 'self_study') return '自习'
            if (course.course_type === 'project') return '项目'
            return '上课'
        },

        editCourse(course) {
            this.form = {
                date: course.date,
                weekday: course.weekday,
                title: course.title,
                courseType: course.course_type || 'lecture',
                startTime: course.start_time || '',
                endTime: course.end_time || ''
            }
            this.editingCourse = course
            this.showAddDialog = true
        },

        async saveCourse() {
            if (!this.form.date || !this.form.title) {
                uni.showToast({ title: '请填写日期和课程名称', icon: 'none' })
                return
            }
            const isRest = this.form.courseType === 'rest' ? 1 : 0
            const isSelfStudy = this.form.courseType === 'self_study' ? 1 : 0

            if (this.editingCourse) {
                await db.updateCourse(this.editingCourse.id, {
                    date: this.form.date,
                    weekday: this.form.weekday,
                    title: this.form.title,
                    course_type: this.form.courseType,
                    start_time: this.form.startTime || null,
                    end_time: this.form.endTime || null,
                    is_rest: isRest,
                    is_self_study: isSelfStudy
                })
            } else {
                await db.insertCourse(
                    this.form.date, this.form.weekday, this.form.title,
                    this.form.courseType,
                    this.form.startTime || null, this.form.endTime || null,
                    null, isRest, isSelfStudy
                )
            }

            this.showAddDialog = false
            this.editingCourse = null
            this.form = this.getEmptyForm()
            uni.showToast({ title: '保存成功', icon: 'success' })
            this.loadData()
        },

        async deleteCourse(id) {
            const res = await new Promise(r => {
                uni.showModal({ title: '确认删除', content: '确定要删除此课程吗？', success: r })
            })
            if (res.confirm) {
                await db.deleteCourse(id)
                uni.showToast({ title: '已删除', icon: 'success' })
                this.loadData()
            }
        },

        async deleteDateGroup(date) {
            const res = await new Promise(r => {
                uni.showModal({ title: '确认删除', content: `确定要删除 ${date} 的所有课程吗？`, success: r })
            })
            if (res.confirm) {
                const courses = this.allCourses.filter(c => c.date === date)
                for (const c of courses) {
                    await db.deleteCourse(c.id)
                }
                uni.showToast({ title: '已删除', icon: 'success' })
                this.loadData()
            }
        },

        async clearAllCourses() {
            const res = await new Promise(r => {
                uni.showModal({ title: '危险操作', content: '确定要清空所有课程数据吗？此操作不可恢复！', success: r })
            })
            if (res.confirm) {
                await db.clearCourses()
                uni.showToast({ title: '已清空所有课程', icon: 'success' })
                this.loadData()
            }
        },

        onImportInput(e) {
            // 手动同步，避免 App 端 v-model 在超长文本时不同步
            this.importText = (e && e.detail && e.detail.value !== undefined) ? e.detail.value : ''
            this.refreshImportStatus()
        },

        refreshImportStatus() {
            const src = this.getImportSource()
            if (!src || !src.trim()) {
                this.importStatus = ''
                return
            }
            try {
                const n = parseCoursesText(src).length
                this.importStatus = `解析到 ${n} 条课程`
            } catch (e) {
                this.importStatus = '内容暂无法解析为课程，请检查格式'
            }
        },

        // 摘要模式下用原文，用户手动编辑过则用输入框内容
        getImportSource() {
            if (this.importTextFull && this.importText.length < this.importTextFull.length) {
                return this.importTextFull
            }
            return this.importText
        },

        applyImportText(text, name) {
            const t = String(text || '')
            if (!t.trim()) {
                uni.showToast({ title: '内容为空', icon: 'none' })
                return
            }
            let count = -1
            try {
                count = parseCoursesText(t).length
            } catch (e) {
                count = -1
            }
            this.importTextFull = t
            this.importFileName = name || ''
            if (t.length > 6000) {
                this.importText = `已加载${name ? '：' + name : '内容'}\n` +
                    `${count >= 0 ? count + ' 条课程' : '格式待校验'}，共 ${t.length} 字符\n` +
                    `内容已就绪，直接点「导入」即可；如需查看或修改，点右侧「载入原文」`
            } else {
                this.importText = t
            }
            this.importStatus = count >= 0 ? `解析到 ${count} 条课程` : '内容暂无法解析为课程，请检查格式'
        },

        loadFullText() {
            this.importText = this.importTextFull
            this.importStatus = '已载入原文（' + this.importTextFull.length + ' 字符）'
        },

        clearImportText() {
            this.importText = ''
            this.importTextFull = ''
            this.importFileName = ''
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

        async doImport() {
            const source = this.getImportSource()
            if (!source || !source.trim()) {
                uni.showToast({ title: '请粘贴或导入JSON数据', icon: 'none' })
                return
            }
            let courses = []
            try {
                courses = parseCoursesText(source)
            } catch (e) {
                uni.showToast({ title: 'JSON格式错误，请检查内容', icon: 'none' })
                return
            }
            if (courses.length === 0) {
                uni.showToast({ title: '未解析到课程数据', icon: 'none' })
                return
            }
            const confirmRes = await new Promise(r => {
                uni.showModal({
                    title: '确认导入',
                    content: `将追加导入 ${courses.length} 条课程，是否继续？`,
                    success: r
                })
            })
            if (!confirmRes.confirm) return

            try {
                await db.batchInsertCourses(courses)
                this.showImportDialog = false
                const count = courses.length
                this.clearImportText()
                uni.showToast({ title: `已导入 ${count} 条课程`, icon: 'success' })
                this.loadData()
            } catch (e) {
                uni.showToast({ title: '导入失败，请重试', icon: 'none' })
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
    margin-bottom: 60px;
}

.date-group {
    margin-bottom: 12px;
}

.date-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8px 12px;
    border-radius: 6px;
    margin-bottom: 4px;
    font-size: 12px;
}

.del-date-btn {
    font-size: 11px;
}

.course-row {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 8px 12px;
    border-radius: 6px;
    border: 1px solid;
    margin-bottom: 4px;
}

.type-tag {
    padding: 2px 6px;
    border-radius: 4px;
    font-size: 10px;
    flex-shrink: 0;
}

.course-title {
    flex: 1;
    font-size: 13px;
}

.course-time {
    font-size: 11px;
    font-family: monospace;
    flex-shrink: 0;
}

.row-actions {
    display: flex;
    gap: 8px;
    font-size: 11px;
    flex-shrink: 0;
}

.edit-btn, .del-btn {
    padding: 2px 4px;
}

.empty {
    text-align: center;
    padding: 40px;
    font-size: 14px;
}

.bottom-bar {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    display: flex;
    gap: 8px;
    padding: 8px 16px;
    border-top: 1px solid;
}

.bar-btn {
    flex: 1;
    height: 36px;
    border-radius: 8px;
    border: 1px solid;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 12px;
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
    max-height: 85vh;
    border-radius: 12px;
    border: 1px solid;
    padding: 20px;
    overflow-y: auto;
}

.modal-title {
    font-size: 16px;
    font-weight: bold;
    text-align: center;
    margin-bottom: 16px;
    display: block;
}

.field-label {
    font-size: 12px;
    margin-bottom: 4px;
    display: block;
}

.field-input {
    width: 100%;
    height: 36px;
    border-radius: 6px;
    border: 1px solid;
    padding: 0 10px;
    font-size: 13px;
    margin-bottom: 10px;
    box-sizing: border-box;
}

.weekday-row, .type-row {
    display: flex;
    flex-wrap: wrap;
    gap: 4px;
    margin-bottom: 10px;
}

.weekday-btn, .type-btn {
    padding: 4px 10px;
    border-radius: 6px;
    border: 1px solid;
    font-size: 11px;
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

.status-line {
    font-size: 11px;
    margin-bottom: 6px;
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