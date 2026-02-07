import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));
    final dateToCheck = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String datePart;
    if (dateToCheck == today) {
      datePart = "Today";
    } else if (dateToCheck == yesterday) {
      datePart = "Yesterday";
    } else if (dateToCheck == tomorrow) {
      datePart = "Tomorrow";
    } else {
      datePart = DateFormat('d MMM').format(dateTime);
    }

    final timePart = DateFormat('h:mm a').format(dateTime);
    return "$datePart at $timePart";
  }

  static String formatDateOnly(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (dateToCheck == today) return "Today";
    
    // Returns "7 Feb, 2026"
    return DateFormat('d MMM, yyyy').format(dateTime);
  }
}