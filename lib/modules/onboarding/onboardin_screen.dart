import 'package:flutter/material.dart';

class OnboardinScreen extends StatefulWidget {
  const OnboardinScreen({super.key});

  @override
  State<OnboardinScreen> createState() => _OnboardinScreenState();
}

class _OnboardinScreenState extends State<OnboardinScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Onboardin Screen'),
      ),
    );
  }
}
