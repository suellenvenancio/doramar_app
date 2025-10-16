import 'package:flutter/widgets.dart';

import '../models/actors.model.dart';
import '../service/actor.service.dart';

class ActorStore with ChangeNotifier {
  final IActorService service;
  List<Actor> _actors = [];
  bool _isLoading = false;
  String? _error;

  List<Actor> get actors => _actors;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ActorStore({required this.service});

  Future getActors() async {
    _error = null;
    _isLoading = true;

    try {
      final fetchedActors = await service.fetchAllActors();
      _actors = fetchedActors;
      notifyListeners();
      return actors;
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
