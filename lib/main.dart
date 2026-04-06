import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_guard/core/navigation/app_router.dart';
import 'package:green_guard/presentation/auth/bloc/auth_bloc.dart';
import 'core/di/di_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  final authBloc =di.sl<AuthBloc>();
  final router=AppRouter.createRouter(authBloc: authBloc);
  runApp(MyApp(authBloc: authBloc, router: router));
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;
  final GoRouter router;
  const MyApp({super.key, required this.authBloc, required this.router});
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: authBloc,
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        
      ),
    );
  }
}
