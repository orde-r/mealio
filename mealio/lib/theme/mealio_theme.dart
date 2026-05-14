import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MealioColors {
  MealioColors._();

  static const Color primary = Color(0xFFF26A3D);
  static const Color primaryDeep = Color(0xFFD95724);
  static const Color background = Color(0xFFF7F4F1);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF8FAFC);
  static const Color surfaceWarm = Color(0xFFFFF7F2);
  static const Color border = Color(0xFFE2E8F0);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color success = Color(0xFF16A34A);
  static const Color danger = Color(0xFFDC2626);
  static const Color accent = Color(0xFF0F766E);
}

class MealioTheme {
  MealioTheme._();

  static ThemeData light() {
    final baseTheme = ThemeData.light();
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(baseTheme.textTheme)
        .copyWith(
          displayLarge: baseTheme.textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -1.1,
          ),
          displayMedium: baseTheme.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -1.0,
          ),
          displaySmall: baseTheme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
          headlineMedium: baseTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
          headlineSmall: baseTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          titleLarge: baseTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(height: 1.5),
          bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(height: 1.5),
        );

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: MealioColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: MealioColors.primary,
          secondary: MealioColors.accent,
          tertiary: MealioColors.primaryDeep,
          surface: MealioColors.surface,
          surfaceContainerHighest: MealioColors.surfaceMuted,
          error: MealioColors.danger,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: MealioColors.background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: MealioColors.textPrimary,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: MealioColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: MealioColors.textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          backgroundColor: MealioColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: MealioColors.primary.withValues(alpha: 0.45),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
          elevation: 0,
          shadowColor: MealioColors.primary.withValues(alpha: 0.24),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          foregroundColor: MealioColors.textPrimary,
          backgroundColor: MealioColors.surface,
          side: const BorderSide(color: MealioColors.border, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MealioColors.surfaceMuted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: MealioColors.textMuted,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: MealioColors.textMuted,
        ),
        prefixIconColor: MealioColors.textSecondary,
        suffixIconColor: MealioColors.textSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: MealioColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: MealioColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: MealioColors.primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: MealioColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: MealioColors.danger, width: 1.8),
        ),
      ),
      cardTheme: CardThemeData(
        color: MealioColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: MealioColors.border,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: MealioColors.surface,
        selectedItemColor: MealioColors.primary,
        unselectedItemColor: MealioColors.textMuted,
        selectedLabelStyle: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: textTheme.labelMedium,
        elevation: 14,
        type: BottomNavigationBarType.fixed,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: MealioColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: MealioColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: MealioColors.textSecondary,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: MealioColors.textPrimary,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: MealioColors.primary,
        inactiveTrackColor: MealioColors.border,
        thumbColor: MealioColors.primary,
        overlayColor: MealioColors.primary.withValues(alpha: 0.16),
        trackHeight: 6,
        valueIndicatorColor: MealioColors.primary,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return MealioColors.surface;
          }
          return MealioColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return MealioColors.primary.withValues(alpha: 0.55);
          }
          return MealioColors.border;
        }),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: MealioColors.primary,
      ),
    );
  }
}
