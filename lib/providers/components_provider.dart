import 'package:flutter/material.dart';

class ComponentsProvider extends ChangeNotifier {
  int _currentIndex = 1;
  int _selectedMovieId = 0;

  int get currentIndex => _currentIndex;
  int get selectedMovieId => _selectedMovieId;

  void changeIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void changeSelectedMovieId(int id) {
    _selectedMovieId = id;
    notifyListeners();
  }
}
