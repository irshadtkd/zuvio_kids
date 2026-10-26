/// Pure Dart User Profile Entity representing child learner profile.
/// Layer: Domain (no Flutter or json dependencies).
class UserProfileEntity {
  const UserProfileEntity({
    required this.name,
    required this.studentClass,
    required this.friendAvatar,
    this.isOnboardingCompleted = false,
  });

  final String name;
  final String studentClass;
  final String friendAvatar;
  final bool isOnboardingCompleted;

  UserProfileEntity copyWith({
    String? name,
    String? studentClass,
    String? friendAvatar,
    bool? isOnboardingCompleted,
  }) {
    return UserProfileEntity(
      name: name ?? this.name,
      studentClass: studentClass ?? this.studentClass,
      friendAvatar: friendAvatar ?? this.friendAvatar,
      isOnboardingCompleted:
          isOnboardingCompleted ?? this.isOnboardingCompleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileEntity &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          studentClass == other.studentClass &&
          friendAvatar == other.friendAvatar &&
          isOnboardingCompleted == other.isOnboardingCompleted;

  @override
  int get hashCode => Object.hash(
        name,
        studentClass,
        friendAvatar,
        isOnboardingCompleted,
      );
}
