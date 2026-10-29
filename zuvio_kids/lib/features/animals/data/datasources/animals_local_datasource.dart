import '../models/animal_session_model.dart';

/// Abstract local data source interface for animals curriculum and progress.
/// Layer: Data Source Interface
abstract interface class AnimalsLocalDataSource {
  /// Loads all animal sessions populated with local progress.
  Future<List<AnimalSessionModel>> getSessions();

  /// Saves session completion and stars earned.
  Future<void> saveSessionCompleted(String sessionId, int stars);

  /// Resets all animal progress in local storage.
  Future<void> resetProgress();
}
