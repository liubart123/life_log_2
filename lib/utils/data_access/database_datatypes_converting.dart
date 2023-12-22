import 'dart:convert';

import 'package:intl/intl.dart';

//todo:rename refactor
String convertDurationToString(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);
  final formattedDuration = '$hours:$minutes:$seconds';
  return formattedDuration;
}

Duration? convertStringToDuration(String string) {
  if (string.isEmpty) return null;
  final timeParts = string.split(':');

  return Duration(
    hours: int.parse(timeParts[0]),
    minutes: int.parse(timeParts[1]),
    seconds: timeParts.length >= 2 ? int.parse(timeParts[1]) : 0,
  );
}

String convertDateTimeToString(DateTime dateTime) {
  const format = 'yyyy-MM-dd HH:mm:ss';
  final formatter = DateFormat(format);
  return formatter.format(dateTime);
}

DateTime? convertStringToDateTime(String dateTimeString) {
  const format = 'yyyy-MM-dd HH:mm:ss';

  final formatter = DateFormat(format);
  return formatter.parse(dateTimeString);
}

String convertObjectToJson(dynamic input) {
  return jsonEncode(input);
}
