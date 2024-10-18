import 'package:flutter/material.dart';

import '../imports/models.dart';
import '../imports/services.dart';

class TheMovieDBProvider extends ChangeNotifier {
  ThemoviedbService apiService = ThemoviedbService();
  List<Movie> _movies = [];
  List<Movie> _trendingMovies = [];

  bool _isLoading = false;

  List<Movie> get movies => _movies;
  List<Movie> get trendingMovies => _trendingMovies;

  bool get isLoading => _isLoading;

  Future<void> searchMovies(String query, int page) async {
    if (query.isEmpty) {
      return fetchMovies(page);
    }
    _isLoading = true;
    notifyListeners();
    try {
      _movies = await apiService.searchMovies(query, page);
    } catch (e) {
      throw Exception('Failed: Error $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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

  Future<void> fetchDiscoverMovies(int page) async {
    _isLoading = true;
    try {
      _trendingMovies = await apiService.fetchDiscoverMovies(page);
    } catch (e) {
      throw Exception('Failed: Error $e');
    } finally {
      _isLoading = false;
    }
  }

  String getImageUrl(String path) {
    return 'https://image.tmdb.org/t/p/w500$path';
  }

  String getProviderLogoUrl(String path) {
    return 'https://image.tmdb.org/t/p/w200$path';
  }
}
