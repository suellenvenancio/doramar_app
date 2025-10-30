import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../http/http_client.dart';
import '../models/list.model.dart';
import 'auth_service.dart';

abstract class IListService {
  Future<List<ListModel>> fetchListsByUserId(String userId);
  Future<ListModel> updateList(
    final String tvShowId,
    final String listId,
    final int order,
    final String userId,
  );
  Future<ListModel> addToTheList(String listId, String tvShowId, String userId);
  Future<ListModel> createList(String userId, String name);
}

class ListService implements IListService {
  final IHttpClient client;
  final AuthService authService;

  ListService({required this.client, required this.authService});

  final String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

  @override
  Future<List<ListModel>> fetchListsByUserId(String userId) async {
    final token = await authService.getFirebaseIdToken();

    final baseUrl = "$apiUrl/lists/user/$userId";
    final response = await client.get(
      url: baseUrl,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<ListModel> lists = [];

      final res = jsonDecode(response.body);

      res['data'].map((item) {
        final ListModel list = ListModel.fromMap(item);
        lists.add(list);
      }).toList();

      return lists;
    } else {
      throw Exception("Falha ao carregar listas: ${response.statusCode}");
    }
  }

  @override
  Future<ListModel> updateList(
    final String tvShowId,
    final String listId,
    final int order,
    final String userId,
  ) async {
    final baseUrl = "$apiUrl/lists/$listId";
    final response = await client.patch(
      url: baseUrl,
      body: {"tvShowId": tvShowId, "order": order, "userId": userId},
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body)['data'];
      final updatedList = ListModel.fromMap(res);

      return updatedList;
    } else {
      throw Exception("Falha ao atualizar lista: ${response.statusCode}");
    }
  }

  @override
  Future<ListModel> addToTheList(
    String listId,
    String tvShowId,
    String userId,
  ) async {
    final token = await authService.getFirebaseIdToken();

    final baseUrl = "$apiUrl/lists/$listId/tvshow/$tvShowId";
    final response = await client.post(
      url: baseUrl,

      body: {"userId": userId},
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body)['data'];
      final updatedList = ListModel.fromMap(res);

      return updatedList;
    } else {
      throw Exception("Falha ao adicionar à lista: ${response.statusCode}");
    }
  }

  @override
  Future<ListModel> createList(String userId, String name) async {
    final token = await authService.getFirebaseIdToken();
    final String baseUrl = "$apiUrl/lists";

    final response = await client.post(
      url: baseUrl,
      body: {"userId": userId, "name": name},
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      if (responseBody != null && responseBody['data'] != null) {
        final newList = ListModel.fromMap(responseBody['data']);
        return newList;
      } else {
        throw Exception("Resposta da API em formato inesperado.");
      }
    } else {
      final errorBody = jsonDecode(response.body);
      throw Exception(
        "Falha ao criar lista: ${errorBody['message'] ?? response.body}",
      );
    }
  }
}
