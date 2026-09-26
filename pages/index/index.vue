<template>
    <view class="page" :style="{ backgroundColor: theme.bg }">
        <view class="header">
            <view class="status-dot" :style="{ backgroundColor: theme.accent }"></view>
            <text class="title" :style="{ color: theme.textPrimary }">学习纪律官</text>
        </view>

        <view class="date-row">
            <text class="date-text" :style="{ color: theme.textDim }">{{ dateTimeStr }}</text>
        </view>

        <view class="module-box" :style="{ backgroundColor: theme.bgModule, borderColor: theme.border }">
            <view class="module-header">
                <text class="module-title" :style="{ color: theme.textPrimary }">今日课程</text>
            </view>
            <text class="course-list" :style="{ color: theme.textSecondary }">{{ courseText }}</text>
        </view>

        <view class="countdown-box" :style="{ backgroundColor: theme.bgModule, borderColor: theme.border, borderLeftColor: theme.accent }">
            <text class="countdown-title" :style="{ color: theme.textSecondary }">{{ countdownTitle }}</text>
            <text class="countdown-time" :style="{ color: countdownColor }">{{ countdownTime }}</text>
        </view>

        <view class="btn-grid">
            <view class="action-btn" :style="{ backgroundColor: theme.bgModule, borderColor: theme.border }"
                  hover-class="btn-hover" @click="goHabit">
                <text class="btn-text" :style="{ color: theme.textPrimary }">打卡</text>
            </view>
            <view class="action-btn" :style="{ backgroundColor: theme.bgModule, borderColor: theme.border }"
                  hover-class="btn-hover" @click="goCourse">
                <text class="btn-text" :style="{ color: theme.textPrimary }">课表</text>
            </view>
            <view class="action-btn" :style="{ backgroundColor: theme.bgModule, borderColor: theme.border }"
                  hover-class="btn-hover" @click="goReview">
                <text class="btn-text" :style="{ color: theme.textPrimary }">复盘</text>
            </view>
            <view class="action-btn" :style="{ backgroundColor: theme.bgModule, borderColor: theme.border }"
                  hover-class="btn-hover" @click="goSettings">
                <text class="btn-text" :style="{ color: theme.textPrimary }">设置</text>
            </view>
        </view>

        <view class="stats-bar" :style="{ backgroundColor: theme.bg, borderColor: theme.border }">
            <text class="stats-text" :style="{ color: theme.textDim }">{{ statsText }}</text>
            <view class="progress-bar-bg" :style="{ backgroundColor: theme.border }">
                <view class="progress-bar-fill" :style="{ width: progressPercent + '%', backgroundColor: theme.accent }"></view>
            </view>
        </view>
    </view>
</template>

<script>
import { getTheme } from '../../common/theme.js'
import { config } from '../../common/config.js'
import { db } from '../../common/database.js'
import { getNextReminder } from '../../common/reminder-engine.js'

const WEEKDAYS = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']

