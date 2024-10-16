import 'package:cine_panda/models/movie_details.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cine_panda/models/movie.dart';

class ApiService {
  final String apiUrl = dotenv.env['API_URL'] ?? 'URL não definida';
  final String apiKey = dotenv.env['API_KEY'] ?? 'Chave não definida';

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
      Uri.parse('$apiUrl/movie/$id?language=pt-BR'),
      headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return MovieDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed: Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$apiUrl/search/movie?language=pt-BR?query=$query'),
      headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> moviesJson = jsonDecode(response.body)['results'];
      return moviesJson.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed: Error ${response.statusCode}: ${response.body}');
    }
  }
}
