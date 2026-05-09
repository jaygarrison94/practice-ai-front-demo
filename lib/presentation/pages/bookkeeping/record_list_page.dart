import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/message_bloc_listener.dart';
import '../../bloc/bookkeeping/bookkeeping_bloc.dart';
import '../../bloc/bookkeeping/bookkeeping_event.dart';
import '../../bloc/bookkeeping/bookkeeping_state.dart';

class RecordListPage extends StatefulWidget {
  const RecordListPage({super.key});

  @override
  State<RecordListPage> createState() => _RecordListPageState();
}

class _RecordListPageState extends State<RecordListPage> {
  int _selectedType = 0;

  @override
  void initState() {
    super.initState();
    context.read<BookkeepingBloc>().add(const LoadRecords());
  }

  @override
  Widget build(BuildContext context) {
    return MessageBlocListener<BookkeepingBloc, BookkeepingState>(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.bookkeeping),
          actions: [
            IconButton(
              icon: const Icon(Icons.bar_chart),
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) => context.push('/bookkeeping/statistics'));
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            WidgetsBinding.instance.addPostFrameCallback((_) => context.push('/bookkeeping/create'));
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            _buildTypeSelector(),
            Expanded(child: _buildRecordList()),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Row(
        children: [
          _TypeButton(
            label: AppStrings.expense,
            isSelected: _selectedType == 1,
            color: AppColors.expense,
            onTap: () {
              setState(() => _selectedType = 1);
              context.read<BookkeepingBloc>().add(LoadRecords(type: 1));
            },
          ),
          const SizedBox(width: AppDimensions.md),
          _TypeButton(
            label: AppStrings.income,
            isSelected: _selectedType == 2,
            color: AppColors.income,
            onTap: () {
              setState(() => _selectedType = 2);
              context.read<BookkeepingBloc>().add(LoadRecords(type: 2));
            },
          ),
          const SizedBox(width: AppDimensions.md),
          _TypeButton(
            label: AppStrings.all,
            isSelected: _selectedType == 0,
            color: AppColors.primary,
            onTap: () {
              setState(() => _selectedType = 0);
              context.read<BookkeepingBloc>().add(const LoadRecords());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecordList() {
    return BlocBuilder<BookkeepingBloc, BookkeepingState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.records.isEmpty) {
          return const EmptyState(message: '暂无记账记录');
        }
        return RefreshIndicator(
          onRefresh: () async {
            context.read<BookkeepingBloc>().add(const LoadRecords());
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            itemCount: state.records.length,
            itemBuilder: (context, index) {
              final record = state.records[index];
              return Dismissible(
                key: ValueKey(record.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: AppDimensions.md),
                  color: AppColors.expense,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  context.read<BookkeepingBloc>().add(DeleteRecord(record.id));
                },
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          record.isIncome ? AppColors.income : AppColors.expense,
                      child: Icon(
                        record.isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(record.categoryName ?? record.typeName),
                    subtitle: Text(record.note ?? record.recordDate),
                    trailing: Text(
                      '${record.isIncome ? '+' : '-'}${record.amountDisplay}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: record.isIncome ? AppColors.income : AppColors.expense,
                      ),
                    ),
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) => context.push(
                        '/bookkeeping/${record.id}',
                      ));
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? color : Colors.grey[200],
          foregroundColor: isSelected ? Colors.white : Colors.grey[600],
        ),
        child: Text(label),
      ),
    );
  }
}