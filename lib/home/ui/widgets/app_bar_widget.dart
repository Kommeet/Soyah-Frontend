import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext ctx;

  const AppBarWidget({super.key, required this.ctx});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black87),
        onPressed: () {
          Scaffold.of(context).openDrawer(); 
        },
      ),
      actions: [
        IconButton(
          icon: Image.asset('assets/images/user_ic.png', scale: 1.3),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}