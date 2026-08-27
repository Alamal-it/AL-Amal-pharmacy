import 'package:flutter/material.dart';

import '../core/app_strings.dart';
import 'account_created_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState
    extends State<CreateAccountScreen> {
  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>();

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

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

  // ============================================================
  // إنشاء الحساب
  // ============================================================

  Future<void> createAccount() async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    // مؤقتًا إلى أن يتم ربط API
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
            const AccountCreatedScreen(),
      ),
    );
  }

  // ============================================================
  // تصميم الحقول
  // ============================================================

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

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xff0E4595),
          width: 1.5,
        ),
      ),
    );
  }

  // ============================================================
  // الصفحة
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final bool isArabic =
        Directionality.of(context) ==
            TextDirection.rtl;

    return Directionality(
      textDirection: isArabic
          ? TextDirection.rtl
          : TextDirection.ltr,

      child: Scaffold(
        backgroundColor:
            const Color(0xffF7F9FC),

        body: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 25,
            ),

            child: Form(
              key: formKey,

              autovalidateMode:
                  AutovalidateMode
                      .onUserInteraction,

              child: Column(
                children: [
                  const SizedBox(height: 15),

                  // ==================================================
                  // العنوان
                  // ==================================================

                  Text(
                    AppStrings
                        .createAccountTitle,

                    textAlign:
                        TextAlign.center,

                    style:
                        const TextStyle(
                      color:
                          Color(0xff123B72),
                      fontSize: 19,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ==================================================
                  // الوصف
                  // ==================================================

                  Text(
                    AppStrings
                        .createAccountSubtitle,

                    textAlign:
                        TextAlign.center,

                    style:
                        const TextStyle(
                      color:
                          Color(0xff7D8CA3),
                      fontSize: 11.5,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ==================================================
                  // اسم المستخدم
                  // ==================================================

                  TextFormField(
                    controller:
                        nameController,

                    textAlign: isArabic
                        ? TextAlign.right
                        : TextAlign.left,

                    textDirection: isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,

                    textInputAction:
                        TextInputAction.next,

                    decoration:
                        decoration(
                      AppStrings.username,
                      Icons.person_outline,
                    ),

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return AppStrings
                            .usernameRequired;
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // ==================================================
                  // رقم الجوال
                  // ==================================================

                  TextFormField(
                    controller:
                        phoneController,

                    keyboardType:
                        TextInputType.phone,

                    textInputAction:
                        TextInputAction.next,

                    textAlign: isArabic
                        ? TextAlign.right
                        : TextAlign.left,

                    textDirection: isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,

                    decoration:
                        decoration(
                      AppStrings.phoneNumber,
                      Icons.phone_outlined,
                    ),

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return AppStrings
                            .phoneRequired;
                      }

                      final phone =
                          value.replaceAll(
                        ' ',
                        '',
                      );

                      if (!RegExp(
                        r'^(05\d{8}|5\d{8}|\+9665\d{8})$',
                      ).hasMatch(phone)) {
                        return AppStrings
                            .invalidSaudiPhone;
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // ==================================================
                  // البريد الإلكتروني
                  // ==================================================

                  TextFormField(
                    controller:
                        emailController,

                    keyboardType:
                        TextInputType
                            .emailAddress,

                    textInputAction:
                        TextInputAction.next,

                    textAlign: isArabic
                        ? TextAlign.right
                        : TextAlign.left,

                    // الإيميل دائمًا LTR
                    textDirection:
                        TextDirection.ltr,

                    decoration:
                        decoration(
                      AppStrings.email,
                      Icons.email_outlined,
                    ),

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return AppStrings
                            .emailRequired;
                      }

                      if (!RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      ).hasMatch(
                        value.trim(),
                      )) {
                        return AppStrings
                            .invalidEmail;
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // ==================================================
                  // كلمة المرور
                  // ==================================================

                  TextFormField(
                    controller:
                        passwordController,

                    obscureText:
                        obscurePassword,

                    textInputAction:
                        TextInputAction.done,

                    textAlign: isArabic
                        ? TextAlign.right
                        : TextAlign.left,

                    textDirection:
                        TextDirection.ltr,

                    enableSuggestions: false,
                    autocorrect: false,

                    onFieldSubmitted:
                        (_) =>
                            createAccount(),

                    decoration:
                        decoration(
                      AppStrings.password,
                      Icons.lock_outline,
                    ).copyWith(
                      suffixIcon:
                          IconButton(
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

                          color:
                              const Color(
                            0xff7D8CA3,
                          ),
                        ),
                      ),
                    ),

                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return AppStrings
                            .passwordRequired;
                      }

                      if (value.length < 8) {
                        return AppStrings
                            .passwordMinLength;
                      }

                      final hasLetter =
                          RegExp(
                        r'[A-Za-z]',
                      ).hasMatch(value);

                      final hasNumber =
                          RegExp(
                        r'\d',
                      ).hasMatch(value);

                      if (!hasLetter ||
                          !hasNumber) {
                        return AppStrings
                            .passwordMustContainLetterAndNumber;
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // زر إنشاء الحساب
                  // ==================================================

                  SizedBox(
                    width:
                        double.infinity,

                    height: 47,

                    child:
                        ElevatedButton(
                      onPressed:
                          loading
                              ? null
                              : createAccount,

                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            const Color(
                          0xff2EAD59,
                        ),

                        foregroundColor:
                            Colors.white,

                        disabledBackgroundColor:
                            const Color(
                          0xffA9D7B8,
                        ),

                        elevation: 0,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            7,
                          ),
                        ),
                      ),

                      child: loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,

                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,

                                valueColor:
                                    AlwaysStoppedAnimation<
                                        Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              AppStrings
                                  .createAccount,

                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
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
      ),
    );
  }
}