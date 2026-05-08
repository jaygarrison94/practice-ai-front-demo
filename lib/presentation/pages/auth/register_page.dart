import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _smsCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreementAccepted = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
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
    final phone = _phoneController.text;
    if (Validators.validatePhone(phone) != null) return;
    context.read<AuthBloc>().add(SendSmsCode(phone));
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

  void _onRegister() {
    if (_formKey.currentState?.validate() != true) return;
    if (!_agreementAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请勾选用户协议与隐私政策')),
      );
      return;
    }
    context.read<AuthBloc>().add(RegisterSubmitted(
          phone: _phoneController.text,
          smsCode: _smsCodeController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          agreementAccepted: _agreementAccepted,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.register)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.xxl),
              const Text(
                '创建账号',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '注册您的私人管家账号',
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
                        _countdown > 0
                            ? '${_countdown}s'
                            : AppStrings.getSmsCode,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.md),
              AppTextField(
                controller: _passwordController,
                hintText: AppStrings.passwordHint,
                obscureText: _obscurePassword,
                validator: Validators.validatePassword,
                onChanged: (_) => setState(() {}),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              if (_passwordController.text.isNotEmpty)
                _buildPasswordStrength(_passwordController.text),
              const SizedBox(height: AppDimensions.md),
              AppTextField(
                controller: _confirmPasswordController,
                hintText: '确认密码',
                obscureText: _obscureConfirm,
                validator: (v) =>
                    Validators.validateConfirmPassword(v, _passwordController.text),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              const SizedBox(height: AppDimensions.md),
              Row(
                children: [
                  Checkbox(
                    value: _agreementAccepted,
                    onChanged: (v) => setState(() => _agreementAccepted = v ?? false),
                  ),
                  const Text(AppStrings.agreementPrefix),
                  TextButton(
                    onPressed: () {},
                    child: const Text(AppStrings.userAgreement),
                  ),
                  const Text(AppStrings.and),
                  TextButton(
                    onPressed: () {},
                    child: const Text(AppStrings.privacyPolicy),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.lg),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return AppButton(
                    text: '完成注册',
                    isLoading: state.status == AuthStatus.loading,
                    onPressed: _onRegister,
                  );
                },
              ),
              const SizedBox(height: AppDimensions.md),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text(AppStrings.hasAccount),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordStrength(String password) {
    final strength = Validators.checkPasswordStrength(password);
    final labels = {
      PasswordStrength.weak: AppStrings.passwordWeak,
      PasswordStrength.medium: AppStrings.passwordMedium,
      PasswordStrength.strong: AppStrings.passwordStrong,
    };
    final colors = {
      PasswordStrength.weak: AppColors.error,
      PasswordStrength.medium: AppColors.warning,
      PasswordStrength.strong: AppColors.success,
    };

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Text(
            '密码强度：${labels[strength]}',
            style: TextStyle(fontSize: 12, color: colors[strength]),
          ),
        ],
      ),
    );
  }
}
