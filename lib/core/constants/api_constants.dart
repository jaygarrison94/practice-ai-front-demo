import 'package:flutter/foundation.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8444/api';
    }
    return 'http://10.0.2.2:8444/api';
  }

  // User
  static const String smsCode = '/user/sms-code';
  static const String register = '/user/register';
  static const String login = '/user/login';
  static const String logout = '/user/logout';
  static const String resetPassword = '/user/reset-password';
  static const String profile = '/user/profile';

  // Schedule
  static const String schedule = '/schedule';
  static const String scheduleList = '/schedule/list';
  static const String scheduleReminders = '/schedule/reminders';

  // Bookkeeping
  static const String record = '/bookkeeping/record';
  static const String records = '/bookkeeping/records';
  static const String statistics = '/bookkeeping/statistics';
}
