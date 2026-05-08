import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/app_button.dart';
import '../../../bloc/bookkeeping/bookkeeping_bloc.dart';
import '../../../bloc/bookkeeping/bookkeeping_event.dart';
import '../../../data/models/bookkeeping/record.dart';

class RecordDetailPage extends StatelessWidget {
  final int recordId;

  const RecordDetailPage({super.key, required this.recordId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('记录详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(
              context,
              '/bookkeeping/edit/${recordId}',
            ),
          ),
        ],
      ),
      body: BlocBuilder<BookkeepingBloc, BookkeepingState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final record = state.records.where((r) => r.id == recordId).firstOrNull;
          if (record == null) {
            return const Center(child: Text('记录不存在'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    child: Column(
                      children: [
                        Text(
                          record.amountDisplay,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: record.isIncome
                                ? AppColors.income
                                : AppColors.expense,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        Chip(
                          label: Text(
                            record.isIncome ? AppStrings.income : AppStrings.expense,
                          ),
                          backgroundColor: record.isIncome
                              ? AppColors.income.withAlpha(25)
                              : AppColors.expense.withAlpha(25),
                        ),
                        const SizedBox(height: AppDimensions.md),
                        _buildDetailRow('分类', record.categoryName ?? '-'),
                        _buildDetailRow('日期', record.recordDate),
                        _buildDetailRow('备注', record.note ?? '-'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.lg),
                AppButton(
                  text: AppStrings.deleteRecord,
                  backgroundColor: AppColors.expense,
                  onPressed: () async {
                    final confirmed = await ConfirmDialog.show(
                      context,
                      message: AppStrings.deleteRecordConfirm,
                    );
                    if (confirmed == true && context.mounted) {
                      context
                          .read<BookkeepingBloc>()
                          .add(DeleteRecord(recordId));
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value),
        ],
      ),
    );
  }
}
