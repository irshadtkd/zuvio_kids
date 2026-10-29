import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/animal_session_entity.dart';

/// Abstract repository contract for Animal Learning.
/// Layer: Domain (pure Dart)
abstract interface class AnimalsRepository {
  /// Loads all animal learning sessions with user progress and star status.
  Future<Either<Failure, List<AnimalSessionEntity>>> getSessions();

  /// Saves progress for a completed session.
  Future<Either<Failure, void>> saveSessionCompleted(String sessionId, int stars);

  /// Clears stored animal session progress.
  Future<Either<Failure, void>> resetProgress();
}
