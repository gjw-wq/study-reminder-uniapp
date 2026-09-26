<template>
    <view class="page" :style="{ backgroundColor: theme.bg }">
        <view class="header-row">
            <text class="date-label" :style="{ color: theme.textSecondary }">{{ todayStr }}</text>
            <view class="header-btn" hover-class="btn-hover" :style="{ backgroundColor: theme.bg, borderColor: theme.border }"
                  @click="goHistory">
                <text :style="{ color: theme.textSecondary }">历史记录</text>
            </view>
        </view>

        <scroll-view class="content" scroll-y>
            <view v-if="todayCourses.length > 0" class="section">
                <text class="section-title" :style="{ color: theme.accent }">今日所学课程:</text>
                <text class="section-text" :style="{ color: theme.textSecondary }">{{ todayCourses.join('、') }}</text>
            </view>
            <view v-else class="section">
                <text class="section-title" :style="{ color: theme.textSecondary }">今日无课程安排</text>
            </view>

            <view class="card" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }">
                <text class="card-title" :style="{ color: theme.textPrimary }">今日收获</text>
                <textarea class="input" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border, color: theme.textPrimary }"
                          v-model="gain1" placeholder="收获 1（必填）..." placeholder-style="color: #555" :maxlength="500" />
                <textarea class="input" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border, color: theme.textPrimary }"
                          v-model="gain2" placeholder="收获 2（选填）..." placeholder-style="color: #555" :maxlength="500" />
                <textarea class="input" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border, color: theme.textPrimary }"
                          v-model="gain3" placeholder="收获 3（选填）..." placeholder-style="color: #555" :maxlength="500" />
            </view>

            <view class="card" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }">
                <text class="card-title" :style="{ color: theme.accent }">遗留疑问</text>
                <textarea class="input" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border, color: theme.textPrimary }"
                          v-model="question" placeholder="有什么没搞懂的问题？明天记得问老师或同学..." placeholder-style="color: #555" :maxlength="500" />
            </view>

            <view v-if="tomorrowCourses.length > 0" class="card" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }">
                <text class="card-title" :style="{ color: theme.accent }">明日课程预告:</text>
                <text class="section-text" :style="{ color: theme.textSecondary }">{{ tomorrowCourses.join('、') }}</text>
            </view>
        </scroll-view>

        <view class="btn-row">
            <view class="cancel-btn" hover-class="btn-hover" :style="{ backgroundColor: theme.bg, borderColor: theme.border }"
                  @click="goBack">
                <text :style="{ color: theme.textSecondary }">稍后再说</text>
            </view>
            <view class="submit-btn" hover-class="btn-hover" :style="{ backgroundColor: theme.accent }"
                  @click="submit">
                <text :style="{ color: theme.textOnAccent }">提交复盘</text>
            </view>
        </view>
    </view>
</template>

<script>
import { getTheme } from '../../common/theme.js'
import { db } from '../../common/database.js'

export default {
    data() {
        const now = new Date()
        const y = now.getFullYear()
        const m = String(now.getMonth() + 1).padStart(2, '0')
        const d = String(now.getDate()).padStart(2, '0')
        const todayStr = `${y}-${m}-${d}`

        return {
            theme: getTheme(),
            todayStr,
            todayCourses: [],
            tomorrowCourses: [],
            gain1: '',
            gain2: '',
            gain3: '',
            question: ''
        }
    },
    onShow() {
        this.theme = getTheme()
        this.loadData()
    },
    methods: {
        async loadData() {
            const courses = await db.getCoursesByDate(this.todayStr)
            const seen = new Set()
            const names = []
            if (courses) {
                for (const c of courses) {
                    if (c.course_type !== 'rest' && !c.is_rest && !c.is_self_study) {
                        if (!seen.has(c.title)) {
                            seen.add(c.title)
                            names.push(c.title)
                        }
                    }
                }
            }
            this.todayCourses = names

            const tomorrow = new Date()
            tomorrow.setDate(tomorrow.getDate() + 1)
            const ty = tomorrow.getFullYear()
            const tm = String(tomorrow.getMonth() + 1).padStart(2, '0')
            const td = String(tomorrow.getDate()).padStart(2, '0')
            const tomorrowStr = `${ty}-${tm}-${td}`
            const tCourses = await db.getCoursesByDate(tomorrowStr)
            const tNames = []
            if (tCourses) {
                for (const c of tCourses) {
                    if (!c.is_rest) {
                        tNames.push(c.title)
                    }
                }
            }
            this.tomorrowCourses = [...new Set(tNames)]

            const log = await db.getStudyLog(this.todayStr)
            if (log) {
                this.gain1 = log.gain1 || ''
                this.gain2 = log.gain2 || ''
                this.gain3 = log.gain3 || ''
                this.question = log.question || ''
            }
        },

        async submit() {
            if (!this.gain1.trim()) {
                uni.showToast({ title: '请至少填写一个收获', icon: 'none' })
                return
            }

            const coursesText = this.todayCourses.join('、') || '无课程'
            await db.saveStudyLog(
                this.todayStr,
                this.gain1.trim(),
                this.gain2.trim(),
                this.gain3.trim(),
                this.question.trim(),
                coursesText
            )

            uni.showToast({ title: '复盘已保存，继续保持！', icon: 'success' })
            setTimeout(() => {
                uni.navigateBack()
            }, 1500)
        },

        goBack() {
            uni.navigateBack()
        },

        goHistory() {
            uni.navigateTo({ url: '/pages/review-history/review-history' })
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

.header-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
}

.date-label {
    font-size: 13px;
}

.header-btn {
    padding: 6px 14px;
    border-radius: 8px;
    border: 1px solid;
    font-size: 12px;
}

.content {
    flex: 1;
}

.section {
    margin-bottom: 12px;
}

.section-title {
    font-size: 13px;
    font-weight: bold;
    margin-bottom: 4px;
}

.section-text {
    font-size: 12px;
    line-height: 1.5;
}

.card {
    border-radius: 8px;
    border: 1px solid;
    padding: 12px;
    margin-bottom: 12px;
}

.card-title {
    font-size: 13px;
    font-weight: bold;
    margin-bottom: 8px;
    display: block;
}

.input {
    width: 100%;
    min-height: 56px;
    border-radius: 6px;
    border: 1px solid;
    padding: 8px;
    font-size: 12px;
    margin-bottom: 8px;
    box-sizing: border-box;
}

.btn-row {
    display: flex;
    gap: 10px;
    padding-top: 12px;
}

.cancel-btn, .submit-btn {
    flex: 1;
    height: 40px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 13px;
}

.cancel-btn {
    border: 1px solid;
}
</style>