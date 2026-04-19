// lib/data/datasources/auth_local_datasource.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:green_guard/core/consts/app_constants.dart';
import 'package:green_guard/core/consts/error_handlers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<UserModel> signInWithGoogle();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth auth;
  final SharedPreferences prefs;
  final GoogleSignIn googleSignIn;
  AuthRemoteDatasourceImpl(this.prefs, this.auth, this.googleSignIn);

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    UserCredential result = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await prefs.setString(
      AppConstants.authTokenKey,
      'mock_token_${email.hashCode}',
    );
    return UserModel.fromFirebase(result.user!);
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await result.user!.updateDisplayName(name);
    await result.user!.reload();
    await prefs.setString(
      AppConstants.authTokenKey,
      'mock_token_${email.hashCode}',
    );
    await prefs.setString(AppConstants.userNameKey, name);
    await prefs.setString(AppConstants.userEmailKey, email);
    return UserModel.fromFirebase(auth.currentUser!);
  }

  @override
  Future<void> signOut() async {
    await prefs.remove(AppConstants.authTokenKey);
    await googleSignIn.signOut();
    await auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final token = prefs.getString(AppConstants.authTokenKey);
    final user = auth.currentUser;
    if (token == null || user == null) return null;
    return UserModel.fromFirebase(user);
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in aborted by user');
      }

      // Obtain auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final UserCredential userCredential = await auth.signInWithCredential(
        credential,
      );
      await prefs.setString(
        AppConstants.authTokenKey,
        'mock_token_${userCredential.user!.email.hashCode}',
      );

      if (userCredential.user == null) {
        throw Exception('Google sign-in failed: no user returned');
      }

      // If it's a new user, update display name from Google
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        await userCredential.user!.updateDisplayName(googleUser.displayName);
        await userCredential.user!.reload();
      }

      return UserModel.fromFirebase(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Google sign-in failed: ${e.toString()}');
    }
  }
}
