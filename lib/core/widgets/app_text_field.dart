import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final bool enabled;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final int maxLines;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.maxLength,
    this.enabled = true,
    this.textInputAction,
    this.focusNode,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.borderDark, width: AppDimensions.pixelBorder),
          left: BorderSide(color: AppColors.borderDark, width: AppDimensions.pixelBorder),
          right: BorderSide(color: AppColors.borderLight, width: AppDimensions.pixelBorder),
          bottom: BorderSide(color: AppColors.borderLight, width: AppDimensions.pixelBorder),
        ),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        maxLength: maxLength,
        maxLines: obscureText ? 1 : maxLines,
        enabled: enabled,
        textInputAction: textInputAction,
        focusNode: focusNode,
        style: GoogleFonts.pressStart2p(
          fontSize: 10,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          counterText: '',
          hintStyle: GoogleFonts.pressStart2p(fontSize: 8, color: AppColors.textSecondary),
          labelStyle: GoogleFonts.pressStart2p(fontSize: 10, color: AppColors.textPrimary),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.sm,
            vertical: AppDimensions.sm,
          ),
        ),
      ),
    );
  }
}
