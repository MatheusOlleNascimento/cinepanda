import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../imports/models.dart';

class ThemoviedbService {
  final String apiUrl = dotenv.env['API_URL'] ?? 'URL não definida';
  final String apiKey = dotenv.env['API_KEY'] ?? 'Chave não definida';

  //TODO Criar função de get já com todos os parametros e headers necessários

  Future<List<Movie>> searchMovies(String query, int page) async {
    final response = await http.get(
      Uri.parse('$apiUrl/search/movie?query=$query&include_adult=false&language=pt-BR&page=$page'),
      headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> moviesJson = jsonDecode(response.body)['results'];
      return moviesJson.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed: Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<List<Movie>> fetchPopularMovies(int page) async {
    final response = await http.get(
      Uri.parse('$apiUrl/movie/popular?language=pt-BR&page=$page'),
      headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> moviesJson = jsonDecode(response.body)['results'];
      return moviesJson.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed: Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<MovieDetails> fetchMovieDetails(int id) async {
    final response = await http.get(
      Uri.parse('$apiUrl/movie/$id?language=pt-BR?include_adult=false'),
      headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return MovieDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed: Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<List<MovieProvider>> fetchWatchProviders(int id) async {
    final response = await http.get(
      Uri.parse('$apiUrl/movie/$id/watch/providers?include_adult=false'),
      headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> providersJson = jsonDecode(response.body)['results'];

      if (providersJson.containsKey('BR')) {
        final brProvidersJson = providersJson['BR'];

        final List<MovieProvider> providers = [];

        if (brProvidersJson['flatrate'] != null) {
          for (var provider in brProvidersJson['flatrate']) {
            providers.add(MovieProvider.fromJson(provider));
          }
        }
        return providers;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed: Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<List<Movie>> fetchDiscoverMovies(int page) async {
    final response = await http.get(
      Uri.parse('$apiUrl/discover/movie?include_adult=false&language=pt-BR&page=$page&sort_by=popularity.desc'),
      headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> moviesJson = jsonDecode(response.body)['results'];
      return moviesJson.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed: Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<String?> fetchYoutubeTrailer(int id) async {
    final response = await http.get(
      Uri.parse('$apiUrl/movie/$id/videos?include_adult=false?language=pt-BR'),
      headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> trailersJson = jsonDecode(response.body)['results'];
      if (trailersJson.isEmpty) {
        return null;
      }

      final List<String?> trailers = extractYoutubeTrailers(trailersJson);
      return trailers.last;
    } else {
      throw Exception('Failed: Error ${response.statusCode}: ${response.body}');
    }
  }
}
