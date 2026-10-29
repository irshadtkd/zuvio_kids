import '../models/color_progress_model.dart';

/// Abstract local data source for reading/writing Colors progress.
/// Layer: Data
abstract interface class ColorLocalDataSource {
  Future<ColorProgressModel?> getProgress(String studentName);
  Future<void> saveProgress(ColorProgressModel model);
  Future<void> clearProgress(String studentName);
  Future<void> clearAll();
}
