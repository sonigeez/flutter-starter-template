import 'package:go_router/go_router.dart';
import 'package:patrika_community_app/modules/home-page/admin_home_page.dart';
import 'package:patrika_community_app/modules/home-page/guard_home_page.dart';
import 'package:patrika_community_app/modules/home-page/resident_home_page.dart';
import 'package:patrika_community_app/modules/onboarding/screens/pending_screen.dart';
import 'package:patrika_community_app/modules/onboarding/screens/signup_process.dart';
import 'package:patrika_community_app/modules/onboarding/screens/walkhrough_screen.dart';
import 'package:patrika_community_app/modules/splash/splash_screen.dart';
import '/utils/router/app_routes.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: AppRoutes.splash,
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: AppRoutes.walkthrough,
        path: AppRoutes.walkthrough,
        builder: (context, state) => const WalkthroughScreen(),
      ),
      GoRoute(
        name: AppRoutes.signup,
        path: AppRoutes.signup,
        builder: (context, state) => const SignupProcess(),
      ),
      GoRoute(
        name: AppRoutes.pending,
        path: AppRoutes.pending,
        builder: (context, state) => const PendingScreen(),
      ),
      GoRoute(
        name: AppRoutes.supportHome,
        path: AppRoutes.supportHome,
        builder: (context, state) => const GuardHomePage(),
      ),
      GoRoute(
        name: AppRoutes.adminHome,
        path: AppRoutes.adminHome,
        builder: (context, state) => const AdminHomePage(),
      ),
      GoRoute(
          name: AppRoutes.home,
          path: AppRoutes.home,
          builder: (context, state) => const ResidentHomePage()),
    ],
  );
}
