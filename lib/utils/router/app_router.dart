import 'package:go_router/go_router.dart';
import 'package:patrika_community_app/modules/gate_management/pre_approve_guard_screen.dart';
import 'package:patrika_community_app/modules/gate_management/pre_approve_resident_screen.dart';
import 'package:patrika_community_app/modules/home_page/admin_home_page.dart';
import 'package:patrika_community_app/modules/home_page/guard_home_page.dart';
import 'package:patrika_community_app/modules/home_page/resident_home_page.dart';
import 'package:patrika_community_app/modules/onboarding/screens/pending_screen.dart';
import 'package:patrika_community_app/modules/onboarding/screens/signup_process.dart';
import 'package:patrika_community_app/modules/onboarding/screens/walkhrough_screen.dart';
import 'package:patrika_community_app/modules/splash/splash_screen.dart';

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
        builder: (context, state) => const ResidentHomePage(),
      ),
      GoRoute(
        name: AppRoutes.preApproveResident,
        path: AppRoutes.preApproveResident,
        builder: (context, state) => const PreApproveResidentScreen(),
      ),
      GoRoute(
        name: AppRoutes.preApproveGuard,
        path: AppRoutes.preApproveGuard,
        builder: (context, state) => const PreApproveGuardScreen(),
      ),
    ],
  );
}

class AppRoutes {
  static const String splash = '/';
  static const String walkthrough = '/walkthrough';
  static const String signup = '/signup';
  static const String pending = '/pending';
  static const String supportHome = '/support-home';
  static const String adminHome = '/admin-home';
  static const String home = '/home';
  static const String preApproveResident = '/pre-approve-resident';
  static const String preApproveGuard = '/pre-approve-guard';
}
