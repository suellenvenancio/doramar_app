import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'auth_layout.dart';
import 'firebase_options.dart';
import 'http/http_client.dart';
import 'service/auth_service.dart';
import 'service/genre.service.dart';
import 'service/list.service.dart';
import 'service/rating.service.dart';
import 'service/tvshow_service.dart';
import 'service/user.service.dart';
import 'store/auth.store.dart';
import 'store/genre.store.dart';
import 'store/list.store.dart';
import 'store/rating.store.dart';
import 'store/tvshow_store.dart';
import 'store/user.store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final httpClient = HttpClient();
    final authService = AuthService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthStore(authService: authService),
        ),

        ChangeNotifierProxyProvider<AuthStore, UserStore>(
          create: (_) => UserStore(
            service: UserService(client: httpClient, authService: authService),
            authService: authService,
          ),
          update: (context, authStore, userStore) {
            userStore!.onUpdateAuth(authStore);
            return userStore;
          },
        ),

        ChangeNotifierProxyProvider<UserStore, ListStore>(
          create: (context) => ListStore(
            service: ListService(client: httpClient, authService: authService),
            userStore: context.read<UserStore>(),
          ),
          update: (context, userStore, listStore) {
            listStore!.getListsOnUpdateUser(userStore);
            return listStore;
          },
        ),

        ChangeNotifierProxyProvider<UserStore, RatingStore>(
          create: (context) => RatingStore(
            service: RatingService(
              client: httpClient,
              authService: authService,
            ),
            userStore: context.read<UserStore>(),
          ),
          update: (context, userStore, ratingStore) {
            ratingStore!.onUpdateUser(userStore);
            return ratingStore;
          },
        ),

        ChangeNotifierProxyProvider<AuthStore, GenreStore>(
          create: (_) => GenreStore(
            service: GenreService(client: httpClient, authService: authService),
          ),
          update: (context, authStore, genreStore) {
            genreStore!.onUpdateAuth(authStore);
            return genreStore;
          },
        ),

        ChangeNotifierProxyProvider<AuthStore, TvShowStore>(
          create: (_) => TvShowStore(
            service: TvShowService(
              client: httpClient,
              authService: authService,
            ),
          ),
          update: (context, userStore, tvShowStore) {
            tvShowStore!.onUpdateAuth(userStore);
            return tvShowStore;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Meu App de Doramas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.pink),
        initialRoute: '/',
        routes: {'/': (context) => const AuthLayout()},
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (context) => const AuthLayout());
        },
      ),
    );
  }
}
