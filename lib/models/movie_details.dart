import '../imports/models.dart';

class MovieDetails extends Movie {
  final String overview;
  final List<String> genreNames;
  final double voteAverage;
  final String releaseDate;
  final int runtime;
  final String? trailerKey;

  MovieDetails({
    required super.id,
    required super.title,
    required super.posterPath,
    required this.overview,
    required this.voteAverage,
    required this.genreNames,
    required this.releaseDate,
    required this.runtime,
    this.trailerKey,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    List<String> genreNames = (json['genres'] as List).map((genre) => genre['name'] as String).toList();

    return MovieDetails(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'],
      overview: json['overview'],
      voteAverage: json['vote_average'],
      releaseDate: json['release_date'],
      runtime: json['runtime'],
      genreNames: genreNames,
    );
  }
}
