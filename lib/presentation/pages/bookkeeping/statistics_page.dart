import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/message_bloc_listener.dart';
import '../../../data/models/bookkeeping/statistics.dart';
import '../../bloc/bookkeeping/bookkeeping_bloc.dart';
import '../../bloc/bookkeeping/bookkeeping_event.dart';
import '../../bloc/bookkeeping/bookkeeping_state.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  String _selectedPeriod = AppStrings.thisMonth;
  final _periods = [AppStrings.thisWeek, AppStrings.thisMonth, AppStrings.custom];

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  void _loadStatistics() {
    final now = DateTime.now();
    String? startDate;
    String? endDate;

    if (_selectedPeriod == AppStrings.thisWeek) {
      startDate = DateFormat('yyyy-MM-dd')
          .format(now.subtract(Duration(days: now.weekday - 1)));
      endDate = Formatters.formatDate(now);
    } else if (_selectedPeriod == AppStrings.thisMonth) {
      startDate = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, 1));
      endDate = Formatters.formatDate(now);
    }

    context.read<BookkeepingBloc>().add(LoadStatistics(
          startDate: startDate,
          endDate: endDate,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MessageBlocListener<BookkeepingBloc, BookkeepingState>(
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.statistics)),
        body: Column(
          children: [
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _periods.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.sm),
                itemBuilder: (context, index) {
                  final period = _periods[index];
                  final isSelected = _selectedPeriod == period;
                  return ChoiceChip(
                    label: Text(period),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => _selectedPeriod = period);
                      _loadStatistics();
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<BookkeepingBloc, BookkeepingState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final stats = state.statistics;
                  if (stats == null) {
                    return const Center(child: Text('暂无统计数据'));
                  }
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDimensions.md),
                    child: Column(
                      children: [
                        _buildSummaryCard(stats),
                        const SizedBox(height: AppDimensions.lg),
                        _buildChart(stats),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(StatisticsResult stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Text('总收入',
                      style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.formatAmount(stats.totalIncome),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.income,
                    ),
                  ),
                ],
              ),
            ),
            Container(width: 1, height: 40, color: AppColors.divider),
            Expanded(
              child: Column(
                children: [
                  const Text('总支出',
                      style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.formatAmount(stats.totalExpense),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.expense,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(StatisticsResult stats) {
    final expenseStats = stats.categoryStats
        .where((s) => s.type == 1)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '支出分类占比',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppDimensions.md),
        if (expenseStats.isEmpty)
          const Center(child: Text('暂无支出数据'))
        else
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: expenseStats.map((s) {
                  return PieChartSectionData(
                    value: s.percentage,
                    title: '${s.percentage.toStringAsFixed(1)}%',
                    color: AppColors.primary
                        .withAlpha((255 - expenseStats.indexOf(s) * 40).clamp(80, 255).toInt()),
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
                centerSpaceRadius: 40,
              ),
            ),
          ),
        const SizedBox(height: AppDimensions.md),
        ...expenseStats.map((s) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('${s.categoryName}: ${Formatters.formatAmount(s.amount)}'),
            )),
      ],
    );
  }
}