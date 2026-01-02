import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeBoxName = 'theme_settings';
  static const String _themeKey = 'is_dark_mode';

  late Box _themeBox;
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> initialize() async {
    _themeBox = await Hive.openBox(_themeBoxName);
    _isDarkMode = _themeBox.get(_themeKey, defaultValue: true);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _themeBox.put(_themeKey, _isDarkMode);
    notifyListeners();
  }

  Future<void> setTheme(bool isDark) async {
    if (_isDarkMode == isDark) return;
    _isDarkMode = isDark;
    await _themeBox.put(_themeKey, _isDarkMode);
    notifyListeners();
  }
}
