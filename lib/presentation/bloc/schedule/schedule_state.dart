import 'package:equatable/equatable.dart';
import '../../../core/widgets/message_bloc_listener.dart';
import '../../../data/models/schedule/schedule.dart';

class ScheduleState extends Equatable implements MessageState {
  final List<Schedule> schedules;
  final Schedule? selectedSchedule;
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const ScheduleState({
    this.schedules = const [],
    this.selectedSchedule,
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  ScheduleState copyWith({
    List<Schedule>? schedules,
    Schedule? selectedSchedule,
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return ScheduleState(
      schedules: schedules ?? this.schedules,
      selectedSchedule: selectedSchedule ?? this.selectedSchedule,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props =>
      [schedules, selectedSchedule, isLoading, error, successMessage];
}
