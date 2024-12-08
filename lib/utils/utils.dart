import 'dart:convert';
import 'dart:io';

import '../imports/models.dart';

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

String favoriteShareMessage(String compactString) {
  return '''
🐼 *CinePanda - Meus Filmes Favoritos*

Para importar no CinePanda, copie este link e cole no app:

https://cinepanda.app/import?data=$compactString

''';
}

String compactFavorites(List<Movie> movies) {
  final minimalList = movies.map((movie) => [movie.id, movie.title, movie.posterPath]).toList();
  final jsonString = jsonEncode(minimalList);

  final compressed = zlib.encode(utf8.encode(jsonString));

  return base64UrlEncode(compressed);
}

String extractCompactString(String message) {
  final regex = RegExp(r'data=([^\s]+)');
  final match = regex.firstMatch(message);

  if (match != null && match.groupCount > 0) {
    return match.group(1)!;
  } else {
    throw const FormatException('Link não encontrado na mensagem');
  }
}

List<Movie> decompressFavorites(String compactString) {
  final decompressed = zlib.decode(base64Url.decode(compactString));
  final jsonList = jsonDecode(utf8.decode(decompressed));

  return (jsonList as List).map((item) => Movie(id: item[0], title: item[1], posterPath: item[2])).toList();
}
