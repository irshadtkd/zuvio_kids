import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/onboarding_repository.dart';

/// Retrieves the saved user profile from storage.
class GetUserProfile {
  const GetUserProfile(this._repository);

  final OnboardingRepository _repository;

  Future<Either<Failure, UserProfileEntity?>> call() =>
      _repository.getUserProfile();
}
