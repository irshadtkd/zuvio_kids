import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/errors/app_exception.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';
import '../models/number_progress_model.dart';
import 'number_local_datasource.dart';

/// SharedPreferences implementation for storing numbers progress.
/// Layer: Data
class NumberLocalDataSourceImpl implements NumberLocalDataSource {
  const NumberLocalDataSourceImpl();

  String _getKey(String studentName) {
    final clean = studentName.trim().toLowerCase();
    return '${AppStrings.prefNumbersCompletedSessions}$clean';
  }

  @override
  Future<NumberProgressModel?> getProgress(String studentName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_getKey(studentName));
      return NumberProgressModel.deserialize(raw);
    } catch (e, st) {
      AppLogger.error('NumberLocalDataSourceImpl: getProgress failed', e, st);
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> saveProgress(NumberProgressModel model) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_getKey(model.studentName), model.serialize());
    } catch (e, st) {
      AppLogger.error('NumberLocalDataSourceImpl: saveProgress failed', e, st);
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> clearProgress(String studentName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_getKey(studentName));
    } catch (e, st) {
      AppLogger.error('NumberLocalDataSourceImpl: clearProgress failed', e, st);
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();
      final numberKeys = allKeys.where((key) =>
          key.startsWith(AppStrings.prefNumbersCompletedSessions) ||
          key.startsWith(AppStrings.prefNumbersStars));

      for (final key in numberKeys.toList()) {
        await prefs.remove(key);
      }
    } catch (e, st) {
      AppLogger.error('NumberLocalDataSourceImpl: clearAll failed', e, st);
      throw CacheException(message: e.toString());
    }
  }
}
