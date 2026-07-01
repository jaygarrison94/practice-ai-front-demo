import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/app_colors.dart';

abstract class MessageState {
  String? get error;
  String? get successMessage;
}

class MessageBlocListener<B extends BlocBase<S>, S extends MessageState>
    extends StatelessWidget {
  final Widget child;
  final bool popOnSuccess;

  const MessageBlocListener({
    super.key,
    required this.child,
    this.popOnSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listenWhen: (previous, current) =>
          previous.error != current.error ||
          previous.successMessage != current.successMessage,
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          if (popOnSuccess) Navigator.pop(context);
        }
      },
      child: child,
    );
  }
}