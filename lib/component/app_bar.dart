import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? username;
  final TabBar? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.username,
    this.bottom,
  });

  final String title;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        username != null ? "@$username" : title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true, // Centralizar o título é uma boa prática de UI.
      backgroundColor: const Color.fromRGBO(233, 30, 99, 1),
      bottom: bottom,
    );
  }
}
