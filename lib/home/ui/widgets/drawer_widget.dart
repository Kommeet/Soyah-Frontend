import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFFFF715B),
        child: Column(
          children: [
     
            Container(
              height: 80, 
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFFFF715B)),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/ic_drawe_star.png',
                      width: 30, 
                      height: 22,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(context, 'assets/images/menu_ic_place.png', 'Places', () {
                    Navigator.pop(context); 
                    
                  }),
                  _buildDrawerItem(context, 'assets/images/menu_ic_map.png', 'Map', () {
                    Navigator.pop(context); 
                   
                  }),
                  _buildDrawerItem(context, 'assets/images/menu_ic_chat.png', 'Request', () {
                    Navigator.pop(context); 
                
                  }),
                  _buildDrawerItem(context, 'assets/images/menu_ic_request.png', 'Chat', () {
                    Navigator.pop(context);
                  }),
                  _buildDrawerItem(context, 'assets/images/menu_ic_acc.png', 'Account', () {
                    Navigator.pop(context); 
                  }),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.black, thickness: 1, indent: 16, endIndent: 16), 
                  const SizedBox(height: 20), 
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0), 
              child: _buildLogoutButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String imgPath, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), 
      leading: Image.asset(imgPath, width: 24, height: 24), 
      title: Text(
        title,
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 16, 
            ),
      ),
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right, color: Colors.white, size: 24), 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      tileColor: Colors.white.withOpacity(0.1), 
      hoverColor: Colors.white.withOpacity(0.2), // Hover feedback
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Logged out successfully!")),
        );
        Navigator.pop(context); 
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), 
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logout.png',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'Logout',
              style: TextStyle(
                color: Color(0xFFFF715B), 
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}