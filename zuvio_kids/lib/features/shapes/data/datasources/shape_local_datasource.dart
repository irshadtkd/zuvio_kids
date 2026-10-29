import '../models/shape_progress_model.dart';

/// Abstract contract for local caching of Shapes learning progress.
/// Layer: Data
abstract interface class ShapeLocalDataSource {
  /// Loads saved shapes progress for [studentName].
  Future<ShapeProgressModel?> getProgress(String studentName);

  /// Saves updated shapes progress for [model].
  Future<void> saveProgress(ShapeProgressModel model);

  /// Clears stored progress for [studentName].
  Future<void> clearProgress(String studentName);

  /// Clears all shape progress for all users (e.g. on global reset / logout).
  Future<void> clearAll();
}
