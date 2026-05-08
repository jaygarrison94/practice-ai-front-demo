import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/schedule/schedule.dart';
import '../models/schedule/schedule_create_request.dart';

class ScheduleRepository {
  final ApiClient _apiClient;

  ScheduleRepository(this._apiClient);

  Future<Schedule> createSchedule(ScheduleCreateRequest request) async {
    final response = await _apiClient.post<Schedule>(
      ApiConstants.schedule,
      data: request.toJson(),
      fromJson: (json) => Schedule.fromJson(json as Map<String, dynamic>),
    );
    return response.data!;
  }

  Future<Schedule> updateSchedule(
      int id, ScheduleCreateRequest request) async {
    final response = await _apiClient.put<Schedule>(
      '${ApiConstants.schedule}/$id',
      data: request.toJson(),
      fromJson: (json) => Schedule.fromJson(json as Map<String, dynamic>),
    );
    return response.data!;
  }

  Future<void> deleteSchedule(int id) async {
    await _apiClient.delete('${ApiConstants.schedule}/$id');
  }

  Future<Schedule> getSchedule(int id) async {
    final response = await _apiClient.get<Schedule>(
      '${ApiConstants.schedule}/$id',
      fromJson: (json) => Schedule.fromJson(json as Map<String, dynamic>),
    );
    return response.data!;
  }

  Future<List<Schedule>> getSchedules({
    String? date,
    String? category,
    String? keyword,
  }) async {
    final params = <String, dynamic>{};
    if (date != null) params['date'] = date;
    if (category != null) params['category'] = category;
    if (keyword != null) params['keyword'] = keyword;

    final response = await _apiClient.get<List<Schedule>>(
      ApiConstants.scheduleList,
      queryParameters: params.isNotEmpty ? params : null,
      fromJson: (json) =>
          (json as List).map((e) => Schedule.fromJson(e as Map<String, dynamic>)).toList(),
    );
    return response.data ?? [];
  }

  Future<List<Schedule>> getReminders() async {
    final response = await _apiClient.get<List<Schedule>>(
      ApiConstants.scheduleReminders,
      fromJson: (json) =>
          (json as List).map((e) => Schedule.fromJson(e as Map<String, dynamic>)).toList(),
    );
    return response.data ?? [];
  }
}
