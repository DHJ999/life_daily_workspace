import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 本地数据存储 —— 基于 shared_preferences 的 KV 持久化
/// 数据存储格式：一个 key 存整个模块的 JSON 数组
class LocalStore {
  static const String _kMoney = 'wb_money_records';
  static const String _kHabits = 'wb_habits';
  static const String _kFitness = 'wb_fitness_records';
  static const String _kPlan = 'wb_plan_items';
  static const String _kShopping = 'wb_shopping_items';
  static const String _kMedia = 'wb_media_items';
  static const String _kWeeklyPlan = 'wb_weekly_plan';
  static const String _kLocale = 'wb_locale';
  static const String _kAgreed = 'wb_agreed';

  /// 读一个 JSON 数组；不存在返回空列表
  Future<List<Map<String, dynamic>>> readList(String key) async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (_) {}
    return [];
  }

  /// 写一个 JSON 数组
  Future<void> writeList(String key, List<Map<String, dynamic>> list) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(key, jsonEncode(list));
  }

  // ---- 模块专属读写 ----
  Future<List<Map<String, dynamic>>> readMoney() => readList(_kMoney);
  Future<void> writeMoney(List<Map<String, dynamic>> list) => writeList(_kMoney, list);

  Future<List<Map<String, dynamic>>> readHabits() => readList(_kHabits);
  Future<void> writeHabits(List<Map<String, dynamic>> list) => writeList(_kHabits, list);

  Future<List<Map<String, dynamic>>> readFitness() => readList(_kFitness);
  Future<void> writeFitness(List<Map<String, dynamic>> list) => writeList(_kFitness, list);

  Future<List<Map<String, dynamic>>> readPlan() => readList(_kPlan);
  Future<void> writePlan(List<Map<String, dynamic>> list) => writeList(_kPlan, list);

  Future<List<Map<String, dynamic>>> readShopping() => readList(_kShopping);
  Future<void> writeShopping(List<Map<String, dynamic>> list) => writeList(_kShopping, list);

  Future<List<Map<String, dynamic>>> readMedia() => readList(_kMedia);
  Future<void> writeMedia(List<Map<String, dynamic>> list) => writeList(_kMedia, list);

  Future<List<Map<String, dynamic>>> readWeeklyPlan() => readList(_kWeeklyPlan);
  Future<void> writeWeeklyPlan(List<Map<String, dynamic>> list) => writeList(_kWeeklyPlan, list);

  // ---- 偏好设置 ----
  Future<String?> readLocale() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kLocale);
  }

  Future<void> writeLocale(String code) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kLocale, code);
  }

  /// 用户是否已同意《用户协议》与《隐私政策》
  Future<bool> readAgreed() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_kAgreed) ?? false;
  }

  Future<void> writeAgreed(bool agreed) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kAgreed, agreed);
  }

  /// 清空全部数据
  Future<void> clearAll() async {
    final sp = await SharedPreferences.getInstance();
    for (final k in [_kMoney, _kHabits, _kFitness, _kPlan, _kShopping, _kMedia, _kWeeklyPlan]) {
      await sp.remove(k);
    }
  }
}
