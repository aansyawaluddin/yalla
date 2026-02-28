import 'package:flutter/material.dart';

class AppColors {
  // Primary & Secondary
  static const Color primary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF004AAB);
  static const Color lightBlue = Color(0xFF0099FF);

  // Status Colors
  static const Color successDark = Color(0xFF20AD00);
  static const Color error = Color(0xFFFF0000);

  // Neutrals / Lines
  static const Color line = Color(0xFFDADADA);
  static const Color textDark = Color(0xFF000000);
  static const Color textGrey = Color(0xFF8E8E8E);

  // Gradients
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [secondary, lightBlue],
  );

  static final List<BoxShadow> defaultShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      blurRadius: 4,
      offset: const Offset(0, 4),
    ),
  ];
}
