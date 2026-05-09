import 'package:equatable/equatable.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

class LoadSchedules extends ScheduleEvent {
  final String? date;
  final String? category;
  final String? keyword;

  const LoadSchedules({this.date, this.category, this.keyword});

  @override
  List<Object?> get props => [date, category, keyword];
}

class CreateSchedule extends ScheduleEvent {
  final String title;
  final String date;
  final String time;
  final String? remindBefore;
  final String? note;
  final String? category;
  final String? repeatType;
  final String? repeatWeekDays;
  final int? repeatMonthDate;
  final String? repeatEndDate;

  const CreateSchedule({
    required this.title,
    required this.date,
    required this.time,
    this.remindBefore,
    this.note,
    this.category,
    this.repeatType,
    this.repeatWeekDays,
    this.repeatMonthDate,
    this.repeatEndDate,
  });

  @override
  List<Object?> get props => [
        title,
        date,
        time,
        remindBefore,
        note,
        category,
        repeatType,
        repeatWeekDays,
        repeatMonthDate,
        repeatEndDate,
      ];
}

class UpdateSchedule extends ScheduleEvent {
  final int id;
  final String title;
  final String date;
  final String time;
  final String? remindBefore;
  final String? note;
  final String? category;
  final String? repeatType;
  final String? repeatWeekDays;
  final int? repeatMonthDate;
  final String? repeatEndDate;

  const UpdateSchedule({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    this.remindBefore,
    this.note,
    this.category,
    this.repeatType,
    this.repeatWeekDays,
    this.repeatMonthDate,
    this.repeatEndDate,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        date,
        time,
        remindBefore,
        note,
        category,
        repeatType,
        repeatWeekDays,
        repeatMonthDate,
        repeatEndDate,
      ];
}

class DeleteSchedule extends ScheduleEvent {
  final int id;
  const DeleteSchedule(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadScheduleDetail extends ScheduleEvent {
  final int id;
  const LoadScheduleDetail(this.id);

  @override
  List<Object?> get props => [id];
}
