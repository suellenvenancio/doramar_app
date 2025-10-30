import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
}

class UserService with ChangeNotifier implements IUserService {
  final IHttpClient client;
  final AuthService authService;

  UserService({required this.client, required this.authService});

  final String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

  @override
  Future<User> fetchUser(String email) async {
    final token = await authService.getFirebaseIdToken();

    final baseUrl = "$apiUrl/users?email=$email";
    final response = await client.get(
      url: baseUrl,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body)['data'];

      final user = User.fromMap(res);
      return user;
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Future<User> createUser(
    String name,
    String email,
    String username,
    String password,
  ) async {
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

    if (response.statusCode == 201 || response.statusCode == 200) {
      final res = jsonDecode(response.body)['data'];

      final user = User.fromMap(res);
      return user;
    } else {
      throw Exception('Failed to create user');
    }
  }
}
