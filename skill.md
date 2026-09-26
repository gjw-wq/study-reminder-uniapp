# Study Reminder App 开发 Skill 文档

> 本文档沉淀 study-reminder-app（HBuilder X + uni-app + Vue 2 Android 应用）开发过程中遇到的所有问题、排查策略与技术决策，供后续维护与同类问题参考。

---

## 一、项目概述

- **平台**：HBuilder X 云打包 Android 应用
- **框架**：uni-app（Vue 2 响应式）
- **语言**：JavaScript（ES6+）
- **存储**：uni.storage（plus.storage 同步键值对）为主，SQLite 预留
- **核心功能**：课程表提醒、习惯打卡、学习复盘日志、数据导入导出、主题配置

---

## 二、存储架构决策（最关键）

### 决策：业务数据全部走 `uni.storage`，SQLite 仅预留

| 数据类型 | 存储方式 | storage key | 说明 |
|---|---|---|---|
| 课程数据 | uni.storage | `courses_data` | 141 条真实课程 |
| 课程版本号 | uni.storage | `courses_data_version` | 迁移触发器 |
| 习惯打卡 | uni.storage | `habit_checks_data` | 数组结构 |
| 学习日志 | uni.storage | `study_logs_data` | 数组结构 |
| 应用配置 | uni.storage | `app_config` | 主题/时间/习惯定义 |
| reminders 表 | SQLite（空） | - | 预留，从未写入 |
| app_meta 表 | SQLite（空） | - | 预留，从未写入 |

### 为什么放弃 SQLite

`plus.sqlite.executeSql` 在云打包环境下存在**静默失败 bug**：调用 `success` 回调但数据未真正写入，`selectSql` 也读不到。这导致课程、打卡、复盘数据全部"写入失败"。改用 `uni.setStorageSync`（同步、可靠、立即落盘）后问题彻底消失。

### storage 统一封装模式

```javascript
const STORAGE_KEY = 'xxx_data'

function _load() {
    try {
        const arr = uni.getStorageSync(STORAGE_KEY)
        return Array.isArray(arr) ? arr : []
    } catch (e) {
        console.error('load from storage failed:', e)
        return []
    }
}

function _save(arr) {
    try {
        uni.setStorageSync(STORAGE_KEY, arr || [])
    } catch (e) {
        console.error('save to storage failed:', e)
    }
}

function _nextId(arr) {
    let max = 0
    for (const item of arr) {
        if (item && typeof item.id === 'number' && item.id > max) max = item.id
    }
    return max + 1
}
```

---

## 三、问题解答策略库

### 问题 1：数据写入后读不到（SQLite 静默失败）

**现象**：INSERT 后 SELECT 返回空，控制台报 `no such table` 或 `actually_in_db=0`，但 `executeSql` 走 success 回调。

**根因**：HBuilder X `plus.sqlite.executeSql` 在部分云打包环境静默失败。

**排查策略**：
1. 确认是否重新云打包（旧包跑旧代码）
2. 在写入后立即读取验证（`getAllXxx()` 计数）
3. 若 SQLite 反复失败 → 改走 `uni.storage`

**解决**：整张表改走 storage，使用统一封装模式（见上）。

---

### 问题 2：异步调用未 await 导致写入丢失

**现象**：调用 `db.checkHabit(...)` 后立即更新 UI，但数据未真正写入。

**根因**：调用方未 `await` 异步方法，即使方法内部写入成功，错误也无法捕获；若方法走 SQLite 则更易静默失败。

**解决**：
- 调用方方法声明为 `async`，内部 `await db.xxx(...)`
- 回调函数（如 `uni.showModal` 的 success）也要 `async (res) => { await ... }`
- 循环内逐条 `await`

```javascript
// 错误写法
doCheck(habit) {
    db.checkHabit(...)  // 未 await
    this.checkedMap = { ... }
}

// 正确写法
async doCheck(habit) {
    await db.checkHabit(...)
    this.checkedMap = { ... }
}
```

---

### 问题 3：Vue 2 响应式失效（视图不更新）

**现象**：数据已修改（缓存里有），但页面列表不刷新，如"点击添加新习惯无反应"。

**根因**：直接修改数组引用（`push`/`splice`）或对象属性后，赋值给 Vue data 的仍是同一引用，Vue 2 判定无变化不重新渲染。

**排查策略**：
- 在控制台打印 `this.xxx` 确认数据是否真的变了
- 若数据变了但视图没变 → 响应式问题

