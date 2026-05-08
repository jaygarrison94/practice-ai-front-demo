import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static String formatAmount(double amount) {
    return '¥${NumberFormat('#,##0.00', 'zh_CN').format(amount)}';
  }

  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd', 'zh_CN').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm', 'zh_CN').format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm', 'zh_CN').format(dateTime);
  }

  static String formatMonthDay(DateTime date) {
    return DateFormat('MM月dd日', 'zh_CN').format(date);
  }

  static String formatWeekday(DateTime date) {
    final weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return weekdays[date.weekday - 1];
  }
}
