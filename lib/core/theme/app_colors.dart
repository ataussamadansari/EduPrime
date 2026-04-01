import 'package:flutter/material.dart';

// Colors extracted from https://ssvvostc.ac.in
class AppColors {
  // ── Brand palette (SSVV OSTC) ─────────────────────────────────────────────
  static const Color primary = Color(0xFF195BBC); // deep blue – main brand
  static const Color primaryLight =
      Color(0xFF3E64DE); // medium blue – hover/accent
  static const Color primaryDark = Color(0xFF0F3D8A); // darker blue – pressed

  // Secondary / accent
  static const Color secondary = Color(0xFF77B0EB); // light blue – highlights
  static const Color accent = Color(0xFF395BCA); // blue variant

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ── Light theme surfaces ──────────────────────────────────────────────────
  static const Color bgLight = Color(0xFFF4F7FC); // very light blue-grey
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF17212C); // site dark navy
  static const Color textSecondaryLight = Color(0xFF5A6A7E);
  static const Color dividerLight = Color(0xFFDDE3EE);
  static const Color borderLight = Color(0xFFDDE3EE);

  // ── Dark theme surfaces ───────────────────────────────────────────────────
  static const Color bgDark = Color(0xFF0D1520); // deep navy bg
  static const Color surfaceDark = Color(0xFF17212C); // site header color
  static const Color cardDark = Color(0xFF1E2D3D);
  static const Color textPrimaryDark = Color(0xFFEDF2FA);
  static const Color textSecondaryDark = Color(0xFF8FA8C8);
  static const Color dividerDark = Color(0xFF243447);
  static const Color borderDark = Color(0xFF243447);

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF195BBC), Color(0xFF3E64DE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF195BBC), Color(0xFF0F3D8A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Navy gradient for header/splash (matches site header #17212c)
  static const LinearGradient navyGradient = LinearGradient(
    colors: [Color(0xFF17212C), Color(0xFF195BBC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
