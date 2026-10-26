import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/features/onboarding/data/datasources/onboarding_local_datasource_impl.dart';
import 'package:zuvio_kids/features/onboarding/data/models/user_profile_model.dart';
import 'package:zuvio_kids/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:zuvio_kids/features/onboarding/domain/entities/user_profile_entity.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding Local Data Source & Repository Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('returns null when no user profile is stored', () async {
      const dataSource = OnboardingLocalDataSourceImpl();
      const repository = OnboardingRepositoryImpl(dataSource);

      final result = await repository.getUserProfile();
      result.fold(
        (failure) => fail('Expected right, got failure: $failure'),
        (profile) => expect(profile, isNull),
      );
    });

    test('persists user profile to local storage and retrieves it', () async {
      const dataSource = OnboardingLocalDataSourceImpl();
      const repository = OnboardingRepositoryImpl(dataSource);

      const profile = UserProfileEntity(
        name: 'Mia',
        studentClass: 'LKG',
        friendAvatar: 'panda',
        isOnboardingCompleted: true,
      );

      final saveResult = await repository.saveUserProfile(profile);
      expect(saveResult.isRight(), isTrue);

      final getResult = await repository.getUserProfile();
      getResult.fold(
        (failure) => fail('Expected right, got failure: $failure'),
        (savedProfile) {
          expect(savedProfile, isNotNull);
          expect(savedProfile!.name, 'Mia');
          expect(savedProfile.studentClass, 'LKG');
          expect(savedProfile.friendAvatar, 'panda');
          expect(savedProfile.isOnboardingCompleted, isTrue);
        },
      );
    });

    test('clearUserProfile removes all keys from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        AppStrings.prefOnboardingDone: true,
        AppStrings.prefUserName: 'Mia',
        AppStrings.prefUserClass: 'LKG',
        AppStrings.prefUserFriend: 'panda',
      });

      const dataSource = OnboardingLocalDataSourceImpl();
      const repository = OnboardingRepositoryImpl(dataSource);

      final clearResult = await repository.clearUserProfile();
      expect(clearResult.isRight(), isTrue);

      final getResult = await repository.getUserProfile();
      getResult.fold(
        (failure) => fail('Expected right, got failure: $failure'),
        (profile) => expect(profile, isNull),
      );
    });

    test('UserProfileModel serialization works correctly', () {
      const model = UserProfileModel(
        name: 'Leo',
        studentClass: 'UKG',
        friendAvatar: 'lion',
        isOnboardingCompleted: true,
      );

      final json = model.toJson();
      expect(json['name'], 'Leo');
      expect(json['studentClass'], 'UKG');
      expect(json['friendAvatar'], 'lion');
      expect(json['isOnboardingCompleted'], isTrue);

      final fromJson = UserProfileModel.fromJson(json);
      expect(fromJson.name, 'Leo');
      expect(fromJson.studentClass, 'UKG');
      expect(fromJson.friendAvatar, 'lion');
      expect(fromJson.isOnboardingCompleted, isTrue);
    });
  });
}
