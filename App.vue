<script>
import { initDatabase, db } from './common/database.js'
import { config } from './common/config.js'
import { initCourseData } from './common/course-data.js'
import { startReminderEngine } from './common/reminder-engine.js'

export default {
    globalData: {
        theme: 'dark'
    },
    onLaunch: async function() {
        console.log('App Launch')
        try {
            // 初始化数据库（创建表结构）
            await initDatabase()
            // 清空旧课程再重新初始化（避免手机上残留过期的6-7月数据）
            try {
                // 如果表中全是今天之前的旧数据，则清空重新初始化
                const allCourses = await db.getAllCourses()
                const todayStr = (() => {
                    const n = new Date();
                    return `${n.getFullYear()}-${String(n.getMonth()+1).padStart(2,'0')}-${String(n.getDate()).padStart(2,'0')}`
                })()
                const hasRecent = allCourses && allCourses.some(c => c.date >= todayStr)
                if (!hasRecent) {
                    console.log('No recent courses found, clearing old data and re-initializing')
                    await db.clearCourses()
                }
            } catch (e) {
                console.log('Clear old courses skipped:', e.message)
            }
            // 导入默认课程数据（仅在首次启动时，await 确保顺序执行）
            try {
                await initCourseData(db)
            } catch (e) {
                console.log('Course data init skipped:', e.message)
            }
            // 根据配置设置主题
            const theme = config.get('theme', 'dark')
            this.globalData.theme = theme
            // 启动提醒引擎
            startReminderEngine()
        } catch (e) {
            console.error('App init failed:', e)
        }
    },
    onShow: function() {
        console.log('App Show')
    },
    onHide: function() {
        console.log('App Hide')
    }
}
</script>

<style>
page {
    background-color: #0a0a0a;
    color: #ffffff;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
}
</style>