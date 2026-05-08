import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../constants/app_dimensions.dart';

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
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(confirmText),
        ),
      ],
    );
  }
}
