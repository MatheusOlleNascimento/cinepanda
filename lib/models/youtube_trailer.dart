class YoutubeTrailer {
  final String key;

  YoutubeTrailer({required this.key});

  factory YoutubeTrailer.fromJson(Map<String, dynamic> json) {
    return YoutubeTrailer(key: json['key']);
  }
}

List<String> extractYoutubeTrailers(List<dynamic> jsonList) {
  return jsonList.where((trailer) => trailer['site'] == 'YouTube').map((trailer) => trailer['key'] as String).toList();
}
