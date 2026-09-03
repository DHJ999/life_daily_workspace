import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../l10n/generated/app_localizations.dart';
import '../screens/dashboard_screen.dart';
import '../screens/money_screen.dart';
import '../screens/habits_screen.dart';
import '../screens/fitness_screen.dart';
import '../screens/planner_screen.dart';
import '../screens/shopping_screen.dart';
import '../screens/media_screen.dart';

/// 应用主框架：底部 Tab 导航 + 六模块
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l10n = AppLocalizations.of(context);
    final tabs = [
      (icon: Icons.today_outlined, active: Icons.today, label: l10n.navToday),
      (icon: Icons.account_balance_wallet_outlined, active: Icons.account_balance_wallet, label: l10n.navMoney),
      (icon: Icons.check_circle_outline, active: Icons.check_circle, label: l10n.navHabits),
      (icon: Icons.monitor_weight_outlined, active: Icons.monitor_weight, label: l10n.navFitness),
      (icon: Icons.event_note_outlined, active: Icons.event_note, label: l10n.navPlan),
      (icon: Icons.shopping_cart_outlined, active: Icons.shopping_cart, label: l10n.navShopping),
      (icon: Icons.collections_bookmark_outlined, active: Icons.collections_bookmark, label: l10n.navMedia),
    ];
    final screens = [
      DashboardScreen(state: state),
      MoneyScreen(state: state),
      HabitsScreen(state: state),
      FitnessScreen(state: state),
      PlannerScreen(state: state),
      ShoppingScreen(state: state),
      MediaScreen(state: state),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: AppTheme.surface,
        indicatorColor: AppTheme.primary.withValues(alpha: 0.12),
        height: 66,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: tabs
            .map((t) => NavigationDestination(
                  icon: Icon(t.icon),
                  selectedIcon: Icon(t.active, color: AppTheme.primary),
                  label: t.label,
                ))
            .toList(),
      ),
    );
  }
}
