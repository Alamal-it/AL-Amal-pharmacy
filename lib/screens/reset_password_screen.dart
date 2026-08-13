import 'package:flutter/material.dart';
import 'password_reset_success_screen.dart';

class ResetPasswordScreen
    extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {

  final formKey = GlobalKey<FormState>();

  final passwordController =
      TextEditingController();

  final confirmController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirm = true;
  bool loading = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (passwordController.text !=
        confirmController.text) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'كلمتا المرور غير متطابقتين',
          ),
        ),
      );

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
        builder: (_) =>
            const PasswordResetSuccessScreen(),
      ),
    );
  }

  InputDecoration decoration(
    String hint,
  ) {
    return InputDecoration(
      hintText: hint,

      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xffDDE5EF),
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xffDDE5EF),
        ),
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
            vertical: 45,
          ),

          child: Form(
            key: formKey,

            child: Column(
              children: [

                const Text(
                  'إعادة تعيين كلمة السر',
                  style: TextStyle(
                    color: Color(0xff123B72),
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'اختر كلمة مرور جديدة وآمنة لحسابك.',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: Color(0xff7D8CA3),
                    fontSize: 11.5,
                  ),
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,

                  decoration:
                      decoration(
                    'كلمة المرور الجديدة',
                  ).copyWith(
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xff0E4595),
                    ),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword =
                              !obscurePassword;
                        });
                      },

                      icon: Icon(
                        obscurePassword
                            ? Icons
                                .visibility_off_outlined
                            : Icons
                                .visibility_outlined,
                      ),
                    ),
                  ),

                  validator: (value) {

                    if (value == null ||
                        value.length < 8) {
                      return 'كلمة المرور 8 أحرف على الأقل';
                    }

                    if (!RegExp(r'[A-Za-z]')
                            .hasMatch(value) ||
                        !RegExp(r'\d')
                            .hasMatch(value)) {
                      return 'استخدم حرفاً ورقماً على الأقل';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 13),

                TextFormField(
                  controller: confirmController,
                  obscureText: obscureConfirm,

                  decoration:
                      decoration(
                    'تأكيد كلمة المرور',
                  ).copyWith(
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xff0E4595),
                    ),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureConfirm =
                              !obscureConfirm;
                        });
                      },

                      icon: Icon(
                        obscureConfirm
                            ? Icons
                                .visibility_off_outlined
                            : Icons
                                .visibility_outlined,
                      ),
                    ),
                  ),

                  validator: (value) {

                    if (value == null ||
                        value.isEmpty) {
                      return 'يرجى تأكيد كلمة المرور';
                    }

                    if (value !=
                        passwordController.text) {
                      return 'كلمتا المرور غير متطابقتين';
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
                        loading
                            ? null
                            : resetPassword,

                    style: ElevatedButton.styleFrom(
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
                      loading
                          ? 'جاري الحفظ...'
                          : 'حفظ كلمة السر',

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