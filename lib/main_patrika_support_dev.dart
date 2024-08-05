import 'package:flutter/material.dart';
import 'package:patrika_community_app/flavors.dart';
import 'package:patrika_community_app/modules/support_app.dart';

Future<void> main() async {
  F.appFlavor = Flavor.patrika_support_dev;
  runApp(const SupportApp());
}
