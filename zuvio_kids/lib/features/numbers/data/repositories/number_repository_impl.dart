import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/app_exception.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';
import 'package:zuvio_kids/features/numbers/domain/entities/number_progress_entity.dart';
import 'package:zuvio_kids/features/numbers/domain/entities/number_session_entity.dart';
import 'package:zuvio_kids/features/numbers/domain/repositories/number_repository.dart';
import '../datasources/number_data.dart';
import '../datasources/number_local_datasource.dart';
import '../models/number_progress_model.dart';

/// Repository implementation for Numbers learning module.
/// Layer: Data
class NumberRepositoryImpl implements NumberRepository {
  const NumberRepositoryImpl(this._localDataSource);

  final NumberLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<NumberSessionEntity>>> getSessions(
    String studentName,
  ) async {
    try {
      final progress = await _localDataSource.getProgress(studentName);
      final completedIds = progress?.completedSessionIds ?? <String>{};

      // 10 sessions. Session 1 is unlocked by default.
      // Session N (where N > 1) is unlocked if Session N - 1 is completed.
      final sessions = NumberData.defaultSessions.map((baseSession) {
        final isCompleted = completedIds.contains(baseSession.id);
        final priorSessionId = 'session_${baseSession.sessionNumber - 1}';
        final isUnlocked = baseSession.sessionNumber == 1 ||
            completedIds.contains(priorSessionId);

        return baseSession.copyWith(
          isCompleted: isCompleted,
          isLocked: !isUnlocked,
          starsEarned: isCompleted ? 10 : 0,
        );
      }).toList();

      return right(sessions);
    } on CacheException catch (e, st) {
      AppLogger.error('NumberRepositoryImpl: getSessions cache error', e, st);
      return left(CacheFailure(message: e.message));
    } catch (e, st) {
      AppLogger.error('NumberRepositoryImpl: getSessions unexpected error', e, st);
      return left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, NumberProgressEntity>> getProgress(
    String studentName,
  ) async {
    try {
      final model = await _localDataSource.getProgress(studentName);
      if (model != null) {
        return right(model);
      }
      return right(
        NumberProgressEntity(
          studentName: studentName,
          completedSessionIds: const <String>{},
          totalStars: 0,
        ),
      );
    } on CacheException catch (e, st) {
      AppLogger.error('NumberRepositoryImpl: getProgress cache error', e, st);
      return left(CacheFailure(message: e.message));
    } catch (e, st) {
      AppLogger.error('NumberRepositoryImpl: getProgress unexpected error', e, st);
      return left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, NumberProgressEntity>> completeSession({
    required String studentName,
    required String sessionId,
  }) async {
    try {
      final current = await _localDataSource.getProgress(studentName);
      final completed = Set<String>.from(
        current?.completedSessionIds ?? <String>{},
      );

      final isAlreadyCompleted = completed.contains(sessionId);
      final starsAwarded = isAlreadyCompleted ? 0 : 10;
      final newTotalStars = (current?.totalStars ?? 0) + starsAwarded;

      completed.add(sessionId);

      final updatedModel = NumberProgressModel(
        studentName: studentName,
        completedSessionIds: completed,
        totalStars: newTotalStars,
      );

      await _localDataSource.saveProgress(updatedModel);
      return right(updatedModel);
    } on CacheException catch (e, st) {
      AppLogger.error('NumberRepositoryImpl: completeSession cache error', e, st);
      return left(CacheFailure(message: e.message));
    } catch (e, st) {
      AppLogger.error(
          'NumberRepositoryImpl: completeSession unexpected error', e, st);
      return left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearProgress(String studentName) async {
    try {
      await _localDataSource.clearProgress(studentName);
      return right(null);
    } on CacheException catch (e, st) {
      AppLogger.error('NumberRepositoryImpl: clearProgress cache error', e, st);
      return left(CacheFailure(message: e.message));
    } catch (e, st) {
      AppLogger.error('NumberRepositoryImpl: clearProgress unexpected error', e, st);
      return left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearAll() async {
    try {
      await _localDataSource.clearAll();
      return right(null);
    } on CacheException catch (e, st) {
      AppLogger.error('NumberRepositoryImpl: clearAll cache error', e, st);
      return left(CacheFailure(message: e.message));
    } catch (e, st) {
      AppLogger.error('NumberRepositoryImpl: clearAll unexpected error', e, st);
      return left(UnexpectedFailure(message: e.toString()));
    }
  }
}
