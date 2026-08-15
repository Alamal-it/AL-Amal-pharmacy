import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'auth/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AlamalApp());
}

class AlamalApp extends StatelessWidget {
  const AlamalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'صيدلية الأمل',

      // ===== دعم اللغة العربية والـ RTL الحقيقي =====
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'), // العربية (اللغة الأساسية)
        Locale('en'), // احتياطي لو احتجنا Localization لاحقاً
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xffF7F9FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff0E4595),
        ),
        fontFamily: 'Cairo',
      ),

      home: const SplashScreen(),
    );
  }
}