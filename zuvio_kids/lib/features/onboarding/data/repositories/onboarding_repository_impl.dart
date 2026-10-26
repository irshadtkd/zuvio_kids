import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/app_exception.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import 'package:zuvio_kids/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:zuvio_kids/features/onboarding/data/models/user_profile_model.dart';
import 'package:zuvio_kids/features/onboarding/domain/entities/user_profile_entity.dart';
import 'package:zuvio_kids/features/onboarding/domain/repositories/onboarding_repository.dart';

/// Repository implementation for onboarding & local user profile.
/// Layer: Data
class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._localDataSource);

  final OnboardingLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, UserProfileEntity?>> getUserProfile() async {
    try {
      final model = await _localDataSource.getUserProfile();
      return right(model);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    } catch (e) {
      return left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveUserProfile(
      UserProfileEntity profile) async {
    try {
      final model = UserProfileModel.fromEntity(profile);
      await _localDataSource.saveUserProfile(model);
      return right(null);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    } catch (e) {
      return left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearUserProfile() async {
    try {
      await _localDataSource.clearUserProfile();
      return right(null);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    } catch (e) {
      return left(UnexpectedFailure(message: e.toString()));
    }
  }
}
