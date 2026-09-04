import 'package:flutter/material.dart';
import '../../theme.dart';
import 'agreement_docs.dart';

/// 通用协议文档阅读页（《用户协议》/《隐私政策》共用）。
/// 按章节渲染标题与正文，暖白底 + 墨绿章节标题，与全局主题一致。
class AgreementDocPage extends StatelessWidget {
  final String title;
  final List<AgreementSection> sections;

  const AgreementDocPage({super.key, required this.title, required this.sections});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(title: Text(title, style: const TextStyle(fontSize: 18))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 48),
        children: [
          for (final section in sections) _SectionBlock(section: section),
        ],
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final AgreementSection section;
  const _SectionBlock({required this.section});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.heading.isNotEmpty) ...[
            Text(
              section.heading,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryDark,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 10),
          ],
          for (final p in section.paragraphs)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                p,
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.75,
                  color: AppTheme.ink,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
