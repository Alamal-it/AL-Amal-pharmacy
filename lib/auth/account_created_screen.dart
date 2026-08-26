import 'package:flutter/material.dart';

import '../core/app_strings.dart';
import 'login_screen.dart';

class AccountCreatedScreen extends StatelessWidget {
  const AccountCreatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration:
                      const BoxDecoration(
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
                  AppStrings.accountCreated,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xff123B72),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  LocaleServiceHelper2.isArabic
                      ? 'يمكنك الآن تسجيل الدخول والاستفادة من كل خدمات صيدلية الأمل'
                      : 'You can now log in and enjoy all Alamal Pharmacy services',
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
                          builder: (_) =>
                              const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xff2EAD59),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(7),
                      ),
                    ),
                    child: Text(
                      LocaleServiceHelper2.isArabic
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
  }
}

class LocaleServiceHelper2 {
  static bool get isArabic =>
      AppStrings.language == 'العربية';
}