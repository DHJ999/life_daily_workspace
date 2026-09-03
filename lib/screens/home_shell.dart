import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme.dart';
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

  static const _tabs = [
    (icon: Icons.today_outlined, active: Icons.today, label: '今日'),
    (icon: Icons.account_balance_wallet_outlined, active: Icons.account_balance_wallet, label: '记账'),
    (icon: Icons.check_circle_outline, active: Icons.check_circle, label: '习惯'),
    (icon: Icons.monitor_weight_outlined, active: Icons.monitor_weight, label: '减脂'),
    (icon: Icons.event_note_outlined, active: Icons.event_note, label: '日程'),
    (icon: Icons.shopping_cart_outlined, active: Icons.shopping_cart, label: '待买'),
    (icon: Icons.collections_bookmark_outlined, active: Icons.collections_bookmark, label: '书影音'),
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
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
        destinations: _tabs
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
