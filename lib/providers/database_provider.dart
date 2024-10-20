import 'package:flutter/material.dart';

import '../imports/database.dart';
import '../imports/models.dart';

class DatabaseProvider extends ChangeNotifier {
  final List<int> _favoriteIds = [];

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

  Future<List<Movie>> getFavorites() async {
    final dbHelper = DatabaseHelper();
    final favorites = await dbHelper.getFavorites();
    _favoriteIds.clear();
    _favoriteIds.addAll(favorites.map((e) => e.id));
    return favorites;
  }

  bool isFavorite(int id) {
    return _favoriteIds.contains(id);
  }
}
