import 'package:flutter/material.dart';

class AppSkin {
  final String id;
  final String name;
  final String description;
  final Color primary;
  final Color primaryDark;
  final Color accent;
  final Color income;
  final Color expense;
  final Color surface;
  final Color surfaceDark;
  final Color background;
  final Color backgroundLight;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDark;
  final Color borderLight;
  final Color borderDark;
  final Color error;
  final Color success;
  final Color warning;

  const AppSkin({
    required this.id,
    required this.name,
    required this.description,
    required this.primary,
    required this.primaryDark,
    required this.accent,
    required this.income,
    required this.expense,
    required this.surface,
    required this.surfaceDark,
    required this.background,
    required this.backgroundLight,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDark,
    required this.borderLight,
    required this.borderDark,
    required this.error,
    required this.success,
    required this.warning,
  });
}

class AppSkins {
  AppSkins._();

  static const eva = AppSkin(
    id: 'eva_unit_01',
    name: 'EVA 初号机',
    description: '深紫 + 荧光绿，高对比像素风',
    primary: Color(0xFF6A0DAD),
    primaryDark: Color(0xFF3A0050),
    accent: Color(0xFF00FF41),
    income: Color(0xFF00FF41),
    expense: Color(0xFFFF4500),
    surface: Color(0xFF1A1A2E),
    surfaceDark: Color(0xFF0D0D1A),
    background: Color(0xFF0A0A0A),
    backgroundLight: Color(0xFF1A1A2E),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF888888),
    textDark: Color(0xFF0A0A0A),
    borderLight: Color(0xFF00FF41),
    borderDark: Color(0xFF3A0050),
    error: Color(0xFFFF0000),
    success: Color(0xFF00FF41),
    warning: Color(0xFFFF4500),
  );

  static const cyberNeon = AppSkin(
    id: 'cyber_neon',
    name: '赛博霓虹',
    description: '深蓝黑底 + 霓虹蓝粉，夜城感',
    primary: Color(0xFF00D9FF),
    primaryDark: Color(0xFF003A66),
    accent: Color(0xFFFF2BD6),
    income: Color(0xFF00F5A0),
    expense: Color(0xFFFF2B6D),
    surface: Color(0xFF101A3A),
    surfaceDark: Color(0xFF071022),
    background: Color(0xFF050814),
    backgroundLight: Color(0xFF101A3A),
    textPrimary: Color(0xFFEAFBFF),
    textSecondary: Color(0xFF8EA4C8),
    textDark: Color(0xFF050814),
    borderLight: Color(0xFF00D9FF),
    borderDark: Color(0xFFFF2BD6),
    error: Color(0xFFFF2B6D),
    success: Color(0xFF00F5A0),
    warning: Color(0xFFFFD166),
  );

  static const all = [eva, cyberNeon];

  static AppSkin byId(String? id) {
    return all.firstWhere(
      (skin) => skin.id == id,
      orElse: () => eva,
    );
  }
}
