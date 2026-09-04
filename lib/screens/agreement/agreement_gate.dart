import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../state/app_state.dart';
import '../../theme.dart';
import 'agreement_doc_page.dart';
import 'agreement_docs.dart';

/// 首次启动的《用户协议》与《隐私政策》确认页。
/// - 勾选「我已阅读并同意」后才可点击「同意并继续」，同意后持久化，下次启动不再展示。
/// - 点击「不同意」弹窗提示后退出应用。
class AgreementGate extends StatefulWidget {
  const AgreementGate({super.key});

  @override
  State<AgreementGate> createState() => _AgreementGateState();
}

class _AgreementGateState extends State<AgreementGate> {
  bool _checked = false;
  TapGestureRecognizer? _uaTap;
  TapGestureRecognizer? _ppTap;

  @override
  void initState() {
    super.initState();
    _uaTap = TapGestureRecognizer()..onTap = _openUserAgreement;
    _ppTap = TapGestureRecognizer()..onTap = _openPrivacyPolicy;
  }

  @override
  void dispose() {
    _uaTap?.dispose();
    _ppTap?.dispose();
    super.dispose();
  }

  void _openUserAgreement() {
    final l10n = AppLocalizations.of(context);
    final zh = AppScope.of(context).isZh;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AgreementDocPage(
        title: l10n.docUserAgreement,
        sections: userAgreementSections(zh: zh),
      ),
    ));
  }

  void _openPrivacyPolicy() {
    final l10n = AppLocalizations.of(context);
    final zh = AppScope.of(context).isZh;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AgreementDocPage(
        title: l10n.docPrivacyPolicy,
        sections: privacyPolicySections(zh: zh),
      ),
    ));
  }

  Future<void> _agree() async {
    await AppScope.of(context).setAgreed();
    // 同意后 main.dart 的 home 会随状态切换到 HomeShell，无需手动导航。
  }

  Future<void> _disagree() async {
    final l10n = AppLocalizations.of(context);
    final exit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(l10n.agreeExitTitle),
        content: Text(l10n.agreeExitMsg,
            style: const TextStyle(fontSize: 14.5, height: 1.6)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.agreeExitAction),
          ),
        ],
      ),
    );
    if (exit == true && mounted) {
      // Android：退出当前任务；iOS 同样回落到桌面
      await SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final primaryLink = TextStyle(
      color: AppTheme.primaryDark,
      fontWeight: FontWeight.w700,
      fontSize: 14.5,
    );
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 40, 28, 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 图标 + 应用名 + 说明
                  Container(
                    width: 76,
                    height: 76,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0x1A4A6B57),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.event_note_outlined,
                        color: AppTheme.primary, size: 38),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.appNameFull,
                    textAlign: TextAlign.center,
                    style: AppTheme.serif.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.agreeIntro,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 13.5, height: 1.6, color: AppTheme.inkSecondary),
                  ),
                  const SizedBox(height: 24),
                  // 协议阅读入口
                  Card(
                    child: Column(children: [
                      ListTile(
                        leading: const Icon(Icons.menu_book_outlined,
                            color: AppTheme.primary),
                        title: Text(l10n.docUserAgreement,
                            style: const TextStyle(fontSize: 15)),
                        trailing: const Icon(Icons.chevron_right,
                            color: AppTheme.inkSecondary),
                        onTap: _openUserAgreement,
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: const Icon(Icons.privacy_tip_outlined,
                            color: AppTheme.primary),
                        title: Text(l10n.docPrivacyPolicy,
                            style: const TextStyle(fontSize: 15)),
                        trailing: const Icon(Icons.chevron_right,
                            color: AppTheme.inkSecondary),
                        onTap: _openPrivacyPolicy,
                      ),
                    ]),
                  ),
                  const SizedBox(height: 6),
                  // 勾选确认
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _checked = !_checked),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(children: [
                        Checkbox(
                          value: _checked,
                          activeColor: AppTheme.primary,
                          onChanged: (v) => setState(() => _checked = v ?? false),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text.rich(
                              TextSpan(style: const TextStyle(
                                  fontSize: 14.5, height: 1.5, color: AppTheme.ink), children: [
                                TextSpan(text: l10n.agreeReadBefore),
                                TextSpan(
                                    text: l10n.docUserAgreement,
                                    style: primaryLink,
                                    recognizer: _uaTap),
                                TextSpan(text: l10n.agreeReadAnd),
                                TextSpan(
                                    text: l10n.docPrivacyPolicy,
                                    style: primaryLink,
                                    recognizer: _ppTap),
                              ]),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // 同意 / 不同意
                  FilledButton(
                    onPressed: _checked ? _agree : null,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      disabledBackgroundColor: const Color(0xFFCFCCC3),
                      disabledForegroundColor: Colors.white,
                    ),
                    child: Text(l10n.agreeActionAgree),
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: _disagree,
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.inkSecondary,
                      minimumSize: const Size.fromHeight(44),
                    ),
                    child: Text(l10n.agreeActionDisagree),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
