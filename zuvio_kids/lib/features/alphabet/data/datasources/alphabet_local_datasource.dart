import '../models/alphabet_progress_model.dart';

/// Abstract interface for alphabet module local storage.
/// Layer: Data
abstract interface class AlphabetLocalDataSource {
  /// Fetches saved progress for student.
  Future<AlphabetProgressModel?> getProgress(String studentName);

  /// Saves progress for student.
  Future<void> saveProgress(AlphabetProgressModel model);

  /// Clears alphabet progress for a specific student.
  Future<void> clearProgress(String studentName);

  /// Clears all alphabet progress across all keys (called on logout/profile reset).
  Future<void> clearAll();
}
