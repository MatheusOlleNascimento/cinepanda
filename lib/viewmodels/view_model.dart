import 'package:flutter/material.dart';
import 'package:onde_assistir/models/movie.dart';
import '../services/api_service.dart';

class ViewModel extends ChangeNotifier {
  ApiService apiService = ApiService();
  List<Movie> _movies = [];
  bool _isLoading = false;

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;

  Future<void> fetchMovies(int page) async {
    _isLoading = true;
    notifyListeners();
    try {
      _movies = await apiService.fetchPopularMovies(page);
    } catch (e) {
      throw Exception('Failed: Error $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Movie> fetchMovieDetails(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      return await apiService.fetchMovieDetails(id);
    } catch (e) {
      throw Exception('Failed: Error $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  getImageUrl(String path) {
    return 'https://image.tmdb.org/t/p/w500$path';
  }
}
