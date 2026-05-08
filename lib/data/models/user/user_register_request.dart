import 'package:equatable/equatable.dart';

class UserRegisterRequest extends Equatable {
  final String phone;
  final String smsCode;
  final String password;
  final String confirmPassword;
  final bool agreementAccepted;

  const UserRegisterRequest({
    required this.phone,
    required this.smsCode,
    required this.password,
    required this.confirmPassword,
    required this.agreementAccepted,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'smsCode': smsCode,
      'password': password,
      'confirmPassword': confirmPassword,
      'agreementAccepted': agreementAccepted,
    };
  }

  @override
  List<Object?> get props => [phone, smsCode, password, confirmPassword, agreementAccepted];
}
