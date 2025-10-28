import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _primaryColor = Colors.blue;
  double _textScaleFactor = 1.0;

  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;
  double get textScaleFactor => _textScaleFactor;

  ThemeProvider() {
    loadPreferences();
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeMode', mode.index);
  }

  void setPrimaryColor(Color color) async {
    _primaryColor = color;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('primaryColor', color.value);
  }

  void setTextScaleFactor(double factor) async {
    _textScaleFactor = factor;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('textScaleFactor', factor);
  }

  void loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? ThemeMode.system.index];
    _primaryColor = Color(prefs.getInt('primaryColor') ?? Colors.blue.value);
    _textScaleFactor = prefs.getDouble('textScaleFactor') ?? 1.0;
    notifyListeners();
  }
}
