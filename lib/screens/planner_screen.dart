import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../models/plan_item.dart';

/// 日程统筹页 —— 按日期分组展示日程
class PlannerScreen extends StatefulWidget {
  final AppState state;
  const PlannerScreen({super.key, required this.state});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  String? _selectedDate;
  AppState get st => widget.state;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('日程统筹'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _showAdd)],
      ),
      body: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          final items = st.planItems.where((p) => p.date == _selectedDate).toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
            children: [
              // 日期选择
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(14, (i) {
                    final d = DateTime.now().add(Duration(days: i - 1));
                    final date = DateFormat('yyyy-MM-dd').format(d);
                    final sel = date == _selectedDate;
                    final count = st.planItems.where((p) => p.date == date).length;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text('${d.month}/${d.day}${count > 0 ? '·$count' : ''}'),
                        selected: sel,
                        onSelected: (_) => setState(() => _selectedDate = date),
                        selectedColor: AppTheme.primary,
                        backgroundColor: AppTheme.surface,
                        labelStyle: TextStyle(color: sel ? Colors.white : AppTheme.inkSecondary, fontSize: 13),
                        side: const BorderSide(color: AppTheme.line),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 12),
              SectionTitle(_selectedDate!),
              if (items.isEmpty)
                const EmptyState('这一天还没有日程')
              else
                for (final p in items) _PlanRow(p: p),
            ],
          );
        },
      ),
    );
  }

  Widget _PlanRow({required PlanItem p}) {
    final meta = PlanTypeMeta.of(p.type);
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(children: [
        GestureDetector(
          onTap: () => st.togglePlan(p.id),
          child: Container(width: 26, height: 26, decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: p.done ? AppTheme.primary : AppTheme.line, width: 1.5),
            color: p.done ? AppTheme.primary : AppTheme.surface),
            child: p.done ? const Icon(Icons.check, size: 16, color: Colors.white) : null),
        ),
        const SizedBox(width: 12),
        Container(width: 32, height: 32, decoration: BoxDecoration(
          color: meta.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(meta.icon, size: 17, color: meta.color)),
        const SizedBox(width: 12),
        Expanded(child: Text(p.title,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,
            decoration: p.done ? TextDecoration.lineThrough : null,
            color: p.done ? AppTheme.inkSecondary : AppTheme.ink))),
        Text(meta.name, style: const TextStyle(fontSize: 12, color: AppTheme.inkSecondary)),
        InkWell(onTap: () => st.removePlan(p.id),
          child: const Padding(padding: EdgeInsets.all(6), child: Icon(Icons.close, size: 16, color: AppTheme.inkSecondary))),
      ]),
    );
  }

  void _showAdd() {
    final titleCtrl = TextEditingController();
    final type = ValueNotifier<String>('一般');
    final date = ValueNotifier<String>(_selectedDate!);
    final dateCtrl = TextEditingController(text: _selectedDate!);

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
            const Text('新增日程', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: '事项')),
            const SizedBox(height: 12),
            TextField(controller: dateCtrl, readOnly: true, decoration: const InputDecoration(labelText: '日期'),
              onTap: () async {
                final picked = await showDatePicker(
                  context: ctx, initialDate: DateTime.parse(date.value),
                  firstDate: DateTime(2020), lastDate: DateTime(2035));
                if (picked != null) {
                  date.value = DateFormat('yyyy-MM-dd').format(picked);
                  dateCtrl.text = date.value;
                }
              }),
            const SizedBox(height: 12),
            const Text('类型', style: TextStyle(fontSize: 13, color: AppTheme.inkSecondary)),
            const SizedBox(height: 8),
            ValueListenableBuilder<String>(
              valueListenable: type,
              builder: (_, t, _) => Wrap(spacing: 8, runSpacing: 8,
                children: [for (final m in PlanTypeMeta.all) ChoiceChip(
                  label: Text(m.name, style: const TextStyle(fontSize: 13)),
                  selected: t == m.name,
                  onSelected: (_) => type.value = m.name,
                  selectedColor: AppTheme.primary,
                  labelStyle: TextStyle(color: t == m.name ? Colors.white : AppTheme.inkSecondary),
                  side: const BorderSide(color: AppTheme.line),
                )]),
            ),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: FilledButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) return;
                st.addPlan(PlanItem(
                  id: st.newId(),
                  date: date.value,
                  title: titleCtrl.text.trim(),
                  type: type.value,
                ));
                Navigator.pop(ctx);
              },
              child: const Text('保存'),
            )),
          ]),
        ),
      ),
    );
  }
}
