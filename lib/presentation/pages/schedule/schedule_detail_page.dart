import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/message_bloc_listener.dart';
import '../../bloc/schedule/schedule_bloc.dart';
import '../../bloc/schedule/schedule_event.dart';
import '../../bloc/schedule/schedule_state.dart';

class ScheduleDetailPage extends StatefulWidget {
  final int scheduleId;

  const ScheduleDetailPage({super.key, required this.scheduleId});

  @override
  State<ScheduleDetailPage> createState() => _ScheduleDetailPageState();
}

class _ScheduleDetailPageState extends State<ScheduleDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ScheduleBloc>().add(LoadScheduleDetail(widget.scheduleId));
  }

  @override
  Widget build(BuildContext context) {
    return MessageBlocListener<ScheduleBloc, ScheduleState>(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('日程详情'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) => context.push(
                  '/schedule/edit/${widget.scheduleId}',
                ));
              },
            ),
          ],
        ),
        body: BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final schedule = state.selectedSchedule;
            if (schedule == null) {
              return const Center(child: Text('日程不存在'));
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            schedule.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.lg),
                          _buildInfoRow(
                            Icons.calendar_today,
                            '日期',
                            schedule.scheduleDate,
                          ),
                          _buildInfoRow(
                            Icons.access_time,
                            '时间',
                            schedule.scheduleTime,
                          ),
                          if (schedule.remindBefore != null)
                            _buildInfoRow(
                              Icons.notifications_active,
                              '提前提醒',
                              schedule.remindBefore!,
                            ),
                          if (schedule.category != null)
                            _buildInfoRow(
                              Icons.category,
                              '分类',
                              schedule.category!,
                            ),
                          if (schedule.note != null && schedule.note!.isNotEmpty)
                            _buildInfoRow(
                              Icons.notes,
                              '备注',
                              schedule.note!,
                            ),
                          if (schedule.repeatRule != null)
                            _buildInfoRow(
                              Icons.repeat,
                              '重复',
                              schedule.repeatRule!.repeatType,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  AppButton(
                    text: AppStrings.deleteSchedule,
                    backgroundColor: AppColors.expense,
                    onPressed: () async {
                      final confirmed = await ConfirmDialog.show(
                        context,
                        message: AppStrings.deleteScheduleConfirm,
                      );
                      if (confirmed == true && context.mounted) {
                        context
                            .read<ScheduleBloc>()
                            .add(DeleteSchedule(widget.scheduleId));
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: AppDimensions.sm),
          Text(
            '$label：',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          Text(value),
        ],
      ),
    );
  }
}