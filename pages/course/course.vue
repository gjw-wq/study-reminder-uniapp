<template>
    <view class="page" :style="{ backgroundColor: theme.bg }">
        <!-- 标签切换 -->
        <view class="tabs" :style="{ borderColor: theme.border }">
            <view class="tab" :class="{ active: activeTab === 0 }"
                  :style="{ borderBottomColor: activeTab === 0 ? theme.accent : 'transparent' }"
                  @click="activeTab = 0">
                <text :style="{ color: activeTab === 0 ? theme.accent : theme.textDim }">周视图</text>
            </view>
            <view class="tab" :class="{ active: activeTab === 1 }"
                  :style="{ borderBottomColor: activeTab === 1 ? theme.accent : 'transparent' }"
                  @click="activeTab = 1">
                <text :style="{ color: activeTab === 1 ? theme.accent : theme.textDim }">今日</text>
            </view>
            <view class="edit-entry" hover-class="btn-hover" @click="goEditor">
                <text :style="{ color: theme.accent }">编辑</text>
            </view>
        </view>

        <!-- 周视图 -->
        <scroll-view v-if="activeTab === 0" class="content" scroll-y>
            <template v-for="(group, gIdx) in weekGroups" :key="gIdx">
                <view class="date-header" :style="{ backgroundColor: theme.bgCard }">
                    <text class="date-header-text" :style="{ color: theme.textSecondary }">{{ group.date }} {{ group.weekday }}</text>
                </view>
                <view v-for="course in group.courses" :key="course.id" class="course-item"
                      :style="{ backgroundColor: theme.bgCard, borderColor: theme.border, borderLeftColor: getBorderColor(course), borderLeftWidth: course.date === todayStr ? '3px' : '1px' }"
                      @longpress="longPressCourse(course)">
                    <view class="type-tag" :style="{ backgroundColor: getBorderColor(course) }">
                        <text :style="{ color: theme.textOnAccent }">{{ getTypeTag(course) }}</text>
                    </view>
                    <text class="course-time" :style="{ color: theme.textSecondary }">{{ course.start_time || '' }}~{{ course.end_time || '' }}</text>
                    <text class="course-title" :style="{ color: theme.textPrimary }">{{ course.title }}</text>
                    <view v-if="course.date === todayStr" class="today-badge" :style="{ backgroundColor: theme.accent }">
                        <text :style="{ color: theme.textOnAccent }">今天</text>
                    </view>
                </view>
            </template>
        </scroll-view>

        <!-- 今日视图 -->
        <view v-if="activeTab === 1" class="content">
            <view v-if="todayCourses.length === 0" class="empty">
                <text :style="{ color: theme.textSecondary }">今日无课程安排，好好休息！</text>
            </view>
            <view v-else>
                <view class="date-header" :style="{ backgroundColor: theme.bgCard }">
                    <text class="date-header-text" :style="{ color: theme.textSecondary }">{{ todayStr }} {{ todayWeekday }}</text>
                </view>
                <view v-for="course in todayCourses" :key="course.id" class="course-item"
                      :style="{ backgroundColor: theme.bgCard, borderColor: theme.border, borderLeftColor: getBorderColor(course), borderLeftWidth: '3px' }"
                      @longpress="longPressCourse(course)">
                    <view class="type-tag" :style="{ backgroundColor: getBorderColor(course) }">
                        <text :style="{ color: theme.textOnAccent }">{{ getTypeTag(course) }}</text>
                    </view>
                    <text class="course-time" :style="{ color: theme.textSecondary }">{{ course.start_time || '' }}~{{ course.end_time || '' }}</text>
                    <text class="course-title" :style="{ color: theme.textPrimary }">{{ course.title }}</text>
                </view>
            </view>
        </view>
    </view>
</template>

<script>
import { getTheme } from '../../common/theme.js'
import { db } from '../../common/database.js'

const WEEKDAYS_CN = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六']

