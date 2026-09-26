/**
 * 提醒引擎模块 - 适配异步数据库API
 * 对应原 Python 版 core/reminder_engine.py
 * 移动端使用 setInterval 轮询 + plus.push 本地通知
 */

import { db } from './database.js'
import { config } from './config.js'
import { DAILY_ROUTINE } from './course-data.js'

// 今日已触发的提醒集合
const triggeredToday = new Set()
let lastCheckDate = ''
let timerId = null
let isRunning = false

function getTodayStr() {
    const now = new Date()
    const y = now.getFullYear()
    const m = String(now.getMonth() + 1).padStart(2, '0')
    const d = String(now.getDate()).padStart(2, '0')
    return `${y}-${m}-${d}`
}

function getCurrentTime() {
    const now = new Date()
    const h = String(now.getHours()).padStart(2, '0')
    const m = String(now.getMinutes()).padStart(2, '0')
    return `${h}:${m}`
}

function sendLocalNotification(title, description, type) {
    if (typeof plus === 'undefined') {
        console.log('[Reminder]', title, description)
        return
    }

    try {
        plus.push.createMessage(title, description, '__UNI__STUDY_REMINDER', {
            cover: false,
            when: new Date().getTime()
        })
    } catch (e) {
        console.error('Local notification failed:', e)
    }
}

async function checkReminders() {
    const now = new Date()
    const todayStr = getTodayStr()
    const currentTime = getCurrentTime()

    // 新的一天，重置触发记录
    if (todayStr !== lastCheckDate) {
        triggeredToday.clear()
        lastCheckDate = todayStr
    }

    // 检查作息提醒
    checkRoutineReminders(currentTime)

    // 检查课程提醒
    await checkCourseReminders(todayStr, currentTime)

    // 检查晚自习结束复盘提醒
    checkEveningReview(todayStr, currentTime)
}

function checkRoutineReminders(currentTime) {
    for (const routine of DAILY_ROUTINE) {
        const reminderKey = `routine_${routine.time}`
        if (currentTime === routine.time && !triggeredToday.has(reminderKey)) {
            triggeredToday.add(reminderKey)
            sendLocalNotification(routine.title, routine.description, routine.type)
        }
    }
}

async function checkCourseReminders(todayStr, currentTime) {
    const advance = config.get('reminder_advance_minutes', 15)
    const courses = await db.getCoursesByDate(todayStr)

    if (!courses) return

    for (const course of courses) {
        if (course.is_rest) continue

        const startTime = course.start_time
        if (!startTime) continue

        const [sh, sm] = startTime.split(':').map(Number)
        const reminderMin = sm - advance
        let reminderH = sh
        let reminderM = reminderMin
        if (reminderM < 0) {
            reminderM += 60
            reminderH -= 1
        }
        const reminderTime = `${String(reminderH).padStart(2, '0')}:${String(reminderM).padStart(2, '0')}`

        const reminderKey = `course_${course.id}_${reminderTime}`
        if (currentTime === reminderTime && !triggeredToday.has(reminderKey)) {
            triggeredToday.add(reminderKey)

            let description = ''
            if (course.is_self_study) {
                description = '自习时间到！请自觉学习，每隔一小时休息10分钟'
            } else if (course.course_type === 'lecture') {
                description = '讲师课程即将开始，请准备好笔记本和学习用品'
            } else {
                description = '课程即将开始，请做好准备'
            }

            sendLocalNotification(course.title, description, 'course')
        }
    }
}

function checkEveningReview(todayStr, currentTime) {
    const eveningEnd = config.get('evening_study_end', '22:30')
    if (currentTime === eveningEnd) {
        const reminderKey = `evening_review_${todayStr}`
        if (!triggeredToday.has(reminderKey)) {
            triggeredToday.add(reminderKey)
            sendLocalNotification(
                '每日学习复盘',
                '晚自习结束了！请完成今日学习复盘：1. 今日学到了什么？2. 有哪些问题需要解决？3. 明日学习计划是什么？',
                'review'
            )
        }
    }
}

/**
 * 获取下一个即将到来的提醒
 */
export async function getNextReminder() {
    const now = new Date()
    const todayStr = getTodayStr()

    const futureReminders = []

    // 课程提醒
    const advance = config.get('reminder_advance_minutes', 15)
    const courses = await db.getCoursesByDate(todayStr)
    if (courses) {
        for (const course of courses) {
            if (course.is_rest) continue
            const startTime = course.start_time
            if (!startTime) continue

            const [sh, sm] = startTime.split(':').map(Number)
            const reminderMin = sm - advance
            let reminderH = sh
            let reminderM = reminderMin
            if (reminderM < 0) {
                reminderM += 60
                reminderH -= 1
            }

            const reminderDate = new Date(now.getFullYear(), now.getMonth(), now.getDate(), reminderH, reminderM, 0)
            if (reminderDate > now) {
                futureReminders.push({
                    type: 'course',
                    title: course.title,
                    time: reminderDate,
                    originalTime: startTime
                })
            }
        }
    }

    // 作息提醒
    for (const routine of DAILY_ROUTINE) {
        const [rh, rm] = routine.time.split(':').map(Number)
        const routineDate = new Date(now.getFullYear(), now.getMonth(), now.getDate(), rh, rm, 0)
        if (routineDate > now) {
            futureReminders.push({
                type: routine.type,
                title: routine.title,
                time: routineDate,
                originalTime: routine.time
            })
        }
    }

    if (futureReminders.length === 0) return null

    futureReminders.sort((a, b) => a.time - b.time)
    return futureReminders[0]
}

export function startReminderEngine() {
    if (isRunning) return
    isRunning = true
    lastCheckDate = getTodayStr()
    timerId = setInterval(checkReminders, 30000)
    console.log('Reminder engine started')
}

export function stopReminderEngine() {
    if (timerId) {
        clearInterval(timerId)
        timerId = null
    }
    isRunning = false
}