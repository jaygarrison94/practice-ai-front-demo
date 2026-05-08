import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage _storage;

  AuthLocalDataSource(this._storage);

  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _phoneKey = 'remembered_phone';
  static const _passwordKey = 'remembered_password';

  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<String?> getToken() => _storage.read(key: _tokenKey);

  Future<void> saveUserId(int userId) =>
      _storage.write(key: _userIdKey, value: userId.toString());

  Future<int?> getUserId() async {
    final id = await _storage.read(key: _userIdKey);
    return id != null ? int.tryParse(id) : null;
  }

  Future<void> saveRememberedCredentials(String phone, String password) async {
    await _storage.write(key: _phoneKey, value: phone);
    await _storage.write(key: _passwordKey, value: password);
  }

  Future<Map<String, String?>> getRememberedCredentials() async {
    final phone = await _storage.read(key: _phoneKey);
    final password = await _storage.read(key: _passwordKey);
    return {'phone': phone, 'password': password};
  }

  Future<void> clearAuth() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userIdKey);
  }

  Future<void> clearAll() async => await _storage.deleteAll();
}
