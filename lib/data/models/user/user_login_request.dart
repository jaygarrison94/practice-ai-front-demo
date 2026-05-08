import 'package:equatable/equatable.dart';

class UserLoginRequest extends Equatable {
  final String phone;
  final String password;
  final bool rememberPassword;

  const UserLoginRequest({
    required this.phone,
    required this.password,
    this.rememberPassword = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'password': password,
      'rememberPassword': rememberPassword,
    };
  }

  @override
  List<Object?> get props => [phone, password, rememberPassword];
}
