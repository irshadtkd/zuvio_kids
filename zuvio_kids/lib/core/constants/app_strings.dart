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
  static const String assetsLottie = 'assets/lottie/';
  static const String assetsAudio = 'assets/audio/';

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
