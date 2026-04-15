// lib/core/navigation/root_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_guard/core/consts/app_theme.dart';
import 'package:green_guard/core/navigation/app_routes.dart';

class RootShell extends StatefulWidget {
  final Widget child;
  const RootShell({super.key, required this.child});

  @override
  State<RootShell> createState() => _RootShellState();
}

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
        final routes = [
      AppRoutes.home,      // '/root/home'
      AppRoutes.calendar,  // '/root/calendar'
      AppRoutes.scanner,   // '/root/scanner'
      AppRoutes.plants,    // '/root/plants'
      AppRoutes.profile,   // '/root/profile'
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
              // ✅ Navigate using absolute path directly
              if (i != currentIndex) {
                context.go(routes[i]);  // e.g., '/root/scanner'
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