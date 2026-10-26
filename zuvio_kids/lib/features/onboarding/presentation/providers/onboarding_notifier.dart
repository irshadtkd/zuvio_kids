import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/features/onboarding/domain/entities/user_profile_entity.dart';
import 'onboarding_provider.dart';
import 'onboarding_state.dart';

class OnboardingNotifier extends AsyncNotifier<OnboardingState> {
  @override
  Future<OnboardingState> build() async {
    final getUserProfile = ref.read(getUserProfileUseCaseProvider);
    final result = await getUserProfile();
    return result.fold(
      (failure) => const OnboardingState(),
      (profile) => OnboardingState(
        name: profile?.name.isNotEmpty == true
            ? profile!.name
            : AppStrings.defaultChildName,
        studentClass: profile?.studentClass.isNotEmpty == true
            ? profile!.studentClass
            : AppStrings.defaultClass,
        friendAvatar: profile?.friendAvatar.isNotEmpty == true
            ? profile!.friendAvatar
            : AppStrings.defaultFriend,
        userProfile: profile,
      ),
    );
  }

  void setName(String name) {
    final current = state.valueOrNull ?? const OnboardingState();
    state = AsyncData(current.copyWith(name: name));
  }

  void setClass(String studentClass) {
    final current = state.valueOrNull ?? const OnboardingState();
    state = AsyncData(current.copyWith(studentClass: studentClass));
  }

  void setFriend(String friend) {
    final current = state.valueOrNull ?? const OnboardingState();
    state = AsyncData(current.copyWith(friendAvatar: friend));
  }

  void goToStep(int step) {
    final current = state.valueOrNull ?? const OnboardingState();
    state = AsyncData(current.copyWith(currentStep: step));
  }

  void nextStep() {
    final current = state.valueOrNull ?? const OnboardingState();
    if (current.currentStep < 2) {
      state = AsyncData(current.copyWith(currentStep: current.currentStep + 1));
    }
  }

  void previousStep() {
    final current = state.valueOrNull ?? const OnboardingState();
    if (current.currentStep > 0) {
      state = AsyncData(current.copyWith(currentStep: current.currentStep - 1));
    }
  }

  Future<bool> completeOnboarding() async {
    final current = state.valueOrNull ?? const OnboardingState();
    final profile = UserProfileEntity(
      name: current.name.trim().isEmpty
          ? AppStrings.defaultChildName
          : current.name.trim(),
      studentClass: current.studentClass.isEmpty
          ? AppStrings.defaultClass
          : current.studentClass,
      friendAvatar: current.friendAvatar.isEmpty
          ? AppStrings.defaultFriend
          : current.friendAvatar,
      isOnboardingCompleted: true,
    );

    final saveUseCase = ref.read(saveUserProfileUseCaseProvider);
    final result = await saveUseCase(profile);

    return result.fold(
      (failure) => false,
      (_) {
        state = AsyncData(
          current.copyWith(
            userProfile: profile,
            name: profile.name,
            studentClass: profile.studentClass,
            friendAvatar: profile.friendAvatar,
          ),
        );
        return true;
      },
    );
  }

  Future<void> resetProfile() async {
    final clearUseCase = ref.read(clearUserProfileUseCaseProvider);
    await clearUseCase();
    state = const AsyncData(OnboardingState());
  }
}
