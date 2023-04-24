import 'package:flutter/material.dart';
import 'package:t_instagram_clone_6h/models/user.dart';
import 'package:t_instagram_clone_6h/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethdods _authMethdods = AuthMethdods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethdods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
