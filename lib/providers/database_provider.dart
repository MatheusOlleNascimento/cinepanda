import 'package:flutter/material.dart';

import '../imports/database.dart';
import '../imports/models.dart';

class DatabaseProvider extends ChangeNotifier {
  Future<List<Movie>> getFavorites() async {
    final dbHelper = DatabaseHelper();
    return await dbHelper.getFavorites();
  }

  Future<void> addFavorite(Movie movie) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.addFavorite(movie);
    notifyListeners();
  }

  Future<void> addFavorites(List<Movie> movies) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.addFavorites(movies);
    notifyListeners();
  }

  Future<void> removeFavorite(int id) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.removeFavorite(id);
    notifyListeners();
  }

  Future<bool> checkFavorite(int id) async {
    final dbHelper = DatabaseHelper();
    return await dbHelper.isFavorite(id);
  }
}
