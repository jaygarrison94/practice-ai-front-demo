import 'package:flutter/material.dart';
import '../theme/skin_controller.dart';

class AppColors {
  AppColors._();

  static final _controller = SkinController.instance;

  static Color get primary => _controller.skin.primary;
  static Color get primaryDark => _controller.skin.primaryDark;
  static Color get accent => _controller.skin.accent;

  static Color get income => _controller.skin.income;
  static Color get expense => _controller.skin.expense;

  static Color get surface => _controller.skin.surface;
  static Color get surfaceDark => _controller.skin.surfaceDark;

  static Color get background => _controller.skin.background;
  static Color get backgroundLight => _controller.skin.backgroundLight;

  static Color get textPrimary => _controller.skin.textPrimary;
  static Color get textSecondary => _controller.skin.textSecondary;
  static Color get textDark => _controller.skin.textDark;

  static Color get borderLight => _controller.skin.borderLight;
  static Color get borderDark => _controller.skin.borderDark;

  static Color get error => _controller.skin.error;
  static Color get success => _controller.skin.success;
  static Color get warning => _controller.skin.warning;
}
