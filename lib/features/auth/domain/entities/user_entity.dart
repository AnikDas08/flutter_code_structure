class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? role;
  final String? avatar;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.role,
    this.avatar,
  });
}
