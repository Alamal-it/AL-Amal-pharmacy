import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_strings.dart';
import '../services/user_service.dart';
import 'account_created_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String phone;
  final String name;
  final String verificationId;
  final int? resendToken;

  // true إذا كان التحقق جاء من تسجيل الضيف أثناء الطلب
  final bool isGuest;

  const VerifyCodeScreen({
    super.key,
    required this.phone,
    required this.name,
    required this.verificationId,
    this.resendToken,
    this.isGuest = false,
  });

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  // Firebase SMS code = 6 أرقام
  static const int codeLength = 6;

  // مدة انتظار إغلاق الكيبورد قبل الانتقال (يمنع الشاشة الحمراء)
  static const Duration _settleDelay = Duration(milliseconds: 350);

  final List<TextEditingController> controllers =
      List.generate(codeLength, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
      List.generate(codeLength, (_) => FocusNode());

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

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft == 0) {
        t.cancel();
      } else if (mounted) {
        setState(() {
          secondsLeft--;
        });
      }
    });
  }

  // ============================================================
  // الرمز
  // ============================================================

  String get code => controllers.map((c) => c.text).join();

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
        verificationCompleted: (PhoneAuthCredential credential) async {
          // لا نحتاج تنفيذ تلقائي هنا.
        },
        verificationFailed: (FirebaseAuthException e) {
          if (!mounted) return;

          setState(() {
            loading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تعذر إعادة إرسال رمز التحقق: ${e.message ?? e.code}',
              ),
            ),
          );
        },
        codeSent: (String newVerificationId, int? newResendToken) {
          if (!mounted) return;

          setState(() {
            verificationId = newVerificationId;
            resendToken = newResendToken;
            loading = false;
          });

          _clearCode();
          _startTimer();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppStrings.codeResent)),
          );
        },
        codeAutoRetrievalTimeout: (String newVerificationId) {
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
          content: Text('حدث خطأ أثناء إعادة إرسال الرمز'),
        ),
      );
    }
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
  // التحقق من الرمز
  // ============================================================

  Future<void> verify() async {
    if (loading) return;

    FocusManager.instance.primaryFocus?.unfocus();

    if (code.length != codeLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('أدخل رمز التحقق المكون من 6 أرقام'),
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    try {
      // إنشاء Firebase credential
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );

      // تسجيل الدخول / إنشاء المستخدم في Firebase
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // حفظ اسم المستخدم في Firebase
      final User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(widget.name);

        await user.reload();
      }

      if (!mounted) return;

      // ==========================================================
      // ننتظر انتهاء حركة إغلاق الكيبورد قبل أي انتقال
      // (هذا هو سبب الشاشة الحمراء _dependents.isEmpty)
      // وزر التحقق يبقى معطّلًا (loading) خلال الانتظار.
      // ==========================================================

      await Future.delayed(_settleDelay);

      if (!mounted) return;

      // إذا كان المستخدم قادم من تسجيل الضيف
      if (widget.isGuest) {
        UserService.instance.loginAsGuestUser(
          name: widget.name,
          phone: widget.phone,
        );

        // نرجع فقط للشاشة السابقة بدون حذف السلة أو مسار الطلب
        Navigator.pop(context, true);

        return;
      }

      // التسجيل العادي
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const AccountCreatedScreen(),
        ),
        (route) => false,
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
        message = 'انتهت صلاحية رمز التحقق، أعد إرسال رمز جديد';
      } else if (e.code == 'invalid-verification-id') {
        message = 'انتهت جلسة التحقق، أعد إرسال الرمز';
      } else if (e.code == 'credential-already-in-use') {
        message = 'هذا الرقم مرتبط بحساب موجود بالفعل';
      } else if (e.code == 'too-many-requests') {
        message = 'تمت محاولات كثيرة، حاول مرة أخرى لاحقًا';
      } else if (e.message != null && e.message!.isNotEmpty) {
        message = e.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء التحقق، حاول مرة أخرى'),
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

  OutlineInputBorder _border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xffF7F9FC),
        elevation: 0,
        foregroundColor: const Color(0xff123B72),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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

              // خانات الرمز - 6 أرقام
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(codeLength, (i) {
                  return Container(
                    width: 45,
                    height: 52,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    child: TextField(
                      controller: controllers[i],
                      focusNode: focusNodes[i],
                      enabled: !loading,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff123B72),
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white,
                        border: _border(const Color(0xffDDE5EF)),
                        enabledBorder: _border(const Color(0xffDDE5EF)),
                        disabledBorder: _border(const Color(0xffDDE5EF)),
                        focusedBorder: _border(const Color(0xff0E4595), 1.5),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && i < codeLength - 1) {
                          focusNodes[i + 1].requestFocus();
                        }

                        if (value.isEmpty && i > 0) {
                          focusNodes[i - 1].requestFocus();
                        }

                        if (i == codeLength - 1 && value.isNotEmpty) {
                          verify();
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 24),

              // المؤقت
              if (secondsLeft > 0)
                Text(
                  '${AppStrings.didNotReceiveCode} '
                  '00:${secondsLeft.toString().padLeft(2, '0')}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xff7D8CA3),
                    fontSize: 11.5,
                  ),
                )
              else
                Center(
                  child: TextButton(
                    onPressed: loading ? null : resend,
                    child: Text(
                      AppStrings.resendCode,
                      style: const TextStyle(
                        color: Color(0xff0E4595),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 18),

              // زر التحقق
              SizedBox(
                height: 47,
                child: ElevatedButton(
                  onPressed: loading ? null : verify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2EAD59),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xffA9D7B8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          AppStrings.verify,
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
    );
  }
}