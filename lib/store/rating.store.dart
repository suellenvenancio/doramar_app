import 'package:flutter/widgets.dart';
import 'package:test/models/user.model.dart';

import '../models/rating.model.dart';
import '../models/rating_scale.model.dart';
import '../service/rating.service.dart';
import 'user.store.dart';

class RatingStore with ChangeNotifier {
  final IRatingService service;
  final UserStore userStore;

  List<RatingScale> _ratingScales = [];
  List<Rating> _ratings = [];

  List<RatingScale> get ratingScales => _ratingScales;
  List<Rating> get ratings => _ratings;
  bool _isLoading = false;
  String? _error;
  String? _addToTheListError;

  RatingStore({required this.service, required this.userStore});

  Future getRatingScales() async {
    _error = null;
    _isLoading = true;
    notifyListeners();
    try {
      final allRatingScales = await service.fetchRatingScale();
      _ratingScales = allRatingScales;
      notifyListeners();
      return _ratingScales;
    } catch (e) {
      print(e.toString());
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future createRating(String tvShowId, int scaleId) async {
    _error = null;
    _isLoading = true;
    notifyListeners();

    final user = userStore.user;
    try {
      if (user == null) return null;
      final createdRating = await service.createRating(
        tvShowId,
        user.id,
        scaleId,
      );
      _ratings.add(createdRating);
      return createdRating;
    } catch (e) {
      print(e.toString());
      _addToTheListError = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Rating>> getRatingsByUserId() async {
    _isLoading = true;
    notifyListeners();
    final user = userStore.user;
    final userId = user?.id;

    try {
      if (userId == null) return [];
      final ratings = await service.fetchRatingsByUserId(userId);
      _ratings = ratings;

      notifyListeners();
      return ratings;
    } catch (e) {
      print(e.toString());
      _error = e.toString();
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future onUpdateUser(UserStore newUserStore) async {
    try {
      if (newUserStore.user == null) return [];

      final ratings = await service.fetchRatingsByUserId(newUserStore.user!.id);
      _ratings = ratings;
      notifyListeners();
      return ratings;
    } catch (e) {
      print(e.toString());
      _error = e.toString();
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
