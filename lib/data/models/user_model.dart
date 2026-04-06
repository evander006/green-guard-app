// lib/data/models/user_model.dart
import 'package:green_guard/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.photoUrl,
    super.isEmailVerified,
    super.provider,
  });

  // ✅ Factory: Firebase User → Your Domain Entity
  factory UserModel.fromFirebase(firebase.User user) {
    final providerData = user.providerData.firstOrNull;
    
    return UserModel(
      id: user.uid,
      name: user.displayName ?? 'User',
      email: user.email ?? '',
      photoUrl: user.photoURL,
      isEmailVerified: user.emailVerified,
      provider: providerData?.providerId, // 'password', 'google.com', etc.
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};
  UserModel copyWith({String? id, String? name, String? email}) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
