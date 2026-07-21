import 'package:equatable/equatable.dart';

import '../../../core/utils/formatters.dart';

class Record extends Equatable {
  final int id;
  final int type;
  final String typeName;
  final double amount;
  final String amountDisplay;
  final int? categoryId;
  final String? categoryName;
  final String? note;
  final String recordDate;

  const Record({
    required this.id,
    required this.type,
    required this.typeName,
    required this.amount,
    required this.amountDisplay,
    this.categoryId,
    this.categoryName,
    this.note,
    required this.recordDate,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['id'] as int,
      type: json['type'] as int,
      typeName: json['typeName'] as String,
      amount: (json['amount'] as num).toDouble(),
      amountDisplay: json['amountDisplay'] as String,
      categoryId: json['categoryId'] as int?,
      categoryName: json['categoryName'] as String?,
      note: json['note'] as String?,
      recordDate: json['recordDate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'typeName': typeName,
      'amount': amount,
      'amountDisplay': amountDisplay,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'note': note,
      'recordDate': recordDate,
    };
  }

  bool get isIncome => type == 2;

  String get absoluteAmountDisplay => Formatters.formatAmount(amount.abs());

  String get signedAmountDisplay {
    final prefix = isIncome ? '+' : '-';
    return '$prefix$absoluteAmountDisplay';
  }

  @override
  List<Object?> get props => [
        id,
        type,
        typeName,
        amount,
        amountDisplay,
        categoryId,
        categoryName,
        note,
        recordDate,
      ];
}
