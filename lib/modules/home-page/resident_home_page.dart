import 'package:flutter/material.dart';

class ResidentHomePage extends StatefulWidget {
  const ResidentHomePage({super.key});

  @override
  State<ResidentHomePage> createState() => _ResidentHomePageState();
}

class _ResidentHomePageState extends State<ResidentHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Resident Home Page'),
      ),
    );
  }
}
