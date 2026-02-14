import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChikitsaTheme {
  // ─── Brutalist / Swiss Palette ────────────────────────────────
  static const Color boneWhite = Color(0xFFF3F2EE); // Driftime background
  static const Color pureBlack = Color(0xFF000000);
  static const Color alertOrange = Color(0xFFFF5722); // High contrast accent
  static const Color darkGrey = Color(0xFF333333);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: pureBlack,
      scaffoldBackgroundColor: boneWhite,
      cardColor: boneWhite, // No cards really, just borders

      colorScheme: const ColorScheme.light(
        primary: pureBlack,
        onPrimary: boneWhite,
        secondary: pureBlack,
        onSecondary: boneWhite,
        surface: boneWhite,
        onSurface: pureBlack,
        outline: pureBlack,
        error: alertOrange,
      ),

      fontFamily: GoogleFonts.archivo().fontFamily, // Geometric, strong

      textTheme: _buildTextTheme(),

      appBarTheme: AppBarTheme(
        backgroundColor: boneWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: pureBlack, size: 28),
        titleTextStyle: GoogleFonts.archivoBlack(
          // Massive headers
          color: pureBlack,
          fontSize: 24,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.0,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: pureBlack,
          foregroundColor: boneWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero), // Sharp
          textStyle: GoogleFonts.archivo(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: pureBlack,
          side: const BorderSide(color: pureBlack, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: GoogleFonts.archivo(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: pureBlack, width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: pureBlack, width: 2),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: pureBlack, width: 4), // Thicker focus
        ),
        hintStyle: GoogleFonts.archivo(color: Colors.black45),
        labelStyle:
            GoogleFonts.archivo(color: pureBlack, fontWeight: FontWeight.bold),
      ),

      iconTheme: const IconThemeData(color: pureBlack, size: 28),

      dividerTheme: const DividerThemeData(
        color: pureBlack,
        thickness: 2,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return boneWhite;
          return pureBlack;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return pureBlack;
          return Colors.transparent;
        }),
        trackOutlineColor: WidgetStateProperty.all(pureBlack),
        trackOutlineWidth: WidgetStateProperty.all(2.0),
      ),

      cardTheme: const CardThemeData(
        color: boneWhite,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: pureBlack, width: 2),
        ),
      ),
    );
  }

  // Dark theme concept for Brutalism usually just inverts or stays light.
  // We'll keep it strictly light as per the "Driftime" reference (Cream bg).
  static ThemeData get darkTheme => lightTheme;

  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.archivoBlack(
        // HERO HEADER
        fontSize: 56,
        fontWeight: FontWeight.w900,
        color: pureBlack,
        letterSpacing: -3.0,
        height: 0.9,
      ),
      displayMedium: GoogleFonts.archivoBlack(
        fontSize: 40,
        fontWeight: FontWeight.w900,
        color: pureBlack,
        letterSpacing: -2.0,
        height: 0.95,
      ),
      headlineSmall: GoogleFonts.archivo(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: pureBlack,
        letterSpacing: -0.5,
      ),
      titleLarge: GoogleFonts.archivo(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: pureBlack,
      ),
      titleMedium: GoogleFonts.archivo(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: pureBlack,
      ),
      bodyLarge: GoogleFonts.archivo(
        // Editorial Body
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: pureBlack,
        height: 1.4,
      ),
      bodyMedium: GoogleFonts.archivo(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: darkGrey,
        height: 1.4,
      ),
      bodySmall: GoogleFonts.archivo(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: pureBlack,
        letterSpacing: 0.5,
      ),
    );
  }
}
