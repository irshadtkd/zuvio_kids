import 'package:zuvio_kids/core/constants/app_strings.dart';
import '../../domain/entities/user_profile_entity.dart';

/// Data transfer object for UserProfileEntity with JSON serialization.
/// Layer: Data
class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.name,
    required super.studentClass,
    required super.friendAvatar,
    super.isOnboardingCompleted = false,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        name: json['name'] as String? ?? '',
        studentClass: json['studentClass'] as String? ?? '',
        friendAvatar: json['friendAvatar'] as String? ?? AppStrings.defaultFriend,
        isOnboardingCompleted:
            json['isOnboardingCompleted'] as bool? ?? false,
      );

  factory UserProfileModel.fromEntity(UserProfileEntity entity) =>
      UserProfileModel(
        name: entity.name,
        studentClass: entity.studentClass,
        friendAvatar: entity.friendAvatar,
        isOnboardingCompleted: entity.isOnboardingCompleted,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'studentClass': studentClass,
        'friendAvatar': friendAvatar,
        'isOnboardingCompleted': isOnboardingCompleted,
      };
}
