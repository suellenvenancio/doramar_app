import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../http/http_client.dart';
import '../models/user.model.dart';
import 'auth_service.dart';

abstract class IUserService {
  Future<User> fetchUser(String email);
  Future<User> createUser(
    String name,
    String email,
    String username,
    String password,
  );
  Future<User> updateUsername(String userId, String username);
}

class UserService with ChangeNotifier implements IUserService {
  final IHttpClient client;
  final AuthService authService;

  UserService({required this.client, required this.authService});

  static const String apiUrl = String.fromEnvironment('API_URL');

  @override
  Future<User> fetchUser(String email) async {
    try {
      final token = await authService.getFirebaseIdToken();

      final baseUrl = "$apiUrl/users?email=$email";
      final response = await client.get(
        url: baseUrl,
        headers: {'Authorization': 'Bearer $token'},
      );

      final res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final user = User.fromMap(res['data']);
        return user;
      } else {
        throw res['message'] ?? 'Failed to load users';
      }
    } catch (e) {
      throw "Error fetching user: ${e.toString()}";
    }
  }

  @override
  Future<User> createUser(
    String name,
    String email,
    String username,
    String password,
  ) async {
    try {
      final baseUrl = "$apiUrl/users";
      final response = await client.post(
        url: baseUrl,
        body: {
          'name': name,
          'email': email,
          'username': username,
          'password': password,
        },
      );

      final res = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final user = User.fromMap(res['data']);
        return user;
      } else {
        throw res['message'] ?? 'Failed to create user';
      }
    } catch (e) {
      throw "Erro ao criar usuário:${e.toString()}";
    }
  }

  @override
  Future<User> updateUsername(String userId, String username) async {
    try {
      final token = await authService.getFirebaseIdToken();

      final baseUrl = "$apiUrl/users/$userId";
      final response = await client.patch(
        url: baseUrl,
        body: {'username': username},
        headers: {'Authorization': 'Bearer $token'},
      );

      final res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final user = User.fromMap(res['data']);
        return user;
      } else {
        throw res['message'] ?? 'Failed to update username';
      }
    } catch (e) {
      throw "Error updating username: ${e.toString()}";
    }
  }
}
