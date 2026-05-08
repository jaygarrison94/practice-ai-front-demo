import 'package:equatable/equatable.dart';

class StatisticsResult extends Equatable {
  final double totalIncome;
  final double totalExpense;
  final List<CategoryStat> categoryStats;

  const StatisticsResult({
    required this.totalIncome,
    required this.totalExpense,
    required this.categoryStats,
  });

  factory StatisticsResult.fromJson(Map<String, dynamic> json) {
    return StatisticsResult(
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalExpense: (json['totalExpense'] as num).toDouble(),
      categoryStats: (json['categoryStats'] as List)
          .map((e) => CategoryStat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [totalIncome, totalExpense, categoryStats];
}

class CategoryStat extends Equatable {
  final String categoryName;
  final double amount;
  final double percentage;
  final int type;

  const CategoryStat({
    required this.categoryName,
    required this.amount,
    required this.percentage,
    required this.type,
  });

  factory CategoryStat.fromJson(Map<String, dynamic> json) {
    return CategoryStat(
      categoryName: json['categoryName'] as String,
      amount: (json['amount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      type: json['type'] as int,
    );
  }

  @override
  List<Object?> get props => [categoryName, amount, percentage, type];
}
