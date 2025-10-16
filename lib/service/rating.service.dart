import 'dart:convert';

import '../http/http_client.dart';
import '../models/rating.model.dart';
import '../models/rating_scale.model.dart';
import 'auth_service.dart';

abstract class IRatingService {
  Future<List<RatingScale>> fetchRatingScale();
  Future<List<Rating>> fetchRatingsByUserId(String userId);
  Future<Rating> createRating(String tvShowId, String userId, int scaleId);
}

class RatingService implements IRatingService {
  final IHttpClient client;
  final AuthService authService;

  RatingService({required this.client, required this.authService});

  @override
  Future<List<RatingScale>> fetchRatingScale() async {
    final token = await authService.getFirebaseIdToken();

    final baseUrl = "http://localhost:3000/ratings/scale";
    final response = await client.get(
      url: baseUrl,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<RatingScale> ratingScales = [];

      final res = jsonDecode(response.body);

      res['data'].map((item) {
        final RatingScale ratingScale = RatingScale.fromMap(item);
        ratingScales.add(ratingScale);
      }).toList();

      return ratingScales;
    } else {
      throw Exception(
        "Falha ao carregar Rating Scales: ${response.statusCode}",
      );
    }
  }

  @override
  Future<List<Rating>> fetchRatingsByUserId(String userId) async {
    final token = await authService.getFirebaseIdToken();

    final baseUrl = "http://localhost:3000/ratings/user/$userId";
    final response = await client.get(
      url: baseUrl,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<Rating> ratings = [];
      final res = jsonDecode(response.body);
      res['data'].map((item) {
        final Rating rating = Rating.fromMap(item);
        ratings.add(rating);
        return rating;
      }).toList();

      return ratings;
    } else {
      throw Exception("Falha ao carregar Ratings: ${response.statusCode}");
    }
  }

  @override
  Future<Rating> createRating(
    String tvShowId,
    String userId,
    int scaleId,
  ) async {
    final token = await authService.getFirebaseIdToken();

    final baseUrl =
        "http://localhost:3000/ratings/$scaleId/user/$userId/tvshow/$tvShowId/";
    final response = await client.post(
      url: baseUrl,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 201) {
      return Rating.fromMap(jsonDecode(response.body));
    } else {
      throw Exception("Falha ao criar Rating: ${response.statusCode}");
    }
  }
}
