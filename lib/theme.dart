import 'package:flutter/material.dart';

/// 全局主题 —— 克制、高级、有生活感
/// 暖白底 + 墨绿主色 + 低饱和强调色，圆角克制，避免千篇一律的卡片风
class AppTheme {
  static const Color bg = Color(0xFFF7F5F0); // 暖米白
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF4A6B57); // 墨绿
  static const Color primaryDark = Color(0xFF3A5647);
  static const Color ink = Color(0xFF2B2B2B); // 主文字
  static const Color inkSecondary = Color(0xFF7A7A72); // 次要文字
  static const Color line = Color(0xFFE8E4DA); // 分隔线
  static const Color income = Color(0xFF2E7D32); // 收入绿
  static const Color expense = Color(0xFFD85A30); // 支出橙红

  static const TextStyle serif = TextStyle(
    fontFamily: 'serif',
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        surface: surface,
      ),
      scaffoldBackgroundColor: bg,
      fontFamily: 'system-ui',
    );
    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: ink,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        iconTheme: IconThemeData(color: ink),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: line),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: inkSecondary),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: const DividerThemeData(color: line, thickness: 0.8),
    );
  }
}
