import 'package:flutter/material.dart';
import 'data/local_store.dart';
import 'repository/local_repository.dart';
import 'state/app_state.dart';
import 'theme.dart';
import 'screens/home_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
          child: MaterialApp(
            title: '日常集 · 生活工作台',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            home: const HomeShell(),
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
