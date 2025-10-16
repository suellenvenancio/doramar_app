import 'package:flutter/material.dart';

import '../pages/change_password_page.dart';
import '../pages/change_username_page.dart';
import '../pages/login_page.dart';
import '../service/auth_service.dart';

class AppBarDrawer extends StatelessWidget {
  final AuthService authService;
  const AppBarDrawer({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.pink),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.settings, size: 50, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  'Opções do Menu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.password),
            title: Text(
              'Alterar senha',
              style: TextStyle(color: Colors.black87, fontSize: 16),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ResetPasswordFromCurrentPasswordPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(
              'Alterar username',
              style: TextStyle(color: Colors.black87, fontSize: 16),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangeUsernamePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(
              'Sair',
              style: TextStyle(color: Colors.black87, fontSize: 16),
            ),
            onTap: () {
              authService.signOut();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
