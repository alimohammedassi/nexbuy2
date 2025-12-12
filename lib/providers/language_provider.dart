import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  bool get isArabic => _currentLocale.languageCode == 'ar';

  Future<void> setLocale(Locale locale) async {
    print('LanguageProvider: Setting locale to ${locale.languageCode}');
    _currentLocale = locale;
    notifyListeners();

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    print(
      'LanguageProvider: Saved language ${locale.languageCode} to SharedPreferences',
    );
  }

  Future<void> loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('language_code') ?? 'en';
      print('LanguageProvider: Loading saved language: $languageCode');
      _currentLocale = Locale(languageCode);
      notifyListeners();
    } catch (e) {
      print('LanguageProvider: Error loading saved language: $e');
      // If there's an error, default to English
      _currentLocale = const Locale('en');
      notifyListeners();
    }
  }
}
