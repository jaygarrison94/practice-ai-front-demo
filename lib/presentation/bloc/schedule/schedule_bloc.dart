import 'package:flutter_bloc/flutter_bloc.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';
import '../../../data/repositories/schedule_repository.dart';
import '../../../data/models/schedule/schedule_create_request.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRepository _repository;

  ScheduleBloc(this._repository) : super(const ScheduleState()) {
    on<LoadSchedules>(_onLoadSchedules);
    on<CreateSchedule>(_onCreateSchedule);
    on<UpdateSchedule>(_onUpdateSchedule);
    on<DeleteSchedule>(_onDeleteSchedule);
    on<LoadScheduleDetail>(_onLoadDetail);
  }

  Future<void> _onLoadSchedules(
      LoadSchedules event, Emitter<ScheduleState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final schedules = await _repository.getSchedules(
        date: event.date,
        category: event.category,
        keyword: event.keyword,
      );
      emit(state.copyWith(schedules: schedules, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: '加载日程失败'));
    }
  }

  Future<void> _onCreateSchedule(
      CreateSchedule event, Emitter<ScheduleState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final request = ScheduleCreateRequest(
        title: event.title,
        date: event.date,
        time: event.time,
        remindBefore: event.remindBefore,
        note: event.note,
        category: event.category,
        repeatType: event.repeatType,
        repeatWeekDays: event.repeatWeekDays,
        repeatMonthDate: event.repeatMonthDate,
        repeatEndDate: event.repeatEndDate,
      );
      await _repository.createSchedule(request);
      final schedules = await _repository.getSchedules();
      emit(state.copyWith(
        schedules: schedules,
        isLoading: false,
        successMessage: '日程创建成功',
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: '创建日程失败'));
    }
  }

  Future<void> _onUpdateSchedule(
      UpdateSchedule event, Emitter<ScheduleState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final request = ScheduleCreateRequest(
        title: event.title,
        date: event.date,
        time: event.time,
        remindBefore: event.remindBefore,
        note: event.note,
        category: event.category,
        repeatType: event.repeatType,
        repeatWeekDays: event.repeatWeekDays,
        repeatMonthDate: event.repeatMonthDate,
        repeatEndDate: event.repeatEndDate,
      );
      await _repository.updateSchedule(event.id, request);
      final schedules = await _repository.getSchedules();
      emit(state.copyWith(
        schedules: schedules,
        isLoading: false,
        successMessage: '编辑成功',
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: '编辑日程失败'));
    }
  }

  Future<void> _onDeleteSchedule(
      DeleteSchedule event, Emitter<ScheduleState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _repository.deleteSchedule(event.id);
      final schedules = await _repository.getSchedules();
      emit(state.copyWith(
        schedules: schedules,
        isLoading: false,
        successMessage: '删除成功',
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: '删除日程失败'));
    }
  }

  Future<void> _onLoadDetail(
      LoadScheduleDetail event, Emitter<ScheduleState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final schedule = await _repository.getSchedule(event.id);
      emit(state.copyWith(selectedSchedule: schedule, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: '加载日程详情失败'));
    }
  }
}
