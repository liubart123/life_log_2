// ignore_for_file: file_names

import 'package:intl/intl.dart';

String formatDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);

  String formattedDuration =
      '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  return formattedDuration;
}

String formatTimestamp(DateTime date) {
  return DateFormat('yyyy-MM-dd HH:mm').format(date);
}

String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

String formatTime(DateTime dateTime) {
  return DateFormat.Hm().format(dateTime);
}
