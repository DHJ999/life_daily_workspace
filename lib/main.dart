import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'data/local_store.dart';
import 'repository/local_repository.dart';
import 'state/app_state.dart';
import 'theme.dart';
import 'screens/home_shell.dart';
import 'screens/agreement/agreement_gate.dart';
import 'l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 预加载中文日期符号（英文为 intl 内建，无需加载），供 DateFormat(..., 'zh') 使用
  try {
    await initializeDateFormatting('zh');
  } catch (_) {}
  runApp(const LifeDailyApp());
}

class LifeDailyApp extends StatelessWidget {
  const LifeDailyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 组装数据层：LocalStore -> LocalRepository -> AppState
    final repo = LocalRepository(LocalStore());
    return FutureBuilder<AppState>(
      future: _initState(repo),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(body: Center(child: Text('加载失败：${snapshot.error}'))),
          );
        }
        if (!snapshot.hasData) {
          return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
        }
        final state = snapshot.data!;
        return AppScope(
          state: state,
          // 监听 AppState：语言切换时重建 MaterialApp，locale 即时生效
          child: ListenableBuilder(
            listenable: state,
            builder: (context, _) => MaterialApp(
              title: state.isZh ? '日常集 · 生活工作台' : 'LifeDaily · Life Workbench',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light(),
              locale: state.isZh ? const Locale('zh') : const Locale('en'),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              // 未同意《用户协议》/《隐私政策》时先展示首启确认页
              home: state.agreed ? const HomeShell() : const AgreementGate(),
            ),
          ),
        );
      },
    );
  }

  Future<AppState> _initState(LocalRepository repo) async {
    final state = AppState(repo);
    await state.load();
    return state;
  }
}
