import 'package:flutter/material.dart'; import 'package:flutter_localizations/flutter_localizations.dart';
import 'auth/splash_screen.dart'; import 'services/locale_service.dart';
Future<void> main() async { WidgetsFlutterBinding.ensureInitialized();
// تحميل اللغة المحفوظة قبل تشغيل التطبيق await LocaleService.instance.loadSavedLocale();
runApp(const AlamalApp()); }
class AlamalApp extends StatelessWidget { const AlamalApp({super.key});
@override Widget build(BuildContext context) { return ListenableBuilder( listenable: LocaleService.instance, builder: (context, _) { final locale = LocaleService.instance.locale;
    final isArabic = locale.languageCode == 'ar';

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // ======================================================
      // اسم التطبيق
      // ======================================================

      title: isArabic
          ? 'صيدلية الأمل'
          : 'Alamal Pharmacy',

      // ======================================================
      // اللغة الحالية
      // ======================================================

      locale: locale,

      // ======================================================
      // اللغات المدعومة
      // ======================================================

      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],

      // ======================================================
      // Flutter Localization
      // ======================================================

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ======================================================
      // اتجاه التطبيق
      // ======================================================

      builder: (context, child) {
        return Directionality(
          textDirection:
              isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: child ?? const SizedBox.shrink(),
        );
      },

      // ======================================================
      // Theme
      // ======================================================

      theme: ThemeData(
        useMaterial3: true,

        scaffoldBackgroundColor:
            const Color(0xffF7F9FC),

        colorScheme:
            ColorScheme.fromSeed(
          seedColor:
              const Color(0xff0E4595),
        ),

        fontFamily: 'Cairo',

        // ====================================================
        // AppBar
        // ====================================================

        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),

        // ====================================================
        // Text Fields
        // ====================================================

        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // ======================================================
      // الشاشة الأولى
      // ======================================================

      home: const SplashScreen(),
    );
  },
);
} }