import 'package:flutter/material.dart';
import 'package:patrika_community_app/flavors.dart';
import 'package:patrika_community_app/utils/app_styles.dart';
import 'package:patrika_community_app/utils/router/app_router.dart';
import 'package:toastification/toastification.dart';

class ResidentApp extends StatefulWidget {
  const ResidentApp({super.key});

  @override
  State<ResidentApp> createState() => _ResidentAppState();
}

class _ResidentAppState extends State<ResidentApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: F.appFlavor != Flavor.patrika_community,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          brightness: Brightness.light,
          primaryColor: Colors.black,
          fontFamily: 'SF Pro',
          textTheme: const TextTheme(
            displayLarge: AppTextStyles.h1Light,
            bodyLarge: AppTextStyles.body1Light,
            bodyMedium: AppTextStyles.body2Light,
            titleMedium: AppTextStyles.body3Light,
            bodySmall: AppTextStyles.smallText1Light,
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.white,
          fontFamily: 'SF Pro',
          textTheme: const TextTheme(
            displayLarge: AppTextStyles.h1Dark,
            bodyLarge: AppTextStyles.body1Dark,
            bodyMedium: AppTextStyles.body2Dark,
            titleMedium: AppTextStyles.body3Dark,
            bodySmall: AppTextStyles.smallText1Dark,
          ),
        ),
        themeMode: ThemeMode.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
