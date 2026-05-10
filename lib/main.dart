import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_guard/core/navigation/app_router.dart';
import 'package:green_guard/presentation/auth/bloc/auth_bloc.dart';
import 'package:green_guard/presentation/auth/bloc/auth_event.dart';
import 'package:green_guard/presentation/calendar/bloc/calendar_bloc.dart';
import 'package:green_guard/presentation/plant_criteria/bloc/plant_bloc.dart';
import 'package:green_guard/presentation/scanner/bloc/scanner_bloc.dart';
import 'core/di/di_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  final authBloc = di.sl<AuthBloc>()..add(AuthCheckRequested());
  final scannerBloc = di.sl<ScannerBloc>();
  final plantBloc = di.sl<PlantBloc>();
  final calendarBloc = di.sl<CalendarBloc>();
  final router = AppRouter.createRouter(authBloc: authBloc);
  runApp(
    MyApp(
      authBloc: authBloc,
      router: router,
      scannerBloc: scannerBloc,
      plantBloc: plantBloc,
      calendarBloc: calendarBloc,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;
  final ScannerBloc scannerBloc;
  final PlantBloc plantBloc;
  final CalendarBloc calendarBloc;
  final GoRouter router;
  const MyApp({
    super.key,
    required this.authBloc,
    required this.router,
    required this.scannerBloc,
    required this.plantBloc,
    required this.calendarBloc,
  });
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => authBloc),
        BlocProvider(create: (context) => scannerBloc),
        BlocProvider(create: (context) => plantBloc),
        BlocProvider(create: (context) => calendarBloc),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      ),
    );
  }
}
