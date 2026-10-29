import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'app_theme_mode.dart';

/// Theme extension defining the color palette for each child-friendly theme.
/// Allows widgets to dynamically adapt their backgrounds, buttons, cards,
/// and accents when the user switches themes.
@immutable
class AppThemePalette extends ThemeExtension<AppThemePalette> {
  const AppThemePalette({
    required this.mode,
    required this.scaffoldBackground,
    required this.primary,
    required this.primaryDark,
    required this.actionButton,
    required this.actionButtonShadow,
    required this.darkText,
    required this.highlight,
    required this.highlightShadow,
    required this.cardAlphabet,
    required this.cardNumbers,
    required this.cardShapes,
    required this.cardColors,
    required this.cardAnimals,
    required this.cardPuzzles,
    required this.sessionColors,
  });

  final AppThemeMode mode;
  final Color scaffoldBackground;
  final Color primary;
  final Color primaryDark;
  final Color actionButton;
  final Color actionButtonShadow;
  final Color darkText;
  final Color highlight;
  final Color highlightShadow;
  final Color cardAlphabet;
  final Color cardNumbers;
  final Color cardShapes;
  final Color cardColors;
  final Color cardAnimals;
  final Color cardPuzzles;
  final List<Color> sessionColors;

  /// Default Sunny Sky Theme (Existing theme).
  static const AppThemePalette sunnySky = AppThemePalette(
    mode: AppThemeMode.sunnySky,
    scaffoldBackground: AppColors.appSkyBlue,
    primary: AppColors.primary,
    primaryDark: AppColors.primaryDark,
    actionButton: AppColors.kidGreen,
    actionButtonShadow: Color(0xFF86BCD8),
    darkText: AppColors.navy,
    highlight: AppColors.cardYellow,
    highlightShadow: Color(0xFFD69E1F),
    cardAlphabet: AppColors.cardYellow,
    cardNumbers: AppColors.cardPink,
    cardShapes: AppColors.cardGreen,
    cardColors: AppColors.cardLavender,
    cardAnimals: AppColors.cardPeach,
    cardPuzzles: AppColors.cardBlue,
    sessionColors: [
      AppColors.cardYellow,
      AppColors.cardPink,
      AppColors.cardGreen,
      AppColors.cardLavender,
    ],
  );

  /// Sweet Candy Carnival Theme.
  static const AppThemePalette candyCarnival = AppThemePalette(
    mode: AppThemeMode.candyCarnival,
    scaffoldBackground: AppColors.candyPinkBg,
    primary: AppColors.candyPrimary,
    primaryDark: AppColors.candyPrimaryDark,
    actionButton: AppColors.candyButton,
    actionButtonShadow: AppColors.candyButtonShadow,
    darkText: AppColors.candyDark,
    highlight: AppColors.candyYellow,
    highlightShadow: Color(0xFFD69E1F),
    cardAlphabet: AppColors.candyCardYellow,
    cardNumbers: AppColors.candyCardPink,
    cardShapes: AppColors.candyCardGreen,
    cardColors: AppColors.candyCardPurple,
    cardAnimals: AppColors.candyCardPeach,
    cardPuzzles: AppColors.candyCardBlue,
    sessionColors: [
      AppColors.candyCardYellow,
      AppColors.candyCardPink,
      AppColors.candyCardGreen,
      AppColors.candyCardPurple,
    ],
  );

  /// Fresh Magic Meadow Theme.
  static const AppThemePalette magicMeadow = AppThemePalette(
    mode: AppThemeMode.magicMeadow,
    scaffoldBackground: AppColors.meadowGreenBg,
    primary: AppColors.meadowPrimary,
    primaryDark: AppColors.meadowPrimaryDark,
    actionButton: AppColors.meadowButton,
    actionButtonShadow: AppColors.meadowButtonShadow,
    darkText: AppColors.meadowDark,
    highlight: AppColors.meadowYellow,
    highlightShadow: Color(0xFFD69E1F),
    cardAlphabet: AppColors.meadowCardYellow,
    cardNumbers: AppColors.meadowCardCoral,
    cardShapes: AppColors.meadowCardGreen,
    cardColors: AppColors.meadowCardViolet,
    cardAnimals: AppColors.meadowCardOrange,
    cardPuzzles: AppColors.meadowCardSky,
    sessionColors: [
      AppColors.meadowCardYellow,
      AppColors.meadowCardCoral,
      AppColors.meadowCardGreen,
      AppColors.meadowCardViolet,
    ],
  );

