import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:improov/src/data/services/auth_service.dart';
import 'package:improov/src/presentation/auth/auth_screen.dart';
import 'package:improov/src/presentation/calendar/screen/calendar_page.dart';
import 'package:improov/src/presentation/home/screens/home_page.dart';
import 'package:improov/src/presentation/settings/screen/settings_page.dart';
import 'package:improov/src/presentation/streak/screen/streak_page.dart';
import 'package:improov/src/core/routing/page_nav.dart';
import 'package:improov/src/presentation/profile/screen/profile_page.dart';

final authServiceProvider = ChangeNotifierProvider<AuthService>((ref) {
  return AuthService(ref); 
});

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  
  return GoRouter(
    navigatorKey: _rootNavigatorKey,

    refreshListenable: ref.watch(authServiceProvider),
    initialLocation: '/',

    redirect: (context, state) {
      final authService = ref.read(authServiceProvider);
      
      final bool loggedIn = authService.isAuthenticated;
      final bool loggingIn = state.matchedLocation == '/auth';

      // If NOT logged in, send them to /auth
      if (!loggedIn) {
        return '/auth';
      }

      // If logged in and trying to go back to /auth, send them home
      if (loggedIn && loggingIn) {
        return '/';
      }

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
          // home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          
          // calendar
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calendar',
                builder: (context, state) => const CalendarPage(),
              ),
            ],
          ),

          // streak
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/streak',
                builder: (context, state) => const StreakPage(),
              ),
            ],
          ),

          // profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    name: 'settings',
                    builder: (context, state) => const SettingsPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});