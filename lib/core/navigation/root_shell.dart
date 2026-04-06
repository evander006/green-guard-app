import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:green_guard/core/consts/app_theme.dart';
import 'package:green_guard/core/navigation/app_routes.dart';

class RootShell extends StatefulWidget {
  final Widget child;
  const RootShell({super.key, required this.child});

  @override
  State<RootShell> createState() => _RootShellState();
}

// lib/core/navigation/root_shell.dart
class _RootShellState extends State<RootShell> {
  @override
  Widget build(BuildContext context) {
    final currLocation = GoRouterState.of(context).uri.toString();
    final currIndex = AppRoutes.getIndexByRoute(currLocation);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: _buildBottomNav(currIndex),
    );
  }

  Widget _buildBottomNav(int currentIndex) {
    final items = [
      Icons.home_rounded,
      Icons.calendar_today_outlined,
      Icons.camera_alt_outlined,
      Icons.eco_outlined,
      Icons.person_outline_rounded,
    ];
    
    // ✅ Map index to RELATIVE paths (combined with '/root' by GoRouter)
    final relativePaths = [
      AppRoutes.home,      // 'home'
      AppRoutes.calendar,  // 'calendar'
      AppRoutes.scanner,   // 'scanner'
      AppRoutes.plants,    // 'plants'
      AppRoutes.profile,   // 'profile'
    ];
    
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final active = i == currentIndex;
          
          return GestureDetector(
            onTap: () {
              // ✅ Navigate using FULL path
              if (i != currentIndex) {
                final fullPath = AppRoutes.getFullPath(relativePaths[i]);
                context.go(fullPath);  // e.g., '/root/scanner'
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: active ? AppTheme.textDark : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                items[i],
                size: 22,
                color: active ? Colors.white : AppTheme.textMuted,
              ),
            ),
          );
        }),
      ),
    );
  }
}