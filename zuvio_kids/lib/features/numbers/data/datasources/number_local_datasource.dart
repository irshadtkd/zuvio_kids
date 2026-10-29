import '../models/number_progress_model.dart';

/// Abstract local data source for reading/writing numbers progress.
/// Layer: Data
abstract interface class NumberLocalDataSource {
  /// Fetches saved progress for [studentName], or null if none saved yet.
  Future<NumberProgressModel?> getProgress(String studentName);

  /// Saves the updated [model] to local storage.
  Future<void> saveProgress(NumberProgressModel model);

  /// Removes saved progress for [studentName].
  Future<void> clearProgress(String studentName);

  /// Clears all numbers progress data across all stored profiles (called on logout).
  Future<void> clearAll();
}
