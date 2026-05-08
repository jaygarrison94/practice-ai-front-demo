import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../constants/app_dimensions.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    this.message = AppStrings.empty,
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
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppDimensions.lg),
              TextButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
