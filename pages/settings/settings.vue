<template>
    <view class="page" :style="{ backgroundColor: theme.bg }">
        <scroll-view class="content" scroll-y>
            <!-- 提醒设置 -->
            <text class="section-title" :style="{ color: theme.accent }">提醒设置</text>

            <view class="form-item">
                <text class="label" :style="{ color: theme.textPrimary }">课程提前提醒:</text>
                <view class="stepper">
                    <view class="step-btn" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }"
                          @click="changeAdvance(-1)">
                        <text :style="{ color: theme.textPrimary }">−</text>
                    </view>
                    <text class="step-val" :style="{ color: theme.textPrimary }">{{ advance }} 分钟</text>
                    <view class="step-btn" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }"
                          @click="changeAdvance(1)">
                        <text :style="{ color: theme.textPrimary }">+</text>
                    </view>
                </view>
            </view>

            <view class="form-item">
                <text class="label" :style="{ color: theme.textSecondary }">弹窗提醒</text>
                <switch :checked="reminderPopup" @change="reminderPopup = $event.detail.value" color="#3ddc84" />
            </view>

            <view class="form-item">
                <text class="label" :style="{ color: theme.textSecondary }">声音提醒</text>
                <switch :checked="reminderSound" @change="reminderSound = $event.detail.value" color="#3ddc84" />
            </view>

            <!-- 外观 -->
            <text class="section-title" :style="{ color: theme.accent }">外观</text>

            <view class="form-item" @click="toggleTheme">
                <text class="label" :style="{ color: theme.textPrimary }">主题:</text>
                <text class="value" :style="{ color: theme.textSecondary }">{{ currentTheme === 'dark' ? '深色模式' : '浅色模式' }}</text>
                <text class="arrow" :style="{ color: theme.textDim }">›</text>
            </view>

            <!-- 作息时间 -->
            <text class="section-title" :style="{ color: theme.accent }">作息时间</text>

            <view class="form-item">
                <text class="label" :style="{ color: theme.textPrimary }">起床时间:</text>
                <input class="time-input" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border, color: theme.textPrimary }"
                       v-model="wakeUpTime" type="text" placeholder="07:00" />
            </view>

            <view class="form-item">
                <text class="label" :style="{ color: theme.textPrimary }">晨检点名:</text>
                <input class="time-input" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border, color: theme.textPrimary }"
                       v-model="checkInTime" type="text" placeholder="08:25" />
            </view>

            <view class="form-item">
                <text class="label" :style="{ color: theme.textPrimary }">晚自习开始:</text>
                <input class="time-input" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border, color: theme.textPrimary }"
                       v-model="eveningStart" type="text" placeholder="19:25" />
            </view>

            <view class="form-item">
                <text class="label" :style="{ color: theme.textPrimary }">晚自习结束:</text>
                <input class="time-input" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border, color: theme.textPrimary }"
                       v-model="eveningEnd" type="text" placeholder="22:30" />
            </view>

            <!-- 习惯管理 -->
            <text class="section-title" :style="{ color: theme.accent }">习惯管理</text>

            <view v-for="(habit, idx) in habits" :key="habit.index" class="habit-row"
                  :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }">
                <view class="habit-idx" :style="{ backgroundColor: theme.border }">
                    <text :style="{ color: theme.textSecondary }">{{ idx + 1 }}</text>
                </view>
                <input class="habit-name-input" :style="{ color: theme.textPrimary }"
                       :value="habit.name" @blur="updateHabitName(habit.index, $event.detail.value)" />
                <view class="habit-actions">
                    <text v-if="idx > 0" class="move-btn" :style="{ color: theme.textDim }"
                          @click="moveHabit(idx, -1)">↑</text>
                    <text v-if="idx < habits.length - 1" class="move-btn" :style="{ color: theme.textDim }"
                          @click="moveHabit(idx, 1)">↓</text>
                    <text class="del-btn" :style="{ color: theme.accentDim }"
                          @click="removeHabit(habit.index)">✕</text>
                </view>
            </view>

            <view class="add-habit-btn" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }"
                  hover-class="btn-hover" @click="addNewHabit">
                <text :style="{ color: theme.accent }">+ 添加新习惯</text>
            </view>

            <!-- 数据管理 -->
            <text class="section-title" :style="{ color: theme.accent }">数据管理</text>

            <view class="data-btn-group">
                <view class="data-btn" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }"
                      hover-class="btn-hover" @click="goDataManager">
                    <text :style="{ color: theme.textPrimary }">数据管理中心</text>
                    <text class="arrow" :style="{ color: theme.textDim }">›</text>
                </view>
                <view class="data-btn" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }"
                      hover-class="btn-hover" @click="goCourseEditor">
                    <text :style="{ color: theme.textPrimary }">编辑课程表</text>
                    <text class="arrow" :style="{ color: theme.textDim }">›</text>
                </view>
                <view class="data-btn" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }"
                      hover-class="btn-hover" @click="resetCourses">
                    <text :style="{ color: theme.accent }">恢复默认课程数据</text>
                    <text class="arrow" :style="{ color: theme.textDim }">›</text>
                </view>
            </view>

            <!-- 关于 -->
            <text class="section-title" :style="{ color: theme.accent }">关于</text>
            <view class="about-box" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }">
                <text :style="{ color: theme.textSecondary }">学习纪律官 v1.0.0</text>
                <text :style="{ color: theme.textDim }">AI大模型就业6期 - 学习纪律提醒工具</text>
                <text :style="{ color: theme.textDim }">基于 uni-app + SQLite 构建</text>
                <text :style="{ color: theme.textDim }">数据库: _doc/study_reminder.db</text>
            </view>
        </scroll-view>

        <!-- 底部保存按钮 -->
        <view class="save-bar" :style="{ backgroundColor: theme.bg, borderColor: theme.border }">
            <view class="save-btn" :style="{ backgroundColor: theme.accent }" @click="save">
                <text :style="{ color: theme.textOnAccent }">保存设置</text>
            </view>
        </view>
    </view>
