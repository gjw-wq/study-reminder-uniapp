/**
 * 配置管理模块 - 基于 uni.storage 的键值配置
 * 对应原 Python 版 core/config.py
 * 新增习惯CRUD方法
 */

const DEFAULT_CONFIG = {
    reminder_advance_minutes: 15,
    reminder_sound: true,
    reminder_popup: true,
    reminder_tray_flash: true,
    theme: 'dark',
    auto_start: false,
    peer_board_enabled: false,
    check_in_time: '08:25',
    evening_study_start: '19:25',
    evening_study_end: '22:30',
    wake_up_time: '07:00',
    habits: [
        { index: 0, name: '拒绝睡懒觉', icon: 'bed' },
        { index: 1, name: '拒绝为了女朋友请假', icon: 'heart' },
        { index: 2, name: '拒绝晚自习下课即跑', icon: 'run' },
        { index: 3, name: '拒绝不交作业', icon: 'book' },
        { index: 4, name: '拒绝打游戏、看游戏', icon: 'game' },
        { index: 5, name: '拒绝离不开手机', icon: 'phone' }
    ],
    window_position: { x: 100, y: 100 },
    window_collapsed: false
}

const ICONS = ['bed', 'heart', 'run', 'book', 'game', 'phone', 'star', 'fire', 'light', 'check']

class Config {
    constructor() {
        this._cache = null
    }

    _load() {
        if (this._cache !== null) return this._cache
        try {
            const stored = uni.getStorageSync('app_config')
            if (stored) {
                this._cache = JSON.parse(stored)
            } else {
                this._cache = JSON.parse(JSON.stringify(DEFAULT_CONFIG))
            }
        } catch (e) {
            this._cache = JSON.parse(JSON.stringify(DEFAULT_CONFIG))
        }
        return this._cache
    }

    _save() {
        try {
            uni.setStorageSync('app_config', JSON.stringify(this._cache))
        } catch (e) {
            console.error('Config save failed:', e)
        }
    }

    get(key, defaultValue) {
        const data = this._load()
        return data[key] !== undefined ? data[key] : defaultValue
    }

    set(key, value) {
        this._load()
        this._cache[key] = value
        this._save()
    }

    getHabits() {
        return this.get('habits', DEFAULT_CONFIG.habits)
    }

    getAll() {
        return this._load()
    }

    // ==================== 习惯管理 ====================

    addHabit(name, icon) {
        // 用 slice 创建副本，避免 Vue 2 因引用未变而不触发重新渲染
        const habits = this.getHabits().slice()
        const maxIndex = habits.length > 0 ? Math.max(...habits.map(h => h.index)) : -1
        habits.push({
            index: maxIndex + 1,
            name: name || '新习惯',
            icon: icon || 'star'
        })
        this.set('habits', habits)
        return habits[habits.length - 1]
    }

    updateHabit(index, data) {
        const habits = this.getHabits()
        const idx = habits.findIndex(h => h.index === index)
        if (idx !== -1) {
            habits[idx] = { ...habits[idx], ...data }
            this.set('habits', habits)
        }
    }

    removeHabit(index) {
        let habits = this.getHabits()
        habits = habits.filter(h => h.index !== index)
        this.set('habits', habits)
    }

    reorderHabits(newOrder) {
        // newOrder: [{index, name, icon}, ...]
        const habits = newOrder.map((h, i) => ({
            index: i,
            name: h.name,
            icon: h.icon || 'star'
        }))
        this.set('habits', habits)
    }

    getAvailableIcons() {
        return ICONS
    }
}

export const config = new Config()