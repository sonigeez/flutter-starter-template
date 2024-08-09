import 'package:flutter/material.dart';

class CountryCodePicker extends StatelessWidget {
  const CountryCodePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 60,
      child: Center(
        child: Text(
          '+91',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
