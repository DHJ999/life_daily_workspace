import 'package:flutter/material.dart';

/// 日程统筹 - 单条事项
class PlanItem {
  final String id;
  final String date; // yyyy-MM-dd
  final String title;
  final String type; // 工作/生活/健康...
  final bool done;

  const PlanItem({
    required this.id,
    required this.date,
    required this.title,
    this.type = '一般',
    this.done = false,
  });

  PlanItem copyWith({String? date, String? title, String? type, bool? done}) =>
      PlanItem(
        id: id,
        date: date ?? this.date,
        title: title ?? this.title,
        type: type ?? this.type,
        done: done ?? this.done,
      );

  Map<String, dynamic> toJson() =>
      {'id': id, 'date': date, 'title': title, 'type': type, 'done': done};

  factory PlanItem.fromJson(Map<String, dynamic> json) => PlanItem(
        id: json['id'] as String,
        date: json['date'] as String,
        title: json['title'] as String,
        type: json['type'] as String? ?? '一般',
        done: json['done'] as bool? ?? false,
      );
}

/// 计划类型图标
class PlanTypeMeta {
  final String name;
  final IconData icon;
  final Color color;
  const PlanTypeMeta(this.name, this.icon, this.color);
  static const List<PlanTypeMeta> all = [
    PlanTypeMeta('工作', Icons.work, Color(0xFF185FA5)),
    PlanTypeMeta('生活', Icons.home, Color(0xFF1D9E75)),
    PlanTypeMeta('健康', Icons.favorite, Color(0xFFD4537E)),
    PlanTypeMeta('学习', Icons.school, Color(0xFFEF9F27)),
    PlanTypeMeta('社交', Icons.people, Color(0xFF7F77DD)),
    PlanTypeMeta('一般', Icons.event, Color(0xFF888780)),
  ];
  static PlanTypeMeta of(String name) =>
      all.firstWhere((m) => m.name == name, orElse: () => all.last);
}
