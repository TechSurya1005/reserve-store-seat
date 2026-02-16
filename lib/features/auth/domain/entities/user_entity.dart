class UserEntity {
  final String uid;
  final String email;
  final String? name;
  final String? role;
  final String? profileImage;

  UserEntity({
    required this.uid,
    required this.email,
    this.name,
    this.role,
    this.profileImage,
  });
}
