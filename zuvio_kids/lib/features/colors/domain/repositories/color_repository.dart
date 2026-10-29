import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/color_progress_entity.dart';
import '../entities/color_session_entity.dart';

/// Abstract repository interface for Colors learning module.
/// Layer: Domain (pure Dart)
abstract interface class ColorRepository {
  /// Fetches the Colors learning session mapped to current student progress.
  Future<Either<Failure, ColorSessionEntity>> getSession(String studentName);

  /// Fetches the colors progress (completed status, total stars) for [studentName].
  Future<Either<Failure, ColorProgressEntity>> getProgress(String studentName);

  /// Completes the Colors session for [studentName], awarding 10 stars if not already awarded.
  Future<Either<Failure, ColorProgressEntity>> completeSession(String studentName);

  /// Clears stored colors learning progress for [studentName].
  Future<Either<Failure, void>> clearProgress(String studentName);

  /// Clears all colors learning data across all stored profiles (called on logout).
  Future<Either<Failure, void>> clearAll();
}
