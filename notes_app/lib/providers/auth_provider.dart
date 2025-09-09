import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _username;
  bool get isAuthenticated => _username != null;

  // Pour le projet: authentification locale simple (ex: user/demo123)
  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 300)); // simulate
    if (username == 'user' && password == 'demo123') {
      _username = username;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _username = null;
    notifyListeners();
  }
}
