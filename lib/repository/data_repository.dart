import '../models/money_record.dart';
import '../models/habit.dart';
import '../models/fitness_record.dart';
import '../models/plan_item.dart';
import '../models/shopping_item.dart';
import '../models/media_item.dart';

/// 数据仓库抽象接口。
/// 所有业务模块只依赖这个接口，不关心数据存本地还是云端。
/// 当前实现为 [LocalRepository]（shared_preferences 本地存储）；
/// 未来接入云端同步时，新增一个实现该接口的 CloudRepository 即可无缝替换。
abstract class DataRepository {
  // ---- 记账 ----
  Future<List<MoneyRecord>> loadMoneyRecords();
  Future<void> saveMoneyRecords(List<MoneyRecord> records);

  // ---- 习惯 ----
  Future<List<Habit>> loadHabits();
  Future<void> saveHabits(List<Habit> habits);

  // ---- 减脂 ----
  Future<List<FitnessRecord>> loadFitnessRecords();
  Future<void> saveFitnessRecords(List<FitnessRecord> records);

  // ---- 日程 ----
  Future<List<PlanItem>> loadPlanItems();
  Future<void> savePlanItems(List<PlanItem> items);

  // ---- 待买 ----
  Future<List<ShoppingItem>> loadShoppingItems();
  Future<void> saveShoppingItems(List<ShoppingItem> items);

  // ---- 书影音 ----
  Future<List<MediaItem>> loadMediaItems();
  Future<void> saveMediaItems(List<MediaItem> items);

  // ---- 偏好设置 ----
  /// 返回 'zh' / 'en'；未设置返回 null（由上层决定默认语言）
  Future<String?> loadLocale();
  Future<void> saveLocale(String code);

  /// 用户是否已同意《用户协议》与《隐私政策》
  Future<bool> loadAgreed();
  Future<void> saveAgreed(bool agreed);
}
