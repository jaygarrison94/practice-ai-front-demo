import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/bookkeeping/record.dart';
import '../models/bookkeeping/record_create_request.dart';
import '../models/bookkeeping/category.dart';
import '../models/bookkeeping/statistics.dart';

class BookkeepingRepository {
  final ApiClient _apiClient;

  BookkeepingRepository(this._apiClient);

  Future<Record> createRecord(RecordCreateRequest request) async {
    final response = await _apiClient.post<Record>(
      ApiConstants.record,
      data: request.toJson(),
      fromJson: (json) => Record.fromJson(json as Map<String, dynamic>),
    );
    return response.data!;
  }

  Future<Record> updateRecord(int id, RecordCreateRequest request) async {
    final response = await _apiClient.put<Record>(
      '${ApiConstants.record}/$id',
      data: request.toJson(),
      fromJson: (json) => Record.fromJson(json as Map<String, dynamic>),
    );
    return response.data!;
  }

  Future<void> deleteRecord(int id) async {
    await _apiClient.delete('${ApiConstants.record}/$id');
  }

  Future<Record> getRecord(int id) async {
    final response = await _apiClient.get<Record>(
      '${ApiConstants.record}/$id',
      fromJson: (json) => Record.fromJson(json as Map<String, dynamic>),
    );
    return response.data!;
  }

  Future<List<Record>> getRecords({
    int? type,
    String? startDate,
    String? endDate,
  }) async {
    final params = <String, dynamic>{};
    if (type != null) params['type'] = type;
    if (startDate != null) params['startDate'] = startDate;
    if (endDate != null) params['endDate'] = endDate;

    final response = await _apiClient.get<List<Record>>(
      ApiConstants.records,
      queryParameters: params.isNotEmpty ? params : null,
      fromJson: (json) =>
          (json as List).map((e) => Record.fromJson(e as Map<String, dynamic>)).toList(),
    );
    return response.data ?? [];
  }

  Future<StatisticsResult> getStatistics({
    String? startDate,
    String? endDate,
  }) async {
    final params = <String, dynamic>{};
    if (startDate != null) params['startDate'] = startDate;
    if (endDate != null) params['endDate'] = endDate;

    final response = await _apiClient.get<StatisticsResult>(
      ApiConstants.statistics,
      queryParameters: params.isNotEmpty ? params : null,
      fromJson: (json) =>
          StatisticsResult.fromJson(json as Map<String, dynamic>),
    );
    return response.data!;
  }
}
