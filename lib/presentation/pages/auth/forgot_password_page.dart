import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/message_bloc_listener.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _smsCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  int _countdown = 0;

  @override
  void dispose() {
    _phoneController.dispose();
    _smsCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _sendSmsCode() {
    if (Validators.validatePhone(_phoneController.text) != null) return;
    context.read<AuthBloc>().add(SendSmsCode(_phoneController.text));
    _startCountdown();
  }

  void _startCountdown() {
    setState(() => _countdown = 60);
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _countdown--);
      return _countdown > 0;
    });
  }

  void _onReset() {
    if (_formKey.currentState?.validate() != true) return;
    context.read<AuthBloc>().add(ResetPassword(
          phone: _phoneController.text,
          smsCode: _smsCodeController.text,
          newPassword: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MessageBlocListener<AuthBloc, AuthState>(
      popOnSuccess: true,
      child: Scaffold(
        appBar: AppBar(title: const Text('忘记密码')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.xxl),
                const Text(
                  '重置密码',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  '通过手机验证码重置您的密码',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppDimensions.xl),
                AppTextField(
                  controller: _phoneController,
                  hintText: AppStrings.phoneHint,
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  validator: Validators.validatePhone,
                ),
                const SizedBox(height: AppDimensions.md),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _smsCodeController,
                        hintText: AppStrings.smsCodeHint,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        validator: Validators.validateSmsCode,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    SizedBox(
                      height: AppDimensions.buttonHeight,
                      child: ElevatedButton(
                        onPressed: _countdown > 0 ? null : _sendSmsCode,
                        child: Text(
                          _countdown > 0 ? '${_countdown}s' : AppStrings.getSmsCode,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.md),
                AppTextField(
                  controller: _passwordController,
                  hintText: '新密码',
                  obscureText: true,
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: AppDimensions.md),
                AppTextField(
                  controller: _confirmPasswordController,
                  hintText: '确认新密码',
                  obscureText: true,
                  validator: (v) =>
                      Validators.validateConfirmPassword(v, _passwordController.text),
                ),
                const SizedBox(height: AppDimensions.xl),
                AppButton(
                  text: '完成重置',
                  onPressed: _onReset,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}