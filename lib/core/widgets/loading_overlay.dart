import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: AppColors.background.withAlpha(200),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.lg),
                decoration: const BoxDecoration(
                  color: AppColors.backgroundLight,
                  border: Border(
                    top: BorderSide(color: AppColors.borderLight, width: AppDimensions.pixelBorder),
                    left: BorderSide(color: AppColors.borderLight, width: AppDimensions.pixelBorder),
                    right: BorderSide(color: AppColors.borderDark, width: AppDimensions.pixelBorder),
                    bottom: BorderSide(color: AppColors.borderDark, width: AppDimensions.pixelBorder),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      AppStrings.loading,
                      style: GoogleFonts.pressStart2p(
                        fontSize: 8,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
