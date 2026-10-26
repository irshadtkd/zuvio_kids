import '../models/user_profile_model.dart';

/// Abstract interface for local storage access for onboarding.
/// Layer: Data
abstract interface class OnboardingLocalDataSource {
  Future<UserProfileModel?> getUserProfile();

  Future<void> saveUserProfile(UserProfileModel model);

  Future<void> clearUserProfile();
}
