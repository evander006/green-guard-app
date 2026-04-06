import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_guard/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signIn({required String email, required String password});
  Future<UserEntity> signUp({required String name, required String email, required String password});
  Future<void> signOut();
  Future<UserEntity> googleSignIn();
  Future<UserEntity?> getCurrentUser();
}