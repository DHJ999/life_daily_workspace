import '../data/local_store.dart';
import '../models/money_record.dart';
import '../models/habit.dart';
import '../models/fitness_record.dart';
import '../models/plan_item.dart';
import '../models/shopping_item.dart';
import '../models/media_item.dart';
import 'data_repository.dart';

/// 本地实现：数据持久化到 shared_preferences
class LocalRepository implements DataRepository {
  final LocalStore _store;

  LocalRepository(this._store);

  @override
  Future<List<MoneyRecord>> loadMoneyRecords() async {
    final list = await _store.readMoney();
    return list.map(MoneyRecord.fromJson).toList();
  }

  @override
  Future<void> saveMoneyRecords(List<MoneyRecord> records) async {
    await _store.writeMoney(records.map((r) => r.toJson()).toList());
  }

  @override
  Future<List<Habit>> loadHabits() async {
    final list = await _store.readHabits();
    return list.map(Habit.fromJson).toList();
  }

  @override
  Future<void> saveHabits(List<Habit> habits) async {
    await _store.writeHabits(habits.map((h) => h.toJson()).toList());
  }

  @override
  Future<List<FitnessRecord>> loadFitnessRecords() async {
    final list = await _store.readFitness();
    return list.map(FitnessRecord.fromJson).toList();
  }

  @override
  Future<void> saveFitnessRecords(List<FitnessRecord> records) async {
    await _store.writeFitness(records.map((r) => r.toJson()).toList());
  }

  @override
  Future<List<PlanItem>> loadPlanItems() async {
    final list = await _store.readPlan();
    return list.map(PlanItem.fromJson).toList();
  }

  @override
  Future<void> savePlanItems(List<PlanItem> items) async {
    await _store.writePlan(items.map((i) => i.toJson()).toList());
  }

  @override
  Future<List<ShoppingItem>> loadShoppingItems() async {
    final list = await _store.readShopping();
    return list.map(ShoppingItem.fromJson).toList();
  }

  @override
  Future<void> saveShoppingItems(List<ShoppingItem> items) async {
    await _store.writeShopping(items.map((i) => i.toJson()).toList());
  }

  @override
  Future<List<MediaItem>> loadMediaItems() async {
    final list = await _store.readMedia();
    return list.map(MediaItem.fromJson).toList();
  }

  @override
  Future<void> saveMediaItems(List<MediaItem> items) async {
    await _store.writeMedia(items.map((i) => i.toJson()).toList());
  }
}