  /// Returns the configured palette for a given [AppThemeMode].
  static AppThemePalette fromMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.sunnySky:
        return sunnySky;
      case AppThemeMode.candyCarnival:
        return candyCarnival;
      case AppThemeMode.magicMeadow:
        return magicMeadow;
    }
  }

  @override
  AppThemePalette copyWith({
    AppThemeMode? mode,
    Color? scaffoldBackground,
    Color? primary,
    Color? primaryDark,
    Color? actionButton,
    Color? actionButtonShadow,
    Color? darkText,
    Color? highlight,
    Color? highlightShadow,
    Color? cardAlphabet,
    Color? cardNumbers,
    Color? cardShapes,
    Color? cardColors,
    Color? cardAnimals,
    Color? cardPuzzles,
    List<Color>? sessionColors,
  }) {
    return AppThemePalette(
      mode: mode ?? this.mode,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      actionButton: actionButton ?? this.actionButton,
      actionButtonShadow: actionButtonShadow ?? this.actionButtonShadow,
      darkText: darkText ?? this.darkText,
      highlight: highlight ?? this.highlight,
      highlightShadow: highlightShadow ?? this.highlightShadow,
      cardAlphabet: cardAlphabet ?? this.cardAlphabet,
      cardNumbers: cardNumbers ?? this.cardNumbers,
      cardShapes: cardShapes ?? this.cardShapes,
      cardColors: cardColors ?? this.cardColors,
      cardAnimals: cardAnimals ?? this.cardAnimals,
      cardPuzzles: cardPuzzles ?? this.cardPuzzles,
      sessionColors: sessionColors ?? this.sessionColors,
    );
  }

  @override
  AppThemePalette lerp(ThemeExtension<AppThemePalette>? other, double t) {
    if (other is! AppThemePalette) return this;
    return AppThemePalette(
      mode: t < 0.5 ? mode : other.mode,
      scaffoldBackground:
          Color.lerp(scaffoldBackground, other.scaffoldBackground, t) ??
              scaffoldBackground,
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t) ?? primaryDark,
      actionButton:
          Color.lerp(actionButton, other.actionButton, t) ?? actionButton,
      actionButtonShadow:
          Color.lerp(actionButtonShadow, other.actionButtonShadow, t) ??
              actionButtonShadow,
      darkText: Color.lerp(darkText, other.darkText, t) ?? darkText,
      highlight: Color.lerp(highlight, other.highlight, t) ?? highlight,
      highlightShadow:
          Color.lerp(highlightShadow, other.highlightShadow, t) ??
              highlightShadow,
      cardAlphabet:
          Color.lerp(cardAlphabet, other.cardAlphabet, t) ?? cardAlphabet,
      cardNumbers:
          Color.lerp(cardNumbers, other.cardNumbers, t) ?? cardNumbers,
      cardShapes: Color.lerp(cardShapes, other.cardShapes, t) ?? cardShapes,
      cardColors: Color.lerp(cardColors, other.cardColors, t) ?? cardColors,
      cardAnimals: Color.lerp(cardAnimals, other.cardAnimals, t) ?? cardAnimals,
      cardPuzzles: Color.lerp(cardPuzzles, other.cardPuzzles, t) ?? cardPuzzles,
      sessionColors: sessionColors,
    );
  }
}

/// Convenience extension on [BuildContext] to get the active [AppThemePalette].
extension AppThemeContextExtension on BuildContext {
  AppThemePalette get themePalette =>
      Theme.of(this).extension<AppThemePalette>() ?? AppThemePalette.sunnySky;
}
