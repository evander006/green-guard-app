import 'package:green_guard/domain/entities/user_entity.dart';

import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;
  SignInUseCase(this.repository);

  Future<UserEntity> call({required String email, required String password}) {
    return repository.signIn(email: email, password: password);
  }
}

class SignUpUseCase {
  final AuthRepository repository;
  SignUpUseCase(this.repository);

  Future<UserEntity> call({
    required String name,
    required String email,
    required String password,
  }) {
    return repository.signUp(name: name, email: email, password: password);
  }
}

class GetCurrentUserUseCase {
  final AuthRepository repository;
  GetCurrentUserUseCase(this.repository);

  Future<UserEntity?> call() => repository.getCurrentUser();
}

class SignOutUseCase {
  final AuthRepository repository;
  SignOutUseCase(this.repository);
  Future<void> call() => repository.signOut();
}

class SignInWithGoogleUserCase {
  final AuthRepository repository;
  SignInWithGoogleUserCase({required this.repository});
  Future<UserEntity> call() => repository.googleSignIn();
}
