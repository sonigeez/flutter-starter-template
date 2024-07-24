import 'package:go_router/go_router.dart';
import 'package:patrika_community_app/modules/onboarding/screens/signup_process.dart';
import 'package:patrika_community_app/modules/onboarding/screens/walkhrough_screen.dart';
import '/utils/router/app_routes.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: AppRoutes.home,
        path: AppRoutes.home,
        builder: (context, state) => const WalkthroughScreen(),
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
    ],
  );
}
