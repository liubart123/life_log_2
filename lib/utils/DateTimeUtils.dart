import 'package:intl/intl.dart';

DateTime parseDateTime(String inputString,
    {String format = "yyyy-MM-dd HH:mm"}) {
  final formatter = DateFormat(format);
  return formatter.parse(inputString);
}

DateTime parseTime(String inputString, {String format = "HH:mm"}) {
  final formatter = DateFormat(format);
  return formatter.parse(inputString);
}

DateTime parseDate(String inputString, {String format = "yyyy-MM-dd"}) {
  final formatter = DateFormat(format);
  return formatter.parse(inputString);
}

Duration parseDuration(String inputString) {
  List<String> timeParts = inputString.split(':');

  return Duration(
    hours: int.parse(timeParts[0]),
    minutes: int.parse(timeParts[1]),
    seconds: timeParts.length >= 2 ? int.parse(timeParts[1]) : 0,
  );
}

String stringifyDateTime(DateTime dateTime,
    {String format = "yyyy-MM-dd HH:mm"}) {
  final formatter = DateFormat(format);
  return formatter.format(dateTime);
}

String stringifyTime(DateTime dateTime, {String format = "HH:mm"}) {
  final formatter = DateFormat(format);
  return formatter.format(dateTime);
}

String stringifyDuration(Duration duration) {
  return "${convertIntToTwoDigitString(duration.inHours)}:${convertIntToTwoDigitString(duration.inMinutes.remainder(60))}";
}

String convertIntToTwoDigitString(int number) {
  String result = number.toString();
  if (result.length == 1) result = '0' + result;
  result = result.substring(0, 2);
  return result;
}
