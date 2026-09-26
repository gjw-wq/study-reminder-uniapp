<template>
    <view class="page" :style="{ backgroundColor: theme.bg }">
        <scroll-view class="content" scroll-y>
            <view v-if="logs.length === 0" class="empty">
                <text :style="{ color: theme.textDim }">暂无复盘记录</text>
            </view>

            <view v-for="log in logs" :key="log.log_date" class="log-card"
                  :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }">
                <view class="log-header">
                    <text class="log-date" :style="{ color: theme.accent }">{{ log.log_date }}</text>
                    <view class="log-actions">
                        <text class="edit-btn" :style="{ color: theme.accent }" @click="editLog(log)">编辑</text>
                        <text class="del-btn" :style="{ color: theme.accentDim }" @click="deleteLog(log.log_date)">删除</text>
                    </view>
                </view>

                <view v-if="expandedLog === log.log_date" class="log-detail">
                    <view v-if="log.gain1" class="log-field">
                        <text class="field-label" :style="{ color: theme.textSecondary }">收获 1:</text>
                        <text class="field-val" :style="{ color: theme.textPrimary }">{{ log.gain1 }}</text>
                    </view>
                    <view v-if="log.gain2" class="log-field">
                        <text class="field-label" :style="{ color: theme.textSecondary }">收获 2:</text>
                        <text class="field-val" :style="{ color: theme.textPrimary }">{{ log.gain2 }}</text>
                    </view>
                    <view v-if="log.gain3" class="log-field">
                        <text class="field-label" :style="{ color: theme.textSecondary }">收获 3:</text>
                        <text class="field-val" :style="{ color: theme.textPrimary }">{{ log.gain3 }}</text>
                    </view>
                    <view v-if="log.question" class="log-field">
                        <text class="field-label" :style="{ color: theme.textSecondary }">疑问:</text>
                        <text class="field-val" :style="{ color: theme.textPrimary }">{{ log.question }}</text>
                    </view>
                    <view v-if="log.courses_today" class="log-field">
                        <text class="field-label" :style="{ color: theme.textSecondary }">课程:</text>
                        <text class="field-val" :style="{ color: theme.textPrimary }">{{ log.courses_today }}</text>
                    </view>
                </view>
                <view v-else class="log-preview" @click="toggleExpand(log.log_date)">
                    <text :style="{ color: theme.textSecondary }">{{ (log.gain1 || '').substring(0, 50) }}{{ log.gain1 && log.gain1.length > 50 ? '...' : '' }}</text>
                    <text class="expand-hint" :style="{ color: theme.textDim }">点击展开</text>
                </view>
            </view>
        </scroll-view>

        <!-- 编辑弹窗 -->
        <view v-if="showEditDialog" class="modal-mask" @click="showEditDialog = false">
            <view class="modal" :style="{ backgroundColor: theme.bgCard, borderColor: theme.border }" @click.stop>
                <text class="modal-title" :style="{ color: theme.textPrimary }">编辑复盘 - {{ editForm.log_date }}</text>

                <textarea class="edit-input" :maxlength="500" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border, color: theme.textPrimary }"
                          v-model="editForm.gain1" placeholder="收获 1" />
                <textarea class="edit-input" :maxlength="500" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border, color: theme.textPrimary }"
                          v-model="editForm.gain2" placeholder="收获 2" />
                <textarea class="edit-input" :maxlength="500" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border, color: theme.textPrimary }"
                          v-model="editForm.gain3" placeholder="收获 3" />
                <textarea class="edit-input" :maxlength="500" :style="{ backgroundColor: theme.bgInput, borderColor: theme.border, color: theme.textPrimary }"
                          v-model="editForm.question" placeholder="遗留疑问" />

                <view class="modal-btns">
                    <view class="modal-btn cancel" :style="{ backgroundColor: theme.bg, borderColor: theme.border }"
                          @click="showEditDialog = false">
                        <text :style="{ color: theme.textSecondary }">取消</text>
                    </view>
                    <view class="modal-btn confirm" :style="{ backgroundColor: theme.accent }"
                          @click="saveEdit">
                        <text :style="{ color: theme.textOnAccent }">保存</text>
                    </view>
                </view>
            </view>
        </view>
    </view>
</template>

<script>
import { getTheme } from '../../common/theme.js'
import { db } from '../../common/database.js'

export default {
    data() {
        return {
            theme: getTheme(),
            logs: [],
            expandedLog: null,
            showEditDialog: false,
            editForm: {}
        }
    },
    onShow() {
        this.theme = getTheme()
        this.loadData()
    },
    methods: {
        async loadData() {
            this.logs = await db.getAllStudyLogs()
        },

        toggleExpand(date) {
            this.expandedLog = this.expandedLog === date ? null : date
        },

        editLog(log) {
            this.editForm = {
                log_date: log.log_date,
                gain1: log.gain1 || '',
                gain2: log.gain2 || '',
                gain3: log.gain3 || '',
                question: log.question || '',
                courses_today: log.courses_today || ''
            }
            this.showEditDialog = true
        },

        async saveEdit() {
            await db.saveStudyLog(
                this.editForm.log_date,
                this.editForm.gain1,
                this.editForm.gain2,
                this.editForm.gain3,
                this.editForm.question,
                this.editForm.courses_today
            )
            this.showEditDialog = false
            uni.showToast({ title: '已保存', icon: 'success' })
            this.loadData()
        },

        async deleteLog(date) {
            const res = await new Promise(r => {
                uni.showModal({ title: '确认删除', content: `确定要删除 ${date} 的复盘记录吗？`, success: r })
            })
            if (res.confirm) {
                await db.deleteStudyLog(date)
                uni.showToast({ title: '已删除', icon: 'success' })
                this.loadData()
            }
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
}

.empty {
    text-align: center;
    padding: 40px;
    font-size: 14px;
}

.log-card {
    border-radius: 8px;
    border: 1px solid;
    padding: 12px;
    margin-bottom: 10px;
}

.log-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 6px;
}

.log-date {
    font-size: 14px;
    font-weight: bold;
}

.log-actions {
    display: flex;
    gap: 12px;
    font-size: 12px;
}

.log-preview {
    padding: 4px 0;
}

.log-preview text {
    font-size: 12px;
    line-height: 1.4;
}

.expand-hint {
    display: block;
    font-size: 10px;
    margin-top: 4px;
}

.log-detail {
    padding-top: 8px;
}

.log-field {
    margin-bottom: 6px;
}

.field-label {
    font-size: 11px;
    font-weight: bold;
    display: block;
    margin-bottom: 2px;
}

.field-val {
    font-size: 12px;
    line-height: 1.5;
    display: block;
}

.modal-mask {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0,0,0,0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 100;
}

.modal {
    width: 90%;
    max-height: 85vh;
    border-radius: 12px;
    border: 1px solid;
    padding: 20px;
    overflow-y: auto;
}

.modal-title {
    font-size: 16px;
    font-weight: bold;
    text-align: center;
    margin-bottom: 16px;
    display: block;
}

.edit-input {
    width: 100%;
    min-height: 50px;
    border-radius: 6px;
    border: 1px solid;
    padding: 8px;
    font-size: 12px;
    margin-bottom: 8px;
    box-sizing: border-box;
}

.modal-btns {
    display: flex;
    gap: 10px;
}

.modal-btn {
    flex: 1;
    height: 38px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 13px;
}

.modal-btn.cancel {
    border: 1px solid;
}
</style>