import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/errors/app_exception.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';
import '../models/color_progress_model.dart';
import 'color_local_datasource.dart';

/// SharedPreferences implementation for storing Colors progress.
/// Layer: Data
class ColorLocalDataSourceImpl implements ColorLocalDataSource {
  const ColorLocalDataSourceImpl();

  String _getKey(String studentName) {
    final clean = studentName.trim().toLowerCase();
    return '${AppStrings.prefColorsCompleted}$clean';
  }

  @override
  Future<ColorProgressModel?> getProgress(String studentName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_getKey(studentName));
      return ColorProgressModel.deserialize(raw);
    } catch (e, st) {
      AppLogger.error('ColorLocalDataSourceImpl: getProgress failed', e, st);
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> saveProgress(ColorProgressModel model) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_getKey(model.studentName), model.serialize());
    } catch (e, st) {
      AppLogger.error('ColorLocalDataSourceImpl: saveProgress failed', e, st);
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> clearProgress(String studentName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_getKey(studentName));
    } catch (e, st) {
      AppLogger.error('ColorLocalDataSourceImpl: clearProgress failed', e, st);
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();
      final colorKeys = allKeys.where((key) =>
          key.startsWith(AppStrings.prefColorsCompleted) ||
          key.startsWith(AppStrings.prefColorsStars));

      for (final key in colorKeys.toList()) {
        await prefs.remove(key);
      }
    } catch (e, st) {
      AppLogger.error('ColorLocalDataSourceImpl: clearAll failed', e, st);
      throw CacheException(message: e.toString());
    }
  }
}
