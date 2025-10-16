import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/loading_page.dart';
import 'pages/login_page.dart';
import 'service/auth_service.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, this.pageIfnotConnected});
  final Widget? pageIfnotConnected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            if (snapshot.connectionState == ConnectionState.waiting) {
              widget = LoadingPage();
            } else if (snapshot.hasData) {
              widget = MenuPage();
            } else {
              widget = pageIfnotConnected ?? const LoginPage();
            }
            return widget;
          },
        );
      },
    );
  }
}
