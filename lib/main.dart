import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'auth/splash_screen.dart';
import 'services/locale_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const AlamalApp());
}

class AlamalApp extends StatelessWidget {
  const AlamalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleService.instance,
      builder: (context, _) {
        final locale =
            LocaleService.instance.locale;

        return MaterialApp(
          debugShowCheckedModeBanner: false,

          title: LocaleService.instance.isArabic
              ? 'صيدلية الأمل'
              : 'Alamal Pharmacy',

          locale: locale,

          supportedLocales: const [
            Locale('ar'),
            Locale('en'),
          ],

          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

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
          ),

          home: const SplashScreen(),
        );
      },
    );
  }
}