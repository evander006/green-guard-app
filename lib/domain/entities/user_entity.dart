import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final bool isEmailVerified;
  final String? provider;

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
  bool get isGoogleUser => provider == 'google.com';
  bool get needsEmailVerification => !isEmailVerified && provider == 'password';
}