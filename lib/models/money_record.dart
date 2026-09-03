import 'package:flutter/material.dart';

/// 收支流水类型
enum FlowType { income, expense }

/// 记账分类（可扩展）
class MoneyCategory {
  final String name;
  final IconData icon;
  final Color color;
  final bool isIncome;

  const MoneyCategory(this.name, this.icon, this.color, {this.isIncome = false});

  static const List<MoneyCategory> incomeCategories = [
    MoneyCategory('工资', Icons.payments, Color(0xFF2E7D32), isIncome: true),
    MoneyCategory('奖金', Icons.card_giftcard, Color(0xFF2E7D32), isIncome: true),
    MoneyCategory('理财', Icons.trending_up, Color(0xFF2E7D32), isIncome: true),
    MoneyCategory('其他收入', Icons.add_circle_outline, Color(0xFF2E7D32), isIncome: true),
  ];

  static const List<MoneyCategory> expenseCategories = [
    MoneyCategory('餐饮', Icons.restaurant, Color(0xFFD85A30)),
    MoneyCategory('交通', Icons.directions_bus, Color(0xFF378ADD)),
    MoneyCategory('购物', Icons.shopping_bag, Color(0xFF7F77DD)),
    MoneyCategory('居住', Icons.home, Color(0xFF1D9E75)),
    MoneyCategory('娱乐', Icons.movie, Color(0xFFD4537E)),
    MoneyCategory('医疗', Icons.local_hospital, Color(0xFFE24B4A)),
    MoneyCategory('教育', Icons.school, Color(0xFFEF9F27)),
    MoneyCategory('其他支出', Icons.more_horiz, Color(0xFF888780)),
  ];

  static MoneyCategory fromName(String name, {FlowType flow = FlowType.expense}) {
    final list = flow == FlowType.income ? incomeCategories : expenseCategories;
    return list.firstWhere((c) => c.name == name,
        orElse: () => flow == FlowType.income
            ? const MoneyCategory('其他收入', Icons.add_circle_outline, Color(0xFF2E7D32), isIncome: true)
            : const MoneyCategory('其他支出', Icons.more_horiz, Color(0xFF888780)));
  }
}

/// 单笔收支记录
class MoneyRecord {
  final String id;
  final String date; // yyyy-MM-dd
  final FlowType flow;
  final String category;
  final double amount;
  final String note;

  const MoneyRecord({
    required this.id,
    required this.date,
    required this.flow,
    required this.category,
    required this.amount,
    this.note = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'flow': flow.name,
        'category': category,
        'amount': amount,
        'note': note,
      };

  factory MoneyRecord.fromJson(Map<String, dynamic> json) => MoneyRecord(
        id: json['id'] as String,
        date: json['date'] as String,
        flow: FlowType.values.firstWhere((f) => f.name == json['flow'],
            orElse: () => FlowType.expense),
        category: json['category'] as String,
        amount: (json['amount'] as num).toDouble(),
        note: json['note'] as String? ?? '',
      );
}
