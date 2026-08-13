import 'package:flutter/material.dart';
import 'account_created_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState
    extends State<CreateAccountScreen> {

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool loading = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> createAccount() async {
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
        builder: (_) => const AccountCreatedScreen(),
      ),
    );
  }

  InputDecoration decoration(
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      hintText: hint,

      prefixIcon: Icon(
        icon,
        color: const Color(0xff0E4595),
      ),

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
            vertical: 25,
          ),

          child: Form(
            key: formKey,

            child: Column(
              children: [

                const SizedBox(height: 15),

                const Text(
                  'إنشاء حساب جديد',
                  style: TextStyle(
                    color: Color(0xff123B72),
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'أنشئ حسابك للوصول إلى خدمات صيدلية الأمل',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff7D8CA3),
                    fontSize: 11.5,
                  ),
                ),

                const SizedBox(height: 25),

                TextFormField(
                  controller: nameController,
                  decoration: decoration(
                    'اسم المستخدم',
                    Icons.person_outline,
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'يرجى إدخال اسم المستخدم';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: decoration(
                    'رقم الجوال',
                    Icons.phone_outlined,
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'يرجى إدخال رقم الجوال';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: emailController,
                  keyboardType:
                      TextInputType.emailAddress,

                  decoration: decoration(
                    'البريد الإلكتروني',
                    Icons.email_outlined,
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'يرجى إدخال البريد الإلكتروني';
                    }

                    if (!RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(value.trim())) {
                      return 'البريد الإلكتروني غير صحيح';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,

                  decoration: decoration(
                    'كلمة المرور',
                    Icons.lock_outline,
                  ).copyWith(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword =
                              !obscurePassword;
                        });
                      },

                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
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

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 47,

                  child: ElevatedButton(
                    onPressed:
                        loading ? null : createAccount,

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
                          ? 'جاري إنشاء الحساب...'
                          : 'إنشاء الحساب',

                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
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