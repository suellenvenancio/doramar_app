import 'package:flutter/widgets.dart';

import '../models/genres.model.dart';
import '../service/genre.service.dart';
import 'auth.store.dart';

class GenreStore with ChangeNotifier {
  final IGenreService service;

  List<Genre> _genres = [];
  bool _isLoading = false;
  String? _error;

  List<Genre> get genres => _genres;
  bool get isLoading => _isLoading;
  String? get error => _error;

  GenreStore({required this.service});

  Future<void> getGenres() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedGenres = await service.fetchAllGenres();
      _genres = fetchedGenres;
    } catch (e) {
      print(e.toString());
      _error = e.toString();
      _genres = [];
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  Future onUpdateAuth(AuthStore authStore) async {
    try {
      final currentUser = authStore.currentUser;
      if (currentUser == null) {
        return await getGenres();
      }
      return _genres;
    } catch (e) {
      print(e.toString());
    }
  }
}
