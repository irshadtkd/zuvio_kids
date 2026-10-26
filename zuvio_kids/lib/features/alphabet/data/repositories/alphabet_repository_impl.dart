import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/errors/app_exception.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';
import 'package:zuvio_kids/features/alphabet/domain/entities/alphabet_progress_entity.dart';
import 'package:zuvio_kids/features/alphabet/domain/entities/alphabet_session_entity.dart';
import 'package:zuvio_kids/features/alphabet/domain/repositories/alphabet_repository.dart';
import '../datasources/alphabet_letter_data.dart';
import '../datasources/alphabet_local_datasource.dart';
import '../models/alphabet_progress_model.dart';

/// Implementation of AlphabetRepository using local data source and static letter data.
/// Layer: Data
class AlphabetRepositoryImpl implements AlphabetRepository {
  const AlphabetRepositoryImpl(this._localDataSource);

  final AlphabetLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<AlphabetSessionEntity>>> getSessions(
    String studentName,
  ) async {
    try {
      final savedProgress = await _localDataSource.getProgress(studentName);
      final completed = savedProgress?.completedSessionIds ?? <String>{};

      const capLetters = AlphabetLetterData.capitalLetters;
      final smLetters = AlphabetLetterData.smallLetters;

      // Session 1: A–L (first 12 capital) — Incomplete sessions always start from index 0
      final session1Completed = completed.contains(AppStrings.sessionCapital1);
      final session1 = AlphabetSessionEntity(
        id: AppStrings.sessionCapital1,
        sessionNumber: 1,
        isCapital: true,
        letterRange: 'A–L',
        letters: capLetters.sublist(0, 12),
        isCompleted: session1Completed,
        isLocked: false,
        starsEarned: session1Completed ? 10 : 0,
      );

      // Session 2: M–Z (remaining 14 capital)
      final session2Completed = completed.contains(AppStrings.sessionCapital2);
      final session2 = AlphabetSessionEntity(
        id: AppStrings.sessionCapital2,
        sessionNumber: 2,
        isCapital: true,
        letterRange: 'M–Z',
        letters: capLetters.sublist(12, 26),
        isCompleted: session2Completed,
        isLocked: !session1Completed,
        starsEarned: session2Completed ? 10 : 0,
      );

      // Session 3: a–l (first 12 small)
      final session3Completed = completed.contains(AppStrings.sessionSmall3);
      final session3 = AlphabetSessionEntity(
        id: AppStrings.sessionSmall3,
        sessionNumber: 3,
        isCapital: false,
        letterRange: 'a–l',
        letters: smLetters.sublist(0, 12),
        isCompleted: session3Completed,
        isLocked: !session2Completed,
        starsEarned: session3Completed ? 10 : 0,
      );

      // Session 4: m–z (remaining 14 small)
      final session4Completed = completed.contains(AppStrings.sessionSmall4);
      final session4 = AlphabetSessionEntity(
        id: AppStrings.sessionSmall4,
        sessionNumber: 4,
        isCapital: false,
        letterRange: 'm–z',
        letters: smLetters.sublist(12, 26),
        isCompleted: session4Completed,
        isLocked: !session3Completed,
        starsEarned: session4Completed ? 10 : 0,
      );

      return right([session1, session2, session3, session4]);
    } on CacheException catch (e, st) {
      AppLogger.error('AlphabetRepositoryImpl: getSessions cache error', e, st);
      return left(CacheFailure(message: e.message));
    } catch (e, st) {
      AppLogger.error('AlphabetRepositoryImpl: getSessions unexpected', e, st);
      return left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AlphabetProgressEntity>> getProgress(
    String studentName,
  ) async {
    try {
      final saved = await _localDataSource.getProgress(studentName);
      if (saved != null) return right(saved);

      return right(AlphabetProgressEntity(
        studentName: studentName,
        completedSessionIds: <String>{},
        totalStars: 0,
      ));
    } on CacheException catch (e, st) {
      AppLogger.error('AlphabetRepositoryImpl: getProgress cache error', e, st);
      return left(CacheFailure(message: e.message));
    } catch (e, st) {
      AppLogger.error('AlphabetRepositoryImpl: getProgress unexpected', e, st);
      return left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AlphabetProgressEntity>> completeSession({
    required String studentName,
    required String sessionId,
  }) async {
    try {
      final current = await _localDataSource.getProgress(studentName) ??
          AlphabetProgressModel(
            studentName: studentName,
            completedSessionIds: <String>{},
            totalStars: 0,
          );

      final wasCompleted = current.completedSessionIds.contains(sessionId);
      final newCompleted = Set<String>.from(current.completedSessionIds)
        ..add(sessionId);

      // Award 10 stars only once per session
      final newStars = wasCompleted ? current.totalStars : current.totalStars + 10;

      final updated = AlphabetProgressModel(
        studentName: studentName,
        completedSessionIds: newCompleted,
        totalStars: newStars,
      );

      await _localDataSource.saveProgress(updated);
      return right(updated);
    } on CacheException catch (e, st) {
      AppLogger.error('AlphabetRepositoryImpl: completeSession cache error', e, st);
      return left(CacheFailure(message: e.message));
    } catch (e, st) {
      AppLogger.error('AlphabetRepositoryImpl: completeSession unexpected', e, st);
      return left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearProgress(String studentName) async {
    try {
      await _localDataSource.clearProgress(studentName);
      return right(null);
    } on CacheException catch (e, st) {
      AppLogger.error('AlphabetRepositoryImpl: clearProgress cache error', e, st);
      return left(CacheFailure(message: e.message));
    } catch (e, st) {
      AppLogger.error('AlphabetRepositoryImpl: clearProgress unexpected', e, st);
      return left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearAll() async {
    try {
      await _localDataSource.clearAll();
      return right(null);
    } on CacheException catch (e, st) {
      AppLogger.error('AlphabetRepositoryImpl: clearAll cache error', e, st);
      return left(CacheFailure(message: e.message));
    } catch (e, st) {
      AppLogger.error('AlphabetRepositoryImpl: clearAll unexpected', e, st);
      return left(UnexpectedFailure(message: e.toString()));
    }
  }
}
