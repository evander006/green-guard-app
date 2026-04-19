import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_guard/core/navigation/app_routes.dart';
import 'package:green_guard/core/navigation/root_shell.dart';
import 'package:green_guard/presentation/auth/bloc/auth_bloc.dart';
import 'package:green_guard/presentation/auth/bloc/auth_state.dart';
import 'package:green_guard/presentation/auth/pages/sign_up_page.dart';
import 'package:green_guard/presentation/calendar/calendar_page.dart';
import 'package:green_guard/presentation/home/pages/home_page.dart';
import 'package:green_guard/presentation/plant_criteria/pages/plant_criteria_page.dart';
import 'package:green_guard/presentation/plants/pages/plants_page.dart';
import 'package:green_guard/presentation/profile/profile_page.dart';
import 'package:green_guard/presentation/scanner/pages/scanner_page.dart';

class AppRouter {
  static GoRouter createRouter({required AuthBloc authBloc}) {
    return GoRouter(
      initialLocation: AppRoutes.home,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final location = state.uri.path;

        // Show nothing (or a splash) while checking
        if (authState is AuthInitial || authState is AuthLoading) {
          return null; // or return null if you have a splash screen
        }

        final isLoggedIn = authState is AuthAuthenticated;
        final isOnAuthPage = location == AppRoutes.signUp;

        if (isLoggedIn && isOnAuthPage) return AppRoutes.home;
        if (!isLoggedIn && !isOnAuthPage) return AppRoutes.signUp;

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.signUp, // '/sign-up' ✓
          name: 'signUp',
          builder: (context, state) => const SignUpPage(),
        ),
        GoRoute(
          path: AppRoutes.plantCriteria, // '/sign-up' ✓
          name: 'plantCriteria',
          builder: (context, state) { 
            final img=state.extra as String?;
            return PlantCriteriaPage(imagePath: img,);},
        ),

        ShellRoute(
          builder: (context, state, child) => RootShell(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: 'rootHome',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HomePage()),
            ),
            GoRoute(
              path: AppRoutes.calendar,
              name: 'rootCalendar',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: CalendarPage()),
            ),
            GoRoute(
              path: AppRoutes.scanner,
              name: 'rootScanner',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ScannerPage()),
            ),
            GoRoute(
              path: AppRoutes.plants,
              name: 'rootPlants',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: PlantsPage()),
            ),
            GoRoute(
              path: AppRoutes.profile,
              name: 'rootProfile',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ProfilePage()),
            ),
          ],
        ),
      ],
    );
  }
}

// A simple Listenable wrapper around a Stream
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _sub = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
