import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.white,
  primaryColorLight: Colors.black,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFF715B), // Primary Color
    primaryContainer: Color(0xFFFFEEEB), // Primary Color Orange Transparent
    secondary: Colors.white, // Primary Blue
    secondaryContainer: Color(0xFF8E8E8E), // Light Gray
    surface: Colors.white,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xFF535353), // Dark Gray Color

    onError: Colors.white,
  ),
).copyWith(
  textTheme: GoogleFonts.robotoTextTheme().copyWith(
    displayLarge: GoogleFonts.roboto(
      fontSize: 32,
      fontWeight: FontWeight.w800,
    ),
    titleLarge: GoogleFonts.manrope(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color(0xFFFFEEEB)),
  ),
);
