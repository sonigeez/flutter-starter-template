import 'package:flutter/material.dart';

class GuardHomePage extends StatefulWidget {
  const GuardHomePage({super.key});

  @override
  State<GuardHomePage> createState() => _GuardHomePageState();
}

class _GuardHomePageState extends State<GuardHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Guard Home Page'),
      ),
    );
  }
}
