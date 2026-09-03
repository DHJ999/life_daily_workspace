import 'package:flutter/widgets.dart';

/// 数据标签双语显示映射
///
/// 账目分类、日程类型在存储层使用中文固定 key（与历史数据保持兼容），
/// 显示层根据当前界面语言映射为对应文案；非预设值（理论不会出现）原样回退。
/// 注意：这里只做「显示」，不改动存储值，保证切换语言不污染数据。
class DataLabels {
  DataLabels._();

  static const Map<String, String> _moneyCat = {
    '工资': 'Salary',
    '奖金': 'Bonus',
    '理财': 'Investment',
    '其他收入': 'Other income',
    '餐饮': 'Dining',
    '交通': 'Transport',
    '购物': 'Shopping',
    '居住': 'Housing',
    '娱乐': 'Entertainment',
    '医疗': 'Medical',
    '教育': 'Education',
    '其他支出': 'Other expense',
  };

  static const Map<String, String> _planType = {
    '工作': 'Work',
    '生活': 'Life',
    '健康': 'Health',
    '学习': 'Study',
    '社交': 'Social',
    '一般': 'General',
  };

  static bool _isZh(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'zh';

  static String _lookup(BuildContext context, Map<String, String> map, String key) {
    if (_isZh(context)) return key;
    return map[key] ?? key;
  }

  /// 记账分类名（zh 原样；en 走映射表）
  static String moneyCategory(BuildContext context, String zhName) =>
      _lookup(context, _moneyCat, zhName);

  /// 日程类型名
  static String planType(BuildContext context, String zhName) =>
      _lookup(context, _planType, zhName);
}
