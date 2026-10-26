import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/onboarding_repository.dart';

/// Persists the user profile to local storage.
class SaveUserProfile {
  const SaveUserProfile(this._repository);

  final OnboardingRepository _repository;

  Future<Either<Failure, void>> call(UserProfileEntity profile) =>
      _repository.saveUserProfile(profile);
}
