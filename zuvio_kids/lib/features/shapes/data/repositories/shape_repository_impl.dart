import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/app_exception.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';
import 'package:zuvio_kids/features/shapes/domain/entities/shape_progress_entity.dart';
import 'package:zuvio_kids/features/shapes/domain/entities/shape_session_entity.dart';
import 'package:zuvio_kids/features/shapes/domain/repositories/shape_repository.dart';
import '../datasources/shape_data.dart';
import '../datasources/shape_local_datasource.dart';
import '../models/shape_progress_model.dart';

/// Repository implementation for Shapes learning.
/// Layer: Data
class ShapeRepositoryImpl implements ShapeRepository {
  const ShapeRepositoryImpl(this._localDataSource);

  final ShapeLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<ShapeSessionEntity>>> getSessions(
    String studentName,
  ) async {
    try {
      final progress = await _localDataSource.getProgress(studentName);
      final completed = progress?.completedSessionIds.toSet() ?? <String>{};

      final sessions = ShapeData.getDefaultSessions().map((base) {
        final isCompleted = completed.contains(base.id);
        final priorId = 'session_${base.sessionNumber - 1}';
        final isUnlocked = base.sessionNumber == 1 || completed.contains(priorId);

        return base.copyWith(
          isCompleted: isCompleted,
          isLocked: !isUnlocked,
          starsEarned: isCompleted ? 10 : 0,
        );
      }).toList();

      return right(sessions);
    } on CacheException catch (e, st) {
      AppLogger.error('ShapeRepositoryImpl: getSessions cache error', e, st);
      return left(CacheFailure(message: e.message));
    } catch (e, st) {
      AppLogger.error('ShapeRepositoryImpl: getSessions error', e, st);
      return left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ShapeProgressEntity>> getProgress(
    String studentName,
  ) async {
    try {
      final model = await _localDataSource.getProgress(studentName);
      if (model != null) {
        return right(model);
      }
      return right(
        ShapeProgressEntity(
          studentName: studentName,
          completedSessionIds: const <String>[],
          unlockedSessionIds: const <String>['session_1'],
          totalStars: 0,
        ),
      );
    } on CacheException catch (e, st) {
      AppLogger.error('ShapeRepositoryImpl: getProgress cache error', e, st);
      return left(CacheFailure(message: e.message));
    } catch (e, st) {
      AppLogger.error('ShapeRepositoryImpl: getProgress error', e, st);
      return left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> completeSession(
    String studentName,
    String sessionId,
  ) async {
    try {
      final current = await _localDataSource.getProgress(studentName);
      final completed = List<String>.from(current?.completedSessionIds ?? <String>[]);
      final unlocked = List<String>.from(current?.unlockedSessionIds ?? <String>['session_1']);

      final isAlreadyCompleted = completed.contains(sessionId);
      final starsAwarded = isAlreadyCompleted ? 0 : 10;
      final newTotalStars = (current?.totalStars ?? 0) + starsAwarded;

      if (!isAlreadyCompleted) {
        completed.add(sessionId);
      }

      // Unlock next session
      final sessionNum = int.tryParse(sessionId.replaceAll('session_', '')) ?? 1;
      final nextSessionId = 'session_${sessionNum + 1}';
      if (!unlocked.contains(nextSessionId) && sessionNum < 4) {
        unlocked.add(nextSessionId);
      }

      final updatedModel = ShapeProgressModel(
        studentName: studentName,
        completedSessionIds: completed,
        unlockedSessionIds: unlocked,
        totalStars: newTotalStars,
      );

      await _localDataSource.saveProgress(updatedModel);
      return right(unit);
    } on CacheException catch (e, st) {
      AppLogger.error('ShapeRepositoryImpl: completeSession cache error', e, st);
      return left(CacheFailure(message: e.message));
    } catch (e, st) {
      AppLogger.error('ShapeRepositoryImpl: completeSession error', e, st);
      return left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearProgress() async {
    try {
      await _localDataSource.clearAll();
      return right(unit);
    } on CacheException catch (e, st) {
      AppLogger.error('ShapeRepositoryImpl: clearProgress cache error', e, st);
      return left(CacheFailure(message: e.message));
    } catch (e, st) {
      AppLogger.error('ShapeRepositoryImpl: clearProgress error', e, st);
      return left(UnexpectedFailure(message: e.toString()));
    }
  }
}
