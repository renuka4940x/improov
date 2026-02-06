import 'package:go_router/go_router.dart';
import 'package:improov/src/presentation/util/page_nav.dart';
import 'package:improov/src/presentation/pages/profile_page.dart';

final AppRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PageNav(),
    ),
    // Example for later
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
  ],
);