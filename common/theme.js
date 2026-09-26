/**
 * 主题管理模块
 * 对应原 Python 版 core/theme.py
 */

import { config } from './config.js'

export const THEME_DARK = {
    bg: '#0a0a0a',
    bgCard: '#111111',
    bgModule: '#0a0a0a',
    bgInput: '#111111',
    border: '#1f1f1f',
    borderHover: '#333333',
    accent: '#3ddc84',
    accentHover: '#4ee895',
    accentDim: '#2a9d5f',
    textPrimary: '#ffffff',
    textSecondary: '#a0a0a0',
    textDim: '#555555',
    textOnAccent: '#0a0a0a',
    tabBarBg: '#111111',
    tabBarBorder: '#1f1f1f'
}

export const THEME_LIGHT = {
    bg: '#f5f5f5',
    bgCard: '#ffffff',
    bgModule: '#f8f8f8',
    bgInput: '#ffffff',
    border: '#e0e0e0',
    borderHover: '#cccccc',
    accent: '#2a9d5f',
    accentHover: '#3ddc84',
    accentDim: '#1a7a47',
    textPrimary: '#1a1a1a',
    textSecondary: '#666666',
    textDim: '#aaaaaa',
    textOnAccent: '#ffffff',
    tabBarBg: '#ffffff',
    tabBarBorder: '#e0e0e0'
}

export function getTheme() {
    const theme = config.get('theme', 'dark')
    return theme === 'dark' ? THEME_DARK : THEME_LIGHT
}