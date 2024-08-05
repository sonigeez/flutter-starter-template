import 'package:flutter/material.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({super.key});

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        // Request Pending
// Our admin team is currently reviewing your documents. Approval may take up to 48-72 hours. You will be notified once your verification is complete.
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Request Pending',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Our admin team is currently reviewing your documents. Approval may take up to 48-72 hours. You will be notified once your verification is complete.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
