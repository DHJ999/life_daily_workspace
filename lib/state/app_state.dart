import 'package:flutter/material.dart';
import '../models/money_record.dart';
import '../models/habit.dart';
import '../models/fitness_record.dart';
import '../models/plan_item.dart';
import '../models/shopping_item.dart';
import '../models/media_item.dart';
import '../repository/data_repository.dart';

/// 全局应用状态（ChangeNotifier）
/// 集中管理所有模块数据 + 通过 Repository 持久化。
/// 页面通过监听本对象实现响应式更新。
class AppState extends ChangeNotifier {
  final DataRepository repo;
  bool _loaded = false;
  String _localeCode = 'zh'; // 界面语言：zh / en
  bool _agreed = false; // 是否已同意《用户协议》与《隐私政策》

  /// 当前界面语言码（'zh' / 'en'）
  String get localeCode => _localeCode;

  /// 是否为简体中文界面
  bool get isZh => _localeCode == 'zh';

  /// 是否已同意《用户协议》与《隐私政策》（决定是否展示首启确认页）
  bool get agreed => _agreed;

  // 各模块数据
  final List<MoneyRecord> moneyRecords = [];
  final List<Habit> habits = [];
  final List<FitnessRecord> fitnessRecords = [];
  final List<PlanItem> planItems = [];
  final List<ShoppingItem> shoppingItems = [];
  final List<MediaItem> mediaItems = [];

  AppState(this.repo);

  bool get loaded => _loaded;

  /// 启动加载全部数据
  Future<void> load() async {
    moneyRecords
      ..clear()
      ..addAll(await repo.loadMoneyRecords());
    habits
      ..clear()
      ..addAll(await repo.loadHabits());
    fitnessRecords
      ..clear()
      ..addAll(await repo.loadFitnessRecords());
    planItems
      ..clear()
      ..addAll(await repo.loadPlanItems());
    shoppingItems
      ..clear()
      ..addAll(await repo.loadShoppingItems());
    mediaItems
      ..clear()
      ..addAll(await repo.loadMediaItems());
    final savedLocale = await repo.loadLocale();
    _localeCode = (savedLocale == 'en' || savedLocale == 'zh') ? savedLocale! : 'zh';
    _agreed = await repo.loadAgreed();
    _loaded = true;
    notifyListeners();
  }

  /// 记录用户同意协议（首次同意后持久化，下次启动不再弹确认页）
  Future<void> setAgreed() async {
    if (_agreed) return;
    _agreed = true;
    await repo.saveAgreed(true);
    notifyListeners();
  }

  /// 切换界面语言（'zh' / 'en'），即时生效并持久化
  Future<void> setLocale(String code) async {
    if (code != 'zh' && code != 'en') return;
    if (_localeCode == code) return;
    _localeCode = code;
    await repo.saveLocale(code);
    notifyListeners();
  }

  String newId() => DateTime.now().microsecondsSinceEpoch.toString();

  // ---- 记账 ----
  Future<void> addMoney(MoneyRecord r) async {
    moneyRecords.add(r);
    await repo.saveMoneyRecords(moneyRecords);
    notifyListeners();
  }

  Future<void> removeMoney(String id) async {
    moneyRecords.removeWhere((r) => r.id == id);
    await repo.saveMoneyRecords(moneyRecords);
    notifyListeners();
  }

  // ---- 习惯 ----
  Future<void> addHabit(Habit h) async {
    habits.add(h);
    await repo.saveHabits(habits);
    notifyListeners();
  }

  Future<void> removeHabit(String id) async {
    habits.removeWhere((h) => h.id == id);
    await repo.saveHabits(habits);
    notifyListeners();
  }

  Future<void> updateHabitEntry(String habitId, String date, double value) async {
    final idx = habits.indexWhere((h) => h.id == habitId);
    if (idx < 0) return;
    if (value <= 0) {
      habits[idx].entries.remove(date);
    } else {
      habits[idx].entries[date] = value;
    }
    await repo.saveHabits(habits);
    notifyListeners();
  }

  // ---- 减脂 ----
  Future<void> addFitness(FitnessRecord r) async {
    fitnessRecords.add(r);
    fitnessRecords.sort((a, b) => a.date.compareTo(b.date));
    await repo.saveFitnessRecords(fitnessRecords);
    notifyListeners();
  }

  Future<void> removeFitness(String id) async {
    fitnessRecords.removeWhere((r) => r.id == id);
    await repo.saveFitnessRecords(fitnessRecords);
    notifyListeners();
  }

  // ---- 日程 ----
  Future<void> addPlan(PlanItem p) async {
    planItems.add(p);
    await repo.savePlanItems(planItems);
    notifyListeners();
  }

  Future<void> togglePlan(String id) async {
    final idx = planItems.indexWhere((p) => p.id == id);
    if (idx < 0) return;
    final old = planItems[idx];
    planItems[idx] = PlanItem(
      id: old.id,
      date: old.date,
      title: old.title,
      type: old.type,
      done: !old.done,
    );
    await repo.savePlanItems(planItems);
    notifyListeners();
  }

  Future<void> removePlan(String id) async {
    planItems.removeWhere((p) => p.id == id);
    await repo.savePlanItems(planItems);
    notifyListeners();
  }

  // ---- 待买 ----
  Future<void> addShopping(ShoppingItem s) async {
    shoppingItems.add(s);
    await repo.saveShoppingItems(shoppingItems);
    notifyListeners();
  }

  Future<void> toggleShopping(String id) async {
    final idx = shoppingItems.indexWhere((s) => s.id == id);
    if (idx < 0) return;
    final old = shoppingItems[idx];
    shoppingItems[idx] = ShoppingItem(
      id: old.id,
      name: old.name,
      quantity: old.quantity,
      price: old.price,
      bought: !old.bought,
      note: old.note,
    );
    await repo.saveShoppingItems(shoppingItems);
    notifyListeners();
  }

  Future<void> removeShopping(String id) async {
    shoppingItems.removeWhere((s) => s.id == id);
    await repo.saveShoppingItems(shoppingItems);
    notifyListeners();
  }

  // ---- 书影音 ----
  Future<void> addMedia(MediaItem m) async {
    mediaItems.add(m);
    await repo.saveMediaItems(mediaItems);
    notifyListeners();
  }

  Future<void> updateMediaStatus(String id, MediaStatus status) async {
    final idx = mediaItems.indexWhere((m) => m.id == id);
    if (idx < 0) return;
    final old = mediaItems[idx];
    mediaItems[idx] = MediaItem(
      id: old.id,
      title: old.title,
      type: old.type,
      status: status,
      rating: old.rating,
      review: old.review,
    );
    await repo.saveMediaItems(mediaItems);
    notifyListeners();
  }

  Future<void> removeMedia(String id) async {
    mediaItems.removeWhere((m) => m.id == id);
    await repo.saveMediaItems(mediaItems);
    notifyListeners();
  }
}

/// 通过 InheritedWidget 提供全局 AppState
class AppScope extends InheritedWidget {
  final AppState state;
  const AppScope({super.key, required this.state, required super.child});

  static AppState of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<AppScope>()!).state;

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      state != oldWidget.state;
}
