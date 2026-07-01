import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = AppStrings.confirm,
    this.cancelText = AppStrings.cancel,
    required this.onConfirm,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String message,
    String title = AppStrings.confirm,
    String confirmText = AppStrings.confirm,
    String cancelText = AppStrings.cancel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: () => Navigator.of(ctx).pop(true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundLight,
          border: Border(
            top: BorderSide(color: AppColors.borderLight, width: AppDimensions.pixelBorder),
            left: BorderSide(color: AppColors.borderLight, width: AppDimensions.pixelBorder),
            right: BorderSide(color: AppColors.borderDark, width: AppDimensions.pixelBorder),
            bottom: BorderSide(color: AppColors.borderDark, width: AppDimensions.pixelBorder),
          ),
        ),
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.pressStart2p(
                fontSize: 12,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              message,
              style: GoogleFonts.pressStart2p(
                fontSize: 8,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.lg),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Container(
                      height: AppDimensions.buttonHeight,
                      decoration: const BoxDecoration(
                        color: AppColors.backgroundLight,
                        border: Border(
                          top: BorderSide(color: AppColors.borderLight, width: AppDimensions.pixelBorder),
                          left: BorderSide(color: AppColors.borderLight, width: AppDimensions.pixelBorder),
                          right: BorderSide(color: AppColors.borderDark, width: AppDimensions.pixelBorder),
                          bottom: BorderSide(color: AppColors.borderDark, width: AppDimensions.pixelBorder),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          cancelText,
                          style: GoogleFonts.pressStart2p(
                            fontSize: 10,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      height: AppDimensions.buttonHeight,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        border: Border(
                          top: BorderSide(color: AppColors.borderLight, width: AppDimensions.pixelBorder),
                          left: BorderSide(color: AppColors.borderLight, width: AppDimensions.pixelBorder),
                          right: BorderSide(color: AppColors.borderDark, width: AppDimensions.pixelBorder),
                          bottom: BorderSide(color: AppColors.borderDark, width: AppDimensions.pixelBorder),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          confirmText,
                          style: GoogleFonts.pressStart2p(
                            fontSize: 10,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
