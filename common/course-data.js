/**
 * 课程数据模块
 * 对应原 Python 版 core/course_data.py
 * 真实课程数据来源：1.sql（由 _parse_courses.py 解析生成 courses-real.json/js）
 */
import { REAL_COURSE_SCHEDULE } from './courses-real.js'

export const COURSE_SCHEDULE = REAL_COURSE_SCHEDULE

export const COURSE_MODULES = [
    '大模型开发入门V6.0',
    '大模型语言进阶V4.0',
    '智能体开发（Coze+Dify）',
    '大模型核心开发技术（ML）',
    '大模型核心开发技术（Transformer）',
    'NewsCompass投满分项目',
    'LangChain',
    'RAG项目',
    '智能体项目1',
    '智能体项目2',
    '大模型开发进阶V6.0-智能体实战',
    '大模型核心运行机制',
    '大模型微调开发',
    '计算机视觉基础',
    '多模态大模型'
]

export const DAILY_ROUTINE = [
    { time: '07:00', title: '起床时间', type: 'routine', description: '拒绝睡懒觉，新的一天开始！' },
    { time: '08:25', title: '晨检点名', type: 'routine', description: '点完名就不可以随便出入教室，准备上课！' },
    { time: '08:30', title: '上午课程开始', type: 'course_start', description: '集中精力，抓住重点，做好笔记' },
    { time: '12:20', title: '午休时间', type: 'routine', description: '适当休息，为下午充电！在教室休息的同学13:00后不要随意进出' },
    { time: '13:00', title: '午休纪律', type: 'routine', description: '教室保持安静，不要随意进出打扰他人休息' },
    { time: '14:15', title: '午间环节', type: 'routine', description: '整理上午笔记，准备下午课程资料' },
    { time: '14:30', title: '下午课程开始', type: 'course_start', description: '保持专注，善于总结，积极提问' },
    { time: '18:20', title: '晚饭时间', type: 'routine', description: '休息用餐，为晚自习充电！注意时间，不要迟到' },
    { time: '19:25', title: '晚自习点名', type: 'evening_start', description: '点完名就开始上自习，不可随便出去教室！' },
    { time: '19:25', title: '晚自习开始', type: 'evening_start', description: '第一时段：总结今日所学，完成课后练习' },
    { time: '20:40', title: '晚自习测试环节', type: 'evening_mid', description: '第二时段：进行测试练习、课本案例实操' },
    { time: '21:40', title: '晚自习预习环节', type: 'evening_mid', description: '第三时段：预习明日内容，整理问题清单' },
    { time: '22:30', title: '晚自习结束', type: 'evening_end', description: '完成今日复盘，记录收获！带好个人物品离开教室' },
    { time: '23:00', title: '就寝提醒', type: 'routine', description: '保证充足睡眠，明日再战！' }
]

export const COURSE_DATA_VERSION = '2026-08-v1'

const COURSES_VERSION_KEY = 'courses_data_version'

export async function initCourseData(db) {
    /**
     * 初始化课程表数据
     * 持久化层：uni.storage
     * 策略：版本号机制 —— storage 中 courses_data_version 与 COURSE_DATA_VERSION
     *       不一致（含全新安装、旧版本升级）时，清空重写真实课程数据并写入新版本号；
     *       版本一致且数据存在则跳过
     */
    const storedVersion = uni.getStorageSync(COURSES_VERSION_KEY)
    let needRewrite = false

    if (storedVersion !== COURSE_DATA_VERSION) {
        // 版本不匹配（全新安装 storedVersion='' / 旧版本升级）→ 清空重写
        console.log(`Course version mismatch: stored='${storedVersion}' vs current='${COURSE_DATA_VERSION}', rewriting`)
        needRewrite = true
    } else {
        // 版本匹配，确认数据存在（防异常丢失）
        let existing = []
        try {
            existing = await db.getAllCourses()
        } catch (e) {
            existing = []
        }
        if (!existing || existing.length === 0) {
            console.log('Version matches but no courses found, rewriting')
            needRewrite = true
        } else {
            console.log(`Course data already initialized (v=${storedVersion}, ${existing.length} rows), skipping init`)
            return
        }
    }

    if (needRewrite) {
        try {
            await db.clearCourses()
        } catch (e) {
            console.log('clearCourses before rewrite failed (ignored):', e.message)
        }
        try {
            await db.batchInsertCourses(COURSE_SCHEDULE)
        } catch (e) {
            console.error('batchInsertCourses failed:', e.message)
        }
        uni.setStorageSync(COURSES_VERSION_KEY, COURSE_DATA_VERSION)
    }

    // 验证写入结果
    let insertedCount = 0
    try {
        const rows = await db.getAllCourses()
        insertedCount = rows ? rows.length : 0
    } catch (e) {
        console.error('Verify courses failed:', e.message)
    }
    console.log(`Course data init complete: expected=${COURSE_SCHEDULE.length}, actually_in_storage=${insertedCount}, version=${COURSE_DATA_VERSION}`)
    if (insertedCount === 0) {
        console.error('WARNING: No courses found in storage after init!')
    }
}