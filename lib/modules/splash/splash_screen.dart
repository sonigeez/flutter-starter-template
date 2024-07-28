import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:patrika_community_app/services/key_value_service.dart';
import 'package:patrika_community_app/services/network_requester.dart';
import 'package:patrika_community_app/utils/router/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(150.ms, () {
      determineNextScreen();
    });
  }

  Future<void> determineNextScreen() async {
    var token = await KeyValueService.getUserToken();

    if (true) {
      await Future.delayed(100.ms);
      if (!mounted) return;
      context.push(AppRoutes.walkthrough);
    } else {
      // get user details from api
      var res = await NetworkRequester.shared.get(
        path: '/auth',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (!mounted) return;

      if (res.data['user']['user_status'] == 'pending') {
        context.go(AppRoutes.pending);
      } else if (res.data['user']['user_status'] == 'initial') {
        context.go(AppRoutes.walkthrough);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Patrika Community App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
