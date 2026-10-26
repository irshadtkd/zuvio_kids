import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/errors/app_exception.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';
import '../models/alphabet_progress_model.dart';
import 'alphabet_local_datasource.dart';

/// SharedPreferences implementation for storing alphabet progress.
/// Layer: Data
class AlphabetLocalDataSourceImpl implements AlphabetLocalDataSource {
  const AlphabetLocalDataSourceImpl();

  String _getKey(String studentName) {
    final clean = studentName.trim().toLowerCase();
    return '${AppStrings.prefAlphabetCompletedSessions}$clean';
  }

  @override
  Future<AlphabetProgressModel?> getProgress(String studentName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_getKey(studentName));
      return AlphabetProgressModel.deserialize(raw);
    } catch (e, st) {
      AppLogger.error('AlphabetLocalDataSourceImpl: getProgress failed', e, st);
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> saveProgress(AlphabetProgressModel model) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_getKey(model.studentName), model.serialize());
    } catch (e, st) {
      AppLogger.error('AlphabetLocalDataSourceImpl: saveProgress failed', e, st);
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> clearProgress(String studentName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_getKey(studentName));
    } catch (e, st) {
      AppLogger.error('AlphabetLocalDataSourceImpl: clearProgress failed', e, st);
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();
      final alphabetKeys = allKeys.where((key) =>
          key.startsWith(AppStrings.prefAlphabetCompletedSessions) ||
          key.startsWith(AppStrings.prefAlphabetStars) ||
          key.startsWith(AppStrings.prefAlphabetCurrentLetter));

      for (final key in alphabetKeys.toList()) {
        await prefs.remove(key);
      }
    } catch (e, st) {
      AppLogger.error('AlphabetLocalDataSourceImpl: clearAll failed', e, st);
      throw CacheException(message: e.toString());
    }
  }
}
