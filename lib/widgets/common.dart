import 'package:flutter/material.dart';
import '../theme.dart';

/// 通用内容卡片（去掉厚重阴影，仅留细边框 + 圆角，克制清爽）
class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;
  const SoftCard({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? AppTheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.line),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// 区块标题（左侧竖线点缀）
class SectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const SectionTitle(this.title, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(width: 3, height: 16, color: AppTheme.primary),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppTheme.ink)),
          const Spacer(),
          ?trailing,
        ],
      ),
    );
  }
}

/// 空状态
class EmptyState extends StatelessWidget {
  final String text;
  final String? hint;
  const EmptyState(this.text, {super.key, this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 40, color: AppTheme.line),
          const SizedBox(height: 12),
          Text(text, style: const TextStyle(color: AppTheme.inkSecondary, fontSize: 14)),
          if (hint != null) ...[
            const SizedBox(height: 4),
            Text(hint!, style: const TextStyle(color: AppTheme.line, fontSize: 12)),
          ],
        ],
      ),
    );
  }
}

/// 金额格式化（¥ + 千分位）
String fmtMoney(double v) {
  final neg = v < 0;
  final a = v.abs();
  final s = a.toStringAsFixed(2);
  final parts = s.split('.');
  final intPart = parts[0];
  final buf = StringBuffer();
  for (int i = 0; i < intPart.length; i++) {
    if (i > 0 && (intPart.length - i) % 3 == 0) buf.write(',');
    buf.write(intPart[i]);
  }
  return '${neg ? '-' : ''}¥${buf.toString()}.${parts[1]}';
}
