import 'package:go_router/go_router.dart';
import 'package:improov/src/presentation/pages/calendar_page.dart';
import 'package:improov/src/features/home/screens/home_page.dart';
import 'package:improov/src/presentation/pages/streak_page.dart';
import 'package:improov/src/core/routing/page_nav.dart';
import 'package:improov/src/presentation/pages/profile_page.dart';

final AppRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        //pass the shell to PageNav
        return PageNav(navigationShell: navigationShell);
      },
      branches: [
        //home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        
        //calendar
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/calendar',
              builder: (context, state) => const CalendarPage(),
            ),
          ],
        ),

        //streak
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/streak',
              builder: (context, state) => const StreakPage(),
            ),
          ],
        ),

        //profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);