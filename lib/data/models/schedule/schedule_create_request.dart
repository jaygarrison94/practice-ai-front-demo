import 'package:equatable/equatable.dart';

class ScheduleCreateRequest extends Equatable {
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

  const ScheduleCreateRequest({
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

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'time': time,
      'remindBefore': remindBefore,
      'note': note,
      'category': category,
      'repeatType': repeatType,
      'repeatWeekDays': repeatWeekDays,
      'repeatMonthDate': repeatMonthDate,
      'repeatEndDate': repeatEndDate,
    };
  }

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
