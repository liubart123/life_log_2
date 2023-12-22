String convertDurationToPostgresString(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);
  final formattedDuration = '$hours:$minutes:$seconds';
  return formattedDuration;
}
