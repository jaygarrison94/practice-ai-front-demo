import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../../../data/models/user/user.dart';
import '../../../data/models/user/user_login_request.dart';
import '../../../data/models/user/user_register_request.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;
  final AuthLocalDataSource _authStorage;

  AuthBloc(this._userRepository, this._authStorage)
      : super(const AuthState()) {
    on<SendSmsCode>(_onSendSmsCode);
    on<RegisterSubmitted>(_onRegister);
    on<LoginSubmitted>(_onLogin);
    on<LogoutRequested>(_onLogout);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<UpdateProfile>(_onUpdateProfile);
    on<ResetPassword>(_onResetPassword);
    on<LoadProfile>(_onLoadProfile);
  }

  Future<void> _onSendSmsCode(
      SendSmsCode event, Emitter<AuthState> emit) async {
    emit(state.copyWith(error: null, successMessage: null));
    try {
      await _userRepository.sendSmsCode(event.phone);
      emit(state.copyWith(successMessage: '验证码已发送'));
    } catch (e) {
      emit(state.copyWith(error: '验证码发送失败，请稍后再试'));
    }
  }

  Future<void> _onRegister(
      RegisterSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      final request = UserRegisterRequest(
        phone: event.phone,
        smsCode: event.smsCode,
        password: event.password,
        confirmPassword: event.confirmPassword,
        agreementAccepted: event.agreementAccepted,
      );
      final result = await _userRepository.register(request);
      final user = User(id: result.userId, phone: event.phone, token: result.token);
      await _authStorage.saveToken(result.token);
      await _authStorage.saveUserId(result.userId);
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        successMessage: '注册成功',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        error: _parseError(e),
      ));
    }
  }

  Future<void> _onLogin(
      LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      final request = UserLoginRequest(
        phone: event.phone,
        password: event.password,
        rememberPassword: event.rememberPassword,
      );
      final result = await _userRepository.login(request);
      final user = User(id: result.userId, phone: event.phone, token: result.token);
      await _authStorage.saveToken(result.token);
      await _authStorage.saveUserId(result.userId);
      if (event.rememberPassword) {
        await _authStorage.saveRememberedCredentials(event.phone, event.password);
      }
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        error: _parseError(e),
      ));
    }
  }

  Future<void> _onLogout(
      LogoutRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _userRepository.logout();
    } catch (_) {}
    await _authStorage.clearAuth();
    emit(state.copyWith(
      status: AuthStatus.unauthenticated,
      user: null,
      profile: null,
    ));
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    final token = await _authStorage.getToken();
    if (token != null && token.isNotEmpty) {
      final userId = await _authStorage.getUserId();
      if (userId != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: User(id: userId, phone: '', token: token),
        ));
        return;
      }
    }
    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<AuthState> emit) async {
    emit(state.copyWith(error: null, successMessage: null));
    try {
      await _userRepository.updateProfile(
        nickname: event.nickname,
        avatar: event.avatar,
        gender: event.gender,
        birthday: event.birthday,
      );
      final profile = await _userRepository.getProfile();
      emit(state.copyWith(
        profile: profile,
        successMessage: '保存成功',
      ));
    } catch (e) {
      emit(state.copyWith(error: _parseError(e)));
    }
  }

  Future<void> _onResetPassword(
      ResetPassword event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null, successMessage: null));
    try {
      await _userRepository.resetPassword(
        phone: event.phone,
        smsCode: event.smsCode,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
      );
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        successMessage: '密码重置成功，请重新登录',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        error: _parseError(e),
      ));
    }
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<AuthState> emit) async {
    try {
      final profile = await _userRepository.getProfile();
      emit(state.copyWith(profile: profile));
    } catch (e) {
      emit(state.copyWith(error: '加载用户信息失败'));
    }
  }

  String _parseError(dynamic e) {
    if (e is DioException) {
      final responseData = e.response?.data;
      if (responseData is Map) {
        return (responseData['message'] as String?) ?? '操作失败';
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return '网络连接超时';
      }
      if (e.type == DioExceptionType.connectionError) {
        return '网络连接失败，请检查网络设置';
      }
    }
    return '操作失败，请稍后再试';
  }
}
