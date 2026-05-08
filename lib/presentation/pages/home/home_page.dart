import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/formatters.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/schedule/schedule_bloc.dart';
import '../../bloc/schedule/schedule_event.dart';
import '../../bloc/schedule/schedule_state.dart';
import '../../bloc/bookkeeping/bookkeeping_bloc.dart';
import '../../bloc/bookkeeping/bookkeeping_event.dart';
import '../../bloc/bookkeeping/bookkeeping_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ScheduleBloc>().add(const LoadSchedules());
    context.read<BookkeepingBloc>().add(const LoadRecords());

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(context),
            const SizedBox(height: AppDimensions.lg),
            _buildQuickActions(context),
            const SizedBox(height: AppDimensions.lg),
            _buildTodaySchedule(context),
            const SizedBox(height: AppDimensions.lg),
            _buildTodayBookkeeping(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final nickname = state.profile?.nickname ?? '用户';
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    nickname.isNotEmpty ? nickname[0] : '用',
                    style: const TextStyle(
                      fontSize: 20,
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
                      '你好，$nickname',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '今天也要好好生活',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            icon: Icons.calendar_today,
            label: '新建日程',
            color: AppColors.primary,
            onTap: () => Navigator.pushNamed(context, '/schedule/create'),
          ),
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: _ActionCard(
            icon: Icons.receipt_long,
            label: '记一笔',
            color: AppColors.income,
            onTap: () => Navigator.pushNamed(context, '/bookkeeping/create'),
          ),
        ),
      ],
    );
  }

  Widget _buildTodaySchedule(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        final todaySchedules = state.schedules
            .where((s) => s.scheduleDate == Formatters.formatDate(DateTime.now()))
            .toList();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '今日日程',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/schedule'),
                      child: const Text('查看全部'),
                    ),
                  ],
                ),
                if (todaySchedules.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppDimensions.lg),
                    child: Center(
                      child: Text(
                        '今日暂无日程',
                        style: TextStyle(color: AppColors.textHint),
                      ),
                    ),
                  )
                else
                  ...todaySchedules.take(3).map(
                        (s) => ListTile(
                          leading: Icon(
                            Icons.circle,
                            size: 12,
                            color: AppColors.primary,
                          ),
                          title: Text(s.title),
                          subtitle: Text(s.scheduleTime),
                          dense: true,
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTodayBookkeeping(BuildContext context) {
    return BlocBuilder<BookkeepingBloc, BookkeepingState>(
      builder: (context, state) {
        final today = Formatters.formatDate(DateTime.now());
        final todayRecords =
            state.records.where((r) => r.recordDate == today).toList();
        final totalIncome = todayRecords
            .where((r) => r.isIncome)
            .fold(0.0, (sum, r) => sum + r.amount);
        final totalExpense = todayRecords
            .where((r) => !r.isIncome)
            .fold(0.0, (sum, r) => sum + r.amount);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '今日收支',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/bookkeeping'),
                      child: const Text('查看全部'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _StatItem(
                        label: '收入',
                        amount: totalIncome,
                        color: AppColors.income,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.md),
                    Expanded(
                      child: _StatItem(
                        label: '支出',
                        amount: totalExpense,
                        color: AppColors.expense,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: AppDimensions.sm),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _StatItem({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(
          Formatters.formatAmount(amount),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
