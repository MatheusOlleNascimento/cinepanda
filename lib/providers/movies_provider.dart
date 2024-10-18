import 'package:cine_panda/database/database_helper.dart';
import 'package:flutter/material.dart';

import '../imports/models.dart';
import '../imports/services.dart';

class MoviesProvider extends ChangeNotifier {
  ApiService apiService = ApiService();
  List<Movie> _movies = [];
  List<Movie> _trendingMovies = [];
  final List<int> _favoriteIds = [];

  bool _isLoading = false;

  List<Movie> get movies => _movies;
  List<Movie> get trendingMovies => _trendingMovies;

  bool get isLoading => _isLoading;

  //TODO Renomear para api provider

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
      var movieDetails = await apiService.fetchMovieDetails(id);
      var trailerKey = await apiService.fetchYoutubeTrailer(id);

      return MovieDetails(
        id: movieDetails.id,
        title: movieDetails.title,
        posterPath: movieDetails.posterPath,
        overview: movieDetails.overview,
        voteAverage: movieDetails.voteAverage,
        genreNames: movieDetails.genreNames,
        releaseDate: movieDetails.releaseDate,
        runtime: movieDetails.runtime,
        trailerKey: trailerKey,
      );
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

  Future<List<Movie>> searchMovies(String query) async {
    _isLoading = true;
    try {
      return await apiService.searchMovies(query);
    } catch (e) {
      throw Exception('Failed: Error $e');
    } finally {
      _isLoading = false;
    }
  }

  Future<void> fetchTrendingMovies(int page) async {
    _isLoading = true;
    try {
      _trendingMovies = await apiService.fetchTrendingMovies(page);
    } catch (e) {
      throw Exception('Failed: Error $e');
    } finally {
      _isLoading = false;
    }
  }

  //TODO Criar um database provider

  Future<void> addFavorite(Movie movie) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.addFavorite(movie);
    _favoriteIds.add(movie.id);
    notifyListeners();
  }

  Future<void> removeFavorite(int id) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.removeFavorite(id);
    _favoriteIds.remove(id);
    notifyListeners();
  }

  Future<bool> checkFavorite(int id) async {
    final dbHelper = DatabaseHelper();
    if (await dbHelper.isFavorite(id)) {
      _favoriteIds.add(id);
      return true;
    } else {
      _favoriteIds.remove(id);
      return false;
    }
  }

  bool isFavorite(int id) {
    return _favoriteIds.contains(id);
  }

  String getImageUrl(String path) {
    return 'https://image.tmdb.org/t/p/w500$path';
  }

  String getProviderLogoUrl(String path) {
    return 'https://image.tmdb.org/t/p/w200$path';
  }
}
