import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'pages/home_page.dart';
import 'pages/loading_page.dart';
import 'pages/login_page.dart';
import 'service/auth_service.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('AuthLayout carregado');
    }

    return Scaffold(body: Center(child: Text('App carregado!')));
  }
}
