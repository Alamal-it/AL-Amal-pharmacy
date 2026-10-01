import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/app_strings.dart';
import 'account_created_screen.dart';
import 'verify_code_screen.dart';

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

  bool loading = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // ============================================================
  // تحويل رقم الجوال السعودي إلى صيغة Firebase
  // ============================================================

  String formatSaudiPhone(String phone) {
    String value = phone.replaceAll(' ', '').trim();

    if (value.startsWith('+966')) {
      return value;
    }

    if (value.startsWith('00966')) {
      return '+966${value.substring(5)}';
    }

    if (value.startsWith('05')) {
      return '+966${value.substring(1)}';
    }

    if (value.startsWith('5') && value.length == 9) {
      return '+966$value';
    }

    return value;
  }

  // ============================================================
  // إرسال رمز التحقق
  // ============================================================

  Future<void> createAccount() async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    final String name = nameController.text.trim();

    final String phone =
        formatSaudiPhone(phoneController.text);

    setState(() {
      loading = true;
    });

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,

        // في حالة تم التحقق تلقائيًا
        verificationCompleted:
            (PhoneAuthCredential credential) async {
          try {
            final UserCredential userCredential =
                await FirebaseAuth.instance
                    .signInWithCredential(credential);

            await userCredential.user
                ?.updateDisplayName(name);

            if (!mounted) return;

            setState(() {
              loading = false;
            });

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const AccountCreatedScreen(),
              ),
              (route) => false,
            );
          } catch (e) {
            if (!mounted) return;

            setState(() {
              loading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'حدث خطأ أثناء إنشاء الحساب: $e',
                ),
              ),
            );
          }
        },

        // فشل إرسال الرمز
        verificationFailed:
            (FirebaseAuthException e) {
          if (!mounted) return;

          setState(() {
            loading = false;
          });

          String message =
              'تعذر إرسال رمز التحقق';

          if (e.code == 'invalid-phone-number') {
            message = 'رقم الجوال غير صحيح';
          } else if (e.code == 'too-many-requests') {
            message =
                'تمت محاولات كثيرة، يرجى المحاولة لاحقًا';
          } else if (e.code == 'quota-exceeded') {
            message =
                'تم تجاوز حد إرسال الرسائل، حاول لاحقًا';
          } else if (e.code == 'app-not-authorized') {
            message =
                'التطبيق غير مصرح له باستخدام Firebase Authentication';
          } else if (e.message != null &&
              e.message!.isNotEmpty) {
            message = e.message!;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
            ),
          );
        },

        // تم إرسال الرمز
        codeSent:
            (String verificationId, int? resendToken) {
          if (!mounted) return;

          setState(() {
            loading = false;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VerifyCodeScreen(
                phone: phone,
                name: name,
                verificationId: verificationId,
                resendToken: resendToken,
              ),
            ),
          );
        },

        // انتهت مدة الاسترجاع التلقائي
        codeAutoRetrievalTimeout:
            (String verificationId) {
          // لا نحتاج تنفيذ شيء هنا.
        },
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'حدث خطأ، حاول مرة أخرى',
          ),
        ),
      );
    }
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
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 25,
            ),
            child: Form(
              key: formKey,
              autovalidateMode:
                  AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  const SizedBox(height: 15),

                  // ==================================================
                  // العنوان
                  // ==================================================

                  Text(
                    AppStrings.createAccountTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xff123B72),
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    AppStrings.createAccountSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xff7D8CA3),
                      fontSize: 11.5,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ==================================================
                  // الاسم
                  // ==================================================

                  TextFormField(
                    controller: nameController,
                    textAlign: isArabic
                        ? TextAlign.right
                        : TextAlign.left,
                    textDirection: isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    textInputAction:
                        TextInputAction.next,
                    decoration: decoration(
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
                    controller: phoneController,
                    keyboardType:
                        TextInputType.phone,
                    textInputAction:
                        TextInputAction.done,
                    textAlign: isArabic
                        ? TextAlign.right
                        : TextAlign.left,
                    textDirection: isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    decoration: decoration(
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
                          value.replaceAll(' ', '');

                      if (!RegExp(
                        r'^(05\d{8}|5\d{8}|\+9665\d{8}|009665\d{8})$',
                      ).hasMatch(phone)) {
                        return AppStrings
                            .invalidSaudiPhone;
                      }

                      return null;
                    },
                    onFieldSubmitted: (_) {
                      if (!loading) {
                        createAccount();
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // زر متابعة
                  // ==================================================

                  SizedBox(
                    width: double.infinity,
                    height: 47,
                    child: ElevatedButton(
                      onPressed:
                          loading ? null : createAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xff2EAD59),
                        foregroundColor:
                            Colors.white,
                        disabledBackgroundColor:
                            const Color(0xffA9D7B8),
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(7),
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
                          : const Text(
                              'متابعة',
                              style: TextStyle(
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