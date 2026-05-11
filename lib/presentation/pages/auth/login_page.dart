import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberPassword = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() != true) return;
    context.read<AuthBloc>().add(LoginSubmitted(
          phone: _phoneController.text,
          password: _passwordController.text,
          rememberPassword: _rememberPassword,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.status != current.status || previous.error != current.error,
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          context.go('/home');
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.login)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.xxl),
                const Text(
                  '欢迎回来',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  '请输入您的账号信息',
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
                AppTextField(
                  controller: _passwordController,
                  hintText: AppStrings.passwordHint,
                  obscureText: _obscurePassword,
                  validator: Validators.validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberPassword,
                      onChanged: (v) => setState(() => _rememberPassword = v ?? false),
                    ),
                    const Text(AppStrings.rememberPassword),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.push('/register'),
                      child: const Text(AppStrings.noAccount),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.lg),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return AppButton(
                      text: AppStrings.login,
                      isLoading: state.status == AuthStatus.loading,
                      onPressed: _onLogin,
                    );
                  },
                ),
                const SizedBox(height: AppDimensions.md),
                Center(
                  child: TextButton(
                    onPressed: () => context.push('/register'),
                    child: const Text(AppStrings.noAccount),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}