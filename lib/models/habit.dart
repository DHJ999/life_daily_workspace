import 'package:flutter/material.dart';

/// 打卡方式：勾选 / 计数 / 数值
enum HabitType { check, counter, value }

/// 一个习惯
class Habit {
  final String id;
  final String name;
  final HabitType type;
  final double target; // 目标值（check 恒为 1）
  final String unit; // 单位（次/分钟/ml...）
  final Color color;
  final DateTime createdAt;

  /// 每天记录：key = yyyy-MM-dd, value = 当日打卡值
  final Map<String, double> entries;

  /// 图标 codePoint（存 int，避免运行时构造 IconData 破坏图标字体 tree-shake）
  final int iconCodePoint;

  Habit({
    required this.id,
    required this.name,
    required this.type,
    this.target = 1,
    this.unit = '',
    this.iconCodePoint = 0xe86c, // Icons.check_circle 的 codePoint
    this.color = const Color(0xFF1D9E75),
    required this.createdAt,
    Map<String, double>? entries,
  }) : entries = entries ?? {};

  /// 渲染用图标（从 const 表中查找，保证可被 tree-shake）
  IconData get icon => const {
    0xe86c: Icons.check_circle, // check_circle
    0xe8d5: Icons.local_drink, // 喝水
    0xe32a: Icons.directions_run, // 跑步
    0xe322: Icons.self_improvement, // 冥想/坐
    0xe8e9: Icons.fitness_center, // 健身
    0xe6d6: Icons.book, // 读书
    0xe7d7: Icons.music_note, // 音乐
    0xe2bd: Icons.wb_sunny, // 早起
  }[iconCodePoint] ??
      Icons.check_circle;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'target': target,
        'unit': unit,
        'icon': iconCodePoint,
        'color': color.toARGB32(),
        'createdAt': createdAt.toIso8601String(),
        'entries': entries.map((k, v) => MapEntry(k, v)),
      };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        id: json['id'] as String,
        name: json['name'] as String,
        type: HabitType.values.firstWhere(
            (t) => t.name == json['type'],
            orElse: () => HabitType.check),
        target: (json['target'] as num?)?.toDouble() ?? 1,
        unit: json['unit'] as String? ?? '',
        iconCodePoint: (json['icon'] as int?) ?? 0xe86c,
        color: Color(json['color'] as int? ?? 0xFF1D9E75),
        createdAt: DateTime.parse(json['createdAt'] as String),
        entries: (json['entries'] as Map<String, dynamic>? ?? {})
            .map((k, v) => MapEntry(k, (v as num).toDouble())),
      );

  bool isDoneOn(String date) {
    if (type == HabitType.check) return (entries[date] ?? 0) > 0;
    return (entries[date] ?? 0) >= target;
  }

  int streakDays() {
    var streak = 0;
    var day = DateTime.now();
    while (true) {
      final date = _fmt(day);
      if ((entries[date] ?? 0) > 0) {
        streak++;
        day = day.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  static String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
