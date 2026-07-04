import 'package:flutter/material.dart';

/// Nexus Chat — Color Design Tokens
///
/// Emerald-neon primary, deep navy backgrounds, gold premium accents.
/// Dark-first design system.
abstract final class AppColors {
  // ── Primary (Emerald) ──
  static const Color emeraldPrimary = Color(0xFF00C896);
  static const Color emeraldGlow = Color(0xFF00FFB2);
  static const Color emeraldDark = Color(0xFF00A67E);
  static const Color emeraldSubtle = Color(0xFF0A3D2E);

  // ── Background (Navy / Graphite) ──
  static const Color navyBackground = Color(0xFF0A0E1A);
  static const Color graphiteSurface = Color(0xFF141926);
  static const Color graphiteLight = Color(0xFF1E2436);
  static const Color graphiteElevated = Color(0xFF252B3B);

  // ── Accent (Gold / Premium) ──
  static const Color goldAccent = Color(0xFFFFD700);
  static const Color goldSubtle = Color(0xFFC9A84C);
  static const Color goldMuted = Color(0xFF8B7A3E);

  // ── Neutral (Silver / Text) ──
  static const Color silverText = Color(0xFFE8ECF4);
  static const Color silverSecondary = Color(0xFFB0B8C9);
  static const Color silverMuted = Color(0xFF7A8599);
  static const Color silverFaint = Color(0xFF4A5168);

  // ── Semantic ──
  static const Color errorRed = Color(0xFFFF4B6E);
  static const Color warningAmber = Color(0xFFFFAB40);
  static const Color infoBlue = Color(0xFF448AFF);
  static const Color successGreen = Color(0xFF69F0AE);

  // ── Gradients ──
  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [emeraldDark, emeraldPrimary, emeraldGlow],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emeraldSoftGradient = LinearGradient(
    colors: [Color(0xFF0D2B22), Color(0xFF143D30)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [emeraldPrimary, goldAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [graphiteSurface, navyBackground],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient statusRingGradient = LinearGradient(
    colors: [emeraldGlow, emeraldPrimary, emeraldDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient storyRingGradient = LinearGradient(
    colors: [Color(0xFF00FFB2), Color(0xFF00C896), Color(0xFFFFD700)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
