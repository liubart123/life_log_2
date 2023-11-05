// ignore_for_file: file_names

class DayLog {
  int? id;
  DateTime date;
  DateTime? sleepStartTime;
  DateTime? sleepEndTime;
  Duration? sleepDuration;
  Duration? deepSleepDuration;
  String? notes;
  List<String> tags;
  DayLog({
    this.id,
    required this.date,
    required this.sleepStartTime,
    required this.sleepEndTime,
    required this.sleepDuration,
    required this.deepSleepDuration,
    required this.notes,
    required this.tags,
  });
}
