import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice_ai_front_demo/data/datasources/auth_local_datasource.dart';
import 'package:practice_ai_front_demo/data/models/user/user.dart';
import 'package:practice_ai_front_demo/data/models/user/user_login_request.dart';
import 'package:practice_ai_front_demo/data/models/user/user_profile.dart';
import 'package:practice_ai_front_demo/data/models/user/user_register_request.dart';
import 'package:practice_ai_front_demo/data/repositories/user_repository.dart';
import 'package:practice_ai_front_demo/presentation/bloc/auth/auth_bloc.dart';
import 'package:practice_ai_front_demo/presentation/bloc/auth/auth_event.dart';
import 'package:practice_ai_front_demo/presentation/bloc/auth/auth_state.dart';

class _FakeUserRepository implements UserRepository {
  @override
  Future<UserProfile> getProfile() => throw UnimplementedError();

  @override
  Future<LoginResult> login(UserLoginRequest request) =>
      throw UnimplementedError();

  @override
  Future<void> logout() async {}

  @override
  Future<RegisterResult> register(UserRegisterRequest request) =>
      throw UnimplementedError();

  @override
  Future<void> resetPassword({
    required String phone,
    required String smsCode,
    required String newPassword,
    required String confirmPassword,
  }) =>
      throw UnimplementedError();

  @override
  Future<String> sendSmsCode(String phone) => throw UnimplementedError();

  @override
  Future<void> updateProfile({
    String? nickname,
    String? avatar,
    int? gender,
    String? birthday,
  }) =>
      throw UnimplementedError();
}

Future<void> _flushBloc() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('moves to unauthenticated when local auth is cleared externally',
      () async {
    FlutterSecureStorage.setMockInitialValues({
      'auth_token': 'token-from-storage',
      'user_id': '7',
    });
    final authStorage = AuthLocalDataSource(const FlutterSecureStorage());
    final bloc = AuthBloc(_FakeUserRepository(), authStorage);
    addTearDown(bloc.close);

    bloc.add(CheckAuthStatus());
    await _flushBloc();
    expect(bloc.state.status, AuthStatus.authenticated);

    await authStorage.clearAuth();
    await _flushBloc();

    expect(bloc.state.status, AuthStatus.unauthenticated);
    expect(bloc.state.user, isNull);
  });
}
