import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:green_guard/data/datasources/plant_local_datasource.dart';
import 'package:green_guard/data/datasources/scanner_datasource.dart';
import 'package:green_guard/data/repositories/auth_repository_impl.dart';
import 'package:green_guard/data/repositories/plant_repository_impl.dart';
import 'package:green_guard/data/repositories/scanner_repository_impl.dart';
import 'package:green_guard/domain/repositories/auth_repository.dart';
import 'package:green_guard/domain/repositories/plant_repository.dart';
import 'package:green_guard/domain/repositories/scanner_repository.dart';
import 'package:green_guard/domain/usecases/plants_usecase.dart';
import 'package:green_guard/domain/usecases/request_camera_permission_usecase.dart';
import 'package:green_guard/domain/usecases/sign_in_usecase.dart';
import 'package:green_guard/firebase_options.dart';
import 'package:green_guard/presentation/auth/bloc/auth_bloc.dart';
import 'package:green_guard/presentation/home/bloc/home_bloc.dart';
import 'package:green_guard/presentation/plant_criteria/bloc/plant_bloc.dart';
import 'package:green_guard/presentation/scanner/bloc/scanner_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/auth_remote_datasource.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  // Data sources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl(), sl(), sl()),
  );
  sl.registerLazySingleton<PlantDatasource>(
    () => PlantDatasourceImpl(firestore: sl(), auth: sl()),
  );
  sl.registerLazySingleton<ScannerDatasource>(() => ScannerDatasourceImpl());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<PlantRepository>(() => PlantRepositoryImpl(sl()));
  sl.registerLazySingleton<ScannerRepository>(
    () => ScannerRepositoryImpl(sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => SignInWithGoogleUserCase(repository: sl()));
  sl.registerLazySingleton(() => GetPlantsUseCase(sl()));
  sl.registerLazySingleton(() => RequestCameraPermissionUseCase(sl()));
  sl.registerLazySingleton(() => CheckIsCameraPermissionGrantedUseCase(sl()));
  sl.registerLazySingleton(
    () => CheckIsCameraPermissionPermanentlyDeniedUseCase(sl()),
  );
  sl.registerLazySingleton(() => PickFromGalleryUseCase(sl()));
  sl.registerLazySingleton(() => CaptureFromCameraUseCase(sl()));
  sl.registerLazySingleton(() => OpenSettingsUseCase(sl()));
  sl.registerLazySingleton(() => DisposeUseCase(sl()));

 
  sl.registerLazySingleton(() => AddPlantUseCase(sl()));
  sl.registerLazySingleton(() => DeletePlantUseCase(sl()));
  sl.registerLazySingleton(() => GetPlantByIdUseCase(sl()));
  sl.registerLazySingleton(() => WatchPlantsUseCase(sl()));

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
  sl.registerFactory(
    () => ScannerBloc(
      requestCameraPermissionUseCase: sl(),
      cameraPermissionGrantedUseCase: sl(),
      checkIsCameraPermissionPermanentlyDeniedUseCase: sl(),
      pickFromGalleryUseCase: sl(),
      captureFromCameraUseCase: sl(),
      openSettingsUseCase: sl(),
      disposeUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => PlantBloc(addPlantUseCase: sl(), watchPlantsUseCase: sl()),
  );
}
