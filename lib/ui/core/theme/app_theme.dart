import 'package:flutter/material.dart';
import '../widgets/tangible_widgets.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => getTheme(PastelPalette.currentSkin);

  static ThemeData getTheme(AppSkin skin) {
    final palette = AppPaletteData.forSkin(skin);
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: palette.canvas,
      colorScheme: ColorScheme.light(
        primary: palette.mint,
        secondary: palette.lavender,
        tertiary: palette.peach,
        surface: palette.surface,
        onSurface: palette.textDark,
        onPrimary: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: palette.textDark),
        titleTextStyle: TextStyle(
          color: palette.textDark,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          color: palette.textDark,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: palette.textDark,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: palette.textDark,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: palette.textDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: palette.textDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: palette.textMuted,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: palette.neutralBevel, width: 2),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      ),
    );
  }
}
