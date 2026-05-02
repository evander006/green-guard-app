// lib/core/navigation/app_routes.dart
abstract class AppRoutes {
  static const String signUp = '/sign-up';

  static const String root = '/root';

  static const String home = '/root/home';
  static const String calendar = '/root/calendar';
  static const String scanner = '/root/scanner';
  static const String profile = '/root/profile';
  static const String plantCriteria = '/plant-ctiteria';
  static const String plantDetails = '/plant-details';

  static String getRouteByIndex(int index) {
    const routes = [home, calendar, scanner, profile];
    return routes[index];
  }

  static int getIndexByRoute(String location) {
    final path = location.split('?').first;
    if (path == home) return 0;
    if (path == calendar) return 1;
    if (path == scanner) return 2;
    if (path == profile) return 3;
    return 0;
  }
}
