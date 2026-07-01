import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin? _plugin;

  NotificationService();

  Future<void> init() async {
    if (kIsWeb) return;

    _plugin ??= FlutterLocalNotificationsPlugin();
    Intl.defaultLocale = 'zh_CN';
    await initializeDateFormatting('zh_CN');
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    try {
      await _plugin!.initialize(settings);
    } catch (_) {}
  }

  Future<void> showScheduleReminder({
    required int id,
    required String title,
    required String body,
  }) async {
    if (_plugin == null) return;
    const androidDetails = AndroidNotificationDetails(
      'schedule_channel',
      '日程提醒',
      channelDescription: '日程提醒通知',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    try {
      await _plugin!.show(id, title, body, details);
    } catch (_) {}
  }
}
