import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../models/fitness_record.dart';

/// 减脂健身页 —— 体重体脂折线 + 7日均线 + BMI + 目标进度 + 热量缺口
class FitnessScreen extends StatefulWidget {
  final AppState state;
  const FitnessScreen({super.key, required this.state});

  @override
  State<FitnessScreen> createState() => _FitnessScreenState();
}

class _FitnessScreenState extends State<FitnessScreen> {
  double _targetWeight = 65; // 目标体重 kg
  double _heightCm = 175; // 身高 cm
  int _dailyCalorieGoal = 1800; // 每日热量目标

  AppState get st => widget.state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('减脂健身'),
        actions: [
          IconButton(icon: const Icon(Icons.tune), onPressed: _showSettings),
          IconButton(icon: const Icon(Icons.add), onPressed: _showAddRecord),
        ],
      ),
      body: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          final records = st.fitnessRecords;
          final latest = records.isEmpty ? null : records.last;
          final start = records.isEmpty ? null : records.first;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
            children: [
              // 目标进度
              if (latest != null && start != null)
                _GoalProgress(
                  current: latest.weight,
                  start: start.weight,
                  target: _targetWeight,
                  heightCm: _heightCm,
                  calorieGoal: _dailyCalorieGoal,
                ),
              // 折线图
              const SectionTitle('体重趋势（含 7 日均线）'),
              if (records.length >= 2)
                SoftCard(padding: const EdgeInsets.all(12),
                  child: SizedBox(height: 180, child: CustomPaint(
                    painter: _WeightChartPainter(records),
                    child: const SizedBox.expand())))
              else
                const EmptyState('至少录入 2 条体重记录后显示趋势'),
              // 记录列表
              const SectionTitle('记录'),
              if (records.isEmpty)
                const EmptyState('还没有记录', hint: '点右上角 + 记录体重体脂')
              else
                ...records.reversed.map((r) => _RecordRow(
                  r: r, onDelete: () => st.removeFitness(r.id))),
            ],
          );
        },
      ),
    );
  }

  void _showAddRecord() {
    final weightCtrl = TextEditingController();
    final fatCtrl = TextEditingController();
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
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('记录体重体脂', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            TextField(controller: weightCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: '体重（kg）')),
            const SizedBox(height: 12),
            TextField(controller: fatCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: '体脂率（%）')),
            const SizedBox(height: 12),
            TextField(controller: noteCtrl, decoration: const InputDecoration(labelText: '备注（可选）')),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: FilledButton(
              onPressed: () {
                final w = double.tryParse(weightCtrl.text);
                final f = double.tryParse(fatCtrl.text) ?? 0;
                if (w == null || w <= 0) return;
                st.addFitness(FitnessRecord(
                  id: st.newId(),
                  date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  weight: w,
                  bodyFat: f,
                  note: noteCtrl.text,
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

  void _showSettings() {
    final targetCtrl = TextEditingController(text: _targetWeight.toString());
    final heightCtrl = TextEditingController(text: _heightCm.toString());
    final calCtrl = TextEditingController(text: _dailyCalorieGoal.toString());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('目标设置', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            TextField(controller: targetCtrl, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '目标体重（kg）')),
            const SizedBox(height: 12),
            TextField(controller: heightCtrl, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '身高（cm，用于 BMI）')),
            const SizedBox(height: 12),
            TextField(controller: calCtrl, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '每日热量目标（kcal）')),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: FilledButton(
              onPressed: () {
                setState(() {
                  _targetWeight = double.tryParse(targetCtrl.text) ?? _targetWeight;
                  _heightCm = double.tryParse(heightCtrl.text) ?? _heightCm;
                  _dailyCalorieGoal = int.tryParse(calCtrl.text) ?? _dailyCalorieGoal;
                });
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

class _GoalProgress extends StatelessWidget {
  final double current, start, target;
  final double heightCm;
  final int calorieGoal;
  const _GoalProgress({required this.current, required this.start, required this.target,
    required this.heightCm, required this.calorieGoal});

  @override
  Widget build(BuildContext context) {
    final bmi = heightCm > 0 ? current / ((heightCm / 100) * (heightCm / 100)) : 0;
    final bmiText = bmi.toStringAsFixed(1);
    final bmiLabel = bmi < 18.5 ? '偏瘦' : (bmi < 24 ? '正常' : (bmi < 28 ? '偏胖' : '肥胖'));
    final bmiColor = bmi < 18.5 ? AppTheme.inkSecondary : (bmi < 24 ? AppTheme.income : (bmi < 28 ? AppTheme.expense : Colors.red));

    final startVal = start > target ? start - target : 0; // 需减
    final progress = startVal > 0 ? ((start - current) / startVal).clamp(0.0, 1.0) : 1.0;

    return SoftCard(padding: const EdgeInsets.all(18), child: Column(children: [
      Row(children: [
        Expanded(child: _Metric(label: '当前体重', value: '${current.toStringAsFixed(1)} kg')),
        const SizedBox(width: 8),
        Expanded(child: _Metric(label: 'BMI · $bmiLabel', value: bmiText, color: bmiColor)),
        const SizedBox(width: 8),
        Expanded(child: _Metric(label: '目标体重', value: '${target.toStringAsFixed(1)} kg')),
      ]),
      const SizedBox(height: 16),
      ClipRRect(borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(value: progress, minHeight: 8,
          backgroundColor: AppTheme.line, valueColor: const AlwaysStoppedAnimation(AppTheme.primary))),
      const SizedBox(height: 6),
      Row(children: [
        Text('已达成 ${(progress * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12, color: AppTheme.primary)),
        const Spacer(),
        Text('热量目标 $calorieGoal kcal/日', style: const TextStyle(fontSize: 12, color: AppTheme.inkSecondary)),
      ]),
    ]));
  }
}

class _Metric extends StatelessWidget {
  final String label, value;
  final Color? color;
  const _Metric({required this.label, required this.value, this.color});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.inkSecondary)),
      const SizedBox(height: 4),
      FittedBox(child: Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color ?? AppTheme.ink))),
    ]);
  }
}

