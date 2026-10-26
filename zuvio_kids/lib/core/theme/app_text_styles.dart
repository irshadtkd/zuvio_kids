import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Centralised typography styles for ZuvioKids.
/// Based on GoogleFonts Nunito for friendly, rounded kid aesthetics.
abstract final class AppTextStyles {
  /// Font family getter
  static TextStyle get base => GoogleFonts.nunito();

  /// Splash & Main Big Titles (e.g. "Kids Learning Adventure")
  static TextStyle get splashTitle => GoogleFonts.nunito(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: AppColors.navy,
        letterSpacing: -0.5,
      );

  /// Splash Subtitle ("See, listen, touch, play!")
  static TextStyle get splashSubtitle => GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: AppColors.navy,
      );

  /// Splash Footer Caption ("No ads. Works offline.")
  static TextStyle get splashCaption => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
      );

  /// Header Top Bar Title ("Your name", "My class", "My friend")
  static TextStyle get headerTitle => GoogleFonts.nunito(
        fontSize: 26,
        fontWeight: FontWeight.w900,
        color: AppColors.navy,
      );

  /// Speech Bubble Text ("Which class are you in?", "Hello, friend!")
  static TextStyle get speechBubbleTitle => GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: AppColors.navy,
      );

  static TextStyle get speechBubbleBody => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.navy,
        height: 1.3,
      );

  /// Card Headings ("Pre-KG", "LKG", "UKG")
  static TextStyle get cardTitle => GoogleFonts.nunito(
        fontSize: 34,
        fontWeight: FontWeight.w900,
        color: AppColors.navy,
      );

  /// Card Subtitles ("Ages 3-4", "Ages 4-5 ✓ Selected")
  static TextStyle get cardSubtitle => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.navy,
      );

  /// Friend Card Name ("Panda", "Bunny", etc.)
  static TextStyle get friendName => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: AppColors.navy,
      );

  /// Big Button Label ("Next ➔", "Done! ➔", "Start ➔")
  static TextStyle get buttonLabel => GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: AppColors.navy,
      );

  /// Label ("Name")
  static TextStyle get inputLabel => GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: AppColors.navy,
      );

  /// Input Value ("Mia")
  static TextStyle get inputValue => GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: AppColors.navy,
      );

  /// Virtual Keyboard Key
  static TextStyle get keyboardKey => GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: AppColors.navy,
      );

  /// Footer link ("For parents")
  static TextStyle get footerLink => GoogleFonts.nunito(
        fontSize: 17,
        fontWeight: FontWeight.w900,
        color: AppColors.navy,
      );

  /// Home Child Greeting ("Hi, Mia!")
  static TextStyle get homeGreeting => GoogleFonts.nunito(
        fontSize: 26,
        fontWeight: FontWeight.w900,
        color: AppColors.navy,
      );

  /// Home Subtitle ("Let us play and learn")
  static TextStyle get homePlaySubtitle => GoogleFonts.nunito(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: AppColors.navy,
      );

  /// Star badge count ("24")
  static TextStyle get starBadgeText => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: AppColors.navy,
      );

  /// Category Big Text Icon ("A B C", "1 2 3", "Moo")
  static TextStyle get categoryIconText => GoogleFonts.nunito(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: AppColors.navy,
        letterSpacing: 0.5,
      );

  /// Category Card Label ("Alphabet", "Numbers", "Shapes", etc.)
  static TextStyle get categoryLabel => GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: AppColors.navy,
      );

  /// Garden card title ("My Garden")
  static TextStyle get gardenTitle => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: AppColors.navy,
      );
}
