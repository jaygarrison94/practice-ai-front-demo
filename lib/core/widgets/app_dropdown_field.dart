import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class AppDropdownField<T> extends StatelessWidget {
  final T initialValue;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? labelText;

  const AppDropdownField({
    super.key,
    required this.initialValue,
    required this.items,
    required this.onChanged,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.borderDark,
            width: AppDimensions.pixelBorder,
          ),
          left: BorderSide(
            color: AppColors.borderDark,
            width: AppDimensions.pixelBorder,
          ),
          right: BorderSide(
            color: AppColors.borderLight,
            width: AppDimensions.pixelBorder,
          ),
          bottom: BorderSide(
            color: AppColors.borderLight,
            width: AppDimensions.pixelBorder,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm),
      child: DropdownButtonFormField<T>(
        initialValue: initialValue,
        items: items,
        onChanged: onChanged,
        dropdownColor: AppColors.backgroundLight,
        iconEnabledColor: AppColors.accent,
        style: GoogleFonts.pressStart2p(
          fontSize: 10,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.pressStart2p(
            fontSize: 10,
            color: AppColors.textPrimary,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
