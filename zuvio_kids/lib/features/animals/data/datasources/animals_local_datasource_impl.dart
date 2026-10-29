import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/errors/app_exception.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';
import '../models/animal_session_model.dart';
import 'animal_data.dart';
import 'animals_local_datasource.dart';

/// SharedPreferences implementation of [AnimalsLocalDataSource].
/// Layer: Data Source Impl
class AnimalsLocalDataSourceImpl implements AnimalsLocalDataSource {
  const AnimalsLocalDataSourceImpl();

  @override
  Future<List<AnimalSessionModel>> getSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final s1Done = prefs.getBool('${AppStrings.prefAnimalsCompletedSessions}${AppStrings.sessionAnimals1}') ?? false;
      final s2Done = prefs.getBool('${AppStrings.prefAnimalsCompletedSessions}${AppStrings.sessionAnimals2}') ?? false;
      final s1Stars = prefs.getInt('${AppStrings.prefAnimalsStars}${AppStrings.sessionAnimals1}') ?? 0;
      final s2Stars = prefs.getInt('${AppStrings.prefAnimalsStars}${AppStrings.sessionAnimals2}') ?? 0;

      return AnimalData.createDefaultSessions(
        session1Completed: s1Done,
        session2Completed: s2Done,
        session1Stars: s1Stars,
        session2Stars: s2Stars,
      );
    } catch (e, st) {
      AppLogger.error('AnimalsLocalDataSourceImpl: getSessions failed', e, st);
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> saveSessionCompleted(String sessionId, int stars) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('${AppStrings.prefAnimalsCompletedSessions}$sessionId', true);
      final currentStars = prefs.getInt('${AppStrings.prefAnimalsStars}$sessionId') ?? 0;
      if (stars > currentStars) {
        await prefs.setInt('${AppStrings.prefAnimalsStars}$sessionId', stars);
      }
    } catch (e, st) {
      AppLogger.error('AnimalsLocalDataSourceImpl: saveSessionCompleted failed', e, st);
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> resetProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where(
            (k) =>
                k.startsWith(AppStrings.prefAnimalsCompletedSessions) ||
                k.startsWith(AppStrings.prefAnimalsStars),
          );
      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e, st) {
      AppLogger.error('AnimalsLocalDataSourceImpl: resetProgress failed', e, st);
      throw CacheException(message: e.toString());
    }
  }
}
