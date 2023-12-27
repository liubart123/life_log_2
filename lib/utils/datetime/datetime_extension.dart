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
