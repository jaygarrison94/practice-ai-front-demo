import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice_ai_front_demo/data/datasources/auth_local_datasource.dart';
import 'package:practice_ai_front_demo/data/models/user/user.dart';
import 'package:practice_ai_front_demo/data/models/user/user_login_request.dart';
import 'package:practice_ai_front_demo/data/models/user/user_profile.dart';
import 'package:practice_ai_front_demo/data/models/user/user_register_request.dart';
import 'package:practice_ai_front_demo/data/repositories/user_repository.dart';
import 'package:practice_ai_front_demo/presentation/bloc/auth/auth_bloc.dart';
import 'package:practice_ai_front_demo/presentation/pages/profile/edit_profile_page.dart';

class _CapturingUserRepository implements UserRepository {
  Object? capturedGender;

  @override
  Future<UserProfile> getProfile() async {
    return const UserProfile(userId: 1, phone: '13800138000', gender: 1);
  }

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
    Object? gender,
    String? birthday,
  }) async {
    capturedGender = gender;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('saves displayed gender as backend numeric value', (tester) async {
    FlutterSecureStorage.setMockInitialValues({});
    final repository = _CapturingUserRepository();
    final authStorage = AuthLocalDataSource(const FlutterSecureStorage());
    final bloc = AuthBloc(repository, authStorage);
    addTearDown(bloc.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: const EditProfilePage(),
        ),
      ),
    );

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('男').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pump();

    expect(repository.capturedGender, 1);
  });
}
