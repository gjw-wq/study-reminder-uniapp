"""
生成 uni-app 所需的 tab bar 图标和应用图标
使用纯色 + 简单图形，无需外部依赖（仅 PIL/Pillow）
"""
import os
import math

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    print("请先安装 Pillow: pip install Pillow")
    exit(1)

STATIC_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'static')
os.makedirs(STATIC_DIR, exist_ok=True)

ACCENT = (61, 220, 132)       # #3ddc84 绿色
ACCENT_DIM = (42, 157, 95)    # #2a9d5f
DARK_BG = (17, 17, 17)        # #111111
WHITE = (255, 255, 255)
DIM = (85, 85, 85)            # #555555


def draw_home(draw, size, color):
    """绘制首页图标 - 房子形状"""
    w, h = size, size
    m = w // 8
    # 屋顶三角形
    draw.polygon([(w//2, m), (m, h//3), (w-m, h//3)], fill=color)
    # 屋身
    draw.rectangle([m*2, h//3, w-m*2, h-m], fill=color)


def draw_check(draw, size, color):
    """绘制打卡图标 - 对勾"""
    w, h = size, size
    m = w // 6
    # 圆形背景
    draw.ellipse([m, m, w-m, h-m], outline=color, width=max(2, w//20))
    # 对勾
    lw = max(2, w//16)
    cx, cy = w//2, h//2
    draw.line([(cx - m*2, cy), (cx - m//2, cy + m*2), (cx + m*2, cy - m)], fill=color, width=lw)


def draw_calendar(draw, size, color):
    """绘制课表图标 - 日历"""
    w, h = size, size
    m = w // 8
    # 日历主体
    draw.rounded_rectangle([m, m*2, w-m, h-m], radius=m//2, outline=color, width=max(2, w//20))
    # 顶部横条
    draw.rectangle([m, m*2, w-m, m*3], fill=color)
    # 文字线条
    lw = max(2, w//20)
    y1 = m*4 + m//2
    y2 = m*5 + m
    draw.line([(m*2, y1), (w-m*2, y1)], fill=color, width=lw)
    draw.line([(m*2, y2), (w-m*2, y2)], fill=color, width=lw)


def draw_settings(draw, size, color):
    """绘制设置图标 - 齿轮"""
    w, h = size, size
    cx, cy = w//2, h//2
    r_outer = w//3
    r_inner = w//6
    # 内部圆
    draw.ellipse([cx-r_inner, cy-r_inner, cx+r_inner, cy+r_inner], outline=color, width=max(2, w//20))
    # 齿
    lw = max(2, w//20)
    for i in range(8):
        angle = i * math.pi / 4
        x1 = cx + (r_inner + 2) * math.cos(angle)
        y1 = cy + (r_inner + 2) * math.sin(angle)
        x2 = cx + (r_outer - 2) * math.cos(angle)
        y2 = cy + (r_outer - 2) * math.sin(angle)
        draw.line([(x1, y1), (x2, y2)], fill=color, width=lw)


def create_icon_pair(name, size=48):
    """创建一对图标（普通色 + 激活色）"""
    # 普通图标（灰色）
    img_normal = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw_normal = ImageDraw.Draw(img_normal)
    draw_func = globals().get(f'draw_{name}')
    if draw_func:
        draw_func(draw_normal, size, DIM)
    img_normal.save(os.path.join(STATIC_DIR, f'tab-{name}.png'))

    # 激活图标（绿色）
    img_active = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw_active = ImageDraw.Draw(img_active)
    if draw_func:
        draw_func(draw_active, size, ACCENT)
    img_active.save(os.path.join(STATIC_DIR, f'tab-{name}-active.png'))

    print(f'  tab-{name}.png / tab-{name}-active.png')


def create_app_icon(size):
    """创建应用图标 - 绿色圆形 + A字母"""
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    m = size // 8
    # 绿色圆形背景
    draw.ellipse([m, m, size-m, size-m], fill=ACCENT)

    # 白色 A 字母
    try:
        font_size = size // 2
        font = ImageFont.truetype('arial.ttf', font_size)
    except:
        font = ImageFont.load_default()

    bbox = draw.textbbox((0, 0), 'A', font=font)
    tw = bbox[2] - bbox[0]
    th = bbox[3] - bbox[1]
    draw.text(((size-tw)//2, (size-th)//2 - size//20), 'A', fill=WHITE, font=font)

    filename = f'icon-{size}x{size}.png'
    img.save(os.path.join(STATIC_DIR, filename))
    print(f'  {filename}')


def create_splash(size_w, size_h):
    """创建启动图 - 纯黑背景 + 绿色圆点 + 文字"""
    img = Image.new('RGB', (size_w, size_h), DARK_BG)
    draw = ImageDraw.Draw(img)

    # 中心绿色圆点
    cx, cy = size_w // 2, size_h // 3
    r = min(size_w, size_h) // 8
    draw.ellipse([cx-r, cy-r, cx+r, cy+r], fill=ACCENT)

    # 文字
    try:
        font = ImageFont.truetype('msyh.ttc', size_w // 12)
    except:
        try:
            font = ImageFont.truetype('arial.ttf', size_w // 12)
        except:
            font = ImageFont.load_default()

    text = '学习纪律官'
    bbox = draw.textbbox((0, 0), text, font=font)
    tw = bbox[2] - bbox[0]
    draw.text(((size_w-tw)//2, cy + r + 30), text, fill=WHITE, font=font)

    filename = f'splash-{size_w}x{size_h}.png'
    img.save(os.path.join(STATIC_DIR, filename))
    print(f'  {filename}')


if __name__ == '__main__':
    print('生成 Tab Bar 图标...')
    create_icon_pair('home')
    create_icon_pair('habit')
    create_icon_pair('course')
    create_icon_pair('settings')

    print('\n生成应用图标...')
    for s in [72, 96, 144, 192]:
        create_app_icon(s)

    print('\n生成启动图...')
    create_splash(480, 800)
    create_splash(720, 1280)
    create_splash(1080, 1920)

    print('\n所有图标生成完成!')