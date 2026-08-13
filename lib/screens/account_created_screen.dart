import 'package:flutter/material.dart';
import 'login_screen.dart';
class AccountCreatedScreen
    extends StatelessWidget {
  const AccountCreatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),

            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                Container(
                  width: 105,
                  height: 105,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xff0E4595),
                      width: 2,
                    ),
                  ),

                  child: const Icon(
                    Icons.check_rounded,
                    color: Color(0xff0E4595),
                    size: 65,
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'تم إنشاء حسابك بنجاح',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: Color(0xff123B72),
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'يمكنك الآن تسجيل الدخول باستخدام بيانات حسابك.',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: Color(0xff7D8CA3),
                    fontSize: 11.5,
                  ),
                ),

                const SizedBox(height: 35),

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

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xff2EAD59),
                      foregroundColor: Colors.white,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(7),
                      ),
                    ),

                    child: const Text(
                      'العودة لتسجيل الدخول',

                      style: TextStyle(
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