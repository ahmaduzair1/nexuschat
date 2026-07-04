import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

/// Nexus Chat — Theme Builder
///
/// Dark-first, luxury aesthetic. Emerald + navy + gold.
abstract final class AppTheme {
  static ThemeData get dark {
    final textTheme = AppTypography.textTheme;

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,

      // ── Colors ──
      scaffoldBackgroundColor: AppColors.navyBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.emeraldPrimary,
        onPrimary: AppColors.navyBackground,
        primaryContainer: AppColors.emeraldDark,
        onPrimaryContainer: AppColors.emeraldGlow,
        secondary: AppColors.goldAccent,
        onSecondary: AppColors.navyBackground,
        secondaryContainer: AppColors.goldMuted,
        onSecondaryContainer: AppColors.goldAccent,
        surface: AppColors.graphiteSurface,
        onSurface: AppColors.silverText,
        surfaceContainerHighest: AppColors.graphiteElevated,
        error: AppColors.errorRed,
        onError: Colors.white,
        outline: AppColors.silverFaint,
        outlineVariant: Color(0xFF2A3040),
      ),

      // ── Text ──
      textTheme: textTheme,

      // ── App Bar ──
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.navyBackground,
        foregroundColor: AppColors.silverText,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineMedium,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: AppColors.navyBackground,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),

      // ── Bottom Nav ──
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: AppColors.emeraldPrimary,
        unselectedItemColor: AppColors.silverMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // ── Cards ──
      cardTheme: CardThemeData(
        color: AppColors.graphiteSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLg,
          side: const BorderSide(color: Color(0xFF1E2436), width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Inputs ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.graphiteLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusFull,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusFull,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusFull,
          borderSide: const BorderSide(color: AppColors.emeraldPrimary, width: 1.5),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.silverMuted),
      ),

      // ── Divider ──
      dividerTheme: const DividerThemeData(
        color: Color(0xFF1E2436),
        thickness: 0.5,
        space: 0,
      ),

      // ── Icon ──
      iconTheme: const IconThemeData(
        color: AppColors.silverSecondary,
        size: 22,
      ),

      // ── Switch ──
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.emeraldPrimary;
          return AppColors.silverMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.emeraldSubtle;
          return AppColors.graphiteLight;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // ── Floating Action Button ──
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.emeraldPrimary,
        foregroundColor: AppColors.navyBackground,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // ── Splash / Ripple ──
      splashColor: AppColors.emeraldPrimary.withOpacity(0.08),
      highlightColor: AppColors.emeraldPrimary.withOpacity(0.04),

      // ── Page Transitions ──
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
