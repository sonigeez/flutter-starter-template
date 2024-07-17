import 'package:go_router/go_router.dart';
import '/modules/app.dart';
import '/utils/router/app_routes.dart';

class AppRouter {
  static GoRouter get router => GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            name: AppRoutes.home,
            path: AppRoutes.home,
            builder: (context, state) => const HomePage(),
          ),
        ],
      );
}
