import 'package:flutter/material.dart';


// 🎨 ADVANCED DESIGN SYSTEM

const Color primaryDark = Color(0xFF0F0F0F);
const Color cardDark = Color(0xFF1E1E1E);
const Color accentRed = Color(0xFFE50914);
const Color textWhite = Color(0xFFFFFFFF);
const Color textMuted = Color(0xFF8C8C8C);

class ThemeController {
  static final ValueNotifier<ThemeMode> themeModeNotifier =
  ValueNotifier(ThemeMode.dark);

  static void toggleTheme(bool isDark) {
    themeModeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}