import 'package:equatable/equatable.dart';
import 'repeat_rule.dart';

class Schedule extends Equatable {
  final int id;
  final String title;
  final String scheduleDate;
  final String scheduleTime;
  final String? remindBefore;
  final String? note;
  final String? category;
  final RepeatRule? repeatRule;

  const Schedule({
    required this.id,
    required this.title,
    required this.scheduleDate,
    required this.scheduleTime,
    this.remindBefore,
    this.note,
    this.category,
    this.repeatRule,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] as int,
      title: json['title'] as String,
      scheduleDate: json['scheduleDate'] as String,
      scheduleTime: json['scheduleTime'] as String,
      remindBefore: json['remindBefore'] as String?,
      note: json['note'] as String?,
      category: json['category'] as String?,
      repeatRule: json['repeatRule'] != null
          ? RepeatRule.fromJson(json['repeatRule'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'scheduleDate': scheduleDate,
      'scheduleTime': scheduleTime,
      'remindBefore': remindBefore,
      'note': note,
      'category': category,
      'repeatRule': repeatRule?.toJson(),
    };
  }

  Schedule copyWith({
    int? id,
    String? title,
    String? scheduleDate,
    String? scheduleTime,
    String? remindBefore,
    String? note,
    String? category,
    RepeatRule? repeatRule,
  }) {
    return Schedule(
      id: id ?? this.id,
      title: title ?? this.title,
      scheduleDate: scheduleDate ?? this.scheduleDate,
      scheduleTime: scheduleTime ?? this.scheduleTime,
      remindBefore: remindBefore ?? this.remindBefore,
      note: note ?? this.note,
      category: category ?? this.category,
      repeatRule: repeatRule ?? this.repeatRule,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        scheduleDate,
        scheduleTime,
        remindBefore,
        note,
        category,
        repeatRule,
      ];
}
