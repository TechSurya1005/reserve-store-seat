import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.email,
    super.name,
    super.role,
    super.profileImage,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> json, String uid) {
    return UserModel(
      uid: uid,
      email: json['email'] ?? '',
      name: json['name'],
      role: json['role'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'role': role,
      'profileImage': profileImage,
    };
  }
}
