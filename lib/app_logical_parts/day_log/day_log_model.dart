// ignore_for_file: public_member_api_docs

/// Model for storing fields of DayLog
class DayLog {
  DayLog({
    required this.date,
    required this.sleepStartTime,
    required this.sleepEndTime,
    required this.sleepDuration,
    required this.deepSleepDuration,
    required this.notes,
    required this.tags,
    this.id,
  });

  int? id;
  DateTime date;
  DateTime? sleepStartTime;
  DateTime? sleepEndTime;
  Duration? sleepDuration;
  Duration? deepSleepDuration;
  String? notes;
  List<String> tags;
}
