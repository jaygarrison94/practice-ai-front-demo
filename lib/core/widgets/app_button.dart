import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = backgroundColor ?? AppColors.primary;
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: double.infinity,
        height: AppDimensions.buttonHeight,
        decoration: BoxDecoration(
          color: color,
          border: Border(
            top: BorderSide(color: AppColors.borderLight, width: AppDimensions.pixelBorder),
            left: BorderSide(color: AppColors.borderLight, width: AppDimensions.pixelBorder),
            right: BorderSide(
              color: onPressed != null ? AppColors.borderDark : color,
              width: AppDimensions.pixelBorder,
            ),
            bottom: BorderSide(
              color: onPressed != null ? AppColors.borderDark : color,
              width: AppDimensions.pixelBorder,
            ),
          ),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.textPrimary,
                  ),
                )
              : Text(
                  text,
                  style: GoogleFonts.pressStart2p(
                    fontSize: 11,
                    color: AppColors.textPrimary,
                  ),
                ),
        ),
      ),
    );
  }
}
