import 'package:flutter/material.dart';

/// Sistema di design e palette colori per Laurentius in stile Wikipedia Mobile Dark Mode.
/// Progettato per garantire massimo contrasto, leggibilità di formule KaTeX/LaTeX,
/// eleganza sobria e zero sfondi bianchi residui.
class AppTheme {
  AppTheme._();

  // Sfondi Wikipedia Dark Mode
  static const Color bgDark = Color(0xFF101214); // Sfondo base profondo (Wikipedia mobile dark)
  static const Color surfaceDark = Color(0xFF191C20); // Card e container di primo livello
  static const Color surfaceElevated = Color(0xFF22262B); // Sezioni interne, input, box formule
  static const Color surfaceHighlight = Color(0xFF2B3138); // Hover, stati attivi

  // Bordi e divisori
  static const Color borderDark = Color(0xFF2D3238); // Bordo sottile di separazione
  static const Color borderSubtle = Color(0xFF22262B);
  static const Color divider = Color(0xFF2D3238);

  // Tipografia ad alto contrasto
  static const Color textPrimary = Color(0xFFEAECF0); // Bianco ottico / crisp off-white per titoli e testi
  static const Color textSecondary = Color(0xFF9CA3AF); // Grigio medio per etichette e metadati
  static const Color textMuted = Color(0xFF6B7280); // Grigio scuro per ID e note secondarie
  static const Color textLink = Color(0xFF60A5FA); // Blu brillante per collegamenti e azioni

  // Accenti funzionali
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentBlueBright = Color(0xFF60A5FA);
  static const Color accentBlueDark = Color(0xFF1E3A8A);

  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentGreenBright = Color(0xFF34D399);
  static const Color accentGreenDark = Color(0xFF064E3B);

  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentAmberBright = Color(0xFFFBBF24);
  static const Color accentAmberDark = Color(0xFF451A03);

  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentPurpleBright = Color(0xFFA78BFA);
  static const Color accentPurpleDark = Color(0xFF2E1065);

  static const Color accentRed = Color(0xFFEF4444);
  static const Color accentRedBright = Color(0xFFF87171);
  static const Color accentRedDark = Color(0xFF450A0A);

  /// ThemeData completo per la modalità scura globale dell'app
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      canvasColor: bgDark,
      cardColor: surfaceDark,
      dialogTheme: const DialogThemeData(backgroundColor: surfaceDark),
      colorScheme: const ColorScheme.dark(
        primary: accentBlueBright,
        secondary: accentBlue,
        surface: surfaceDark,
        surfaceContainerHighest: surfaceElevated,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        outline: borderDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgDark,
        selectedItemColor: accentBlueBright,
        unselectedItemColor: textSecondary,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(
        color: borderDark,
        thickness: 1,
        space: 1,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w800),
        headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
        headlineSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: textSecondary, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 16, height: 1.6),
        bodyMedium: TextStyle(color: textPrimary, fontSize: 14, height: 1.5),
        bodySmall: TextStyle(color: textSecondary, fontSize: 12),
      ),
    );
  }
}
