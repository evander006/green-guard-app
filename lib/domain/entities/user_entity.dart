import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;      // ✅ Optional: for Google avatar
  final bool isEmailVerified;  // ✅ Useful for onboarding
  final String? provider;      // ✅ 'password' | 'google.com' | 'apple.com'

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.isEmailVerified = false,
    this.provider,
  });

  @override
  List<Object?> get props => [
    id, name, email, photoUrl, isEmailVerified, provider
  ];

  // ✅ Helper: Check if user signed up with Google
  bool get isGoogleUser => provider == 'google.com';
  
  // ✅ Helper: Check if user needs email verification
  bool get needsEmailVerification => !isEmailVerified && provider == 'password';
}