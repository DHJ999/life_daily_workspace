import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../models/money_record.dart';
import '../l10n/generated/app_localizations.dart';
import '../l10n/data_labels.dart';

/// 记账理财页
class MoneyScreen extends StatefulWidget {
  final AppState state;
  const MoneyScreen({super.key, required this.state});

  @override
  State<MoneyScreen> createState() => _MoneyScreenState();
}

class _MoneyScreenState extends State<MoneyScreen> {
  String _month = DateFormat('yyyy-MM').format(DateTime.now());
  String _categoryFilter = ''; // '' 表示全部（避免存中文常量）

  AppState get st => widget.state;

  List<MoneyRecord> get _monthRecords => st.moneyRecords.where((r) => r.date.startsWith(_month)).toList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final monthRecords = _monthRecords;
    final income = monthRecords.where((r) => r.flow == FlowType.income).fold(0.0, (a, r) => a + r.amount);
    final expense = monthRecords.where((r) => r.flow == FlowType.expense).fold(0.0, (a, r) => a + r.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.moneyTitle),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _showAddSheet),
        ],
      ),
      body: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          final l = AppLocalizations.of(context);
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
            children: [
              _MonthSwitcher(
                month: _month,
                onPrev: () => setState(() => _month = _shiftMonth(-1)),
                onNext: () => setState(() => _month = _shiftMonth(1)),
              ),
              SoftCard(
                padding: const EdgeInsets.all(18),
                child: Column(children: [
                  Row(children: [
                    Expanded(child: _MoneyCol(label: l.moneyMonthExpense, value: expense, color: AppTheme.expense)),
                    Expanded(child: _MoneyCol(label: l.moneyMonthIncome, value: income, color: AppTheme.income)),
                    Expanded(child: _MoneyCol(label: l.moneyBalance, value: income - expense, color: AppTheme.primary)),
                  ]),
                  const SizedBox(height: 16),
                  _ExpensePie(records: monthRecords.where((r) => r.flow == FlowType.expense).toList()),
                ]),
              ),
              const SizedBox(height: 8),
              // 分类筛选（'' 表示全部；显示走双语映射，值用存储 key）
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _chip(l.commonAll, ''),
                    for (final c in MoneyCategory.expenseCategories)
                      _chip(DataLabels.moneyCategory(context, c.name), c.name),
                    for (final c in MoneyCategory.incomeCategories)
                      _chip(DataLabels.moneyCategory(context, c.name), c.name),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              // 记录列表
              ..._recordList(context, monthRecords),
              if (monthRecords.isEmpty)
                EmptyState(l.moneyEmptyMonth, hint: l.moneyEmptyMonthHint),
            ],
          );
        },
      ),
    );
  }

  /// 显示用分类名：筛选值 ''（全部）或自定义时原样，预设分类走双语映射
  Widget _chip(String display, String value) {
    final active = _categoryFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(display),
        selected: active,
        onSelected: (_) => setState(() => _categoryFilter = value),
        selectedColor: AppTheme.primary,
        backgroundColor: AppTheme.surface,
        labelStyle: TextStyle(
            color: active ? Colors.white : AppTheme.inkSecondary, fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: AppTheme.line),
      ),
    );
  }

  List<Widget> _recordList(BuildContext context, List<MoneyRecord> all) {
    final l10n = AppLocalizations.of(context);
    final filtered = _categoryFilter.isEmpty
        ? all
        : all.where((r) => r.category == _categoryFilter).toList();
    filtered.sort((a, b) => b.date.compareTo(a.date));
    if (filtered.isEmpty) return [EmptyState(l10n.moneyEmptyCat)];
    return filtered.map((r) {
      final cat = MoneyCategory.fromName(r.category, flow: r.flow);
      final isIn = r.flow == FlowType.income;
      return SoftCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(children: [
          CircleAvatar(radius: 18, backgroundColor: cat.color.withValues(alpha: 0.12),
            child: Icon(cat.icon, size: 18, color: cat.color)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(DataLabels.moneyCategory(context, r.category),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            if (r.note.isNotEmpty) Text(r.note, style: const TextStyle(fontSize: 12, color: AppTheme.inkSecondary)),
          ])),
          Text(r.date.substring(5).replaceAll('-', '/'),
              style: const TextStyle(fontSize: 12, color: AppTheme.inkSecondary)),
          const SizedBox(width: 10),
          Text(fmtMoney(isIn ? r.amount : -r.amount),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                  color: isIn ? AppTheme.income : AppTheme.expense)),
          InkWell(
            onTap: () => st.removeMoney(r.id),
            child: const Padding(padding: EdgeInsets.all(6), child: Icon(Icons.close, size: 16, color: AppTheme.inkSecondary)),
          ),
        ]),
      );
    }).toList();
  }

  String _shiftMonth(int delta) {
    final y = int.parse(_month.substring(0, 4));
    final m = int.parse(_month.substring(5));
    final d = DateTime(y, m + delta, 1);
    return '${d.year}-${d.month.toString().padLeft(2, '0')}';
  }

  void _showAddSheet() {
    final l10n = AppLocalizations.of(context);
    final flow = ValueNotifier<FlowType>(FlowType.expense);
    final category = ValueNotifier<String>(MoneyCategory.expenseCategories.first.name); // '餐饮'
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();

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
            Text(l10n.moneyAddTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            // 收支切换
            ValueListenableBuilder<FlowType>(
              valueListenable: flow,
              builder: (_, f, _) => Row(children: [
                Expanded(child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: f == FlowType.expense ? AppTheme.expense : AppTheme.line),
                  onPressed: () {
                    flow.value = FlowType.expense;
                    category.value = MoneyCategory.expenseCategories.first.name;
                  },
                  child: Text(l10n.moneyExpense),
                )),
                const SizedBox(width: 12),
                Expanded(child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: f == FlowType.income ? AppTheme.income : AppTheme.line),
                  onPressed: () {
                    flow.value = FlowType.income;
                    category.value = MoneyCategory.incomeCategories.first.name;
                  },
                  child: Text(l10n.moneyIncome),
                )),
              ]),
            ),
            const SizedBox(height: 16),
            // 分类
            ValueListenableBuilder<FlowType>(
              valueListenable: flow,
              builder: (_, f, _) => Wrap(
                spacing: 8, runSpacing: 8,
                children: [
                  for (final c in (f == FlowType.income ? MoneyCategory.incomeCategories : MoneyCategory.expenseCategories))
                    ValueListenableBuilder<String>(
                      valueListenable: category,
                      builder: (_, cur, _) => ChoiceChip(
                        label: Text(DataLabels.moneyCategory(ctx, c.name)),
                        selected: cur == c.name,
                        onSelected: (_) => category.value = c.name,
                        selectedColor: f == FlowType.income ? AppTheme.income : AppTheme.expense,
                        labelStyle: TextStyle(color: cur == c.name ? Colors.white : AppTheme.inkSecondary, fontSize: 13),
                        side: const BorderSide(color: AppTheme.line),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(controller: amountCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.moneyAmount, prefixText: '¥ ')),
            const SizedBox(height: 12),
            TextField(controller: noteCtrl, decoration: InputDecoration(labelText: l10n.commonNote)),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: FilledButton(
              onPressed: () {
                final amt = double.tryParse(amountCtrl.text) ?? 0;
                if (amt <= 0) return;
                st.addMoney(MoneyRecord(
                  id: st.newId(),
                  date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  flow: flow.value,
                  category: category.value,
                  amount: amt,
                  note: noteCtrl.text,
                ));
                Navigator.pop(ctx);
              },
              child: Text(l10n.commonSave),
            )),
          ]),
        ),
      ),
    );
  }
}

