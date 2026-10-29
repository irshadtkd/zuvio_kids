import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/errors/app_exception.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';
import '../models/shape_progress_model.dart';
import 'shape_local_datasource.dart';

/// SharedPreferences implementation for storing Shapes learning progress.
/// Layer: Data
class ShapeLocalDataSourceImpl implements ShapeLocalDataSource {
  const ShapeLocalDataSourceImpl();

  String _getKey(String studentName) {
    final clean = studentName.trim().toLowerCase();
    return '${AppStrings.prefShapesCompletedSessions}$clean';
  }

  @override
  Future<ShapeProgressModel?> getProgress(String studentName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_getKey(studentName));
      return ShapeProgressModel.deserialize(raw);
    } catch (e, st) {
      AppLogger.error('ShapeLocalDataSourceImpl: getProgress failed', e, st);
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> saveProgress(ShapeProgressModel model) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_getKey(model.studentName), model.serialize());
    } catch (e, st) {
      AppLogger.error('ShapeLocalDataSourceImpl: saveProgress failed', e, st);
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> clearProgress(String studentName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_getKey(studentName));
    } catch (e, st) {
      AppLogger.error('ShapeLocalDataSourceImpl: clearProgress failed', e, st);
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();
      final shapeKeys = allKeys.where(
        (key) =>
            key.startsWith(AppStrings.prefShapesCompletedSessions) ||
            key.startsWith(AppStrings.prefShapesUnlockedSessions) ||
            key.startsWith(AppStrings.prefShapesStars),
      );
      for (final key in shapeKeys) {
        await prefs.remove(key);
      }
    } catch (e, st) {
      AppLogger.error('ShapeLocalDataSourceImpl: clearAll failed', e, st);
      throw CacheException(message: e.toString());
    }
  }
}
