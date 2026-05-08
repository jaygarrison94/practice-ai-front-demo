import 'package:equatable/equatable.dart';
import '../../../data/models/bookkeeping/record.dart';
import '../../../data/models/bookkeeping/statistics.dart';

abstract class BookkeepingEvent extends Equatable {
  const BookkeepingEvent();

  @override
  List<Object?> get props => [];
}

class LoadRecords extends BookkeepingEvent {
  final int? type;
  final String? startDate;
  final String? endDate;

  const LoadRecords({this.type, this.startDate, this.endDate});

  @override
  List<Object?> get props => [type, startDate, endDate];
}

class CreateRecord extends BookkeepingEvent {
  final int type;
  final double amount;
  final int? categoryId;
  final String? categoryName;
  final String? note;
  final String recordDate;

  const CreateRecord({
    required this.type,
    required this.amount,
    this.categoryId,
    this.categoryName,
    this.note,
    required this.recordDate,
  });

  @override
  List<Object?> get props => [type, amount, categoryId, categoryName, note, recordDate];
}

class UpdateRecord extends BookkeepingEvent {
  final int id;
  final int type;
  final double amount;
  final int? categoryId;
  final String? categoryName;
  final String? note;
  final String recordDate;

  const UpdateRecord({
    required this.id,
    required this.type,
    required this.amount,
    this.categoryId,
    this.categoryName,
    this.note,
    required this.recordDate,
  });

  @override
  List<Object?> get props => [id, type, amount, categoryId, categoryName, note, recordDate];
}

class DeleteRecord extends BookkeepingEvent {
  final int id;
  const DeleteRecord(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadStatistics extends BookkeepingEvent {
  final String? startDate;
  final String? endDate;

  const LoadStatistics({this.startDate, this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}
