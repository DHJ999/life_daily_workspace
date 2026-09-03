import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../models/habit.dart';

/// 习惯健康页 —— 习惯列表 + 30 天热力图 + 三种打卡方式
class HabitsScreen extends StatelessWidget {
  final AppState state;
  const HabitsScreen({super.key, required this.state});

  String get _today => DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('习惯健康'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => _showAddHabit(context)),
        ],
      ),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          if (state.habits.isEmpty) {
            return const EmptyState('还没有习惯', hint: '点右上角 + 新建一个习惯');
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
            children: [
              const SectionTitle('我的习惯'),
              for (final h in state.habits) _HabitCard(
                habit: h,
                today: _today,
                onCheck: (v) => state.updateHabitEntry(h.id, _today, v),
                onDelete: () => state.removeHabit(h.id),
              ),
              const SizedBox(height: 8),
              const SectionTitle('30 天热力图'),
              _Heatmap(habits: state.habits),
            ],
          );
        },
      ),
    );
  }

  void _showAddHabit(BuildContext context) {
    final nameCtrl = TextEditingController();
    final targetCtrl = TextEditingController(text: '1');
    final type = ValueNotifier<HabitType>(HabitType.check);
    final unitCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('新建习惯', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: '习惯名称', hintText: '如：早起、喝水、跑步')),
            const SizedBox(height: 12),
            const Text('打卡方式', style: TextStyle(fontSize: 13, color: AppTheme.inkSecondary)),
            const SizedBox(height: 8),
            ValueListenableBuilder<HabitType>(
              valueListenable: type,
              builder: (_, t, _) => Row(children: [
                _typeChip('勾选', HabitType.check, t, type),
                const SizedBox(width: 8),
                _typeChip('计数', HabitType.counter, t, type),
                const SizedBox(width: 8),
                _typeChip('数值', HabitType.value, t, type),
              ]),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextField(controller: targetCtrl, keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '目标'))),
              const SizedBox(width: 12),
              Expanded(child: TextField(controller: unitCtrl, decoration: const InputDecoration(labelText: '单位（可选）'))),
            ]),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: FilledButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                state.addHabit(Habit(
                  id: state.newId(),
                  name: nameCtrl.text.trim(),
                  type: type.value,
                  target: double.tryParse(targetCtrl.text) ?? 1,
                  unit: unitCtrl.text.trim(),
                  createdAt: DateTime.now(),
                ));
                Navigator.pop(ctx);
              },
              child: const Text('创建'),
            )),
          ]),
        ),
      ),
    );
  }

  Widget _typeChip(String label, HabitType v, HabitType cur, ValueNotifier<HabitType> n) {
    return Expanded(child: ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 13)),
      selected: cur == v,
      onSelected: (_) => n.value = v,
      selectedColor: AppTheme.primary,
      labelStyle: TextStyle(color: cur == v ? Colors.white : AppTheme.inkSecondary),
      side: const BorderSide(color: AppTheme.line),
    ));
  }
}

class _HabitCard extends StatelessWidget {
  final Habit habit;
  final String today;
  final void Function(double) onCheck;
  final VoidCallback onDelete;
  const _HabitCard({required this.habit, required this.today, required this.onCheck, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(
          color: habit.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
          child: Icon(habit.icon, color: habit.color)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(habit.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text('${habit.type == HabitType.check ? '完成/未完成' : (habit.type == HabitType.counter ? '计数' : '数值')} · 目标 ${_targetStr()} · 连续 ${habit.streakDays()} 天',
              style: const TextStyle(fontSize: 12, color: AppTheme.inkSecondary)),
        ])),
        _checkControl(),
        InkWell(onTap: onDelete, child: const Padding(padding: EdgeInsets.all(6), child: Icon(Icons.delete_outline, size: 18, color: AppTheme.inkSecondary))),
      ]),
    );
  }

  String _targetStr() {
    final unit = habit.unit.isEmpty ? '' : ' ${habit.unit}';
    if (habit.type == HabitType.check) return '1 次$unit';
    return '${habit.target.toStringAsFixed(habit.target % 1 == 0 ? 0 : 1)}$unit';
  }

  Widget _checkControl() {
    final done = habit.isDoneOn(today);
    if (habit.type == HabitType.check) {
      return Checkbox(
        value: done,
        onChanged: (v) => onCheck(v == true ? 1 : 0),
        activeColor: habit.color,
      );
    }
    // 计数/数值：显示今日值 + 加/减
    final todayVal = habit.entries[today] ?? 0;
    return Row(children: [
      IconButton(
        icon: const Icon(Icons.remove_circle_outline, size: 22),
        color: AppTheme.inkSecondary,
        onPressed: () => onCheck(todayVal <= 0 ? 0 : todayVal - 1),
      ),
      Text(todayVal.toStringAsFixed(todayVal % 1 == 0 ? 0 : 1),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: done ? habit.color : AppTheme.ink)),
      IconButton(
        icon: const Icon(Icons.add_circle_outline, size: 22),
        color: habit.color,
        onPressed: () => onCheck(todayVal + 1),
      ),
    ]);
  }
}

/// 30 天热力图
class _Heatmap extends StatelessWidget {
  final List<Habit> habits;
  const _Heatmap({required this.habits});

  @override
  Widget build(BuildContext context) {
    // 计算每天总完成率
    final today = DateTime.now();
    final days = List.generate(30, (i) {
      final d = DateTime(today.year, today.month, today.day).subtract(Duration(days: 29 - i));
      final date = DateFormat('yyyy-MM-dd').format(d);
      final done = habits.where((h) => h.isDoneOn(date)).length;
      final pct = habits.isEmpty ? 0.0 : done / habits.length;
      return (date: date, pct: pct);
    });

    return SoftCard(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(
          spacing: 4, runSpacing: 4,
          children: days.map((d) {
            final color = _heatColor(d.pct);
            return Container(
              width: 22, height: 22,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
              child: Tooltip(message: '${d.date} ${(d.pct * 100).toStringAsFixed(0)}%',
                  child: const SizedBox.expand()),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Row(children: [
          const Text('少', style: TextStyle(fontSize: 11, color: AppTheme.inkSecondary)),
          const SizedBox(width: 4),
          for (final c in [0.0, 0.25, 0.5, 0.75, 1.0])
            Container(width: 14, height: 14, margin: const EdgeInsets.only(right: 3),
              decoration: BoxDecoration(color: _heatColor(c), borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 4),
          const Text('多', style: TextStyle(fontSize: 11, color: AppTheme.inkSecondary)),
          const Spacer(),
          const Text('近 30 天', style: TextStyle(fontSize: 11, color: AppTheme.inkSecondary)),
        ]),
      ]),
    );
  }

  static Color _heatColor(double pct) {
    if (pct == 0) return AppTheme.line;
    final green = Color.lerp(AppTheme.primary.withValues(alpha: 0.25), AppTheme.primary, pct)!;
    return green;
  }
}
