extension DurationExtension on Duration {
  String toFormattedString({bool withSeconds = false}) {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    String formattedDuration = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    if (withSeconds) {
      formattedDuration += ':${seconds.toString().padLeft(2, '0')}';
    }
    return formattedDuration;
  }

  String toOnlyMinutesString() {
    return '${inMinutes}m';
  }
}

Duration convertStringToDuration(String inputString) {
  final List<String> timeParts = inputString.split(':');

  return Duration(
    hours: int.parse(timeParts[0]),
    minutes: int.parse(timeParts[1]),
    seconds: timeParts.length >= 3 ? int.parse(timeParts[2]) : 0,
  );
}
