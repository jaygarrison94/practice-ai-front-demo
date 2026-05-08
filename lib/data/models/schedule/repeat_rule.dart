import 'package:equatable/equatable.dart';

class RepeatRule extends Equatable {
  final String repeatType;
  final String? repeatWeekDays;
  final int? repeatMonthDate;
  final String? repeatEndDate;

  const RepeatRule({
    required this.repeatType,
    this.repeatWeekDays,
    this.repeatMonthDate,
    this.repeatEndDate,
  });

  factory RepeatRule.fromJson(Map<String, dynamic> json) {
    return RepeatRule(
      repeatType: json['repeatType'] as String,
      repeatWeekDays: json['repeatWeekDays'] as String?,
      repeatMonthDate: json['repeatMonthDate'] as int?,
      repeatEndDate: json['repeatEndDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'repeatType': repeatType,
      'repeatWeekDays': repeatWeekDays,
      'repeatMonthDate': repeatMonthDate,
      'repeatEndDate': repeatEndDate,
    };
  }

  @override
  List<Object?> get props => [repeatType, repeatWeekDays, repeatMonthDate, repeatEndDate];
}
