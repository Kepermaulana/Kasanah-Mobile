import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  get themeMode => _themeMode;

  toogleTheme(bool isDark) {
    _themeMode = isDark ? themeMode.dark : themeMode.light;
    notifyListeners();
  }
}
