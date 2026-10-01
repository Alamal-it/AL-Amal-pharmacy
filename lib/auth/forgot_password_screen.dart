import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/app_strings.dart';
import 'forgot_verify_code_screen.dart';
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>();

  final TextEditingController phoneController =
      TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  // ============================================================
  // تحويل رقم الجوال السعودي
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
  // إرسال رمز Firebase
  // ============================================================

  Future<void> sendCode() async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    final String phone =
        formatSaudiPhone(phoneController.text);

    setState(() {
      loading = true;
    });

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,

        // التحقق التلقائي
        verificationCompleted:
            (PhoneAuthCredential credential) async {
          // لا نكمل تلقائيًا في شاشة Forgot
          // لأن المستخدم يحتاج إدخال الرمز.
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
                'تمت محاولات كثيرة، حاول مرة أخرى لاحقًا';
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
              builder: (_) => ForgotVerifyCodeScreen(
  phone: phone,
  verificationId: verificationId,
  resendToken: resendToken,
),
            ),
          );
        },

        codeAutoRetrievalTimeout:
            (String verificationId) {},
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'حدث خطأ أثناء إرسال رمز التحقق',
          ),
        ),
      );
    }
  }

  // ============================================================
  // واجهة الصفحة
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

        appBar: AppBar(
          backgroundColor:
              const Color(0xffF7F9FC),
          elevation: 0,
          foregroundColor:
              const Color(0xff123B72),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              isArabic
                  ? Icons.arrow_forward
                  : Icons.arrow_back,
            ),
          ),
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 10,
            ),
            child: Form(
              key: formKey,
              autovalidateMode:
                  AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),

                  Text(
                    AppStrings.forgotPasswordTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xff123B72),
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    AppStrings.forgotPasswordSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xff7D8CA3),
                      fontSize: 11.5,
                    ),
                  ),

                  const SizedBox(height: 30),

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
                    autofillHints: const [
                      AutofillHints.telephoneNumber,
                    ],

                    onFieldSubmitted: (_) {
                      if (!loading) {
                        sendCode();
                      }
                    },

                    decoration:
                        InputDecoration(
                      hintText:
                          AppStrings.phoneNumber,
                      prefixIcon:
                          const Icon(
                        Icons.phone_outlined,
                        color:
                            Color(0xff0E4595),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(
                          color:
                              Color(0xffDDE5EF),
                        ),
                      ),
                      enabledBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(
                          color:
                              Color(0xffDDE5EF),
                        ),
                      ),
                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(
                          color:
                              Color(0xff0E4595),
                          width: 1.5,
                        ),
                      ),
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
                        r'^(05\d{8}|5\d{8}|\+9665\d{8}|009665\d{8})$',
                      ).hasMatch(phone)) {
                        return AppStrings
                            .invalidSaudiPhone;
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 22),

                  // ==================================================
                  // زر إرسال الرمز
                  // ==================================================

                  SizedBox(
                    width: double.infinity,
                    height: 47,
                    child: ElevatedButton(
                      onPressed:
                          loading
                              ? null
                              : sendCode,
                      style:
                          ElevatedButton.styleFrom(
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
                              BorderRadius.circular(
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
                              AppStrings.sendCode,
                              style:
                                  const TextStyle(
                                fontSize: 13,
                                fontWeight:
                                    FontWeight.bold,
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