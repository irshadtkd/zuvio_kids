import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../repositories/onboarding_repository.dart';

/// Clears the saved user profile from local storage.
class ClearUserProfile {
  const ClearUserProfile(this._repository);

  final OnboardingRepository _repository;

  Future<Either<Failure, void>> call() =>
      _repository.clearUserProfile();
}