**解决**：
1. 修改数据时创建副本：`const arr = this.getHabits().slice()`
2. 赋值给 Vue data 时深拷贝：`this.habits = JSON.parse(JSON.stringify(config.getHabits()))`

```javascript
// 错误写法（引用未变）
addHabit(name) {
    const habits = this.getHabits()  // 返回内部引用
    habits.push({...})               // 修改原数组
    this.set('habits', habits)       // 同一引用
}
// 调用方
this.habits = config.getHabits()    // 同一引用，Vue 不渲染

// 正确写法
addHabit(name) {
    const habits = this.getHabits().slice()  // 副本
    habits.push({...})
    this.set('habits', habits)               // 新引用
}
// 调用方
this.habits = JSON.parse(JSON.stringify(config.getHabits()))  // 深拷贝
```

---

### 问题 4：底部导航图标缺失

**现象**：tabBar 某些 tab 不显示图标。

**根因**：图标文件是空 PNG 占位（88 字节，1x1 透明），实际无图形内容。

**排查策略**：
- 检查 `static/tab-*.png` 文件大小（正常 200-300 字节，空占位 88 字节）
- 用 `System.Drawing.Image.FromFile` 读尺寸确认

**解决**：用 PowerShell + System.Drawing 重新生成 48x48 PNG：

```powershell
Add-Type -AssemblyName System.Drawing
function MakeIcon($path, $cr, $cg, $cb, $shape) {
    $bmp = New-Object System.Drawing.Bitmap(48, 48)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([System.Drawing.Color]::Transparent)
    $color = [System.Drawing.Color]::FromArgb($cr, $cg, $cb)
    # 绘制图形（对勾/网格/线条）
    $pen = New-Object System.Drawing.Pen($color, 4.0)
    $g.DrawLine($pen, x1, y1, x2, y2)
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose()
}
# 普通态 #555555，激活态 #3ddc84（与 pages.json tabBar 配色一致）
```

> 注意：PowerShell 中用 `[System.Drawing.Color]::FromArgb(r,g,b)`，不要用 `ColorTranslator.FromHtml`（API 写法易错）。

---

### 问题 5：课程数据版本迁移

**现象**：内置课程数据更新后，老用户 storage 里仍是旧数据。

**解决**：版本号机制自动迁移：

```javascript
const COURSE_DATA_VERSION = '2026-08-v1'

async function initCourseData(db) {
    const storedVersion = uni.getStorageSync('courses_data_version') || ''
    if (storedVersion === COURSE_DATA_VERSION) {
        const existing = await db.getAllCourses()
        if (existing.length > 0) return  // 版本匹配且有数据，跳过
    }
    // 版本不匹配或无数据 → 清空 + 重写 + 写版本号
    await db.clearCourses()
    await db.batchInsertCourses(REAL_COURSE_SCHEDULE)
    uni.setStorageSync('courses_data_version', COURSE_DATA_VERSION)
}
```

---

### 问题 6：备份恢复策略

**现象**：.db 文件导出/导入不含 storage 数据，用户误以为 .db 是完整备份。

**决策**：
- **JSON 统一备份恢复**（推荐）：含 courses + habit_checks + study_logs
- **.db 文件**：仅含 SQLite 残留空表，无业务价值，UI 文案标注"仅打卡/日志"或隐藏

**exportAllData 结构**：
```javascript
{
    version: '1.0',
    exportTime: '...',
    courses: [...],         // 来自 storage
    habit_checks: [...],    // 来自 storage
    study_logs: [...]       // 来自 storage
}
```

**注意**：`app_config`（配置/习惯定义）目前不在导出范围内，换机会丢失。如需完整备份可补充。

---

### 问题 7：批量导入文本被截断 + 无法直接导入 JSON 文件

**现象**：导出 APP 后，课程编辑页「批量导入」和数据管理页「导入JSON」粘贴长文本后被截断，141 条课程只能导进一小部分；且两处都只能粘贴文本，不能选文件。

**根因**：
1. **uni-app `textarea` 默认 `maxlength = 140`**。不显式设置时框架自动补 `maxlength="140"`，超过即无法继续输入（审查元素可见）。
2. **App 端 `uni.chooseFile` 不支持选择非媒体文件**（官方明确：App 需 Native.js 或插件市场插件）。
3. 旧解析只做一次 `JSON.parse`，粘贴内容被截断后直接报"JSON格式错误"。

