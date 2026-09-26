<template>
    <view class="page" :style="{ backgroundColor: theme.bg }">
        <text class="summary" :style="{ color: theme.accent }">最近7天完成率: {{ checkedTotal }}/{{ totalPossible }} ({{ rate }}%)</text>

        <scroll-view class="table-scroll" scroll-x>
            <view class="table">
                <view class="table-row header-row" :style="{ borderColor: theme.border }">
                    <view class="col-date" :style="{ borderColor: theme.border }">
                        <text :style="{ color: theme.textSecondary }">日期</text>
                    </view>
                    <view v-for="h in habits" :key="h.index" class="col-habit" :style="{ borderColor: theme.border }">
                        <text :style="{ color: theme.textSecondary }">{{ h.name }}</text>
                    </view>
                </view>
                <view v-for="(dateStr, rowIdx) in dates" :key="dateStr" class="table-row" :style="{ borderColor: theme.border }">
                    <view class="col-date" :style="{ borderColor: theme.border }">
                        <text :style="{ color: theme.textSecondary }">{{ dateStr.slice(5) }}</text>
                    </view>
                    <view v-for="h in habits" :key="h.index" class="col-habit"
                          :style="{ backgroundColor: isChecked(dateStr, h.index) ? theme.accent : 'transparent' }">
                        <text :style="{ color: isChecked(dateStr, h.index) ? theme.textOnAccent : theme.textDim }">
                            {{ isChecked(dateStr, h.index) ? '✓' : '' }}
                        </text>
                    </view>
                </view>
            </view>
        </scroll-view>
    </view>
</template>

<script>
import { getTheme } from '../../common/theme.js'
import { config } from '../../common/config.js'
import { db } from '../../common/database.js'

export default {
    data() {
        const today = new Date()
        const dates = []
        for (let i = 6; i >= 0; i--) {
            const d = new Date(today)
            d.setDate(d.getDate() - i)
            const y = d.getFullYear()
            const m = String(d.getMonth() + 1).padStart(2, '0')
            const day = String(d.getDate()).padStart(2, '0')
            dates.push(`${y}-${m}-${day}`)
        }

        return {
            theme: getTheme(),
            habits: config.getHabits(),
            dates,
            checkData: {}
        }
    },
    computed: {
        totalPossible() {
            return this.dates.length * this.habits.length
        },
        checkedTotal() {
            let count = 0
            for (const dateStr of this.dates) {
                for (const h of this.habits) {
                    if (this.isChecked(dateStr, h.index)) count++
                }
            }
            return count
        },
        rate() {
            if (this.totalPossible === 0) return '0.0'
            return (this.checkedTotal / this.totalPossible * 100).toFixed(1)
        }
    },
    onShow() {
        this.theme = getTheme()
        this.loadData()
    },
    methods: {
        async loadData() {
            const data = {}
            for (const dateStr of this.dates) {
                const status = await db.getHabitStatus(dateStr)
                data[dateStr] = {}
                for (const h of status) {
                    data[dateStr][h.habit_index] = h.checked === 1
                }
            }
            this.checkData = data
        },
        isChecked(dateStr, habitIndex) {
            return this.checkData[dateStr] && this.checkData[dateStr][habitIndex]
        }
    }
}
</script>

<style scoped>
.page {
    min-height: 100vh;
    padding: 16px;
}

.summary {
    font-size: 14px;
    font-weight: bold;
    text-align: center;
    margin-bottom: 16px;
    display: block;
}

.table-scroll {
    width: 100%;
}

.table {
    min-width: 600px;
}

.table-row {
    display: flex;
    border-bottom: 1px solid;
}

.table-row.header-row {
    border-bottom-width: 2px;
}

.col-date {
    width: 80px;
    padding: 8px 6px;
    text-align: center;
    font-size: 12px;
    border-right: 1px solid;
    flex-shrink: 0;
}

.col-habit {
    flex: 1;
    min-width: 60px;
    padding: 8px 4px;
    text-align: center;
    font-size: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
}
</style>