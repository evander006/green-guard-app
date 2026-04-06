import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:green_guard/data/datasources/plant_local_datasource.dart';
import 'package:green_guard/data/repositories/auth_repository_impl.dart';
import 'package:green_guard/data/repositories/plant_repository_impl.dart';
import 'package:green_guard/domain/repositories/auth_repository.dart';
import 'package:green_guard/domain/repositories/plant_repository.dart';
import 'package:green_guard/domain/usecases/get_plants_usecase.dart';
import 'package:green_guard/domain/usecases/sign_in_usecase.dart';
import 'package:green_guard/firebase_options.dart';
import 'package:green_guard/presentation/auth/bloc/auth_bloc.dart';
import 'package:green_guard/presentation/home/bloc/home_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/auth_remote_datasource.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  // Data sources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl(), sl(), sl()),
  );
  sl.registerLazySingleton<PlantLocalDatasource>(
    () => PlantLocalDatasourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<PlantRepository>(() => PlantRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => SignInWithGoogleUserCase(repository: sl()));
  sl.registerLazySingleton(() => GetPlantsUseCase(sl()));

  // BLoCs (factory = new instance each time)
  sl.registerFactory(
    () => AuthBloc(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      signOutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      signInWithGoogleUserCase: sl(),
    ),
  );
  sl.registerFactory(() => HomeBloc(getPlantsUseCase: sl()));
}
