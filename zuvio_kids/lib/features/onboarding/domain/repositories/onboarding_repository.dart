import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/user_profile_entity.dart';

/// Abstract interface for onboarding and local user profile operations.
/// Layer: Domain
abstract interface class OnboardingRepository {
  /// Fetches saved user profile from local storage, or null if none saved.
  Future<Either<Failure, UserProfileEntity?>> getUserProfile();

  /// Persists user profile to local storage.
  Future<Either<Failure, void>> saveUserProfile(UserProfileEntity profile);

  /// Clears stored user profile (e.g. for reset or testing).
  Future<Either<Failure, void>> clearUserProfile();
}
