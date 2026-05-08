import 'package:equatable/equatable.dart';

class RecordCreateRequest extends Equatable {
  final int type;
  final double amount;
  final int? categoryId;
  final String? categoryName;
  final String? note;
  final String recordDate;

  const RecordCreateRequest({
    required this.type,
    required this.amount,
    this.categoryId,
    this.categoryName,
    this.note,
    required this.recordDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'amount': amount,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'note': note,
      'recordDate': recordDate,
    };
  }

  @override
  List<Object?> get props => [type, amount, categoryId, categoryName, note, recordDate];
}
