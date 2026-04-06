import 'package:firebase_auth/firebase_auth.dart';

String handleFirebaseAuthException(FirebaseAuthException e) {
    return switch (e.code) {
      'account-exists-with-different-credential' => 
        'An account already exists with this email but different sign-in method',
      'credential-already-in-use' => 
        'This Google account is already linked to another account',
      'invalid-credential' => 'Invalid authentication credentials',
      'operation-not-allowed' => 'Google sign-in is not enabled for this app',
      'user-disabled' => 'This user account has been disabled',
      _ => e.message ?? 'Authentication failed',
    };
  }