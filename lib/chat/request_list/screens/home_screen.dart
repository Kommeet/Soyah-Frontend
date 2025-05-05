// import 'package:flutter/material.dart';
// import '../widgets/bottom_navigation.dart';
// import 'requests_screen.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _currentIndex = 2; // Requests tab selected by default

//   final List<Widget> _screens = [
//     Center(child: Text('Places')),
//     Center(child: Text('Map')),
//     RequestsScreen(),
//     Center(child: Text('Chat')),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_currentIndex],
//       bottomNavigationBar: BottomNavigation(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }