String formatRuntime(int runtime) {
  if (runtime == 0) {
    return 'Sem duração';
  }

  final hours = runtime ~/ 60;
  final minutes = runtime % 60;

  if (hours > 0) {
    return '${hours}h ${minutes}min';
  } else {
    return '${minutes}min';
  }
}
