import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../http/http_client.dart' show HttpClient, IHttpClient;
import '../models/tvshow.model.dart';
import 'auth_service.dart';

abstract class ITvShowService {
  Future<List<TvShow>> fetchTvshows();
}

class TvShowService implements ITvShowService {
  final IHttpClient client;
  final AuthService authService;

  TvShowService({required this.client, required this.authService});

  final String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

  @override
  Future<List<TvShow>> fetchTvshows() async {
    final token = await authService.getFirebaseIdToken();

    final baseUrl = "$apiUrl/tvshows";
    final response = await client.get(
      url: baseUrl,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<TvShow> tvShows = [];

      final res = jsonDecode(response.body);
      res['data'].map((item) {
        final TvShow tvShow = TvShow.fromMap(item);
        tvShows.add(tvShow);
      }).toList();

      return tvShows;
    } else {
      throw Exception("Falha ao carregar TV Shows: ${response.statusCode}");
    }
  }
}
