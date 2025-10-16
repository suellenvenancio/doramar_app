import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../models/tvshow.model.dart';
import '../service/tvshow_service.dart';
import 'auth.store.dart';

class TvShowStore extends ChangeNotifier {
  final ITvShowService service;

  bool _isLoading = false;
  List<TvShow> _tvShows = [];
  String? _error;

  bool get isLoading => _isLoading;
  List<TvShow> get tvShows => _tvShows;
  String? get error => _error;

  TvShowStore({required this.service});

  Future getTvShows() async {
    _error = null;
    _isLoading = true;
    notifyListeners();

    try {
      final tvshows = await service.fetchTvshows();
      _tvShows = tvshows;
      _error = null;
    } catch (e) {
      print(e.toString());
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onUpdateAuth(AuthStore authStore) async {
    try {
      final currentUser = authStore.currentUser;
      if (currentUser == null) {
        await getTvShows();
        notifyListeners();
        return;
      }
      await getTvShows();
    } catch (e) {
      print(e.toString());
    }
  }
}
