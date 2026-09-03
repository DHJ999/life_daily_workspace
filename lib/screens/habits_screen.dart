import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../models/habit.dart';
import '../l10n/generated/app_localizations.dart';

/// 习惯健康页 —— 习惯列表 + 30 天热力图 + 三种打卡方式
class HabitsScreen extends StatelessWidget {
  final AppState state;
  const HabitsScreen({super.key, required this.state});

  String get _today => DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.habitsTitle),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => _showAddHabit(context)),
        ],
      ),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          final l = AppLocalizations.of(context);
          if (state.habits.isEmpty) {
            return EmptyState(l.habitsEmpty, hint: l.habitsEmptyHint);
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
            children: [
              SectionTitle(l.habitsMy),
              for (final h in state.habits) _HabitCard(
                habit: h,
                today: _today,
                onCheck: (v) => state.updateHabitEntry(h.id, _today, v),
                onDelete: () => state.removeHabit(h.id),
              ),
              const SizedBox(height: 8),
              SectionTitle(l.habitsHeat),
              _Heatmap(habits: state.habits),
            ],
          );
        },
      ),
    );
  }

  void _showAddHabit(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
            Text(l10n.habitsAddTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            TextField(controller: nameCtrl,
                decoration: InputDecoration(labelText: l10n.habitsName, hintText: l10n.habitsNameHint)),
            const SizedBox(height: 12),
            Text(l10n.habitsTypeLabel, style: const TextStyle(fontSize: 13, color: AppTheme.inkSecondary)),
            const SizedBox(height: 8),
            ValueListenableBuilder<HabitType>(
              valueListenable: type,
              builder: (_, t, _) => Row(children: [
                _typeChip(l10n.habitsChipCheck, HabitType.check, t, type),
                const SizedBox(width: 8),
                _typeChip(l10n.habitsChipCounter, HabitType.counter, t, type),
                const SizedBox(width: 8),
                _typeChip(l10n.habitsChipValue, HabitType.value, t, type),
              ]),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextField(controller: targetCtrl, keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.habitsTarget))),
              const SizedBox(width: 12),
              Expanded(child: TextField(controller: unitCtrl,
                  decoration: InputDecoration(labelText: l10n.habitsUnit))),
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
              child: Text(l10n.habitsCreate),
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
    final l10n = AppLocalizations.of(context);
    final zh = Localizations.localeOf(context).languageCode == 'zh';

    // 类型文案
    final typeLabel = switch (habit.type) {
      HabitType.check => l10n.habitsDoneStatus,
      HabitType.counter => l10n.habitsChipCounter,
      HabitType.value => l10n.habitsChipValue,
    };

    // 目标文本：check 固定 1 次/1 time；counter/value 显示数值 + 单位
    final targetText = () {
      final unit = habit.unit.isEmpty ? '' : ' ${habit.unit}';
      if (habit.type == HabitType.check) return zh ? '1 次$unit' : '1 time$unit';
      final num = habit.target.toStringAsFixed(habit.target % 1 == 0 ? 0 : 1);
      return '$num$unit';
    }();

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
          Text(
              '$typeLabel · ${l10n.habitsTargetFmt(targetText)} · ${l10n.habitsStreakFmt(habit.streakDays())}',
              style: const TextStyle(fontSize: 12, color: AppTheme.inkSecondary)),
        ])),
        _checkControl(),
        InkWell(onTap: onDelete, child: const Padding(padding: EdgeInsets.all(6), child: Icon(Icons.delete_outline, size: 18, color: AppTheme.inkSecondary))),
      ]),
    );
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
    final l10n = AppLocalizations.of(context);
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
              child: Tooltip(
                  message: l10n.heatTooltipFmt(
                      d.date, (d.pct * 100).toStringAsFixed(0)),
                  child: const SizedBox.expand()),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Row(children: [
          Text(l10n.heatLow, style: const TextStyle(fontSize: 11, color: AppTheme.inkSecondary)),
          const SizedBox(width: 4),
          for (final c in [0.0, 0.25, 0.5, 0.75, 1.0])
            Container(width: 14, height: 14, margin: const EdgeInsets.only(right: 3),
              decoration: BoxDecoration(color: _heatColor(c), borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 4),
          Text(l10n.heatHigh, style: const TextStyle(fontSize: 11, color: AppTheme.inkSecondary)),
          const Spacer(),
          Text(l10n.heatLast30, style: const TextStyle(fontSize: 11, color: AppTheme.inkSecondary)),
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
