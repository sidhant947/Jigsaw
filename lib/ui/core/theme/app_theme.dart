import 'package:flutter/material.dart';
import '../widgets/tangible_widgets.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: PastelPalette.canvas,
    colorScheme: const ColorScheme.light(
      primary: PastelPalette.mint,
      secondary: PastelPalette.lavender,
      tertiary: PastelPalette.peach,
      surface: PastelPalette.surface,
      onSurface: PastelPalette.textDark,
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: PastelPalette.textDark),
      titleTextStyle: TextStyle(
        color: PastelPalette.textDark,
        fontSize: 22,
        fontWeight: FontWeight.w800,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        color: PastelPalette.textDark,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: PastelPalette.textDark,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: PastelPalette.textDark,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: PastelPalette.textDark,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: PastelPalette.textDark,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: PastelPalette.textMuted,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: PastelPalette.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: PastelPalette.neutralBevel, width: 2),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
    ),
  );
}