class _MonthSwitcher extends StatelessWidget {
  final String month;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  const _MonthSwitcher({required this.month, required this.onPrev, required this.onNext});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(onPressed: onPrev, icon: const Icon(Icons.chevron_left)),
        Text(month, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        IconButton(onPressed: onNext, icon: const Icon(Icons.chevron_right)),
      ]),
    );
  }
}

class _MoneyCol extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _MoneyCol({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.inkSecondary)),
      const SizedBox(height: 6),
      FittedBox(child: Text(fmtMoney(value), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color))),
    ]);
  }
}

/// 消费结构饼图（纯 CustomPaint 手绘，无第三方图表库）
class _ExpensePie extends StatelessWidget {
  final List<MoneyRecord> records;
  const _ExpensePie({required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    // 按分类聚合
    final Map<String, double> byCat = {};
    var total = 0.0;
    for (final r in records) {
      byCat[r.category] = (byCat[r.category] ?? 0) + r.amount;
      total += r.amount;
    }
    final colors = MoneyCategory.expenseCategories.map((c) => c.color).toList();
    final entries = byCat.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    // 图例
    return Column(children: [
      Text(l10n.moneyPieTitle, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Row(children: [
        SizedBox(width: 120, height: 120,
          child: CustomPaint(painter: _PiePainter(entries, colors, total))),
        const SizedBox(width: 20),
        Expanded(child: Column(children: [
          for (final e in entries.take(6))
            Padding(padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(
                  color: colors[byCat.keys.toList().indexOf(e.key)], shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(child: Text(DataLabels.moneyCategory(context, e.key),
                    style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)),
                Text('${(e.value / total * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 13, color: AppTheme.inkSecondary)),
              ])),
        ])),
      ]),
    ]);
  }
}

class _PiePainter extends CustomPainter {
  final List<MapEntry<String, double>> entries;
  final List<Color> colors;
  final double total;
  _PiePainter(this.entries, this.colors, this.total);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;
    var start = -3.14 / 2;
    for (int i = 0; i < entries.length; i++) {
      final sweep = entries[i].value / total * 2 * 3.14159;
      final color = colors[entries[i].key == '' ? 0 : i % colors.length];
      final paint = Paint()..color = color..style = PaintingStyle.fill;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
          start, sweep > 0.02 ? sweep : 0.02, true, paint);
      start += sweep;
    }
    // 中心挖空成环形
    canvas.drawCircle(center, radius * 0.5, Paint()..color = AppTheme.surface);
  }

  @override
  bool shouldRepaint(covariant _PiePainter old) => true;
}
