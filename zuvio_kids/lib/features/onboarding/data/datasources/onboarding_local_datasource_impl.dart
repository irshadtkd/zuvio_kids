import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/errors/app_exception.dart';
import '../models/user_profile_model.dart';
import 'onboarding_local_datasource.dart';

/// Implementation of [OnboardingLocalDataSource] using [SharedPreferences].
/// Layer: Data
class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  const OnboardingLocalDataSourceImpl([this._prefs]);

  final SharedPreferences? _prefs;

  Future<SharedPreferences> get _instance async =>
      _prefs ?? await SharedPreferences.getInstance();

  @override
  Future<UserProfileModel?> getUserProfile() async {
    try {
      final prefs = await _instance;
      final isDone = prefs.getBool(AppStrings.prefOnboardingDone) ?? false;
      final name = prefs.getString(AppStrings.prefUserName);
      final studentClass = prefs.getString(AppStrings.prefUserClass);
      final friendAvatar = prefs.getString(AppStrings.prefUserFriend);

      if (!isDone || name == null || name.isEmpty) {
        return null;
      }

      return UserProfileModel(
        name: name,
        studentClass: studentClass ?? '',
        friendAvatar: friendAvatar ?? AppStrings.defaultFriend,
        isOnboardingCompleted: isDone,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to read user profile: $e');
    }
  }

  @override
  Future<void> saveUserProfile(UserProfileModel model) async {
    try {
      final prefs = await _instance;
      await prefs.setBool(
        AppStrings.prefOnboardingDone,
        model.isOnboardingCompleted,
      );
      await prefs.setString(AppStrings.prefUserName, model.name);
      await prefs.setString(AppStrings.prefUserClass, model.studentClass);
      await prefs.setString(AppStrings.prefUserFriend, model.friendAvatar);
    } catch (e) {
      throw CacheException(message: 'Failed to save user profile: $e');
    }
  }

  @override
  Future<void> clearUserProfile() async {
    try {
      final prefs = await _instance;
      await prefs.remove(AppStrings.prefOnboardingDone);
      await prefs.remove(AppStrings.prefUserName);
      await prefs.remove(AppStrings.prefUserClass);
      await prefs.remove(AppStrings.prefUserFriend);
    } catch (e) {
      throw CacheException(message: 'Failed to clear user profile: $e');
    }
  }
}
