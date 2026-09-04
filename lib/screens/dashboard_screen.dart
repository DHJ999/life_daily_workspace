import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../models/money_record.dart';
import '../models/plan_item.dart';
import '../models/shopping_item.dart';
import '../l10n/generated/app_localizations.dart';
import 'agreement/agreement_doc_page.dart';
import 'agreement/agreement_docs.dart';
import 'planner_screen.dart';
import 'shopping_screen.dart';

/// 今日概览页 —— 顶部「今天要处理」，下方各模块摘要；右上角为设置入口
class DashboardScreen extends StatelessWidget {
  final AppState state;
  const DashboardScreen({super.key, required this.state});

  String get _today => DateFormat('yyyy-MM-dd').format(DateTime.now());

  /// 顶部日期副标题：zh 用「9月4日 星期五」，en 用「Fri, Sep 4」
  String _todayLabel(BuildContext context) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    return DateFormat(zh ? 'M月d日 EEEE' : 'EEE, MMM d', zh ? 'zh' : 'en')
        .format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // 计算今日数据
    final todayMoney = state.moneyRecords
        .where((r) => r.date == _today)
        .fold<({double in_, double out})>(
            (in_: 0, out: 0),
            (acc, r) => r.flow == FlowType.income
                ? (in_: acc.in_ + r.amount, out: acc.out)
                : (in_: acc.in_, out: acc.out + r.amount));

    final todayPlans = state.planItems.where((p) => p.date == _today).toList();
    final undonePlans = todayPlans.where((p) => !p.done).toList();
    final overduePlans = state.planItems
        .where((p) => p.date.isNotEmpty && p.date.compareTo(_today) < 0 && !p.done)
        .toList();
    final todayShopping = state.shoppingItems.where((s) => !s.bought).toList();
    final todayHabitsDone = state.habits.where((h) => h.isDoneOn(_today)).length;

    final allNeed = overduePlans.length + undonePlans.length + todayShopping.length;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.appName),
            Text(_todayLabel(context),
                style: const TextStyle(fontSize: 13, color: AppTheme.inkSecondary, fontWeight: FontWeight.w400)),
          ],
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: l10n.settingsTitle,
              onPressed: () => _showSettings(context)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
        children: [
          // 今天要处理
          _TodaySection(
            count: allNeed,
            undonePlans: undonePlans,
            overduePlans: overduePlans,
            todayShopping: todayShopping,
            onGoPlan: () => _switchTab(context, 4),
            onGoShopping: () => _switchTab(context, 5),
          ),
          // 今日数字
          Row(children: [
            Expanded(child: _StatCard(label: l10n.dashStatExpense, value: fmtMoney(todayMoney.out), color: AppTheme.expense)),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(label: l10n.dashStatIncome, value: fmtMoney(todayMoney.in_), color: AppTheme.income)),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(label: l10n.dashStatHabit, value: '$todayHabitsDone/${state.habits.length}', color: AppTheme.primary)),
          ]),
          const SizedBox(height: 8),
          // 模块摘要入口
          SectionTitle(l10n.dashQuick),
          _ModuleGrid(state: state),
        ],
      ),
    );
  }

  /// 打开协议文档页（用户协议 / 隐私政策）
  void _openDoc(BuildContext context, {required bool privacy}) {
    final l10n = AppLocalizations.of(context);
    final zh = state.isZh;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AgreementDocPage(
        title: privacy ? l10n.docPrivacyPolicy : l10n.docUserAgreement,
        sections: privacy
            ? privacyPolicySections(zh: zh)
            : userAgreementSections(zh: zh),
      ),
    ));
  }

  /// 设置面板：语言切换 / 数据存储 / 协议与隐私 / 关于
  void _showSettings(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
            child: Row(children: [
              Text(l10n.settingsTitle,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ]),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.settingsLanguage),
            subtitle: Text(state.isZh ? '简体中文' : 'English', style: const TextStyle(fontSize: 12)),
            onTap: () => _showLanguagePicker(ctx, l10n),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.storage),
            title: Text(l10n.settingsStorage),
            subtitle: Text(l10n.settingsStorageSub, style: const TextStyle(fontSize: 12)),
            onTap: () => Navigator.pop(ctx),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 2),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(l10n.settingsAgreement,
                  style: const TextStyle(fontSize: 12, color: AppTheme.inkSecondary)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book_outlined, color: AppTheme.primary),
            title: Text(l10n.docUserAgreement, style: const TextStyle(fontSize: 15)),
            onTap: () {
              Navigator.pop(ctx);
              _openDoc(context, privacy: false);
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined, color: AppTheme.primary),
            title: Text(l10n.docPrivacyPolicy, style: const TextStyle(fontSize: 15)),
            onTap: () {
              Navigator.pop(ctx);
              _openDoc(context, privacy: true);
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.settingsAbout),
            subtitle: Text('${l10n.appNameFull} v1.0.0', style: const TextStyle(fontSize: 12)),
            onTap: () => Navigator.pop(ctx),
          ),
          const SizedBox(height: 8),
        ]),
        ),
      ),
    );
  }

  /// 语言选择：简体中文 / English
  void _showLanguagePicker(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
            child: Row(children: [
              Text(l10n.settingsLanguage,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ]),
          ),
          RadioGroup<String>(
            groupValue: state.localeCode,
            onChanged: (value) {
              Navigator.pop(ctx);
              if (value != null) state.setLocale(value);
            },
            child: const Column(mainAxisSize: MainAxisSize.min, children: [
              RadioListTile<String>(
                value: 'zh',
                title: Text('简体中文'),
                activeColor: AppTheme.primary,
              ),
              RadioListTile<String>(
                value: 'en',
                title: Text('English'),
                activeColor: AppTheme.primary,
              ),
            ]),
          ),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }

  void _switchTab(BuildContext context, int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => _TabWrapper(index: index, state: state),
    ));
  }
}

