import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_strings.dart';
import 'reset_password_screen.dart';

class ForgotVerifyCodeScreen extends StatefulWidget {
  final String phone;
  final String verificationId;
  final int? resendToken;

  const ForgotVerifyCodeScreen({
    super.key,
    required this.phone,
    required this.verificationId,
    this.resendToken,
  });

  @override
  State<ForgotVerifyCodeScreen> createState() =>
      _ForgotVerifyCodeScreenState();
}

class _ForgotVerifyCodeScreenState
    extends State<ForgotVerifyCodeScreen> {
  static const int codeLength = 6;

  final List<TextEditingController> controllers =
      List.generate(
    codeLength,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes =
      List.generate(
    codeLength,
    (_) => FocusNode(),
  );

  Timer? timer;

  int secondsLeft = 45;

  bool loading = false;

  late String verificationId;

  int? resendToken;

  @override
  void initState() {
    super.initState();

    verificationId = widget.verificationId;
    resendToken = widget.resendToken;

    _startTimer();
  }

  // ============================================================
  // المؤقت
  // ============================================================

  void _startTimer() {
    secondsLeft = 45;

    timer?.cancel();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (t) {
        if (secondsLeft == 0) {
          t.cancel();
        } else {
          if (mounted) {
            setState(() {
              secondsLeft--;
            });
          }
        }
      },
    );
  }

  // ============================================================
  // الرمز
  // ============================================================

  String get code {
    return controllers
        .map((controller) => controller.text)
        .join();
  }

  // ============================================================
  // مسح الرمز
  // ============================================================

  void _clearCode() {
    for (final controller in controllers) {
      controller.clear();
    }

    if (focusNodes.isNotEmpty) {
      focusNodes.first.requestFocus();
    }
  }

  // ============================================================
  // إعادة إرسال الرمز
  // ============================================================

  Future<void> resend() async {
    if (loading) return;

    setState(() {
      loading = true;
    });

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phone,

        forceResendingToken: resendToken,

        verificationCompleted:
            (PhoneAuthCredential credential) {
          // لا نكمل تلقائيًا في Forgot Password.
        },

        verificationFailed:
            (FirebaseAuthException e) {
          if (!mounted) return;

          setState(() {
            loading = false;
          });

          String message =
              'تعذر إعادة إرسال رمز التحقق';

          if (e.code == 'invalid-phone-number') {
            message = 'رقم الجوال غير صحيح';
          } else if (e.code == 'too-many-requests') {
            message =
                'تمت محاولات كثيرة، حاول مرة أخرى لاحقًا';
          } else if (e.code == 'quota-exceeded') {
            message =
                'تم تجاوز حد إرسال الرسائل، حاول لاحقًا';
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

        codeSent:
            (String newVerificationId,
                int? newResendToken) {
          if (!mounted) return;

          setState(() {
            verificationId = newVerificationId;
            resendToken = newResendToken;
            loading = false;
          });

          _clearCode();
          _startTimer();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'تم إرسال رمز جديد',
              ),
            ),
          );
        },

        codeAutoRetrievalTimeout:
            (String newVerificationId) {
          verificationId = newVerificationId;
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
            'حدث خطأ أثناء إعادة إرسال الرمز',
          ),
        ),
      );
    }
  }

  // ============================================================
  // التحقق من الرمز
  // ============================================================

  Future<void> verify() async {
    FocusScope.of(context).unfocus();

    if (code.length != codeLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'أدخل رمز التحقق المكون من 6 أرقام',
          ),
        ),
      );

      return;
    }

    if (loading) return;

    setState(() {
      loading = true;
    });

    try {
      final PhoneAuthCredential credential =
          PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );

      // التحقق من الرمز مع Firebase
      await FirebaseAuth.instance
          .signInWithCredential(credential);

      if (!mounted) return;

      setState(() {
        loading = false;
      });

      // بعد نجاح التحقق ننتقل لتغيير كلمة المرور
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(
            phone: widget.phone,
            otp: code,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      String message = 'رمز التحقق غير صحيح';

      if (e.code == 'invalid-verification-code') {
        message = 'رمز التحقق غير صحيح';
      } else if (e.code == 'session-expired') {
        message =
            'انتهت صلاحية رمز التحقق، أعد إرسال رمز جديد';
      } else if (e.code == 'invalid-verification-id') {
        message =
            'انتهت جلسة التحقق، أعد إرسال الرمز';
      } else if (e.code == 'too-many-requests') {
        message =
            'تمت محاولات كثيرة، حاول مرة أخرى لاحقًا';
      } else if (e.message != null &&
          e.message!.isNotEmpty) {
        message = e.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'حدث خطأ أثناء التحقق، حاول مرة أخرى',
          ),
        ),
      );
    }
  }

  // ============================================================
  // إغلاق الموارد
  // ============================================================

  @override
  void dispose() {
    timer?.cancel();

    for (final controller in controllers) {
      controller.dispose();
    }

    for (final focusNode in focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
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
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),

                Text(
                  AppStrings.verifyCodeTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xff123B72),
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '${AppStrings.verifyCodeSubtitle}\n${widget.phone}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xff7D8CA3),
                    fontSize: 11.5,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 28),

                // ==================================================
                // خانات الرمز
                // ==================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: List.generate(
                    codeLength,
                    (i) {
                      return Container(
                        width: 45,
                        height: 52,
                        margin:
                            const EdgeInsets.symmetric(
                          horizontal: 3,
                        ),
                        child: TextField(
                          controller:
                              controllers[i],
                          focusNode:
                              focusNodes[i],
                          textAlign:
                              TextAlign.center,
                          keyboardType:
                              TextInputType.number,
                          maxLength: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly,
                          ],
                          style:
                              const TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w800,
                            color:
                                Color(0xff123B72),
                          ),
                          decoration:
                              InputDecoration(
                            counterText: '',
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
                          onChanged: (value) {
                            if (value.isNotEmpty &&
                                i <
                                    codeLength - 1) {
                              focusNodes[i + 1]
                                  .requestFocus();
                            }

                            if (value.isEmpty &&
                                i > 0) {
                              focusNodes[i - 1]
                                  .requestFocus();
                            }

                            if (i ==
                                    codeLength - 1 &&
                                value.isNotEmpty) {
                              verify();
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // ==================================================
                // المؤقت
                // ==================================================

                if (secondsLeft > 0)
                  Text(
                    '${AppStrings.didNotReceiveCode} '
                    '00:${secondsLeft.toString().padLeft(2, '0')}',
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(
                      color:
                          Color(0xff7D8CA3),
                      fontSize: 11.5,
                    ),
                  )
                else
                  Center(
                    child: TextButton(
                      onPressed:
                          loading ? null : resend,
                      child: Text(
                        AppStrings.resendCode,
                        style:
                            const TextStyle(
                          color:
                              Color(0xff0E4595),
                          fontWeight:
                              FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 18),

                // ==================================================
                // زر التحقق
                // ==================================================

                SizedBox(
                  height: 47,
                  child: ElevatedButton(
                    onPressed:
                        loading ? null : verify,
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
                            AppStrings.verify,
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
    );
  }
}