export default {
    data() {
        const now = new Date()
        const y = now.getFullYear()
        const m = String(now.getMonth() + 1).padStart(2, '0')
        const d = String(now.getDate()).padStart(2, '0')
        const todayStr = `${y}-${m}-${d}`
        const todayWeekday = WEEKDAYS_CN[now.getDay()]

        return {
            theme: getTheme(),
            activeTab: 0,
            todayStr,
            todayWeekday,
            allCourses: [],
            todayCourses: [],
            weekGroups: []
        }
    },
    onShow() {
        this.theme = getTheme()
        this.loadData()
    },
    methods: {
        async loadData() {
            try {
                this.allCourses = (await db.getAllCourses()) || []
                console.log('[COURSE-PAGE] getAllCourses count:', this.allCourses.length)
            } catch (e) {
                console.error('[COURSE-PAGE] getAllCourses failed:', e)
                this.allCourses = []
            }
            try {
                this.todayCourses = (await db.getCoursesByDate(this.todayStr)) || []
                console.log('[COURSE-PAGE] getCoursesByDate count:', this.todayCourses.length, 'date:', this.todayStr)
            } catch (e) {
                console.error('[COURSE-PAGE] getCoursesByDate failed:', e)
                this.todayCourses = []
            }

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
            this.weekGroups = groups
            console.log('[COURSE-PAGE] weekGroups count:', groups.length)
        },

        getBorderColor(course) {
            if (course.is_rest) return this.theme.accentDim
            return this.theme.accent
        },

        getTypeTag(course) {
            if (course.is_rest) return '休息'
            if (course.is_self_study) return '自习'
            if (course.course_type === 'project') return '项目'
            return '上课'
        },

        longPressCourse(course) {
            uni.showActionSheet({
                itemList: ['编辑课程', '删除课程'],
                success: async (res) => {
                    if (res.tapIndex === 0) {
                        uni.navigateTo({ url: '/pages/course-editor/course-editor' })
                    } else if (res.tapIndex === 1) {
                        const confirm = await new Promise(r => {
                            uni.showModal({
                                title: '确认删除',
                                content: `确定要删除「${course.title}」吗？`,
                                success: r
                            })
                        })
                        if (confirm.confirm) {
                            await db.deleteCourse(course.id)
                            uni.showToast({ title: '已删除', icon: 'success' })
                            this.loadData()
                        }
                    }
                }
            })
        },

        goEditor() {
            uni.navigateTo({ url: '/pages/course-editor/course-editor' })
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

.tabs {
    display: flex;
    border-bottom: 1px solid;
    margin-bottom: 12px;
}

.tab {
    flex: 1;
    text-align: center;
    padding: 10px 0;
    font-size: 13px;
    border-bottom: 2px solid transparent;
}

.edit-entry {
    padding: 10px 12px;
    font-size: 13px;
    font-weight: bold;
}

.content {
    flex: 1;
}

.date-header {
    padding: 8px 12px;
    border-radius: 6px;
    margin-bottom: 6px;
}

.date-header-text {
    font-size: 12px;
    font-weight: bold;
}

.course-item {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 10px 12px;
    border-radius: 8px;
    border: 1px solid;
    border-left-style: solid;
    margin-bottom: 6px;
    height: 48px;
}

.type-tag {
    padding: 2px 6px;
    border-radius: 4px;
    font-size: 10px;
    flex-shrink: 0;
}

.course-time {
    font-size: 11px;
    font-family: monospace;
    min-width: 80px;
    flex-shrink: 0;
}

.course-title {
    font-size: 13px;
    font-weight: bold;
    flex: 1;
}

.today-badge {
    padding: 3px 10px;
    border-radius: 10px;
    font-size: 10px;
    font-weight: bold;
    flex-shrink: 0;
}

.empty {
    padding: 40px;
    text-align: center;
    font-size: 15px;
}
</style>