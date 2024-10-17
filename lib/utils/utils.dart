String formatRuntime(int runtime) {
  final hours = runtime ~/ 60;
  final minutes = runtime % 60;

  if (hours > 0) {
    return '${hours}h ${minutes}min';
  } else {
    return '${minutes}min';
  }
}
