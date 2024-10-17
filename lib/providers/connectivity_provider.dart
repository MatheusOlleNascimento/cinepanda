import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isOnline = true;

  bool get isOnline => _isOnline;

  ConnectivityProvider() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      _checkConnectivity(result);
    });
  }

  Future<void> _checkConnectivity(List<ConnectivityResult> result) async {
    if (result.contains(ConnectivityResult.none)) {
      _isOnline = false;
    } else {
      _isOnline = true;
    }
    notifyListeners();
  }
}
