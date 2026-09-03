import 'package:flutter_test/flutter_test.dart';
import 'package:life_daily_workspace/models/money_record.dart';
import 'package:life_daily_workspace/models/habit.dart';
import 'package:life_daily_workspace/models/shopping_item.dart';
import 'package:life_daily_workspace/models/media_item.dart';

void main() {
  group('MoneyRecord JSON 往返', () {
    test('序列化与反序列化一致', () {
      const r = MoneyRecord(
        id: '1', date: '2026-09-01', flow: FlowType.expense,
        category: '餐饮', amount: 25.5, note: '午餐');
      final back = MoneyRecord.fromJson(r.toJson());
      expect(back.id, '1');
      expect(back.amount, 25.5);
      expect(back.flow, FlowType.expense);
      expect(back.note, '午餐');
    });
  });

  group('Habit', () {
    test('check 类型打卡与连续天数', () {
      final h = Habit(
        id: '1', name: '喝水', type: HabitType.check,
        createdAt: DateTime.now(), entries: {
          '2026-09-01': 1, '2026-08-31': 1, '2026-08-30': 0,
        });
      expect(h.isDoneOn('2026-09-01'), isTrue);
      // 连续天数从今天倒推，今天有记录则至少 1
      expect(h.streakDays() >= 1, isTrue);
    });
  });

  group('ShoppingItem', () {
    test('totalPrice 计算', () {
      const s = ShoppingItem(id: '1', name: '牛奶', quantity: 3, price: 10);
      expect(s.totalPrice, 30.0);
    });
  });

  group('MediaItem', () {
    test('状态与类型序列化', () {
      const m = MediaItem(id: '1', title: '百年孤独', type: MediaType.book,
          status: MediaStatus.watching, rating: 4.5);
      final back = MediaItem.fromJson(m.toJson());
      expect(back.type, MediaType.book);
      expect(back.status, MediaStatus.watching);
      expect(back.rating, 4.5);
    });
  });
}
