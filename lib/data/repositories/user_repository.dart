import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/user/user.dart';
import '../models/user/user_profile.dart';
import '../models/user/user_login_request.dart';
import '../models/user/user_register_request.dart';

class UserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  Future<String> sendSmsCode(String phone) async {
    final response = await _apiClient.post<String>(
      ApiConstants.smsCode,
      queryParameters: {'phone': phone},
    );
    return response.data ?? '';
  }

  Future<RegisterResult> register(UserRegisterRequest request) async {
    final response = await _apiClient.post<RegisterResult>(
      ApiConstants.register,
      data: request.toJson(),
      fromJson: (json) => RegisterResult.fromJson(json as Map<String, dynamic>),
    );
    return response.data!;
  }

  Future<LoginResult> login(UserLoginRequest request) async {
    final response = await _apiClient.post<LoginResult>(
      ApiConstants.login,
      data: request.toJson(),
      fromJson: (json) => LoginResult.fromJson(json as Map<String, dynamic>),
    );
    return response.data!;
  }

  Future<void> logout() async {
    await _apiClient.post(ApiConstants.logout);
  }

  Future<void> resetPassword({
    required String phone,
    required String smsCode,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _apiClient.post(
      ApiConstants.resetPassword,
      queryParameters: {
        'phone': phone,
        'smsCode': smsCode,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );
  }

  Future<UserProfile> getProfile() async {
    final response = await _apiClient.get<UserProfile>(
      ApiConstants.profile,
      fromJson: (json) => UserProfile.fromJson(json as Map<String, dynamic>),
    );
    return response.data!;
  }

  Future<void> updateProfile({
    String? nickname,
    String? avatar,
    String? gender,
    String? birthday,
  }) async {
    final params = <String, dynamic>{};
    if (nickname != null) params['nickname'] = nickname;
    if (avatar != null) params['avatar'] = avatar;
    if (gender != null) params['gender'] = gender;
    if (birthday != null) params['birthday'] = birthday;

    await _apiClient.put(ApiConstants.profile, queryParameters: params);
  }
}
