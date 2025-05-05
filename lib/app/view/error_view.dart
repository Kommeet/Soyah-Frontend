import 'package:flutter/material.dart';

/// A widget that renders a user-friendly error screen for the application.
///
/// This widget is typically displayed when a routing error occurs or
/// when the user attempts to access an invalid or non-existent route.

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
  });

  /// Builds the error view UI, including a message, an image, a 404 status code,
  /// and a "Go Home" button to direct the user back to the home screen.

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Seems Like you are lost'),
          const SizedBox(height: 30),
          const Text('404',
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          const Text('You want me to take you home?'),
          const SizedBox(height: 30),
          TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.home),
              label: const Text('Go Home')),
        ],
      ),
    );
  }
}
