import 'package:flutter/material.dart';

import '../imports/components.dart';
import '../imports/models.dart';
import '../imports/services.dart';

class TheMovieDBProvider extends ChangeNotifier {
  ThemoviedbService apiService = ThemoviedbService();
  List<Movie> _movies = [];
  bool _isLoading = false;

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;

  Future<void> fetchPMovies(BuildContext context, String query, int page) async {
    if (query.isEmpty) {
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _movies = await apiService.fetchPMovies(query, page);
    } catch (e) {
      Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPopularMovies(BuildContext context, int page) async {
    _isLoading = true;
    notifyListeners();
    try {
      _movies = await apiService.fetchPopularMovies(page);
    } catch (e) {
      Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<MovieDetails> fetchMovieDetails(BuildContext context, int id) async {
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
      if (context.mounted) snackbar(context, e.toString());
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  Future<List<MovieProvider>> fetchWatchProviders(BuildContext context, int id) async {
    _isLoading = true;
    try {
      return await apiService.fetchWatchProviders(id);
    } catch (e) {
      if (context.mounted) snackbar(context, e.toString());
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  Future<List<Movie>> fetchDiscoverMovies(BuildContext context, int page) async {
    _isLoading = true;
    try {
      return await apiService.fetchDiscoverMovies(page);
    } catch (e) {
      if (context.mounted) snackbar(context, e.toString());
      rethrow;
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
