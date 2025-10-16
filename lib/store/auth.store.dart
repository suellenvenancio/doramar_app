import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/auth_service.dart';

class AuthStore with ChangeNotifier {
  final AuthService authService;

  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;

  AuthStore({required this.authService});

  Future<void> signIn({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();
    await authService.signIn(email: email, password: password);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    await authService.signOut();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createAccount(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    await authService.createAccount(email: email, password: password);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    await authService.resetPassword(email: email);
  }

  Future<void> updateUsername(String username) async {
    await authService.updateUsername(username: username);

    _currentUser = authService.currentUser;
    notifyListeners();
  }

  Future<void> deleteAccount(String email, String password) async {
    await authService.deleteAccount(email: email, password: password);
  }
}
