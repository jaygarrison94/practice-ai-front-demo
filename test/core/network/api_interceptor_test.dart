import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice_ai_front_demo/core/network/api_interceptor.dart';
import 'package:practice_ai_front_demo/data/datasources/auth_local_datasource.dart';

class _ForbiddenAdapter implements HttpClientAdapter {
  Map<String, dynamic>? capturedHeaders;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    capturedHeaders = Map<String, dynamic>.from(options.headers);
    return ResponseBody.fromString(
      '{"code":403,"message":"Forbidden","data":null}',
      403,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('adds bearer token and clears local auth after a 403 response',
      () async {
    FlutterSecureStorage.setMockInitialValues({
      'auth_token': 'stale-token',
      'user_id': '12',
    });
    const secureStorage = FlutterSecureStorage();
    final authStorage = AuthLocalDataSource(secureStorage);
    final adapter = _ForbiddenAdapter();
    final dio = Dio()..httpClientAdapter = adapter;
    dio.interceptors.add(AuthInterceptor(authStorage));

    await expectLater(
      dio.get<void>('/api/schedule/list'),
      throwsA(isA<DioException>()),
    );

    expect(adapter.capturedHeaders?['Authorization'], 'Bearer stale-token');
    expect(await authStorage.getToken(), isNull);
    expect(await authStorage.getUserId(), isNull);
  });
}
