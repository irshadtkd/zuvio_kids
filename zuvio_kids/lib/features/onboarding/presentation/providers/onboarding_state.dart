import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/features/onboarding/domain/entities/user_profile_entity.dart';

/// State of the onboarding flow and current child user draft.
class OnboardingState {
  const OnboardingState({
    this.name = AppStrings.defaultChildName,
    this.studentClass = AppStrings.defaultClass,
    this.friendAvatar = AppStrings.defaultFriend,
    this.currentStep = 0,
    this.isLoading = false,
    this.userProfile,
  });

  final String name;
  final String studentClass;
  final String friendAvatar;
  final int currentStep;
  final bool isLoading;
  final UserProfileEntity? userProfile;

  bool get isCompleted => userProfile?.isOnboardingCompleted ?? false;

  OnboardingState copyWith({
    String? name,
    String? studentClass,
    String? friendAvatar,
    int? currentStep,
    bool? isLoading,
    UserProfileEntity? userProfile,
    bool clearUserProfile = false,
  }) {
    return OnboardingState(
      name: name ?? this.name,
      studentClass: studentClass ?? this.studentClass,
      friendAvatar: friendAvatar ?? this.friendAvatar,
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      userProfile:
          clearUserProfile ? null : (userProfile ?? this.userProfile),
    );
  }
}
