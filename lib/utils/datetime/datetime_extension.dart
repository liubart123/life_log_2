import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DurationExtension on DateTime {
  String toTimeString() {
    const String format = 'HH:mm';
    final formatter = DateFormat(format);
    return formatter.format(this);
  }

  String toDateString() {
    const String format = 'dd MMM';
    final formatter = DateFormat(format);
    return formatter.format(this);
  }
}

DateTime convertStringToDateTime(String inputString, {String format = 'HH:mm'}) {
  final formatter = DateFormat(format);
  return formatter.parse(inputString);
}

DateTime combinationOfDateAndTime(DateTime date, TimeOfDay time) {
  final result = DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
  return result;
}
