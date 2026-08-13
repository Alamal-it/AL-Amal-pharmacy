import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

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

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xffF7F9FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff0E4595),
        ),
        fontFamily: 'Arial',
      ),

      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox(),
        );
      },

      home: const SplashScreen(),
    );
  }
}