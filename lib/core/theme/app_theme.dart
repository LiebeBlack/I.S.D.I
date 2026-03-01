import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta de colores Premium 2026 - Vibrante y Amigable para niños
class IslaColors {
  // Primarios: Inspirados en la naturaleza caribeña de Margarita
  static const Color oceanBlue = Color(0xFF1E90FF); // Azul más vivido
  static const Color oceanLight = Color(0xFF64B5F6);
  static const Color oceanDark = Color(0xFF0D47A1);
  
  static const Color sunflower = Color(0xFFFFD700); // Amarillo más cálido
  static const Color tropicOrange = Color(0xFFFF8C00);
  
  static const Color jungleGreen = Color(0xFF00C853); // Verde más vibrante
  static const Color leafLight = Color(0xFF69F0AE);
  
  static const Color sunsetPink = Color(0xFFFF4081);
  static const Color royalPurple = Color(0xFF7C4DFF);
  static const Color coralReef = Color(0xFFFF5252);
  
  // Neutros y UI
  static const Color softWhite = Color(0xFFF8FAFC);
  static const Color glassWhite = Color(0xFFFFFFFF);
  static const Color charcoal = Color(0xFF1E293B);
  static const Color slate = Color(0xFF64748B);
  static const Color mist = Color(0xFFE2E8F0);
  
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color greyLight = Color(0xFFECEFF1);
  static const Color sand = Color(0xFFFBE9E7); // Color arena suave
}

class IslaTypography {
  static TextTheme get textTheme {
    // Usamos 'Outfit' para un look más moderno, geométrico y accesible
    return GoogleFonts.outfitTextTheme().copyWith(
      displayLarge: GoogleFonts.outfit(fontSize: 42, fontWeight: FontWeight.w900, color: IslaColors.charcoal, letterSpacing: -1.5),
      displayMedium: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w900, color: IslaColors.charcoal, letterSpacing: -1),
      displaySmall: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w900, color: IslaColors.charcoal),
      headlineLarge: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w800, color: IslaColors.charcoal),
      headlineMedium: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, color: IslaColors.charcoal),
      titleLarge: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: IslaColors.charcoal),
      bodyLarge: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: IslaColors.charcoal),
      bodyMedium: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, color: IslaColors.charcoal),
      labelLarge: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: IslaColors.charcoal),
    );
  }
}

class IslaThemes {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: IslaColors.oceanBlue,
        primary: IslaColors.oceanBlue,
        secondary: IslaColors.sunflower,
        surface: IslaColors.softWhite,
        onSurface: IslaColors.charcoal,
      ),
      textTheme: IslaTypography.textTheme,
      
      // --- Glassmorphism UI Defaults ---
      cardTheme: CardThemeData(
        elevation: 0,
        color: IslaColors.white.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: BorderSide(
            color: IslaColors.white.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: IslaColors.white.withValues(alpha: 0.9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36),
          side: BorderSide(color: IslaColors.white.withValues(alpha: 0.5)),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: IslaColors.oceanBlue,
          foregroundColor: IslaColors.white,
          minimumSize: const Size(140, 64),
          elevation: 8,
          shadowColor: IslaColors.oceanBlue.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 0.5),
        ),
      ),

      scaffoldBackgroundColor: Colors.transparent,
    );
  }
}

extension IslaColorScheme on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
}