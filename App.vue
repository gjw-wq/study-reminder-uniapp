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
            // 导入默认课程数据（仅首次/版本升级且用户未导入自有数据时，await 确保顺序执行）
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