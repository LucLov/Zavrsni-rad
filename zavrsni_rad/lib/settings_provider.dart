import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  double _fontSize = 30.0;
  String _fontFamily = 'Sans';
  bool _backgroundSound = true;
  bool _quizSound = true;

  double get fontSize => _fontSize;
  String get fontFamily => _fontFamily;
  bool get backgroundSound => _backgroundSound;
  bool get quizSound => _quizSound;

  Locale _locale = const Locale('hr');
  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getDouble('fontSize') ?? 24.0;
    _fontFamily = prefs.getString('fontFamily') ?? 'Sans';
    _backgroundSound = prefs.getBool('backgroundSound') ?? true;
    _quizSound = prefs.getBool('quizSound') ?? true;
    notifyListeners();
  }

  void updateFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }

  void updateFontFamily(String font) {
    _fontFamily = font;
    notifyListeners();
  }

  void setBackgroundSound(bool value) {
    _backgroundSound = value;
    notifyListeners();
  }

  void setQuizSound(bool value) {
    _quizSound = value;
    notifyListeners();
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', _fontSize);
    await prefs.setString('fontFamily', _fontFamily);
    await prefs.setBool('backgroundSound', _backgroundSound);
    await prefs.setBool('quizSound', _quizSound);
  }
}
