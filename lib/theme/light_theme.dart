import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


/// {@template light_theme}
/// Defines the light theme for the application using [ThemeData].
///
/// This theme includes the color scheme, text styles, and primary/secondary colors.
/// It utilizes the Google Fonts package to apply the 'Manrope' font across different text styles.
///
/// The color scheme is primarily based on a bright color palette, with the primary color being
/// a shade of orange (`0xFFFF715B`) and the secondary color being black.
/// {@endtemplate}
ThemeData lightTheme = ThemeData(
  /// {@macro light_theme}

  // Sets the brightness of the theme to light mode.
  brightness: Brightness.light,

  // Defines the primary color used throughout the app (e.g., for the AppBar).
  primaryColor: Colors.white,

  // A secondary lighter color variant, often used in contrast with the primary color.
  primaryColorLight: Colors.black,

  // Configures the color scheme of the app.
  colorScheme: const ColorScheme(
    brightness: Brightness.light,

    // Primary color for active elements.
    primary: Color(0xFFFF715B),

    // Lighter variant of the primary color, used for background elements.
    primaryContainer: Color(0xFFFFEEEB),


    // Secondary color for accents and highlights.
    secondary: Colors.black,
    secondaryFixedDim:Color(0xFF130701),
    // Secondary container color, commonly used for background elements.
    secondaryContainer: Color(0xFF130701),
    //130701
    // Default surface color for components like cards and sheets.
    surface: Colors.white,

    // Error color for indicating issues such as validation errors.
    error: Colors.red,

    // Color for text/icons on primary components.
    onPrimary: Colors.white,

    // Color for text/icons on secondary components.
    onSecondary: Colors.white,

    // Color for text/icons on surface components.
    onSurface: Color(0xFFA7A7A7),

    // Color for text/icons on error components.
    onError: Colors.white,
  ),
).copyWith(
  // Customizes the typography of the theme using Google Fonts' Manrope.
  textTheme: GoogleFonts.manropeTextTheme().copyWith(
    /// {@template display_large_text}
    /// Text style for large display elements, typically used for headings.
    /// - Font size: 32
    /// - Line height: 1.3
    /// - Font weight: Extra bold
    /// - Color: Primary theme color (`0xFFFF715B`)
    /// {@endtemplate}
    headlineLarge: GoogleFonts.manrope(
      fontSize: 28,
      height: 1.3,
      fontWeight: FontWeight.w800,
      color: const Color(0xFFFF715B),
    ),
    headlineMedium: GoogleFonts.manrope(
      fontSize: 28,
      height: 1.3,
      fontWeight: FontWeight.w500,
      color: const Color(0xFFFF715B),
    ),
    headlineSmall: GoogleFonts.manrope(
      fontSize: 24,
      height: 1.3,
      fontWeight: FontWeight.w800,
    ),
    displayLarge: GoogleFonts.manrope(
      fontSize: 16,
      height: 1.3,
      fontWeight: FontWeight.w800,
    ),
    displayMedium: GoogleFonts.manrope(
      fontSize: 16,
      height: 1.3,
      fontWeight: FontWeight.w600,
    ),
    displaySmall: GoogleFonts.manrope(
      fontSize: 16,
      height: 1.3,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: GoogleFonts.manrope(
      fontSize: 14,
      height: 1.3,
      fontWeight: FontWeight.w800,
    ),
    titleMedium: GoogleFonts.manrope(
        fontSize: 14,
        height: 1.3,
        fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.manrope(
      fontSize: 14,
      height: 1.3,
      fontWeight: FontWeight.w100,
    ),

    labelLarge: GoogleFonts.manrope(
      fontWeight: FontWeight.w800,
      fontSize: 12,
      height: 1.3,
    ),
    labelMedium: GoogleFonts.manrope(
      fontWeight: FontWeight.w600,
      fontSize: 12,
      height: 1.3,
    ),
    labelSmall: GoogleFonts.manrope(
      fontWeight: FontWeight.w400,
      height: 1.3,
      fontSize: 12,
    ),
    bodyLarge: GoogleFonts.manrope(
      fontSize: 10,
      fontWeight: FontWeight.w800,
    ),
    bodyMedium: GoogleFonts.manrope(
      fontSize: 10,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: GoogleFonts.manrope(
      fontSize: 10,
      fontWeight: FontWeight.w100,
    ),

  ),
);


