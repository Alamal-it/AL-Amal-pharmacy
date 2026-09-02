import 'package:flutter/material.dart';

import 'login_screen.dart';
import '../services/locale_service.dart';

class PasswordResetSuccessScreen extends StatelessWidget {
  const PasswordResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleService.instance,
      builder: (context, child) {
        final bool isArabic = LocaleService.instance.isArabic;

        return Directionality(
          textDirection:
              isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffE7F5EC),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Color(0xff2EAD59),
                        size: 52,
                      ),
                    ),

                    const SizedBox(height: 22),

                    Text(
                      isArabic
                          ? 'تم إنشاء كلمة السر بنجاح'
                          : 'Password Created Successfully',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xff123B72),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      isArabic
                          ? 'يمكنك الآن تسجيل الدخول بكلمة السر الجديدة'
                          : 'You can now log in with your new password',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xff7D8CA3),
                        fontSize: 12.5,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 47,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2EAD59),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: Text(
                          isArabic
                              ? 'عودة تسجيل الدخول'
                              : 'Back to Login',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}