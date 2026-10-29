/// Local data source interface for storing puzzle progress and variation history.
/// Layer: Data Source Interface
abstract interface class PuzzleLocalDataSource {
  /// Loads the set of completed puzzle session IDs.
  Future<Set<String>> getCompletedSessionIds();

  /// Saves a session as completed.
  Future<void> saveCompletedSessionId(String sessionId);

  /// Clears all puzzle completion data.
  Future<void> clearCompletedSessions();

  /// Loads the set of completed puzzle variation signatures (e.g. 'shapes:circle,star,crescent').
  Future<Set<String>> getCompletedVariationKeys();

  /// Saves a variation signature to completed history.
  Future<void> saveCompletedVariationKey(String key);

  /// Resets variation history for a specific category when all combinations have been used.
  Future<void> resetVariationHistoryForCategory(String category);

  /// Clears all variation history.
  Future<void> clearVariationHistory();
}
