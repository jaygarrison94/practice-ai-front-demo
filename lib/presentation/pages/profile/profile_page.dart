import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/message_bloc_listener.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return MessageBlocListener<AuthBloc, AuthState>(
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.profile)),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final profile = state.profile;
            final nickname = profile?.nickname ?? '用户';
            final phone = profile?.phone ?? '';

            return ListView(
              padding: const EdgeInsets.all(AppDimensions.md),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            nickname.isNotEmpty ? nickname[0] : '用',
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.md),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nickname,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              phone.isNotEmpty ? phone : '',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => context.push('/profile/edit'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.lg),
                Card(
                  child: Column(
                    children: [
                      _buildMenuItem(
                        context,
                        Icons.notifications_outlined,
                        AppStrings.settings,
                        () {},
                      ),
                      const Divider(height: 1, indent: AppDimensions.xxl),
                      _buildMenuItem(
                        context,
                        Icons.palette_outlined,
                        '主题皮肤',
                        () => context.push('/profile/skin'),
                      ),
                      const Divider(height: 1, indent: AppDimensions.xxl),
                      _buildMenuItem(
                        context,
                        Icons.help_outline,
                        '帮助中心',
                        () {},
                      ),
                      const Divider(height: 1, indent: AppDimensions.xxl),
                      _buildMenuItem(
                        context,
                        Icons.info_outline,
                        '关于',
                        () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.lg),
                Card(
                  child: _buildMenuItem(
                    context,
                    Icons.logout,
                    AppStrings.logout,
                    () async {
                      final confirmed = await ConfirmDialog.show(
                        context,
                        message: AppStrings.logoutConfirm,
                      );
                      if (confirmed == true && context.mounted) {
                        context.read<AuthBloc>().add(LogoutRequested());
                      }
                    },
                    color: AppColors.expense,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textPrimary),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
