// lib/data/repositories/auth_repository_impl.dart
import 'package:green_guard/domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource datasource;
  AuthRepositoryImpl(this.datasource);

  @override
  Future<UserEntity> signIn({required String email, required String password}) =>
      datasource.signIn(email: email, password: password);

  @override
  Future<UserEntity> signUp({required String name, required String email, required String password}) =>
      datasource.signUp(name: name, email: email, password: password);

  @override
  Future<void> signOut() => datasource.signOut();

  @override
  Future<UserEntity?> getCurrentUser() => datasource.getCurrentUser();

  @override
  Future<UserEntity> googleSignIn() async{
    return await datasource.signInWithGoogle();
  }

}
