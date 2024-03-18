import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appTheme = ThemeData.from(
  textTheme: GoogleFonts.signikaTextTheme(),
  colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurpleAccent, brightness: Brightness.dark),
  useMaterial3: true,
);
