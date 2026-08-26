import 'package:flutter/material.dart';

class LocaleService extends ChangeNotifier {
  LocaleService._internal();

  static final LocaleService instance = LocaleService._internal();

  // ============================================================
  // اللغة الحالية
  // ============================================================

  Locale _locale = const Locale('ar');

  Locale get locale => _locale;

  // ============================================================
  // فحص اللغة
  // ============================================================

  bool get isArabic => _locale.languageCode == 'ar';

  bool get isEnglish => _locale.languageCode == 'en';

  // ============================================================
  // تغيير اللغة
  // ============================================================

  void setLocale(Locale locale) {
    if (_locale.languageCode == locale.languageCode) {
      return;
    }

    _locale = locale;

    notifyListeners();
  }

  // ============================================================
  // English
  // ============================================================

  void setEnglish() {
    setLocale(const Locale('en'));
  }

  // ============================================================
  // Arabic
  // ============================================================

  void setArabic() {
    setLocale(const Locale('ar'));
  }
}