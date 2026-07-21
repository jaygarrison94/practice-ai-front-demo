import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final int userId;
  final String phone;
  final String? nickname;
  final String? avatar;
  final int? gender;
  final String? birthday;
  final bool remindSoundEnabled;
  final bool remindVibrationEnabled;

  const UserProfile({
    required this.userId,
    required this.phone,
    this.nickname,
    this.avatar,
    this.gender,
    this.birthday,
    this.remindSoundEnabled = true,
    this.remindVibrationEnabled = true,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] as int,
      phone: json['phone'] as String,
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      gender: _parseGender(json['gender']),
      birthday: json['birthday'] as String?,
      remindSoundEnabled: json['remindSoundEnabled'] as bool? ?? true,
      remindVibrationEnabled: json['remindVibrationEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'phone': phone,
      'nickname': nickname,
      'avatar': avatar,
      'gender': gender,
      'birthday': birthday,
      'remindSoundEnabled': remindSoundEnabled,
      'remindVibrationEnabled': remindVibrationEnabled,
    };
  }

  UserProfile copyWith({
    int? userId,
    String? phone,
    String? nickname,
    String? avatar,
    int? gender,
    String? birthday,
    bool? remindSoundEnabled,
    bool? remindVibrationEnabled,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      phone: phone ?? this.phone,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      remindSoundEnabled: remindSoundEnabled ?? this.remindSoundEnabled,
      remindVibrationEnabled:
          remindVibrationEnabled ?? this.remindVibrationEnabled,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        phone,
        nickname,
        avatar,
        gender,
        birthday,
        remindSoundEnabled,
        remindVibrationEnabled,
      ];
}

int? _parseGender(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
