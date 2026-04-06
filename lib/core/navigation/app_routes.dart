// lib/core/navigation/app_routes.dart
abstract class AppRoutes {
  // 🔐 Auth (public)
  static const String signUp = '/sign-up';
  
  // 🧭 Root prefix for protected tabs
  static const String root = '/root';
  
  // ✅ Tab routes: RELATIVE paths (for nested ShellRoute)
  // These combine with parent '/root' → '/root/home', etc.
  static const String home = 'home';
  static const String calendar = 'calendar';
  static const String scanner = 'scanner';
  static const String plants = 'plants';
  static const String profile = 'profile';
  
  // ✅ Helper: Get full path by combining root + relative
  static String getFullPath(String relativePath) => '$root/$relativePath';
  
  // ✅ Helper: Get route by index (returns full path)
  static String getRouteByIndex(int index) {
    const relative = [home, calendar, scanner, plants, profile];
    return getFullPath(relative[index]);
  }
  
  // ✅ Helper: Get index from full location
  static int getIndexByRoute(String location) {
    final path = location.split('?').first;  // Remove query params
    
    if (path == getFullPath(home)) return 0;
    if (path == getFullPath(calendar)) return 1;
    if (path == getFullPath(scanner)) return 2;
    if (path == getFullPath(plants)) return 3;
    if (path == getFullPath(profile)) return 4;
    
    return 0; // Default to home
  }
}