**修复方案**：
- 所有 `textarea` 显式加 `maxlength="-1"`（不限制）或 `:maxlength="500"`；导入框高度提到 180px
- 新建 [common/file-import.js](file:///d:/360MoveData/Users/Administrator/Desktop/study-reminder/study-reminder-app/common/file-import.js)：
  - `pickJsonFile()`：Android 用 Native.js 调起系统文件选择器（`ACTION_GET_CONTENT` + `CATEGORY_OPENABLE`），URI 读取五级降级：`file://` 直读 → `plus.android.resolveNativeUri()` → MediaStore `_data` → `plus.io` 解析 → `ContentResolver.openInputStream` 流式读取
  - `listJsonFiles()`：扫描 `_downloads`/`_doc`/`/storage/emulated/0/Download|Documents` 自建选择列表（Android 11+ 分区存储可能扫不到，作兜底）
  - `readClipboardText()`：剪贴板通道
  - `parseCoursesText()` / `parseBackupText()`：容错解析（整体 JSON / `{courses:[]}` / 完整备份 / NDJSON 每行一个对象 / 多余逗号 / 中文引号 / BOM）
- 大文本（>6000 字符）不在 textarea 渲染全文，改为摘要 + 「载入原文」，避免卡顿；导入时以原文为准
- `db.importAllData(data, { clear })` 支持覆盖/追加两种模式，返回条数统计；id 统一重排避免冲突

**关键代码片段（Android 文件选择器）**：
```javascript
const main = plus.android.runtimeMainActivity()
const Intent = plus.android.importClass('android.content.Intent')
const intent = new Intent(Intent.ACTION_GET_CONTENT)
intent.addCategory(Intent.CATEGORY_OPENABLE)   // 必加，否则部分 ROM 无响应
intent.setType('*/*')
main.onActivityResult = function (requestCode, resultCode, data) {
    if (requestCode !== REQ || resultCode !== -1 || !data) return
    const uri = data.getData()      // content:// 或 file://
    // 读取：resolveNativeUri -> MediaStore _data -> plus.io -> openInputStream
}
main.startActivityForResult(intent, REQ)
```

**注意**：不要用 `cursor.getString(cursor.getColumnIndex("_data"))` 作为唯一手段——Android 10+ 已废弃；最终兜底是 `ContentResolver.openInputStream` + `BufferedReader.readLine()` 流式读取。

---

## 四、通用排查策略

### 4.1 数据问题排查流程

1. **确认是否重新打包**：HBuilder X 云打包后旧代码不生效，必须重新打包安装
2. **加日志验证**：写入后立即读取计数，对比 `expected` vs `actually`
3. **区分存储层**：确认数据在 storage 还是 SQLite，用对应方式读取
4. **检查异步调用**：grep 调用方是否有 `await`，方法是否 `async`
5. **检查响应式**：数据变了视图没变 → 引用问题 → 深拷贝

### 4.2 修改前必读

- **先读再改**：用 Read 工具读目标文件，理解上下文
- **最小改动**：只改相关部分，不动其他区域（符合用户偏好）
- **接口兼容**：方法签名、返回字段不变，避免影响调用方
- **并行编辑**：不同文件的独立编辑可并行，同文件不同位置的 Edit 也可并行（old_string 不重叠）

### 4.3 验证检查清单

- [ ] 重新云打包安装
- [ ] 启动日志确认初始化成功（`actually_in_storage=N`）
- [ ] 写入后重新进入页面，数据仍在
- [ ] 数据管理页各 tab 能浏览数据
- [ ] 导出 JSON 含三类数据
- [ ] tabBar 4 个图标正常显示

---

## 五、已知坑与规避

| 坑 | 规避方式 |
|---|---|
| `plus.sqlite.executeSql` 静默失败 | 业务数据全部走 `uni.storage` |
| Vue 2 数组响应式失效 | `.slice()` 创建副本 + `JSON.parse(JSON.stringify())` 深拷贝 |
| 异步方法未 await | 调用方 `async` + `await`，回调函数也要 `async` |
| 空 PNG 占位图标 | 检查文件大小，用 System.Drawing 生成真实图标 |
| 旧包跑旧代码 | 改完必须重新云打包 |
| `ColorTranslator.FromHtml` API 写错 | 用 `Color.FromArgb(r,g,b)` 传数值 RGB |
| .db 文件不含 storage 数据 | JSON 统一备份恢复，.db 仅辅助 |
| 版本升级数据不迁移 | 版本号机制（`xxx_data_version`）触发自动重建 |
| `textarea` 不设 maxlength 默认 140 字截断 | 显式写 `maxlength="-1"`；导入框用 `:value` + `@input` 手动同步 |
| App 端 `uni.chooseFile` 选不了 JSON | Android 用 Native.js `ACTION_GET_CONTENT`，或 plus.io 扫描目录自建列表 |
| `<text>` 内嵌 `<template v-if>` | uni-app 编译不稳，改 computed 返回拼接字符串 |

---

## 六、关键文件索引

| 文件 | 职责 |
|---|---|
| [common/database.js](file:///d:/360MoveData/Users/Administrator/Desktop/study-reminder/study-reminder-app/common/database.js) | 数据层：courses/habits/logs 的 storage CRUD + 导入导出 |
| [common/file-import.js](file:///d:/360MoveData/Users/Administrator/Desktop/study-reminder/study-reminder-app/common/file-import.js) | 导入工具：文件选择器/目录扫描/剪贴板/容错 JSON 解析/导出写文件 |
| [common/config.js](file:///d:/360MoveData/Users/Administrator/Desktop/study-reminder/study-reminder-app/common/config.js) | 配置层：主题/时间/习惯定义，storage 持久化 |
| [common/course-data.js](file:///d:/360MoveData/Users/Administrator/Desktop/study-reminder/study-reminder-app/common/course-data.js) | 课程初始化 + 版本迁移 |
| [common/courses-real.js](file:///d:/360MoveData/Users/Administrator/Desktop/study-reminder/study-reminder-app/common/courses-real.js) | 内置 141 条真实课程数据 |
| [common/courses-real.json](file:///d:/360MoveData/Users/Administrator/Desktop/study-reminder/study-reminder-app/common/courses-real.json) | 可批量导入的 JSON 备份 |
| [pages/habit/habit.vue](file:///d:/360MoveData/Users/Administrator/Desktop/study-reminder/study-reminder-app/pages/habit/habit.vue) | 习惯打卡页 |
| [pages/review/review.vue](file:///d:/360MoveData/Users/Administrator/Desktop/study-reminder/study-reminder-app/pages/review/review.vue) | 复盘日志页 |
| [pages/review-history/review-history.vue](file:///d:/360MoveData/Users/Administrator/Desktop/study-reminder/study-reminder-app/pages/review-history/review-history.vue) | 复盘历史页 |
| [pages/settings/settings.vue](file:///d:/360MoveData/Users/Administrator/Desktop/study-reminder/study-reminder-app/pages/settings/settings.vue) | 设置页（习惯管理/主题/时间） |
| [pages/data-manager/data-manager.vue](file:///d:/360MoveData/Users/Administrator/Desktop/study-reminder/study-reminder-app/pages/data-manager/data-manager.vue) | 数据管理页（导入导出/浏览/清空） |
| [pages/course-editor/course-editor.vue](file:///d:/360MoveData/Users/Administrator/Desktop/study-reminder/study-reminder-app/pages/course-editor/course-editor.vue) | 课程编辑页 |
| [pages.json](file:///d:/360MoveData/Users/Administrator/Desktop/study-reminder/study-reminder-app/pages.json) | 路由 + tabBar 配置 |
| [static/tab-*.png](file:///d:/360MoveData/Users/Administrator/Desktop/study-reminder/study-reminder-app/static) | 底部导航图标（48x48，灰#555555/绿#3ddc84） |

---

## 七、数据结构参考

### 课程对象
```json
{
    "id": 1,
    "date": "2026-06-16",
    "weekday": 1,
    "title": "早读",
    "course_type": "lecture",
    "start_time": "07:00",
    "end_time": "07:30",
    "description": null,
    "is_rest": 0,
    "is_self_study": 0,
    "created_at": "2026-08-02T..."
}
```

### 习惯打卡对象
```json
{
    "id": 1,
    "habit_index": 0,
    "habit_name": "拒绝睡懒觉",
    "check_date": "2026-08-02",
    "checked": 1,
    "created_at": "2026-08-02T..."
}
```

### 学习日志对象
```json
{
    "id": 1,
    "log_date": "2026-08-02",
    "gain1": "收获1",
    "gain2": "收获2",
    "gain3": "收获3",
    "question": "疑问",
    "courses_today": "今日课程",
    "created_at": "2026-08-02T..."
}
```

---

## 八、开发流程要点

1. **改完必重新云打包**：HBuilder X → 发行 → 云打包 → 安装新 APK
2. **日志看控制台**：HBuilder X 控制台或 Android logcat
3. **改一处验一处**：避免一次改多处难定位问题
4. **保持接口兼容**：方法签名和返回字段不变，调用方无需改动
5. **同源问题一并修**：发现 SQLite 静默失败，所有业务表统一改 storage，避免逐个返工
