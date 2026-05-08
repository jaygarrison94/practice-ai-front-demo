import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../constants/api_constants.dart';
import 'api_interceptor.dart';
import 'api_response.dart';
import '../../data/datasources/auth_local_datasource.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(
      AuthInterceptor(GetIt.instance<AuthLocalDataSource>()),
    );
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    final response = await _dio.get(path, queryParameters: queryParameters);
    return ApiResponse.fromJson(response.data, fromJson);
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromJson,
  }) async {
    final response = await _dio.post(path, data: data);
    return ApiResponse.fromJson(response.data, fromJson);
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromJson,
  }) async {
    final response = await _dio.put(path, data: data);
    return ApiResponse.fromJson(response.data, fromJson);
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    T Function(dynamic)? fromJson,
  }) async {
    final response = await _dio.delete(path);
    return ApiResponse.fromJson(response.data, fromJson);
  }
}
