import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class AppTheme {
  AppTheme._();

  static TextStyle get pixelText => GoogleFonts.pressStart2p(
        color: AppColors.textPrimary,
      );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: TextTheme(
        displayLarge: pixelText.copyWith(fontSize: 28),
        displayMedium: pixelText.copyWith(fontSize: 24),
        displaySmall: pixelText.copyWith(fontSize: 20),
        headlineLarge: pixelText.copyWith(fontSize: 18),
        headlineMedium: pixelText.copyWith(fontSize: 16),
        headlineSmall: pixelText.copyWith(fontSize: 14),
        titleLarge: pixelText.copyWith(fontSize: 14),
        titleMedium: pixelText.copyWith(fontSize: 12),
        titleSmall: pixelText.copyWith(fontSize: 11),
        bodyLarge: pixelText.copyWith(fontSize: 12),
        bodyMedium: pixelText.copyWith(fontSize: 10),
        bodySmall: pixelText.copyWith(fontSize: 8),
        labelLarge: pixelText.copyWith(fontSize: 11),
        labelMedium: pixelText.copyWith(fontSize: 10),
        labelSmall: pixelText.copyWith(fontSize: 8),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.backgroundLight,
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: pixelText.copyWith(fontSize: 14, color: AppColors.accent),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: AppColors.backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          textStyle: pixelText.copyWith(fontSize: 12),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm,
        ),
        labelStyle: pixelText.copyWith(fontSize: 10),
        hintStyle: GoogleFonts.pressStart2p(fontSize: 8, color: AppColors.textSecondary),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide.none,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.backgroundLight,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        titleTextStyle: pixelText.copyWith(fontSize: 12, color: AppColors.accent),
        contentTextStyle: GoogleFonts.pressStart2p(
          fontSize: 8,
          color: AppColors.textPrimary,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.textSecondary,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.background,
        labelStyle: pixelText.copyWith(fontSize: 8),
        selectedColor: AppColors.primary,
        secondarySelectedColor: AppColors.primaryDark,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.sm,
          vertical: AppDimensions.xs,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide.none,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.backgroundLight,
        contentTextStyle: GoogleFonts.pressStart2p(
          fontSize: 8,
          color: AppColors.textPrimary,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.backgroundLight;
        }),
        checkColor: WidgetStateProperty.all(AppColors.textPrimary),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary.withAlpha(100);
          return AppColors.backgroundLight;
        }),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
