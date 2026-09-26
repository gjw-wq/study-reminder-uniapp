<template>
    <view class="page" :style="{ backgroundColor: theme.bg }">
        <view class="header-row">
            <text class="date-label" :style="{ color: theme.textSecondary }">{{ todayStr }}</text>
            <view class="header-btns">
                <view class="header-btn" hover-class="btn-hover" :style="{ backgroundColor: theme.bg, borderColor: theme.border }"
                      @click="goHistory">
                    <text :style="{ color: theme.textSecondary }">记录</text>
                </view>
                <view class="header-btn" hover-class="btn-hover" :style="{ backgroundColor: theme.bg, borderColor: theme.border }"
                      @click="goSettings">
                    <text :style="{ color: theme.textSecondary }">管理</text>
                </view>
            </view>
        </view>

        <scroll-view class="habit-list" scroll-y>
            <view v-for="habit in habits" :key="habit.index" class="habit-item"
                  :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }">
                <view class="habit-idx" :style="{ backgroundColor: theme.border }">
                    <text :style="{ color: theme.textSecondary }">{{ habit.index + 1 }}</text>
                </view>
                <text class="habit-name" :style="{ color: theme.textPrimary }">{{ habit.name }}</text>
                <text v-if="getStreak(habit.index) > 0" class="streak" :style="{ color: theme.accent }">{{ getStreak(habit.index) }}天</text>
                <view v-if="isChecked(habit.index)" class="check-btn checked" :style="{ backgroundColor: theme.accent }">
                    <text :style="{ color: theme.textOnAccent }">已打卡 ✓</text>
                </view>
                <view v-else class="check-btn" hover-class="btn-hover"
                      :style="{ backgroundColor: theme.bg, borderColor: theme.border }"
                      @click="doCheck(habit)">
                    <text :style="{ color: theme.textPrimary }">打卡</text>
                </view>
            </view>
        </scroll-view>

        <text class="stats" :style="{ color: theme.accent }">今日完成: {{ checkedCount }}/{{ habits.length }} 项</text>

        <view class="check-all-btn" hover-class="btn-hover" :style="{ backgroundColor: theme.accent }"
              @click="checkAll">
            <text class="check-all-text" :style="{ color: theme.textOnAccent }">一键全部打卡</text>
        </view>
    </view>
</template>

<script>
import { getTheme } from '../../common/theme.js'
import { config } from '../../common/config.js'
import { db } from '../../common/database.js'

export default {
    data() {
        return {
            theme: getTheme(),
            todayStr: '',
            habits: [],
            checkedMap: {},
            streakMap: {}
        }
    },
    computed: {
        checkedCount() {
            return this.habits.filter(h => this.checkedMap[h.index]).length
        }
    },
    onShow() {
        this.theme = getTheme()
        this.refresh()
    },
    methods: {
        async refresh() {
            const now = new Date()
            const y = now.getFullYear()
            const m = String(now.getMonth() + 1).padStart(2, '0')
            const d = String(now.getDate()).padStart(2, '0')
            this.todayStr = `${y}-${m}-${d}`

            this.habits = config.getHabits()
            const status = await db.getHabitStatus(this.todayStr)
            this.checkedMap = {}
            for (const h of status) {
                this.checkedMap[h.habit_index] = h.checked === 1
            }

            this.streakMap = {}
            for (const habit of this.habits) {
                this.streakMap[habit.index] = await db.getStreak(habit.index)
            }
        },

        isChecked(index) {
            return !!this.checkedMap[index]
        },

        getStreak(index) {
            return this.streakMap[index] || 0
        },

        async doCheck(habit) {
            await db.checkHabit(habit.index, habit.name, this.todayStr, 1)
            this.checkedMap = { ...this.checkedMap, [habit.index]: true }
        },

        checkAll() {
            uni.showModal({
                title: '确认',
                content: '确定要一键打卡所有习惯吗？',
                success: async (res) => {
                    if (res.confirm) {
                        for (const habit of this.habits) {
                            await db.checkHabit(habit.index, habit.name, this.todayStr, 1)
                        }
                        const newMap = {}
                        for (const habit of this.habits) {
                            newMap[habit.index] = true
                        }
                        this.checkedMap = newMap
                    }
                }
            })
        },

        goHistory() {
            uni.navigateTo({ url: '/pages/habit-history/habit-history' })
        },

        goSettings() {
            uni.switchTab({ url: '/pages/settings/settings' })
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
    gap: 12px;
}

.header-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.date-label {
    font-size: 13px;
}

.header-btns {
    display: flex;
    gap: 8px;
}

.header-btn {
    padding: 6px 14px;
    border-radius: 8px;
    border: 1px solid;
    font-size: 12px;
}

.habit-list {
    flex: 1;
}

.habit-item {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 10px 14px;
    border-radius: 10px;
    border: 1px solid;
    margin-bottom: 10px;
    height: 52px;
}

.habit-idx {
    width: 28px;
    height: 28px;
    border-radius: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 12px;
    font-weight: bold;
    flex-shrink: 0;
}

.habit-name {
    flex: 1;
    font-size: 13px;
}

.streak {
    font-size: 11px;
    font-weight: bold;
    margin-right: 4px;
}

.check-btn {
    min-width: 80px;
    height: 34px;
    border-radius: 8px;
    border: 1px solid;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 12px;
    flex-shrink: 0;
}

.check-btn.checked {
    border: none;
}

.stats {
    font-size: 14px;
    font-weight: bold;
    text-align: center;
}

.check-all-btn {
    height: 42px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.check-all-text {
    font-size: 13px;
    font-weight: bold;
}
</style>