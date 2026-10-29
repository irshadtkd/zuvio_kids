/// Non-localised internal string constants for ZuvioKids.
///
/// Use this class for: route names, asset paths, shared-preference keys,
/// environment configs, and other internal identifiers.
///
/// DO NOT put user-facing strings here. All UI strings belong in the ARB files
/// and are accessed through AppLocalizations.
abstract final class AppStrings {
  // ── App ───────────────────────────────────────────────────────────────
  static const String appName = 'ZuvioKids';

  // ── Asset paths ───────────────────────────────────────────────────────
  static const String assetsImages = 'assets/images/';
  static const String assetsAnimals = 'assets/images/animals/';
  static const String assetsLottie = 'assets/lottie/';
  static const String assetsAudio = 'assets/audio/';
  static const String assetClappingSound = 'assets/audio/clapping.wav';

  // ── Shared Preference keys ────────────────────────────────────────────
  static const String prefLocale = 'pref_locale';
  static const String prefStudentLevel = 'pref_student_level';
  static const String prefOnboardingDone = 'pref_onboarding_done';
  static const String prefUserName = 'pref_user_name';
  static const String prefUserClass = 'pref_user_class';
  static const String prefUserFriend = 'pref_user_friend';
  static const String prefAlphabetCompletedSessions = 'pref_alphabet_completed_sessions_';
  static const String prefAlphabetStars = 'pref_alphabet_stars_';
  static const String prefAlphabetCurrentLetter = 'pref_alphabet_current_letter_';
  static const String prefNumbersCompletedSessions = 'pref_numbers_completed_sessions_';
  static const String prefNumbersStars = 'pref_numbers_stars_';
  static const String prefColorsCompleted = 'pref_colors_completed_';
  static const String prefColorsStars = 'pref_colors_stars_';
  static const String prefShapesCompletedSessions = 'pref_shapes_completed_sessions_';
  static const String prefShapesUnlockedSessions = 'pref_shapes_unlocked_sessions_';
  static const String prefShapesStars = 'pref_shapes_stars_';
  static const String prefAnimalsCompletedSessions = 'pref_animals_completed_sessions_';
  static const String prefAnimalsStars = 'pref_animals_stars_';
  static const String prefTotalStarPoints = 'pref_total_star_points';
  static const String prefThemeMode = 'pref_theme_mode';
  static const String prefPuzzleCompletedSessions = 'pref_puzzle_completed_sessions';
  static const String prefPuzzleCompletedVariations = 'pref_puzzle_completed_variations';

  // ── Animals Session Identifiers ───────────────────────────────────────
  static const String sessionAnimals1 = 'animals_session_1';
  static const String sessionAnimals2 = 'animals_session_2';

  // ── Alphabet Session Identifiers ──────────────────────────────────────
  static const String sessionCapital1 = 'capital_1';
  static const String sessionCapital2 = 'capital_2';
  static const String sessionSmall3 = 'small_3';
  static const String sessionSmall4 = 'small_4';

  // ── Cartoon Friend Identifiers ────────────────────────────────────────
  static const String idFriendPanda = 'panda';
  static const String idFriendBunny = 'bunny';
  static const String idFriendLion = 'lion';
  static const String idFriendFrog = 'frog';
  static const String idFriendCat = 'cat';
  static const String idFriendDog = 'dog';

  // ── Class Identifiers ─────────────────────────────────────────────────
  static const String idClassPreKg = 'Pre-KG';
  static const String idClassLkg = 'LKG';
  static const String idClassUkg = 'UKG';

  // ── Default Fallbacks ─────────────────────────────────────────────────
  static const String defaultChildName = 'Star⭐';
  static const String defaultClass = 'LKG';
  static const String defaultFriend = 'panda';
}
