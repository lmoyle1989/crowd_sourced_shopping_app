import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData lightTheme = ThemeData.light();
ThemeData darkTheme = ThemeData.dark();

class ThemeSettings with ChangeNotifier {
  bool _darkTheme  = false;
  SharedPreferences? _preferences;
  bool get darkTheme => _darkTheme;

  ThemeSettings() {
    _getTheme();
  }

  _initialize() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  _getTheme() async {
    await _initialize();
    _darkTheme = _preferences?.getBool('isDarkTheme') ?? false;
    notifyListeners();
  }

  _saveTheme() async {
    await _initialize();
    _preferences?.setBool('isDarkTheme', _darkTheme);
  }

  void changeTheme() {
    _darkTheme = !_darkTheme;
    _saveTheme();
    notifyListeners();
  }
}