import 'package:intl/intl.dart';

class DateFormatter {
  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, d MMM yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatDay(DateTime date) {
    return DateFormat('EEEE').format(date);
  }
}
