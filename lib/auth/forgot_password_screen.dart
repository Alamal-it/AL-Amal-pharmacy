import 'package:flutter/material.dart';

import '../core/app_strings.dart';
import 'verify_code_screen.dart';

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
  // إرسال رمز التحقق
  // ============================================================

  Future<void> sendCode() async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    // TODO:
    // استبدلي هذا لاحقًا باستدعاء API
    // لإرسال رمز OTP إلى رقم الجوال.
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    if (!mounted) return;

    setState(() {
      loading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VerifyCodeScreen(
          phone: phoneController.text.trim(),
        ),
      ),
    );
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

        // ======================================================
        // AppBar
        // ======================================================

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

        // ======================================================
        // Body
        // ======================================================

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

                  // ==================================================
                  // العنوان
                  // ==================================================

                  Text(
                    AppStrings.forgotPasswordTitle,

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
                        .forgotPasswordSubtitle,

                    textAlign:
                        TextAlign.center,

                    style:
                        const TextStyle(
                      color:
                          Color(0xff7D8CA3),

                      fontSize: 11.5,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ==================================================
                  // رقم الجوال
                  // ==================================================

                  TextFormField(
                    controller:
                        phoneController,

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
                      AutofillHints
                          .telephoneNumber,
                    ],

                    onFieldSubmitted: (_) {
                      sendCode();
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

                      fillColor:
                          Colors.white,

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

                      enabledBorder:
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

                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          8,
                        ),

                        borderSide:
                            const BorderSide(
                          color:
                              Color(0xff0E4595),

                          width: 1.5,
                        ),
                      ),
                    ),

                    // ==================================================
                    // التحقق من رقم الجوال
                    // ==================================================

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

                  const SizedBox(height: 22),

                  // ==================================================
                  // زر إرسال الرمز
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