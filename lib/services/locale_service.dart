import 'package:flutter/material.dart'; import 'package:shared_preferences/shared_preferences.dart';
class LocaleService extends ChangeNotifier { LocaleService._internal();
static final LocaleService instance = LocaleService._internal();
// ============================================================ // المفتاح المستخدم لحفظ اللغة // ============================================================
static const String _localeKey = 'app_locale';
// ============================================================ // اللغة الافتراضية // ============================================================
Locale _locale = const Locale('ar');
Locale get locale => _locale;
// ============================================================ // فحص اللغة // ============================================================
bool get isArabic => _locale.languageCode == 'ar';
bool get isEnglish => _locale.languageCode == 'en';
// ============================================================ // تحميل اللغة المحفوظة // ============================================================
Future<void> loadSavedLocale() async { final prefs = await SharedPreferences.getInstance();
final savedLanguage = prefs.getString(_localeKey);

if (savedLanguage == 'en') {
  _locale = const Locale('en');
} else {
  _locale = const Locale('ar');
}

notifyListeners();
}
// ============================================================ // تغيير اللغة // ============================================================
Future<void> setLocale(Locale locale) async { final languageCode = locale.languageCode;
// السماح بالعربي والإنجليزي فقط
if (languageCode != 'ar' && languageCode != 'en') {
  return;
}

// إذا كانت نفس اللغة لا داعي لإعادة البناء
if (_locale.languageCode == languageCode) {
  return;
}

_locale = Locale(languageCode);

// حفظ اللغة
final prefs = await SharedPreferences.getInstance();

await prefs.setString(
  _localeKey,
  languageCode,
);

// تحديث التطبيق بالكامل
notifyListeners();
}
// ============================================================ // English // ============================================================
Future<void> setEnglish() async { await setLocale(const Locale('en')); }
// ============================================================ // Arabic // ============================================================
Future<void> setArabic() async { await setLocale(const Locale('ar')); }
// ============================================================ // تبديل اللغة // ============================================================
Future<void> toggleLanguage() async { if (isArabic) { await setEnglish(); } else { await setArabic(); 
} 
} 
}