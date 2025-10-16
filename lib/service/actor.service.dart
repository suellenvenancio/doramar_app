import 'dart:convert';

import '../http/http_client.dart';
import '../models/actors.model.dart';
import 'auth_service.dart';

abstract class IActorService {
  Future<List<Actor>> fetchAllActors();
}

class ActorService implements IActorService {
  final IHttpClient client;
  final AuthService authService;

  ActorService({required this.client, required this.authService});

  @override
  Future<List<Actor>> fetchAllActors() async {
    final token = await authService.getFirebaseIdToken();

    final baseUrl = "http://localhost:3000/actors";
    final response = await client.get(
      url: baseUrl,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<Actor> actors = [];

      final res = jsonDecode(response.body);

      res['data'].map((item) {
        final Actor actor = Actor.fromMap(item);
        actors.add(actor);
      }).toList();

      return actors;
    } else {
      throw Exception("Falha ao carregar atores: ${response.statusCode}");
    }
  }
}
