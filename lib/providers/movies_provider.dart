import 'package:flutter/material.dart';

import '../imports/models.dart';
import '../imports/services.dart';

class MoviesProvider extends ChangeNotifier {
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

  Future<MovieDetails> fetchMovieDetails(int id) async {
    _isLoading = true;
    try {
      return await apiService.fetchMovieDetails(id);
    } catch (e) {
      throw Exception('Failed: Error $e');
    } finally {
      _isLoading = false;
    }
  }

  Future<List<MovieProvider>> fetchWatchProviders(int id) async {
    _isLoading = true;
    try {
      return await apiService.fetchWatchProviders(id);
    } catch (e) {
      throw Exception('Failed: Error $e');
    } finally {
      _isLoading = false;
    }
  }

  getImageUrl(String path) {
    return 'https://image.tmdb.org/t/p/w500$path';
  }

  getProviderLogoUrl(String path) {
    return 'https://image.tmdb.org/t/p/w200$path';
  }
}
