import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    this.message = 'NO DATA',
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              message,
              style: GoogleFonts.pressStart2p(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppDimensions.lg),
              GestureDetector(
                onTap: onAction,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.md,
                    vertical: AppDimensions.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    border: Border(
                      top: BorderSide(color: AppColors.borderLight, width: AppDimensions.pixelBorder),
                      left: BorderSide(color: AppColors.borderLight, width: AppDimensions.pixelBorder),
                      right: BorderSide(color: AppColors.borderDark, width: AppDimensions.pixelBorder),
                      bottom: BorderSide(color: AppColors.borderDark, width: AppDimensions.pixelBorder),
                    ),
                  ),
                  child: Text(
                    actionLabel!,
                    style: GoogleFonts.pressStart2p(
                      fontSize: 10,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
