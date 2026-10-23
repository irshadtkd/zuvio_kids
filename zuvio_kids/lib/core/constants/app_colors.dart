import 'package:flutter/material.dart';

/// Centralised colour palette for ZuvioKids.
/// Never use raw [Color] literals in widgets — always reference this class.
abstract final class AppColors {
  // ── Primary brand ────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF4A90D9);
  static const Color primaryDark = Color(0xFF2C6FAC);
  static const Color primaryLight = Color(0xFF79B8F4);

  // ── Accent ───────────────────────────────────────────────────────────────
  static const Color accent = Color(0xFFFF8C42);
  static const Color accentLight = Color(0xFFFFB380);

  // ── Background ───────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFECF2FB);

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFFB0B8C4);

  // ── Semantic ─────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF34C759);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFF9500);
  static const Color info = Color(0xFF5AC8FA);

  // ── Divider / Border ─────────────────────────────────────────────────────
  static const Color divider = Color(0xFFE5E9F0);
  static const Color border = Color(0xFFD1D9E6);
}
