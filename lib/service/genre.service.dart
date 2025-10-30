import 'dart:convert';

import '../http/http_client.dart';
import '../models/genres.model.dart';
import 'auth_service.dart';

abstract class IGenreService {
  Future<List<Genre>> fetchAllGenres();
}

class GenreService implements IGenreService {
  final IHttpClient client;
  final AuthService authService;

  GenreService({required this.client, required this.authService});

  static const String apiUrl = String.fromEnvironment('API_URL');

  @override
  Future<List<Genre>> fetchAllGenres() async {
    final token = await authService.getFirebaseIdToken();

    final baseUrl = "$apiUrl/genres";
    final response = await client.get(
      url: baseUrl,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<Genre> genres = [];

      final res = jsonDecode(response.body);

      res['data'].map((item) {
        final Genre genre = Genre.fromMap(item);
        genres.add(genre);
      }).toList();

      return genres;
    } else {
      throw Exception("Falha ao carregar gêneros: ${response.statusCode}");
    }
  }
}
