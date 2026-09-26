# 截图目录

本目录存放 README 用到的功能截图。

当前 5 个文件是 **SVG 占位图**，需要替换为真机截图。

## 替换方式

按同名文件覆盖即可（**保留文件名**，README 里的引用就不会断）：

| 文件名 | 对应页面 | 路由 |
|---|---|---|
| `home.svg` | 首页 | `pages/index/index` |
| `habit.svg` | 今日习惯打卡 | `pages/habit/habit` |
| `course.svg` | 课程表 | `pages/course/course` |
| `review.svg` | 每日学习复盘 | `pages/review/review` |
| `data-manager.svg` | 数据管理中心 | `pages/data-manager/data-manager` |

如果换成 PNG，记得同步改 README.md 里的引用扩展名。

## 出图建议

- 尺寸统一 240×480（手机竖屏 1:2），README 里以两列表格并排展示
- 深色主题下截取，与应用默认配色一致（背景 `#0a0a0a`，强调色 `#3ddc84`）
- 状态栏不要带电量/时间等无关信息，或统一裁掉

## 取图命令

手机连上电脑后：

```bash
adb exec-out screencap -p > home.png
```

Windows PowerShell 下改用 `adb exec-out screencap -p | Set-Content -Encoding Byte home.png`。
