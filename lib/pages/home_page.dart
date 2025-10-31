import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../component/app_bar.dart';
import '../component/drawer.dart';
import '../models/tvshow.model.dart';
import '../service/auth_service.dart';
import '../store/user.store.dart';
import 'lists_page.dart';
import '../component/tv_shows.dart';
import 'review_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuStateApp();
  }
}

class MenuStateApp extends StatefulWidget {
  const MenuStateApp({super.key});

  @override
  State<MenuStateApp> createState() => MenuState();
}

class MenuState extends State<MenuStateApp> with TickerProviderStateMixin {
  late final TabController tabController;
  List<TvShow> tvShows = [];
  late bool showListDetails = false;
  String listId = '';

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserStore>(context).user;

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 174, 201, 1),
      appBar: CustomAppBar(
        title: "@${user?.username}",
        username: user?.username,
        bottom: TabBar(
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          unselectedLabelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.white70,
          ),
          controller: tabController,
          tabs: const <Widget>[
            Tab(text: 'SÉRIES'),
            Tab(text: 'LISTAS'),
            Tab(text: 'REVIEWS'),
          ],
        ),
      ),
      drawer: AppBarDrawer(authService: AuthService()),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          TvShowList(),
          ListPage(showListDetails: showListDetails, listId: listId),
          ReviewPage(),
        ],
      ),
    );
  }
}
