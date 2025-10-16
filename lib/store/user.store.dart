import 'package:flutter/widgets.dart';

import '../models/user.model.dart';
import '../service/auth_service.dart';
import '../service/user.service.dart';
import 'auth.store.dart';

class UserStore with ChangeNotifier {
  final IUserService service;
  final AuthService authService;

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  UserStore({required this.service, required this.authService});

  Future<void> fetchUserData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final email = authService.currentUser?.email;

      if (email == null) {
        throw Exception('User is not logged in.');
      }

      final fetchedUser = await service.fetchUser(email);
      _user = fetchedUser;
    } catch (e) {
      print(e.toString());
      _error = e.toString();
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createUser(
    String name,
    String email,
    String username,
    String password,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final createdUser = await service.createUser(
        name,
        email,
        username,
        password,
      );
      _user = createdUser;
    } catch (e) {
      print(e.toString());
      _error = e.toString();
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onUpdateAuth(AuthStore authStore) async {
    try {
      await fetchUserData();
    } catch (e) {
      print(e.toString());
    }
  }
}
