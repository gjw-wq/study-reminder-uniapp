DELETE FROM courses WHERE date BETWEEN '2026-06-16' AND '2026-08-15';

INSERT INTO courses(date, weekday, title, course_type, start_time, end_time, is_rest, is_self_study)
VALUES(
    '2026-06-16',
    CASE strftime('%w', '2026-06-16')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-06-17',
    CASE strftime('%w', '2026-06-17')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-06-20',
    CASE strftime('%w', '2026-06-20')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-06-21',
    CASE strftime('%w', '2026-06-21')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-06-22',
    CASE strftime('%w', '2026-06-22')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '自习', 'self_study', '10:00', '12:00', 0, 1),
    ('2026-06-22',
    CASE strftime('%w', '2026-06-22')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '自习', 'self_study', '14:00', '17:00', 0, 1),
    ('2026-06-23',
    CASE strftime('%w', '2026-06-23')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-06-23',
    CASE strftime('%w', '2026-06-23')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-06-23',
    CASE strftime('%w', '2026-06-23')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-06-24',
    CASE strftime('%w', '2026-06-24')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-06-24',
    CASE strftime('%w', '2026-06-24')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-06-24',
    CASE strftime('%w', '2026-06-24')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-06-25',
    CASE strftime('%w', '2026-06-25')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '休息', 'rest', NULL, NULL, 1, 0),
    ('2026-06-26',
    CASE strftime('%w', '2026-06-26')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-06-26',
    CASE strftime('%w', '2026-06-26')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-06-26',
    CASE strftime('%w', '2026-06-26')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-06-27',
    CASE strftime('%w', '2026-06-27')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-06-27',
    CASE strftime('%w', '2026-06-27')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-06-27',
    CASE strftime('%w', '2026-06-27')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-06-28',
    CASE strftime('%w', '2026-06-28')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '自习', 'self_study', '10:00', '12:00', 0, 1),
    ('2026-06-28',
    CASE strftime('%w', '2026-06-28')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '自习', 'self_study', '14:00', '17:00', 0, 1),
    ('2026-06-29',
    CASE strftime('%w', '2026-06-29')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型语言进阶V4.0', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-06-29',
    CASE strftime('%w', '2026-06-29')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型语言进阶V4.0', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-06-29',
    CASE strftime('%w', '2026-06-29')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型语言进阶V4.0', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-06-30',
    CASE strftime('%w', '2026-06-30')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型语言进阶V4.0', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-06-30',
    CASE strftime('%w', '2026-06-30')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型语言进阶V4.0', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-06-30',
    CASE strftime('%w', '2026-06-30')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型语言进阶V4.0', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-07-01',
    CASE strftime('%w', '2026-07-01')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '休息', 'rest', NULL, NULL, 1, 0),
    ('2026-07-02',
    CASE strftime('%w', '2026-07-02')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-07-02',
    CASE strftime('%w', '2026-07-02')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-07-02',
    CASE strftime('%w', '2026-07-02')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-07-03',
    CASE strftime('%w', '2026-07-03')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-07-03',
    CASE strftime('%w', '2026-07-03')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-07-03',
    CASE strftime('%w', '2026-07-03')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-07-04',
    CASE strftime('%w', '2026-07-04')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '自习', 'self_study', '10:00', '12:00', 0, 1),
    ('2026-07-04',
    CASE strftime('%w', '2026-07-04')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '自习', 'self_study', '14:00', '17:00', 0, 1),
    ('2026-07-05',
    CASE strftime('%w', '2026-07-05')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型语言进阶V4.0', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-07-05',
    CASE strftime('%w', '2026-07-05')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型语言进阶V4.0', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-07-05',
    CASE strftime('%w', '2026-07-05')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型语言进阶V4.0', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-07-06',
    CASE strftime('%w', '2026-07-06')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型语言进阶V4.0', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-07-06',
    CASE strftime('%w', '2026-07-06')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型语言进阶V4.0', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-07-06',
    CASE strftime('%w', '2026-07-06')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型语言进阶V4.0', 'lecture', '19:25', '22:00', NULL, 0),
    ('2026-07-07',
    CASE strftime('%w', '2026-07-07')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '休息', 'rest', NULL, NULL, 1, 0),
    ('2026-07-08',
    CASE strftime('%w', '2026-07-08')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-07-08',
    CASE strftime('%w', '2026-07-08')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-07-08',
    CASE strftime('%w', '2026-07-08')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-07-09',
    CASE strftime('%w', '2026-07-09')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-07-09',
    CASE strftime('%w', '2026-07-09')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-07-09',
    CASE strftime('%w', '2026-07-09')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型开发入门V4.0', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-07-10',
    CASE strftime('%w', '2026-07-10')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '自习', 'self_study', '10:00', '12:00', 0, 1),
    ('2026-07-10',
    CASE strftime('%w', '2026-07-10')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '自习', 'self_study', '14:00', '17:00', 0, 1),
    ('2026-07-11',
    CASE strftime('%w', '2026-07-11')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型语言进阶V4.0', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-07-11',
    CASE strftime('%w', '2026-07-11')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型语言进阶V4.0', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-07-11',
    CASE strftime('%w', '2026-07-11')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型语言进阶V4.0', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-07-13',
    CASE strftime('%w', '2026-07-13')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型语言进阶V4.0', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-07-13',
    CASE strftime('%w', '2026-07-13')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型语言进阶V4.0', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-07-13',
    CASE strftime('%w', '2026-07-13')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '大模型语言进阶V4.0', 'lecture', '19:25', '22:00', NULL, 0),
    ('2026-07-12',
    CASE strftime('%w', '2026-07-12')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '休息', 'rest', NULL, NULL, 1, 0),
    ('2026-07-14',
    CASE strftime('%w', '2026-07-14')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '提示词工程', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-07-14',
    CASE strftime('%w', '2026-07-14')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '提示词工程', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-07-14',
    CASE strftime('%w', '2026-07-14')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '提示词工程', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-07-16',
    CASE strftime('%w', '2026-07-16')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '提示词工程', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-07-16',
    CASE strftime('%w', '2026-07-16')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '提示词工程', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-07-16',
    CASE strftime('%w', '2026-07-16')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '提示词工程', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-07-15',
    CASE strftime('%w', '2026-07-15')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '自习', 'self_study', '10:00', '12:00', 0, 1),
    ('2026-07-15',
    CASE strftime('%w', '2026-07-15')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '自习', 'self_study', '14:00', '17:00', 0, 1),
    ('2026-07-17',
    CASE strftime('%w', '2026-07-17')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-07-17',
    CASE strftime('%w', '2026-07-17')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-07-17',
    CASE strftime('%w', '2026-07-17')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-07-18',
    CASE strftime('%w', '2026-07-18')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '休息', 'rest', NULL, NULL, 1, 0),
    ('2026-07-19',
    CASE strftime('%w', '2026-07-19')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-07-19',
    CASE strftime('%w', '2026-07-19')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-07-19',
    CASE strftime('%w', '2026-07-19')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-07-20',
    CASE strftime('%w', '2026-07-20')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-07-20',
    CASE strftime('%w', '2026-07-20')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-07-20',
    CASE strftime('%w', '2026-07-20')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-07-21',
    CASE strftime('%w', '2026-07-21')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '自习', 'self_study', '10:00', '12:00', 0, 1),
    ('2026-07-21',
    CASE strftime('%w', '2026-07-21')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '自习', 'self_study', '14:00', '17:00', 0, 1),
    ('2026-07-22',
    CASE strftime('%w', '2026-07-22')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-07-22',
    CASE strftime('%w', '2026-07-22')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-07-22',
    CASE strftime('%w', '2026-07-22')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-07-23',
    CASE strftime('%w', '2026-07-23')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-07-23',
    CASE strftime('%w', '2026-07-23')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-07-23',
    CASE strftime('%w', '2026-07-23')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-07-24',
    CASE strftime('%w', '2026-07-24')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '休息', 'rest', NULL, NULL, 1, 0),
    ('2026-07-25',
    CASE strftime('%w', '2026-07-25')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-07-25',
    CASE strftime('%w', '2026-07-25')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-07-25',
    CASE strftime('%w', '2026-07-25')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-07-26',
    CASE strftime('%w', '2026-07-26')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-07-26',
    CASE strftime('%w', '2026-07-26')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-07-26',
    CASE strftime('%w', '2026-07-26')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-07-27',
    CASE strftime('%w', '2026-07-27')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '自习', 'self_study', '10:00', '12:00', 0, 1),
    ('2026-07-27',
    CASE strftime('%w', '2026-07-27')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '自习', 'self_study', '14:00', '17:00', 0, 1),
    ('2026-07-28',
    CASE strftime('%w', '2026-07-28')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-07-28',
    CASE strftime('%w', '2026-07-28')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-07-28',
    CASE strftime('%w', '2026-07-28')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '智能体开发(Coze+Dify)', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-07-29',
    CASE strftime('%w', '2026-07-29')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '项目实战', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-07-29',
    CASE strftime('%w', '2026-07-29')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '项目实战', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-07-29',
    CASE strftime('%w', '2026-07-29')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '项目实战', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-07-30',
    CASE strftime('%w', '2026-07-30')
       WHEN '0' THEN '星期日'
       WHEN '1' THEN '星期一'
       WHEN '2' THEN '星期二'
       WHEN '3' THEN '星期三'
       WHEN '4' THEN '星期四'
       WHEN '5' THEN '星期五'
       WHEN '6' THEN '星期六'
    END,
    '休息', 'rest', NULL, NULL, 1, 0),
    ('2026-07-31',
     CASE strftime('%w', '2026-07-31')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（ML）', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-07-31',
     CASE strftime('%w', '2026-07-31')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（ML）', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-07-31',
     CASE strftime('%w', '2026-07-31')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（ML）', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-08-01',
     CASE strftime('%w', '2026-08-01')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（ML）', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-08-01',
     CASE strftime('%w', '2026-08-01')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（ML）', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-08-01',
     CASE strftime('%w', '2026-08-01')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（ML）', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-08-02',
     CASE strftime('%w', '2026-08-02')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '自习', 'self_study', '10:00', '12:00', 0, 1),
    ('2026-08-02',
     CASE strftime('%w', '2026-08-02')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '自习', 'self_study', '14:00', '17:00', 0, 1),
    ('2026-08-03',
     CASE strftime('%w', '2026-08-03')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（ML）', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-08-03',
     CASE strftime('%w', '2026-08-03')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（ML）', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-08-03',
     CASE strftime('%w', '2026-08-03')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（ML）', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-08-04',
     CASE strftime('%w', '2026-08-04')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（ML）', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-08-04',
     CASE strftime('%w', '2026-08-04')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（ML）', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-08-04',
     CASE strftime('%w', '2026-08-04')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（ML）', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-08-05',
     CASE strftime('%w', '2026-08-05')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '休息', 'rest', NULL, NULL, 1, 0),
    ('2026-08-06',
     CASE strftime('%w', '2026-08-06')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（ML）', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-08-06',
     CASE strftime('%w', '2026-08-06')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（ML）', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-08-06',
     CASE strftime('%w', '2026-08-06')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（ML）', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-08-07',
     CASE strftime('%w', '2026-08-07')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（DL）', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-08-07',
     CASE strftime('%w', '2026-08-07')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（DL）', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-08-07',
     CASE strftime('%w', '2026-08-07')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（DL）', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-08-08',
     CASE strftime('%w', '2026-08-08')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '自习', 'self_study', '10:00', '12:00', 0, 1),
    ('2026-08-08',
     CASE strftime('%w', '2026-08-08')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '自习', 'self_study', '14:00', '17:00', 0, 1),
    ('2026-08-09',
     CASE strftime('%w', '2026-08-09')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（DL）', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-08-09',
     CASE strftime('%w', '2026-08-09')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（DL）', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-08-09',
     CASE strftime('%w', '2026-08-09')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（DL）', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-08-10',
     CASE strftime('%w', '2026-08-10')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '休息', 'rest', NULL, NULL, 1, 0),
    ('2026-08-11',
     CASE strftime('%w', '2026-08-11')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（DL）', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-08-11',
     CASE strftime('%w', '2026-08-11')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（DL）', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-08-11',
     CASE strftime('%w', '2026-08-11')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（DL）', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-08-12',
     CASE strftime('%w', '2026-08-12')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（DL）', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-08-12',
     CASE strftime('%w', '2026-08-12')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（DL）', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-08-12',
     CASE strftime('%w', '2026-08-12')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（DL）', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-08-13',
     CASE strftime('%w', '2026-08-13')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '自习', 'self_study', '10:00', '12:00', 0, 1),
    ('2026-08-13',
     CASE strftime('%w', '2026-08-13')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '自习', 'self_study', '14:00', '17:00', 0, 1),
    ('2026-08-14',
     CASE strftime('%w', '2026-08-14')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（DL）', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-08-14',
     CASE strftime('%w', '2026-08-14')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（DL）', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-08-14',
     CASE strftime('%w', '2026-08-14')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（DL）', 'lecture', '19:25', '22:30', NULL, 0),
    ('2026-08-15',
     CASE strftime('%w', '2026-08-15')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（DL）', 'lecture', '08:30', '12:20', 0, 0),
    ('2026-08-15',
     CASE strftime('%w', '2026-08-15')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（DL）', 'lecture', '14:30', '18:20', 0, 0),
    ('2026-08-15',
     CASE strftime('%w', '2026-08-15')
         WHEN '0' THEN '星期日'
         WHEN '1' THEN '星期一'
         WHEN '2' THEN '星期二'
         WHEN '3' THEN '星期三'
         WHEN '4' THEN '星期四'
         WHEN '5' THEN '星期五'
         WHEN '6' THEN '星期六'
     END,
     '大模型核心开发技术（DL）', 'lecture', '19:25', '22:30', NULL, 0);
UPDATE app_meta SET value = '2026-07-v1' WHERE key = 'course_data_version';
