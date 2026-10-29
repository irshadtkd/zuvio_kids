import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../../domain/entities/puzzle_session_entity.dart';
import '../../domain/repositories/puzzle_repository.dart';
import '../datasources/puzzle_generator.dart';
import '../datasources/puzzle_local_datasource.dart';

/// Repository implementation for randomized puzzle generation and completion tracking.
/// Layer: Data Repository Implementation
class PuzzleRepositoryImpl implements PuzzleRepository {
  const PuzzleRepositoryImpl({
    required PuzzleLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  final PuzzleLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<PuzzleSessionEntity>>> generateNewPuzzleSet() async {
    try {
      final completedVariations =
          await _localDataSource.getCompletedVariationKeys();

      final sessions = PuzzleGenerator.generatePuzzleSet(
        completedVariationKeys: completedVariations,
        onHistoryResetNeeded:
            _localDataSource.resetVariationHistoryForCategory,
      );

      return Right(sessions);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> markVariationCompleted(String variationKey) async {
    try {
      if (variationKey.isNotEmpty) {
        await _localDataSource.saveCompletedVariationKey(variationKey);
      }
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearProgress() async {
    try {
      await _localDataSource.clearCompletedSessions();
      await _localDataSource.clearVariationHistory();
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