class _RecordRow extends StatelessWidget {
  final FitnessRecord r;
  final VoidCallback onDelete;
  const _RecordRow({required this.r, required this.onDelete});
  @override
  Widget build(BuildContext context) {
    return SoftCard(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(children: [
        const Icon(Icons.monitor_weight, color: AppTheme.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${r.weight.toStringAsFixed(1)} kg', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          if (r.note.isNotEmpty) Text(r.note, style: const TextStyle(fontSize: 12, color: AppTheme.inkSecondary)),
        ])),
        Text('体脂 ${r.bodyFat.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 13, color: AppTheme.inkSecondary)),
        const SizedBox(width: 12),
        Text(r.date.substring(5), style: const TextStyle(fontSize: 12, color: AppTheme.inkSecondary)),
        InkWell(onTap: onDelete, child: const Padding(padding: EdgeInsets.all(6), child: Icon(Icons.close, size: 16, color: AppTheme.inkSecondary))),
      ]));
  }
}

/// 体重折线 + 7日均线（纯 CustomPaint）
class _WeightChartPainter extends CustomPainter {
  final List<FitnessRecord> records;
  _WeightChartPainter(this.records);

  @override
  void paint(Canvas canvas, Size size) {
    final pad = EdgeInsets.fromLTRB(40, 12, 16, 24);
    final chartW = size.width - pad.left - pad.right;
    final chartH = size.height - pad.top - pad.bottom;
    if (records.length < 2 || chartW <= 0) return;

    final weights = records.map((r) => r.weight).toList();
    final minW = weights.reduce((a, b) => a < b ? a : b) - 1;
    final maxW = weights.reduce((a, b) => a > b ? a : b) + 1;
    final range = (maxW - minW).clamp(1.0, 999.0);

    Offset pt(int i, double w) => Offset(
        pad.left + chartW * (records.length == 1 ? 0.5 : i / (records.length - 1)),
        pad.top + chartH * (1 - (w - minW) / range));

    // 网格 + 数值标签
    final gridPaint = Paint()..color = AppTheme.line..strokeWidth = 0.8;
    for (int g = 0; g <= 3; g++) {
      final y = pad.top + chartH * g / 3;
      canvas.drawLine(Offset(pad.left, y), Offset(size.width - pad.right, y), gridPaint);
      final v = (maxW - range * g / 3).toStringAsFixed(0);
      final tp = TextPainter(
        text: TextSpan(text: v, style: const TextStyle(fontSize: 10, color: AppTheme.inkSecondary)),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(2, y - 6));
    }

    // 7日均线（只画平滑后的离散点连线）
    final ma7 = <double>[];
    for (int i = 0; i < weights.length; i++) {
      final from = (i - 6).clamp(0, i);
      final seg = weights.sublist(from, i + 1);
      ma7.add(seg.reduce((a, b) => a + b) / seg.length);
    }

    // 体重实线
    final linePaint = Paint()..color = AppTheme.primary..strokeWidth = 2..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final path = Path()..moveTo(pt(0, weights[0]).dx, pt(0, weights[0]).dy);
    for (int i = 1; i < weights.length; i++) {
      path.lineTo(pt(i, weights[i]).dx, pt(i, weights[i]).dy);
    }
    canvas.drawPath(path, linePaint);

    // 7日均线（橙色虚线）
    if (ma7.length >= 2) {
      final maPaint = Paint()..color = AppTheme.expense..strokeWidth = 1.6..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
      final maPath = Path()..moveTo(pt(0, ma7[0]).dx, pt(0, ma7[0]).dy);
      for (int i = 1; i < ma7.length; i++) {
        maPath.lineTo(pt(i, ma7[i]).dx, pt(i, ma7[i]).dy);
      }
      canvas.drawPath(maPath, maPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WeightChartPainter old) => old.records != records;
}
