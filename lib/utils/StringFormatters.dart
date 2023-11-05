// ignore_for_file: file_names

import 'package:intl/intl.dart';

String formatDuration(Duration? duration) {
  if (duration == null) return "";
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);

  String formattedDuration =
      '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  return formattedDuration;
}

String formatTimestamp(DateTime? date) {
  if (date == null) return "";
  return DateFormat('yyyy-MM-dd HH:mm').format(date);
}

String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

String formatTime(DateTime? dateTime) {
  if (dateTime == null) return "";
  return DateFormat.Hm().format(dateTime);
}
