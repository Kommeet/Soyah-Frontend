import 'package:flutter/material.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlobalAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black87),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      title: Image.asset(
        'assets/images/app_bar_header.png',
        height: 30,
      ),
      centerTitle: true,
      actions: [
        // To balance the leading icon and keep title perfectly centered
        Opacity(
          opacity: 0,
          child: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
