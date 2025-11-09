import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing app locale
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    return const Locale('en');
  }

  void setLocale(Locale locale) {
    print('🌍 Changing locale to: ${locale.languageCode}');
    state = locale;
  }

  void toggleLanguage() {
    state = state.languageCode == 'en' 
        ? const Locale('th') 
        : const Locale('en');
    print('🌍 Toggled locale to: ${state.languageCode}');
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});
