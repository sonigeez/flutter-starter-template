import 'package:flutter/material.dart';
import 'package:patrika_community_app/flavors.dart';
import 'package:patrika_community_app/modules/resident_app.dart';

Future<void> main() async {
  F.appFlavor = Flavor.patrika_community;
  runApp(const ResidentApp());
}