export default {
    data() {
        return {
            theme: getTheme(),
            dateTimeStr: '',
            courseText: 'NO SCHEDULE',
            countdownTitle: '下一个提醒',
            countdownTime: '--:--:--',
            countdownColor: '#3ddc84',
            statsText: 'HABIT 0/6',
            progressPercent: 0
        }
    },
    mounted() {
        this.updateAll()
        this.timer = setInterval(() => {
            this.updateAll()
        }, 1000)
    },
    onShow() {
        this.theme = getTheme()
        this.updateAll()
    },
    beforeUnmount() {
        if (this.timer) clearInterval(this.timer)
    },
    methods: {
        async updateAll() {
            const now = new Date()
            const todayStr = this.formatDate(now)
            const y = now.getFullYear()
            const mo = String(now.getMonth() + 1).padStart(2, '0')
            const d = String(now.getDate()).padStart(2, '0')
            const h = String(now.getHours()).padStart(2, '0')
            const mi = String(now.getMinutes()).padStart(2, '0')
            const s = String(now.getSeconds()).padStart(2, '0')
            const wd = WEEKDAYS[now.getDay()]

            this.dateTimeStr = `${y}.${mo}.${d}  ${h}:${mi}:${s}  ${wd}`

            const courses = await db.getCoursesByDate(todayStr)
            if (courses && courses.length > 0) {
                const lines = []
                for (const c of courses) {
                    if (c.is_rest) {
                        lines.push('  [REST]  休息日')
                    } else if (c.is_self_study) {
                        lines.push('  [STUDY] 自习')
                    } else {
                        const t = c.start_time && c.end_time ? `${c.start_time}~${c.end_time}` : ''
                        lines.push(`  ${t}  ${c.title}`)
                    }
                }
                this.courseText = lines.join('\n')
            } else {
                this.courseText = '  NO SCHEDULE'
            }

            await this.updateCountdown()
            await this.updateStats(todayStr)
        },

        async updateCountdown() {
            const next = await getNextReminder()
            if (!next) {
                this.countdownTitle = 'ALL DONE'
                this.countdownTime = '--:--:--'
                this.countdownColor = this.theme.textDim
                return
            }

            this.countdownTitle = next.title
            const now = new Date()
            const secondsLeft = Math.floor((next.time - now) / 1000)

            if (secondsLeft <= 0) {
                this.countdownTime = 'NOW!'
                this.countdownColor = this.theme.accent
                return
            }

            if (secondsLeft < 300) {
                this.countdownColor = this.theme.accent
            } else {
                this.countdownColor = this.theme.accentDim
            }

            const hh = Math.floor(secondsLeft / 3600)
            const mm = Math.floor((secondsLeft % 3600) / 60)
            const ss = secondsLeft % 60
            this.countdownTime = `${String(hh).padStart(2, '0')}:${String(mm).padStart(2, '0')}:${String(ss).padStart(2, '0')}`
        },

        async updateStats(todayStr) {
            const habits = config.getHabits()
            const checkedStatus = await db.getHabitStatus(todayStr)
            const checkedMap = {}
            for (const h of checkedStatus) {
                checkedMap[h.habit_index] = h.checked
            }
            const checked = habits.filter(h => checkedMap[h.index]).length
            const total = habits.length

            const courses = await db.getCoursesByDate(todayStr)
            const hasRest = courses && courses.some(c => c.is_rest)

            if (hasRest) {
                this.statsText = `HABIT ${checked}/${total}  |  REST DAY`
            } else {
                this.statsText = `HABIT ${checked}/${total}`
            }
            this.progressPercent = total > 0 ? Math.round((checked / total) * 100) : 0
        },

        formatDate(date) {
            const y = date.getFullYear()
            const m = String(date.getMonth() + 1).padStart(2, '0')
            const d = String(date.getDate()).padStart(2, '0')
            return `${y}-${m}-${d}`
        },

        goHabit() { uni.switchTab({ url: '/pages/habit/habit' }) },
        goCourse() { uni.switchTab({ url: '/pages/course/course' }) },
        goReview() { uni.navigateTo({ url: '/pages/review/review' }) },
        goSettings() { uni.switchTab({ url: '/pages/settings/settings' }) }
    }
}
</script>

<style scoped>
.page {
    min-height: 100vh;
    padding: 16px;
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.header {
    display: flex;
    align-items: center;
    gap: 10px;
}

.status-dot {
    width: 8px;
    height: 8px;
    border-radius: 4px;
}

.title {
    font-size: 18px;
    font-weight: bold;
}

.date-row {
    padding: 0;
}

.date-text {
    font-size: 11px;
    font-family: monospace;
}

.module-box {
    border-radius: 10px;
    border: 1px solid;
    padding: 12px;
}

.module-header {
    margin-bottom: 6px;
}

.module-title {
    font-size: 13px;
    font-weight: bold;
}

.course-list {
    font-size: 12px;
    line-height: 1.6;
    white-space: pre-line;
}

.countdown-box {
    border-radius: 10px;
    border: 1px solid;
    border-left-width: 3px;
    border-left-style: solid;
    padding: 12px;
    text-align: center;
}

.countdown-title {
    font-size: 12px;
    margin-bottom: 4px;
}

.countdown-time {
    font-size: 28px;
    font-weight: bold;
    font-family: monospace;
}

.btn-grid {
    display: flex;
    gap: 8px;
}

.action-btn {
    flex: 1;
    height: 48px;
    border-radius: 8px;
    border: 1px solid;
    display: flex;
    align-items: center;
    justify-content: center;
}

.btn-hover {
    opacity: 0.7;
    background-color: #3ddc84 !important;
}

.btn-text {
    font-size: 13px;
    font-weight: bold;
}

.stats-bar {
    display: flex;
    align-items: center;
    gap: 10px;
    border-radius: 6px;
    border: 1px solid;
    padding: 8px 12px;
}

.stats-text {
    font-size: 11px;
    font-family: monospace;
    flex-shrink: 0;
}

.progress-bar-bg {
    flex: 1;
    height: 4px;
    border-radius: 2px;
    overflow: hidden;
}

.progress-bar-fill {
    height: 100%;
    border-radius: 2px;
    transition: width 0.3s ease;
}
</style>