import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _localeKey = 'app_locale';

/// Provider for managing app locale with persistence
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    _loadSavedLocale();
    return const Locale('en'); // Default while loading
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString(_localeKey);
      if (savedLanguageCode != null) {
        if (kDebugMode) debugPrint('🌍 Loading saved locale: $savedLanguageCode');
        state = Locale(savedLanguageCode);
      }
    } catch (e) {
      debugPrint('⚠️ Error loading saved locale: $e');
    }
  }

  Future<void> setLocale(Locale locale) async {
  if (kDebugMode) debugPrint('🌍 Changing locale to: ${locale.languageCode}');
  state = locale;
    
    // Save to shared preferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.languageCode);
  if (kDebugMode) debugPrint('💾 Saved locale to storage');
    } catch (e) {
  if (kDebugMode) debugPrint('⚠️ Error saving locale: $e');
    }
  }

  Future<void> toggleLanguage() async {
    final newLocale = state.languageCode == 'en' 
        ? const Locale('th') 
        : const Locale('en');
    await setLocale(newLocale);
  if (kDebugMode) debugPrint('🌍 Toggled locale to: ${newLocale.languageCode}');
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});
