import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class PixelContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final bool raised;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const PixelContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.raised = true,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.backgroundLight,
        border: Border(
          top: BorderSide(
            color: raised ? AppColors.borderLight : AppColors.borderDark,
            width: AppDimensions.pixelBorder,
          ),
          left: BorderSide(
            color: raised ? AppColors.borderLight : AppColors.borderDark,
            width: AppDimensions.pixelBorder,
          ),
          right: BorderSide(
            color: raised ? AppColors.borderDark : AppColors.borderLight,
            width: AppDimensions.pixelBorder,
          ),
          bottom: BorderSide(
            color: raised ? AppColors.borderDark : AppColors.borderLight,
            width: AppDimensions.pixelBorder,
          ),
        ),
      ),
      padding: padding ?? const EdgeInsets.all(AppDimensions.md),
      child: child,
    );
  }
}
