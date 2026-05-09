import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SendSmsCode extends AuthEvent {
  final String phone;
  const SendSmsCode(this.phone);

  @override
  List<Object?> get props => [phone];
}

class RegisterSubmitted extends AuthEvent {
  final String phone;
  final String smsCode;
  final String password;
  final String confirmPassword;
  final bool agreementAccepted;

  const RegisterSubmitted({
    required this.phone,
    required this.smsCode,
    required this.password,
    required this.confirmPassword,
    required this.agreementAccepted,
  });

  @override
  List<Object?> get props =>
      [phone, smsCode, password, confirmPassword, agreementAccepted];
}

class LoginSubmitted extends AuthEvent {
  final String phone;
  final String password;
  final bool rememberPassword;

  const LoginSubmitted({
    required this.phone,
    required this.password,
    this.rememberPassword = false,
  });

  @override
  List<Object?> get props => [phone, password, rememberPassword];
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class UpdateProfile extends AuthEvent {
  final String? nickname;
  final String? avatar;
  final String? gender;
  final String? birthday;

  const UpdateProfile({this.nickname, this.avatar, this.gender, this.birthday});

  @override
  List<Object?> get props => [nickname, avatar, gender, birthday];
}

class ResetPassword extends AuthEvent {
  final String phone;
  final String smsCode;
  final String newPassword;
  final String confirmPassword;

  const ResetPassword({
    required this.phone,
    required this.smsCode,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [phone, smsCode, newPassword, confirmPassword];
}

class LoadProfile extends AuthEvent {
  const LoadProfile();
}