/// 临时 Tab 跳转包装（实际切到指定模块页）
class _TabWrapper extends StatelessWidget {
  final int index;
  final AppState state;
  const _TabWrapper({required this.index, required this.state});
  @override
  Widget build(BuildContext context) {
    final map = {
      4: PlannerScreen(state: state),
      5: ShoppingScreen(state: state),
    };
    return Scaffold(appBar: AppBar(), body: map[index]!);
  }
}

class _TodaySection extends StatelessWidget {
  final int count;
  final List<PlanItem> undonePlans;
  final List<PlanItem> overduePlans;
  final List<ShoppingItem> todayShopping;
  final VoidCallback onGoPlan;
  final VoidCallback onGoShopping;
  const _TodaySection({
    required this.count,
    required this.undonePlans,
    required this.overduePlans,
    required this.todayShopping,
    required this.onGoPlan,
    required this.onGoShopping,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (count == 0) {
      return SoftCard(
        padding: const EdgeInsets.all(20),
        child: Row(children: [
          const Icon(Icons.celebration_outlined, color: AppTheme.primary, size: 28),
          const SizedBox(width: 14),
          Expanded(
              child: Text(l10n.dashAllDone,
                  style: const TextStyle(fontSize: 15, color: AppTheme.ink))),
        ]),
      );
    }
    return SoftCard(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.notifications_active_outlined, color: AppTheme.expense, size: 20),
          const SizedBox(width: 6),
          Text(l10n.dashToday, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(color: AppTheme.expense.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
            child: Text(l10n.dashTodoCountFmt(count),
                style: const TextStyle(color: AppTheme.expense, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ]),
        const SizedBox(height: 10),
        for (final p in overduePlans) _NeedRow(
          icon: Icons.error_outline, text: l10n.dashOverdueFmt(p.title),
          tint: AppTheme.expense, onTap: onGoPlan),
        for (final p in undonePlans) _NeedRow(
          icon: Icons.event, text: l10n.dashTodayItemFmt(p.title),
          tint: AppTheme.primary, onTap: onGoPlan),
        for (final s in todayShopping) _NeedRow(
          icon: Icons.shopping_cart, text: l10n.dashToBuyFmt(s.name, s.quantity),
          tint: AppTheme.inkSecondary, onTap: onGoShopping),
      ]),
    );
  }
}

class _NeedRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color tint;
  final VoidCallback onTap;
  const _NeedRow({required this.icon, required this.text, required this.tint, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(children: [
          Icon(icon, size: 17, color: tint),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
          const Icon(Icons.chevron_right, size: 18, color: AppTheme.inkSecondary),
        ]),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.inkSecondary)),
        const SizedBox(height: 6),
        FittedBox(child: Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color))),
      ]),
    );
  }
}

class _ModuleGrid extends StatelessWidget {
  final AppState state;
  const _ModuleGrid({required this.state});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      _M(label: l10n.navMoney, icon: Icons.account_balance_wallet_outlined, color: AppTheme.expense,
          sub: l10n.dashModMoneyFmt(state.moneyRecords.length)),
      _M(label: l10n.navHabits, icon: Icons.check_circle_outline, color: AppTheme.primary,
          sub: l10n.dashModHabitFmt(state.habits.length)),
      _M(label: l10n.navFitness, icon: Icons.monitor_weight_outlined, color: AppTheme.income,
          sub: l10n.dashModFitnessFmt(state.fitnessRecords.length)),
      _M(label: l10n.navPlan, icon: Icons.event_note_outlined, color: AppTheme.inkSecondary,
          sub: l10n.dashModPlanFmt(state.planItems.length)),
      _M(label: l10n.navShopping, icon: Icons.shopping_cart_outlined, color: AppTheme.inkSecondary,
          sub: l10n.dashModShoppingFmt(state.shoppingItems.where((s) => !s.bought).length)),
      _M(label: l10n.navMedia, icon: Icons.collections_bookmark_outlined, color: AppTheme.inkSecondary,
          sub: l10n.dashModMediaFmt(state.mediaItems.length)),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: items.map((m) => SoftCard(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(m.icon, color: m.color, size: 22),
          const Spacer(),
          Text(m.label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          Text(m.sub, style: const TextStyle(fontSize: 12, color: AppTheme.inkSecondary)),
        ]),
      )).toList(),
    );
  }
}

class _M {
  final String label;
  final IconData icon;
  final Color color;
  final String sub;
  _M({required this.label, required this.icon, required this.color, required this.sub});
}
