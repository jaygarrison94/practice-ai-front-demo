import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class AppPickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const AppPickerTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 18),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.pressStart2p(
                  fontSize: 10,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            Text(
              value,
              style: GoogleFonts.pressStart2p(
                fontSize: 9,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
