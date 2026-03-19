import 'package:go_router/go_router.dart';
import 'package:improov/src/data/services/auth_service.dart';
import 'package:improov/src/presentation/auth/auth_screen.dart';
import 'package:improov/src/presentation/calendar/screen/calendar_page.dart';
import 'package:improov/src/presentation/home/screens/home_page.dart';
import 'package:improov/src/presentation/settings/screen/settings_page.dart';
import 'package:improov/src/presentation/streak/screen/streak_page.dart';
import 'package:improov/src/core/routing/page_nav.dart';
import 'package:improov/src/presentation/profile/screen/profile_page.dart';

final _authService = AuthService();

final appRouter = GoRouter(
  refreshListenable: _authService,
  initialLocation: '/',

  redirect: (context, state) {
    final bool loggedIn = _authService.isAuthenticated;
    final bool loggingIn = state.matchedLocation == '/auth';

    //If not logged in and not on auth page, send to auth page
    if (!loggedIn) {
      return '/auth';
    }

    //If logged in and trying to go to auth page, send to home
    if (loggedIn && loggingIn) {
      return '/';
    }

    //Otherwise, stay where you are
    return null;
  },

  routes: [
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) => const AuthScreen(),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
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

        //settings
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              name: 'settings',
              builder: (context, state) => const SettingsPage(),
            )
          ]
        ),
      ],
    ),
  ],
);