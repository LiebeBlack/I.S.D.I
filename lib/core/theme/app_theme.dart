import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isla_digital/core/constants/isla_colors.dart';

class IslaTypography {
  static TextTheme get textTheme => GoogleFonts.outfitTextTheme().copyWith(
      displayLarge: GoogleFonts.outfit(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        color: IslaColors.charcoal,
        letterSpacing: -2,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.w900,
        color: IslaColors.charcoal,
      ),
      bodyLarge: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: IslaColors.charcoal,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.1,
      ),
    );
}

class DynamicThemingEngine {
  // Feature 22: Dynamic Adaptive Theming Engine
  // Provides type-safe text styles aligned with Material 3 typography
  static TextStyle get labelStyle => GoogleFonts.outfit(
      fontSize: 14, fontWeight: FontWeight.w600, color: IslaColors.slate);
  static TextStyle get titleMediumStyle => GoogleFonts.outfit(
      fontSize: 18, fontWeight: FontWeight.w700, color: IslaColors.charcoal);
  static TextStyle get badgeCounterStyle => GoogleFonts.outfit(
      fontSize: 12, fontWeight: FontWeight.w800, color: IslaColors.white);
  static TextStyle get displayStyle => GoogleFonts.outfit(
      fontSize: 28, fontWeight: FontWeight.w900, color: IslaColors.charcoal);
  static TextStyle get subtitleStyle => GoogleFonts.outfit(
      fontSize: 16, fontWeight: FontWeight.w500, color: IslaColors.slate);

  static ThemeData get lightTheme => ThemeData(
      useMaterial3: true,
      // Dynamic color generation based on seed
      colorScheme: ColorScheme.fromSeed(
        seedColor: IslaColors.oceanBlue,
        primary: IslaColors.oceanBlue,
        secondary: IslaColors.sunflower,
        surface: IslaColors.softWhite,
        error: IslaColors.coralReef,
        tertiary: IslaColors.sunsetPink,
      ),
      textTheme: IslaTypography.textTheme,
      // Global component themes
      sliderTheme: SliderThemeData(
        activeTrackColor: IslaColors.oceanBlue,
        inactiveTrackColor: IslaColors.mist,
        thumbColor: IslaColors.oceanBlue,
        overlayColor: IslaColors.oceanBlue.withValues(alpha: 0.1),
        trackHeight: 8,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: IslaColors.oceanBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(180, 72),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          elevation: 4,
          shadowColor: IslaColors.oceanBlue.withValues(alpha: 0.4),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: IslaColors.oceanDark,
          side: const BorderSide(color: IslaColors.oceanBlue, width: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: IslaColors.oceanBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: IslaColors.coralReef, width: 2),
        ),
        labelStyle: IslaTypography.textTheme.bodyLarge
            ?.copyWith(color: IslaColors.slate),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
          side: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: Colors.white,
      ),
    );
}

// Extension para facilitar el acceso
extension IslaColorScheme on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
}
