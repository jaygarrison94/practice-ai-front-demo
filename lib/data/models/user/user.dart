import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String phone;
  final String? token;

  const User({required this.id, required this.phone, this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userId'] as int,
      phone: json['phone'] as String,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'phone': phone,
      'token': token,
    };
  }

  @override
  List<Object?> get props => [id, phone, token];
}

class RegisterResult {
  final int userId;
  final String token;

  const RegisterResult({required this.userId, required this.token});

  factory RegisterResult.fromJson(Map<String, dynamic> json) {
    return RegisterResult(
      userId: json['userId'] as int,
      token: json['token'] as String,
    );
  }
}

class LoginResult {
  final int userId;
  final String token;
  final bool? rememberPassword;

  const LoginResult({
    required this.userId,
    required this.token,
    this.rememberPassword,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      userId: json['userId'] as int,
      token: json['token'] as String,
      rememberPassword: json['rememberPassword'] as bool?,
    );
  }
}
