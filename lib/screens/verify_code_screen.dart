import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'reset_password_screen.dart';

class VerifyCodeScreen
    extends StatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  State<VerifyCodeScreen> createState() =>
      _VerifyCodeScreenState();
}

class _VerifyCodeScreenState
    extends State<VerifyCodeScreen> {

  final controllers =
      List.generate(
    5,
    (_) => TextEditingController(),
  );

  final focusNodes =
      List.generate(
    5,
    (_) => FocusNode(),
  );

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }

    for (final node in focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  void verifyCode() {
    final code =
        controllers.map((e) => e.text).join();

    if (code.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'أدخل رمز التحقق المكون من 5 أرقام',
          ),
        ),
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const ResetPasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 45,
          ),

          child: Column(
            children: [

              const Text(
                'التحقق من الرمز',
                style: TextStyle(
                  color: Color(0xff123B72),
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'تم إرسال رمز التحقق إلى رقم الجوال المسجل في الحساب.',
                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Color(0xff7D8CA3),
                  fontSize: 11.5,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 35),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: List.generate(
                  5,
                  (index) {

                    return Container(
                      width: 48,
                      height: 52,

                      margin:
                          const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),

                      child: TextField(
                        controller:
                            controllers[index],

                        focusNode:
                            focusNodes[index],

                        textAlign: TextAlign.center,

                        keyboardType:
                            TextInputType.number,

                        maxLength: 1,

                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly,
                        ],

                        style: const TextStyle(
                          color: Color(0xff123B72),
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),

                        decoration:
                            InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: Colors.white,

                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              8,
                            ),
                            borderSide:
                                const BorderSide(
                              color:
                                  Color(0xffDDE5EF),
                            ),
                          ),
                        ),

                        onChanged: (value) {

                          if (value.isNotEmpty &&
                              index < 4) {
                            focusNodes[index + 1]
                                .requestFocus();
                          }

                          if (value.isEmpty &&
                              index > 0) {
                            focusNodes[index - 1]
                                .requestFocus();
                          }
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 18),

              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'سيتم إرسال رمز جديد من الخادم',
                      ),
                    ),
                  );
                },

                child: const Text(
                  'لم يصلك الرمز؟ إعادة الإرسال',

                  style: TextStyle(
                    color: Color(0xff0E4595),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 47,

                child: ElevatedButton(
                  onPressed: verifyCode,

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
                    'تحقق',

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
    );
  }
}