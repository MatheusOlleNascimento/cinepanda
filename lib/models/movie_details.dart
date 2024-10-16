import '../imports/models.dart';

class MovieDetails extends Movie {
  final String overview;

  MovieDetails({
    required super.id,
    required super.title,
    required super.posterPath,
    required this.overview,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'],
      overview: json['overview'],
    );
  }
}
