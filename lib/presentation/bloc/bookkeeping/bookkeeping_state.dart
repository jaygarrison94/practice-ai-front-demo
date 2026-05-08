import 'package:equatable/equatable.dart';
import '../../../data/models/bookkeeping/record.dart';
import '../../../data/models/bookkeeping/statistics.dart';

class BookkeepingState extends Equatable {
  final List<Record> records;
  final Record? selectedRecord;
  final StatisticsResult? statistics;
  final int selectedType;
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const BookkeepingState({
    this.records = const [],
    this.selectedRecord,
    this.statistics,
    this.selectedType = 1,
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  BookkeepingState copyWith({
    List<Record>? records,
    Record? selectedRecord,
    StatisticsResult? statistics,
    int? selectedType,
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return BookkeepingState(
      records: records ?? this.records,
      selectedRecord: selectedRecord ?? this.selectedRecord,
      statistics: statistics ?? this.statistics,
      selectedType: selectedType ?? this.selectedType,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        records,
        selectedRecord,
        statistics,
        selectedType,
        isLoading,
        error,
        successMessage,
      ];
}
