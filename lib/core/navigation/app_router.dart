// lib/core/navigation/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:green_guard/core/navigation/app_routes.dart';
import 'package:green_guard/core/navigation/root_shell.dart';
import 'package:green_guard/presentation/auth/bloc/auth_bloc.dart';
import 'package:green_guard/presentation/auth/bloc/auth_state.dart';
import 'package:green_guard/presentation/auth/pages/sign_up_page.dart';
import 'package:green_guard/presentation/calendar/calendar_page.dart';
import 'package:green_guard/presentation/home/pages/home_page.dart';
import 'package:green_guard/presentation/plants/plants_page.dart';
import 'package:green_guard/presentation/profile/profile_page.dart';
import 'package:green_guard/presentation/scanner/scanner_page.dart';

class AppRouter {
  static GoRouter createRouter({required AuthBloc authBloc}) {
    return GoRouter(
      initialLocation: AppRoutes.signUp,
      
      redirect: (context, state) {
        final isLoggedIn = authBloc.state is AuthAuthenticated;
        final location = state.uri.path;
        
        // ✅ Allow sign-up for unauthenticated users
        if (location == AppRoutes.signUp) {
          return isLoggedIn ? AppRoutes.home : null;
        }
        
        // ✅ Redirect unauthenticated users away from protected routes
        if (!isLoggedIn) {
          return AppRoutes.signUp;
        }
        
        return null;
      },
      
      routes: [
        // 🔐 Public route (outside protected shell)
        GoRoute(
          path: AppRoutes.signUp,  // '/sign-up'
          name: 'signUp',
          builder: (context, state) => const SignUpPage(),
        ),
        
        // 🛡️ Protected routes wrapper (with auth check)
        GoRoute(
          path: AppRoutes.root,  // '/root' - PARENT PATH
          // Optional: Add auth redirect here too for extra safety
          redirect: (context, state) {
            final isLoggedIn = authBloc.state is AuthAuthenticated;
            return isLoggedIn ? null : AppRoutes.signUp;
          },
          routes: [
            // 🧭 ShellRoute for persistent bottom nav (NESTED inside parent GoRoute)
            ShellRoute(
              builder: (context, state, child) {
                return RootShell(child: child);
              },
              routes: [
                // ✅ Child paths are RELATIVE to parent '/root'
                GoRoute(
                  path: 'home',  // ✅ Relative: Full path = '/root/home'
                  name: 'rootHome',
                  pageBuilder: (context, state) => 
                      const NoTransitionPage(child: HomePage()),
                ),
                GoRoute(
                  path: 'calendar',  // '/root/calendar'
                  name: 'rootCalendar',
                  pageBuilder: (context, state) => 
                      const NoTransitionPage(child: CalendarPage()),
                ),
                GoRoute(
                  path: 'scanner',  // '/root/scanner'
                  name: 'rootScanner',
                  pageBuilder: (context, state) => 
                      const NoTransitionPage(child: ScannerPage()),
                ),
                GoRoute(
                  path: 'plants',  // '/root/plants'
                  name: 'rootPlants',
                  pageBuilder: (context, state) => 
                      const NoTransitionPage(child: PlantsPage()),
                ),
                GoRoute(
                  path: 'profile',  // '/root/profile'
                  name: 'rootProfile',
                  pageBuilder: (context, state) => 
                      const NoTransitionPage(child: ProfilePage()),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}