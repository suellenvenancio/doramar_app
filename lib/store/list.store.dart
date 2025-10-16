import 'package:flutter/widgets.dart';

import '../models/list.model.dart';
import '../models/list_order.params.dart';
import '../service/auth_service.dart';
import '../service/list.service.dart';
import 'user.store.dart';

class ListStore with ChangeNotifier {
  final IListService service;
  final UserStore userStore;

  late ListOrder listOrder;
  AuthService authService = AuthService();

  List<ListModel> _lists = [];
  bool _isLoading = false;
  String? _error;
  String? _addToTheListError;
  bool _createListIsLoading = false;

  List<ListModel> get lists => _lists;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get addToTheListError => _addToTheListError;
  bool get createListIsLoading => _createListIsLoading;
  ListStore({required this.service, required this.userStore});

  Future getLists() async {
    _error = null;
    _isLoading = true;
    final userFetched = await userStore.user;
    notifyListeners();
    try {
      if (userFetched == null) return [];

      final fetchedLists = await service.fetchListsByUserId(userFetched.id);
      _lists = fetchedLists;
      notifyListeners();
      return lists;
    } catch (e) {
      print(e.toString());
      _error = e.toString();
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future updateList(
    final String tvShowId,
    final String listId,
    final int order,
  ) async {
    _error = null;
    _isLoading = true;
    notifyListeners();

    final userId = userStore.user?.id;
    try {
      if (userId == null) return null;

      return await service.updateList(tvShowId, listId, order, userId);
    } catch (e) {
      print(e.toString());
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future addToTheList(String listId, String tvShowId) async {
    _addToTheListError = null;
    _isLoading = true;
    notifyListeners();
    final userId = userStore.user?.id;
    try {
      if (userId == null) return null;

      final updatedList = await service.addToTheList(listId, tvShowId, userId);
      final listIndex = lists.indexWhere((list) => list.id == listId);
      if (listIndex != -1) {
        lists[listIndex] = updatedList;
      }
      ;
      notifyListeners();

      return updatedList;
    } catch (e) {
      print(e.toString());
      _addToTheListError = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future createList(String name) async {
    _error = null;
    _createListIsLoading = true;
    notifyListeners();
    try {
      final userFetched = userStore.user;
      final userId = userFetched?.id;
      if (userId == null) return null;

      final newList = await service.createList(userId, name);
      lists.add(newList);
      notifyListeners();
      return newList;
    } catch (e) {
      print(e.toString());
      _error = e.toString();
      return null;
    } finally {
      _createListIsLoading = false;
      notifyListeners();
    }
  }

  Future getListsOnUpdateUser(UserStore newUserStore) async {
    _error = null;
    _isLoading = true;
    notifyListeners();

    try {
      final userFetched = newUserStore.user;

      if (userFetched == null) return lists;

      final fetchedLists = await service.fetchListsByUserId(userFetched.id);
      _lists = fetchedLists;
      notifyListeners();

      return lists;
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
