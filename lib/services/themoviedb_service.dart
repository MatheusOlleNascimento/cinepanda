import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../imports/models.dart';

class ThemoviedbService {
  final String apiUrl = dotenv.env['API_URL'] ?? 'URL não definida';
  final String apiKey = dotenv.env['API_KEY'] ?? 'Chave não definida';

  Future<http.Response> _httpGet(String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
    );

    return response;
  }

  Future<List<Movie>> fetchPMovies(String query, int page) async {
    final response = await _httpGet('$apiUrl/search/movie?query=$query&include_adult=false&language=pt-BR&page=$page');

    if (response.statusCode == 200) {
      final List<dynamic> moviesJson = jsonDecode(response.body)['results'];
      if (moviesJson.isEmpty) return [];
      return moviesJson.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Não foi possível buscar os filmes');
    }
  }

  Future<List<Movie>> fetchPopularMovies(int page) async {
    final response = await _httpGet('$apiUrl/movie/popular?language=pt-BR&page=$page');

    if (response.statusCode == 200) {
      final List<dynamic> moviesJson = jsonDecode(response.body)['results'];
      return moviesJson.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Não foi possível buscar os filmes mais populares');
    }
  }

  Future<MovieDetails> fetchMovieDetails(int id) async {
    final response = await _httpGet('$apiUrl/movie/$id?language=pt-BR?include_adult=false');

    if (response.statusCode == 200) {
      return MovieDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Não foi possível buscar os detalhes do filme');
    }
  }

  Future<List<MovieProvider>> fetchWatchProviders(int id) async {
    final response = await _httpGet('$apiUrl/movie/$id/watch/providers?include_adult=false');

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
      throw Exception('Não foi possível buscar os provedores de streaming');
    }
  }

  Future<List<Movie>> fetchDiscoverMovies(int page) async {
    final response = await _httpGet('$apiUrl/discover/movie?include_adult=false&language=pt-BR&page=$page&sort_by=popularity.desc');

    if (response.statusCode == 200) {
      final List<dynamic> moviesJson = jsonDecode(response.body)['results'];
      return moviesJson.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Não foi possível buscar um filme para você');
    }
  }

  Future<String?> fetchYoutubeTrailer(int id) async {
    final response = await _httpGet('$apiUrl/movie/$id/videos?include_adult=false?language=pt-BR');

    if (response.statusCode == 200) {
      final List<dynamic> trailersJson = jsonDecode(response.body)['results'];
      if (trailersJson.isEmpty) {
        return null;
      }

      final List<String?> trailers = extractYoutubeTrailers(trailersJson);
      return trailers.last;
    } else {
      throw Exception('Não foi possível buscar o trailer do filme');
    }
  }
}
