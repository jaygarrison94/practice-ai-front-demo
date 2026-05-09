import 'package:flutter_bloc/flutter_bloc.dart';
import 'bookkeeping_event.dart';
import 'bookkeeping_state.dart';
import '../../../data/repositories/bookkeeping_repository.dart';
import '../../../data/models/bookkeeping/record_create_request.dart';

class BookkeepingBloc extends Bloc<BookkeepingEvent, BookkeepingState> {
  final BookkeepingRepository _repository;

  BookkeepingBloc(this._repository) : super(const BookkeepingState()) {
    on<LoadRecords>(_onLoadRecords);
    on<CreateRecord>(_onCreateRecord);
    on<UpdateRecord>(_onUpdateRecord);
    on<DeleteRecord>(_onDeleteRecord);
    on<LoadStatistics>(_onLoadStatistics);
    on<LoadRecordDetail>(_onLoadRecordDetail);
  }

  Future<void> _onLoadRecords(
      LoadRecords event, Emitter<BookkeepingState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final records = await _repository.getRecords(
        type: event.type,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(state.copyWith(records: records, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: '加载记账记录失败'));
    }
  }

  Future<void> _onCreateRecord(
      CreateRecord event, Emitter<BookkeepingState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final request = RecordCreateRequest(
        type: event.type,
        amount: event.amount,
        categoryId: event.categoryId,
        categoryName: event.categoryName,
        note: event.note,
        recordDate: event.recordDate,
      );
      await _repository.createRecord(request);
      final records = await _repository.getRecords();
      emit(state.copyWith(
        records: records,
        isLoading: false,
        successMessage: '记账成功',
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: '创建记录失败'));
    }
  }

  Future<void> _onUpdateRecord(
      UpdateRecord event, Emitter<BookkeepingState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final request = RecordCreateRequest(
        type: event.type,
        amount: event.amount,
        categoryId: event.categoryId,
        categoryName: event.categoryName,
        note: event.note,
        recordDate: event.recordDate,
      );
      await _repository.updateRecord(event.id, request);
      final records = await _repository.getRecords();
      emit(state.copyWith(
        records: records,
        isLoading: false,
        successMessage: '编辑成功',
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: '编辑记录失败'));
    }
  }

  Future<void> _onDeleteRecord(
      DeleteRecord event, Emitter<BookkeepingState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _repository.deleteRecord(event.id);
      final records = await _repository.getRecords();
      emit(state.copyWith(
        records: records,
        isLoading: false,
        successMessage: '删除成功',
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: '删除记录失败'));
    }
  }

  Future<void> _onLoadStatistics(
      LoadStatistics event, Emitter<BookkeepingState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final statistics = await _repository.getStatistics(
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(state.copyWith(statistics: statistics, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: '加载统计数据失败'));
    }
  }

  Future<void> _onLoadRecordDetail(
      LoadRecordDetail event, Emitter<BookkeepingState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final record = await _repository.getRecord(event.id);
      emit(state.copyWith(selectedRecord: record, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: '加载记录详情失败'));
    }
  }
}
