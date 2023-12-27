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
