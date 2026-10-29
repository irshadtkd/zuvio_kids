import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'puzzle_local_datasource.dart';

/// SharedPreferences implementation of [PuzzleLocalDataSource].
/// Layer: Data Source Implementation
class PuzzleLocalDataSourceImpl implements PuzzleLocalDataSource {
  const PuzzleLocalDataSourceImpl();

  @override
  Future<Set<String>> getCompletedSessionIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(AppStrings.prefPuzzleCompletedSessions);
    return list?.toSet() ?? <String>{};
  }

  @override
  Future<void> saveCompletedSessionId(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    final current =
        (prefs.getStringList(AppStrings.prefPuzzleCompletedSessions) ?? <String>[])
            .toSet();
    current.add(sessionId);
    await prefs.setStringList(
      AppStrings.prefPuzzleCompletedSessions,
      current.toList(),
    );
  }

  @override
  Future<void> clearCompletedSessions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppStrings.prefPuzzleCompletedSessions);
  }

  @override
  Future<Set<String>> getCompletedVariationKeys() async {
    final prefs = await SharedPreferences.getInstance();
    final list =
        prefs.getStringList(AppStrings.prefPuzzleCompletedVariations);
    return list?.toSet() ?? <String>{};
  }

  @override
  Future<void> saveCompletedVariationKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final current =
        (prefs.getStringList(AppStrings.prefPuzzleCompletedVariations) ??
                <String>[])
            .toSet();
    current.add(key);
    await prefs.setStringList(
      AppStrings.prefPuzzleCompletedVariations,
      current.toList(),
    );
  }

  @override
  Future<void> resetVariationHistoryForCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final current =
        prefs.getStringList(AppStrings.prefPuzzleCompletedVariations) ??
            <String>[];
    final prefix = '$category:';
    final filtered = current.where((k) => !k.startsWith(prefix)).toList();
    await prefs.setStringList(
      AppStrings.prefPuzzleCompletedVariations,
      filtered,
    );
  }

  @override
  Future<void> clearVariationHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppStrings.prefPuzzleCompletedVariations);
  }
}
