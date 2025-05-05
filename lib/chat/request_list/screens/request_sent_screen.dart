import 'package:flutter/material.dart';

class RequestSentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Spacer(),
              // Success animation/image
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.purple,
                    size: 80,
                  ),
                  // Note: In a real app, you might use Lottie animation here
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Request Sent!',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 10),
              Text(
                'You will be notified once the request has been accepted',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Spacer(),
              // Go back to home button
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate back to home screen
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: Icon(Icons.arrow_forward),
                label: Text('GO BACK TO HOME'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}