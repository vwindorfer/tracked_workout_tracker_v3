import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Dark mode colors
  static const Color darkBackground = Color(0xFF282B2B);
  static const Color darkSurface = Color(0xFF333636);
  static const Color darkSurfaceLight = Color(0xFF3E4242);
  static const Color darkPrimary = Color(0xFFEE6C29); // Orange for buttons/highlights
  static const Color darkAccent = Color(0xFF7AA6B3); // Teal for extras
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB8BCBC);
  static const Color darkTextTertiary = Color(0xFF888C8C);
  static const Color darkBorder = Color(0xFF4A4E4E);

  // Light mode colors
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceLight = Color(0xFFF8F8F8);
  static const Color lightPrimary = Color(0xFFEE6C29); // Keep orange for consistency
  static const Color lightAccent = Color(0xFF5C8A96); // Slightly darker teal for light mode
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF5A5A5A);
  static const Color lightTextTertiary = Color(0xFF9E9E9E);
  static const Color lightBorder = Color(0xFFE0E0E0);

  // Common colors
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);

  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // Border radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        surface: darkSurface,
        primary: darkPrimary,
        secondary: darkAccent,
        error: error,
        onSurface: darkTextPrimary,
        onPrimary: darkTextPrimary,
        outline: darkBorder,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: darkTextPrimary),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: darkTextPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: spacingLg, vertical: spacingMd),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkTextPrimary,
          side: const BorderSide(color: darkBorder),
          padding: const EdgeInsets.symmetric(horizontal: spacingLg, vertical: spacingMd),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimary,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: spacingMd, vertical: spacingMd),
        hintStyle: const TextStyle(color: darkTextTertiary),
        labelStyle: const TextStyle(color: darkTextSecondary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: darkPrimary,
        unselectedItemColor: darkTextTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceLight,
        selectedColor: darkPrimary,
        labelStyle: const TextStyle(color: darkTextPrimary, fontSize: 14),
        secondaryLabelStyle: const TextStyle(color: darkTextPrimary, fontSize: 14),
        padding: const EdgeInsets.symmetric(horizontal: spacingMd, vertical: spacingSm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: darkBorder,
        thickness: 1,
        space: spacingMd,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkSurfaceLight,
        contentTextStyle: const TextStyle(color: darkTextPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      textTheme: _getTextTheme(darkTextPrimary, darkTextSecondary, darkTextTertiary),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme.light(
        surface: lightSurface,
        primary: lightPrimary,
        secondary: lightAccent,
        error: error,
        onSurface: lightTextPrimary,
        onPrimary: Colors.white,
        outline: lightBorder,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: lightTextPrimary),
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: lightBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: spacingLg, vertical: spacingMd),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightTextPrimary,
          side: const BorderSide(color: lightBorder),
          padding: const EdgeInsets.symmetric(horizontal: spacingLg, vertical: spacingMd),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightPrimary,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: spacingMd, vertical: spacingMd),
        hintStyle: const TextStyle(color: lightTextTertiary),
        labelStyle: const TextStyle(color: lightTextSecondary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: lightPrimary,
        unselectedItemColor: lightTextTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightSurfaceLight,
        selectedColor: lightPrimary,
        labelStyle: const TextStyle(color: lightTextPrimary, fontSize: 14),
        secondaryLabelStyle: const TextStyle(color: lightTextPrimary, fontSize: 14),
        padding: const EdgeInsets.symmetric(horizontal: spacingMd, vertical: spacingSm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: lightBorder,
        thickness: 1,
        space: spacingMd,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightTextPrimary,
        contentTextStyle: const TextStyle(color: lightSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      textTheme: _getTextTheme(lightTextPrimary, lightTextSecondary, lightTextTertiary),
    );
  }

  static TextTheme _getTextTheme(Color primary, Color secondary, Color tertiary) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: primary,
        letterSpacing: -1,
      ),
      displayMedium: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: primary,
        letterSpacing: -0.5,
      ),
      displaySmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: primary,
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: primary,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: secondary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: primary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: secondary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: tertiary,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primary,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondary,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: tertiary,
        letterSpacing: 0.5,
      ),
    );
  }

  // Helper methods to get current theme colors
  static Color getBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkBackground : lightBackground;
  }

  static Color getSurface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkSurface : lightSurface;
  }

  static Color getSurfaceLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkSurfaceLight : lightSurfaceLight;
  }

  static Color getPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkPrimary : lightPrimary;
  }

  static Color getAccent(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkAccent : lightAccent;
  }

  static Color getTextPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkTextPrimary : lightTextPrimary;
  }

  static Color getTextSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkTextSecondary : lightTextSecondary;
  }

  static Color getTextTertiary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkTextTertiary : lightTextTertiary;
  }

  static Color getBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkBorder : lightBorder;
  }
}