</template>

<script>
import { getTheme } from '../../common/theme.js'
import { config } from '../../common/config.js'
import { db } from '../../common/database.js'
import { initCourseData } from '../../common/course-data.js'

export default {
    data() {
        return {
            theme: getTheme(),
            currentTheme: config.get('theme', 'dark'),
            advance: config.get('reminder_advance_minutes', 15),
            reminderPopup: config.get('reminder_popup', true),
            reminderSound: config.get('reminder_sound', true),
            wakeUpTime: config.get('wake_up_time', '07:00'),
            checkInTime: config.get('check_in_time', '08:25'),
            eveningStart: config.get('evening_study_start', '19:25'),
            eveningEnd: config.get('evening_study_end', '22:30'),
            habits: config.getHabits()
        }
    },
    onShow() {
        this.theme = getTheme()
        this.habits = config.getHabits()
    },
    methods: {
        changeAdvance(delta) {
            const newVal = this.advance + delta
            if (newVal >= 1 && newVal <= 60) {
                this.advance = newVal
            }
        },

        toggleTheme() {
            this.currentTheme = this.currentTheme === 'dark' ? 'light' : 'dark'
        },

        updateHabitName(index, value) {
            if (value && value.trim()) {
                config.updateHabit(index, { name: value.trim() })
            }
        },

        addNewHabit() {
            config.addHabit('新习惯', 'star')
            // 深拷贝确保 Vue 检测到引用变化，触发列表重新渲染
            this.habits = JSON.parse(JSON.stringify(config.getHabits()))
        },

        removeHabit(index) {
            uni.showModal({
                title: '确认删除',
                content: '确定要删除此习惯吗？',
                success: (res) => {
                    if (res.confirm) {
                        config.removeHabit(index)
                        this.habits = config.getHabits()
                    }
                }
            })
        },

        moveHabit(idx, direction) {
            const habits = [...this.habits]
            const newIdx = idx + direction
            if (newIdx < 0 || newIdx >= habits.length) return
            const temp = habits[idx]
            habits[idx] = habits[newIdx]
            habits[newIdx] = temp
            config.reorderHabits(habits)
            this.habits = config.getHabits()
        },

        goDataManager() {
            uni.navigateTo({ url: '/pages/data-manager/data-manager' })
        },

        goCourseEditor() {
            uni.navigateTo({ url: '/pages/course-editor/course-editor' })
        },

        async resetCourses() {
            const res = await new Promise(r => {
                uni.showModal({
                    title: '恢复默认课程',
                    content: '将清空当前课程数据并恢复为默认课程表，确定继续？',
                    success: r
                })
            })
            if (res.confirm) {
                await db.clearCourses()
                initCourseData(db)
                uni.showToast({ title: '已恢复默认课程', icon: 'success' })
            }
        },

        save() {
            config.set('reminder_advance_minutes', this.advance)
            config.set('reminder_popup', this.reminderPopup)
            config.set('reminder_sound', this.reminderSound)
            config.set('theme', this.currentTheme)
            config.set('wake_up_time', this.wakeUpTime)
            config.set('check_in_time', this.checkInTime)
            config.set('evening_study_start', this.eveningStart)
            config.set('evening_study_end', this.eveningEnd)

            uni.showToast({ title: '设置已保存', icon: 'success' })
            setTimeout(() => {
                this.theme = getTheme()
            }, 500)
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

.section-title {
    font-size: 13px;
    font-weight: bold;
    margin: 16px 0 10px;
    display: block;
}

.section-title:first-child {
    margin-top: 0;
}

.form-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 10px 0;
    min-height: 40px;
}

.label {
    font-size: 13px;
}

.value {
    font-size: 13px;
}

.arrow {
    font-size: 18px;
    margin-left: 6px;
}

.stepper {
    display: flex;
    align-items: center;
    gap: 10px;
}

.step-btn {
    width: 30px;
    height: 30px;
    border-radius: 6px;
    border: 1px solid;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 16px;
}

.step-val {
    font-size: 13px;
    min-width: 60px;
    text-align: center;
}

.time-input {
    width: 80px;
    height: 32px;
    border-radius: 6px;
    border: 1px solid;
    padding: 0 8px;
    font-size: 13px;
    text-align: center;
}

.habit-row {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 8px 12px;
    border-radius: 8px;
    border: 1px solid;
    margin-bottom: 6px;
}

.habit-idx {
    width: 24px;
    height: 24px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 11px;
    flex-shrink: 0;
}

.habit-name-input {
    flex: 1;
    height: 32px;
    font-size: 13px;
    background: transparent;
    border: none;
    padding: 0;
}

.habit-actions {
    display: flex;
    gap: 6px;
    font-size: 14px;
    flex-shrink: 0;
}

.move-btn, .del-btn {
    padding: 2px 6px;
}

.add-habit-btn {
    height: 36px;
    border-radius: 8px;
    border: 1px dashed;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 13px;
    margin-top: 4px;
}

.data-btn-group {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.data-btn {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 10px 14px;
    border-radius: 8px;
    border: 1px solid;
    font-size: 13px;
}

.about-box {
    border-radius: 8px;
    border: 1px solid;
    padding: 14px;
    display: flex;
    flex-direction: column;
    gap: 6px;
    font-size: 12px;
}

.save-bar {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    padding: 8px 16px;
    border-top: 1px solid;
}

.save-btn {
    height: 40px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    font-weight: bold;
}
</style>