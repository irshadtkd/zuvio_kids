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
}
