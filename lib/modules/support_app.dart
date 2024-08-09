import 'package:flutter/material.dart';
import 'package:patrika_community_app/flavors.dart';
import 'package:patrika_community_app/utils/app_styles.dart';
import 'package:patrika_community_app/utils/router/app_router.dart';
import 'package:toastification/toastification.dart';

class SupportApp extends StatefulWidget {
  const SupportApp({super.key});

  @override
  State<SupportApp> createState() => _ResidentAppState();
}

class _ResidentAppState extends State<SupportApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: F.appFlavor != Flavor.patrika_support,
        title: 'Flutter Demo',
        theme: ThemeData(
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final flavor = F.appFlavor;
    return Scaffold(
      body: Center(
        child: Text(
          flavor!.name,
        ),
      ),
    );
  }
}
