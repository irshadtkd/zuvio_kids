import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/app_exception.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';
import 'package:zuvio_kids/features/colors/domain/entities/color_progress_entity.dart';
import 'package:zuvio_kids/features/colors/domain/entities/color_session_entity.dart';
import 'package:zuvio_kids/features/colors/domain/repositories/color_repository.dart';
import '../datasources/color_data.dart';
import '../datasources/color_local_datasource.dart';
import '../models/color_progress_model.dart';

/// Repository implementation for Colors learning module.
/// Layer: Data
class ColorRepositoryImpl implements ColorRepository {
  const ColorRepositoryImpl(this._localDataSource);

  final ColorLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, ColorSessionEntity>> getSession(
    String studentName,
  ) async {
    try {
      final progress = await _localDataSource.getProgress(studentName);
      final isCompleted = progress?.isCompleted ?? false;

      final session = ColorData.defaultSession.copyWith(
        isCompleted: isCompleted,
        starsEarned: isCompleted ? 10 : 0,
        currentColorIndex: 0,
      );

      return right(session);
    } on CacheException catch (e, st) {
      AppLogger.error('ColorRepositoryImpl: getSession cache error', e, st);
      return left(CacheFailure(message: e.message));
    } catch (e, st) {
      AppLogger.error('ColorRepositoryImpl: getSession unexpected error', e, st);
      return left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ColorProgressEntity>> getProgress(
    String studentName,
  ) async {
    try {
      final model = await _localDataSource.getProgress(studentName);
      if (model != null) {
        return right(model);
      }
      return right(
        ColorProgressEntity(
          studentName: studentName,
          isCompleted: false,
          totalStars: 0,
        ),
      );
    } on CacheException catch (e, st) {
      AppLogger.error('ColorRepositoryImpl: getProgress cache error', e, st);
      return left(CacheFailure(message: e.message));
    } catch (e, st) {
      AppLogger.error('ColorRepositoryImpl: getProgress unexpected error', e, st);
      return left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ColorProgressEntity>> completeSession(
    String studentName,
  ) async {
    try {
      final current = await _localDataSource.getProgress(studentName);
      final alreadyCompleted = current?.isCompleted ?? false;
      final starsAwarded = alreadyCompleted ? 0 : 10;
      final newTotalStars = (current?.totalStars ?? 0) + starsAwarded;

      final updatedModel = ColorProgressModel(
        studentName: studentName,
        isCompleted: true,
        totalStars: newTotalStars,
      );

      await _localDataSource.saveProgress(updatedModel);
      return right(updatedModel);
    } on CacheException catch (e, st) {
      AppLogger.error('ColorRepositoryImpl: completeSession cache error', e, st);
      return left(CacheFailure(message: e.message));
    } catch (e, st) {
      AppLogger.error(
          'ColorRepositoryImpl: completeSession unexpected error', e, st);
      return left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearProgress(String studentName) async {
    try {
      await _localDataSource.clearProgress(studentName);
      return right(null);
    } on CacheException catch (e, st) {
      AppLogger.error('ColorRepositoryImpl: clearProgress cache error', e, st);
      return left(CacheFailure(message: e.message));
    } catch (e, st) {
      AppLogger.error(
          'ColorRepositoryImpl: clearProgress unexpected error', e, st);
      return left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearAll() async {
    try {
      await _localDataSource.clearAll();
      return right(null);
    } on CacheException catch (e, st) {
      AppLogger.error('ColorRepositoryImpl: clearAll cache error', e, st);
      return left(CacheFailure(message: e.message));
    } catch (e, st) {
      AppLogger.error('ColorRepositoryImpl: clearAll unexpected error', e, st);
      return left(UnexpectedFailure(message: e.toString()));
    }
  }
}
