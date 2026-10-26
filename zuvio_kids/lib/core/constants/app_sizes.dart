/// Centralised spacing, sizing, and border-radius constants for ZuvioKids.
/// Never use magic numbers in widgets — always reference this class.
abstract final class AppSizes {
  // ── Spacing / Padding ─────────────────────────────────────────────────
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // ── Gap (between siblings) ────────────────────────────────────────────
  static const double gapXS = 4.0;
  static const double gapS = 8.0;
  static const double gapM = 16.0;
  static const double gapL = 24.0;
  static const double gapXL = 32.0;

  // ── Border Radius ─────────────────────────────────────────────────────
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusCircle = 999.0;

  // ── Icon sizes ────────────────────────────────────────────────────────
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;

  // ── Elevation ─────────────────────────────────────────────────────────
  static const double elevationNone = 0.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // ── Responsive Breakpoints ─────────────────────────────────────────────
  /// Maximum width for mobile layouts (< 600)
  static const double maxMobileWidth = 600.0;

  /// Maximum width for standard tablet / iPad layouts (< 1024)
  static const double maxTabletWidth = 1024.0;

  /// Maximum width constraint for readability on wide tablet / iPad displays
  static const double maxContentWidth = 840.0;

  // ── Name Validation ───────────────────────────────────────────────────
  static const int nameMinLength = 2;
  static const int nameMaxLength = 10;
}
