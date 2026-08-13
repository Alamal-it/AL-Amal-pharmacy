import 'package:flutter/material.dart';
import 'verify_code_screen.dart';

class ForgotPasswordScreen
    extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<void> sendCode() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    setState(() {
      loading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const VerifyCodeScreen(),
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
            horizontal: 25,
            vertical: 40,
          ),

          child: Form(
            key: formKey,

            child: Column(
              children: [

                const SizedBox(height: 40),

                const Text(
                  'نسيت كلمة السر',
                  style: TextStyle(
                    color: Color(0xff123B72),
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'أدخل رقم الجوال المرتبط بحسابك لإرسال رمز التحقق.',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: Color(0xff7D8CA3),
                    fontSize: 11.5,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,

                  decoration: InputDecoration(
                    hintText: 'رقم الجوال',

                    prefixIcon: const Icon(
                      Icons.phone_outlined,
                      color: Color(0xff0E4595),
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xffDDE5EF),
                      ),
                    ),

                    enabledBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xffDDE5EF),
                      ),
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'يرجى إدخال رقم الجوال';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  height: 47,

                  child: ElevatedButton(
                    onPressed:
                        loading ? null : sendCode,

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

                    child: Text(
                      loading
                          ? 'جاري الإرسال...'
                          : 'إرسال الرمز',

                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'سيتم إرسال رمز تحقق لمرة واحدة إلى رقم الجوال.',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: Color(0xff7D8CA3),
                    fontSize: 10.5,
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