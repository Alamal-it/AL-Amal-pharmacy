import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../core/app_strings.dart';
import 'create_account_screen.dart';
import 'forgot_password_screen.dart';
import '../main_nav/main_nav_screen.dart';
import '../services/user_service.dart';

class LoginScreen extends StatefulWidget {
  final bool fromCheckout;

  const LoginScreen({
    super.key,
    this.fromCheckout = false,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController phoneController =
      TextEditingController();

  // ============================================================
  // Firebase Authentication
  // ============================================================

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _verificationId;

  // ============================================================
  // Google Sign-In
  // ============================================================

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _googleInitialized = false;

  // ============================================================
  // حالة الصفحة
  // ============================================================

  bool loading = false;

  // ============================================================
  // Web Client ID
  // ============================================================
static const String webClientId =
    '674471536194-pefh07cnq060fthlk131o3467ilppfir.apps.googleusercontent.com';

  // ============================================================
  // Dispose
  // ============================================================

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  // ============================================================
  // تهيئة Google Sign-In
  // ============================================================

  Future<void> initializeGoogleSignIn() async {
    if (_googleInitialized) {
      return;
    }

    await _googleSignIn.initialize(
      serverClientId: webClientId,
    );

    _googleInitialized = true;
  }

  // ============================================================
  // تحويل رقم الجوال السعودي
  // ============================================================

  String _formatSaudiPhone(String phone) {
    String value = phone.trim();

    value = value.replaceAll(' ', '');

    if (value.startsWith('+966')) {
      return value;
    }

    if (value.startsWith('00966')) {
      return '+${value.substring(2)}';
    }

    if (value.startsWith('05') && value.length == 10) {
      return '+966${value.substring(1)}';
    }

    if (value.startsWith('5') && value.length == 9) {
      return '+966$value';
    }

    return value;
  }

  // ============================================================
  // تسجيل الدخول بواسطة Firebase OTP
  // ============================================================

  Future<void> login() async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    final String phone = _formatSaudiPhone(
      phoneController.text,
    );

    setState(() {
      loading = true;
    });

    debugPrint('====================================');
    debugPrint('Firebase Phone Login');
    debugPrint('Phone: $phone');
    debugPrint('====================================');

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,

        // ======================================================
        // التحقق التلقائي
        // ======================================================

        verificationCompleted:
            (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(
              credential,
            );

            if (!mounted) {
              return;
            }

            UserService.instance.isLoggedIn = true;
            UserService.instance.phone = phone;

            setState(() {
              loading = false;
            });

            _goToMainScreen();
          } on FirebaseAuthException catch (e) {
            if (!mounted) {
              return;
            }

            setState(() {
              loading = false;
            });

            _showFirebaseError(e);
          }
        },

        // ======================================================
        // فشل Firebase
        // ======================================================

        verificationFailed:
            (FirebaseAuthException e) {
          debugPrint('Firebase Phone Auth Error');
          debugPrint('Code: ${e.code}');
          debugPrint('Message: ${e.message}');

          if (!mounted) {
            return;
          }

          setState(() {
            loading = false;
          });

          _showFirebaseError(e);
        },

        // ======================================================
        // تم إرسال OTP
        // ======================================================

        codeSent: (
          String verificationId,
          int? resendToken,
        ) {
          _verificationId = verificationId;

          debugPrint('OTP تم إرساله بنجاح');

          if (!mounted) {
            return;
          }

          setState(() {
            loading = false;
          });

          _showOtpDialog(phone);
        },

        // ======================================================
        // انتهاء الوقت
        // ======================================================

        codeAutoRetrievalTimeout:
            (String verificationId) {
          _verificationId = verificationId;
        },

        timeout: const Duration(
          seconds: 60,
        ),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Error: ${e.code}');
      debugPrint('Message: ${e.message}');

      if (!mounted) {
        return;
      }

      setState(() {
        loading = false;
      });

      _showFirebaseError(e);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ غير متوقع:\n$e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // التحقق من OTP
  // ============================================================

  Future<void> _verifyOtp(
    String otp,
    String phone,
    BuildContext dialogContext,
  ) async {
    if (_verificationId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'لم يتم العثور على جلسة التحقق، حاولي إرسال الرمز مرة أخرى.',
            ),
          ),
        );
      }

      return;
    }

    try {
      setState(() {
        loading = true;
      });

      final PhoneAuthCredential credential =
          PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await _auth.signInWithCredential(
        credential,
      );

      if (!mounted) {
        return;
      }

      UserService.instance.isLoggedIn = true;
      UserService.instance.phone = phone;

      setState(() {
        loading = false;
      });

      Navigator.of(dialogContext).pop();

      _goToMainScreen();
    } on FirebaseAuthException catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        loading = false;
      });

      String message;

      switch (e.code) {
        case 'invalid-verification-code':
          message = 'رمز التحقق غير صحيح.';
          break;

        case 'session-expired':
          message =
              'انتهت صلاحية رمز التحقق. أرسلي رمزًا جديدًا.';
          break;

        case 'too-many-requests':
          message =
              'تم إجراء محاولات كثيرة. حاولي مرة أخرى لاحقًا.';
          break;

        default:
          message =
              'Firebase: ${e.code}\n'
              '${e.message ?? ''}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(
            seconds: 6,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ أثناء التحقق:\n$e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // نافذة OTP
  // ============================================================

  void _showOtpDialog(String phone) {
    final TextEditingController otpController =
        TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            'رمز التحقق',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff123B72),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'تم إرسال رمز التحقق إلى رقم الجوال',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff7D8CA3),
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                phone,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xff0E4595),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 18),

              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLength: 6,
                textAlign: TextAlign.center,
                autofocus: true,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff123B72),
                  letterSpacing: 4,
                ),
                decoration: InputDecoration(
                  hintText: '000000',
                  counterText: '',
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
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: loading
                  ? null
                  : () {
                      Navigator.of(dialogContext).pop();
                    },
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  color: Color(0xff7D8CA3),
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(width: 10),

            SizedBox(
              width: 100,
              height: 40,
              child: ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        final String otp =
                            otpController.text.trim();

                        if (otp.length != 6) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'أدخل رمز التحقق المكون من 6 أرقام',
                              ),
                            ),
                          );

                          return;
                        }

                        await _verifyOtp(
                          otp,
                          phone,
                          dialogContext,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xff2EAD59),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'تحقق',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      otpController.dispose();
    });
  }

  // ============================================================
  // أخطاء Firebase
  // ============================================================

  void _showFirebaseError(
    FirebaseAuthException e,
  ) {
    if (!mounted) {
      return;
    }

    String message;

    switch (e.code) {
      case 'invalid-phone-number':
        message = 'رقم الجوال غير صحيح.';
        break;

      case 'too-many-requests':
        message =
            'تم إجراء محاولات كثيرة. حاولي مرة أخرى لاحقًا.';
        break;

      case 'quota-exceeded':
        message =
            'تم تجاوز الحد المسموح لإرسال الرسائل.';
        break;

      case 'operation-not-allowed':
        message =
            'تسجيل الدخول برقم الجوال غير مفعّل في Firebase.';
        break;

      case 'app-not-authorized':
        message =
            'التطبيق غير مصرح له باستخدام Firebase Phone Authentication.\n'
            'تأكدي من SHA-1 و SHA-256 و Package Name.';
        break;

      case 'captcha-check-failed':
        message =
            'فشل التحقق الأمني من Firebase. حاولي مرة أخرى.';
        break;

      case 'network-request-failed':
        message =
            'تأكدي من اتصال الإنترنت ثم حاولي مرة أخرى.';
        break;

      default:
        message =
            'Firebase: ${e.code}\n'
            '${e.message ?? ''}';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(
          seconds: 8,
        ),
      ),
    );
  }

  // ============================================================
  // الانتقال للرئيسية
  // ============================================================

  void _goToMainScreen() {
    if (!mounted) {
      return;
    }

    if (widget.fromCheckout) {
      Navigator.pop(context, true);
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavScreen(),
        ),
        (route) => false,
      );
    }
  }

  // ============================================================
  // Google
  // ============================================================

  Future<void> loginWithGoogle() async {
    if (loading) {
      return;
    }

    try {
      setState(() {
        loading = true;
      });

      // تهيئة Google
      await initializeGoogleSignIn();

      // فتح حسابات Google
      final GoogleSignInAccount account =
          await _googleSignIn.authenticate();

      // ========================================================
      // الحصول على Google Authentication
      // ========================================================

      final GoogleSignInAuthentication googleAuth =
          account.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw Exception(
          'لم يتم الحصول على Google ID Token',
        );
      }

      debugPrint(
        'Google ID Token received successfully',
      );

      // ========================================================
      // إنشاء Firebase Credential
      // ========================================================

      final OAuthCredential credential =
          GoogleAuthProvider.credential(
        idToken: idToken,
      );

      // ========================================================
      // تسجيل الدخول الفعلي في Firebase
      // ========================================================

      final UserCredential userCredential =
          await _auth.signInWithCredential(
        credential,
      );

      final User? user = userCredential.user;

      if (user == null) {
        throw Exception(
          'لم يتم إنشاء مستخدم في Firebase',
        );
      }

      debugPrint('====================================');
      debugPrint('Google Firebase Login SUCCESS');
      debugPrint('UID: ${user.uid}');
      debugPrint('Name: ${user.displayName}');
      debugPrint('Email: ${user.email}');
      debugPrint('====================================');

      if (!mounted) {
        return;
      }

      // ========================================================
      // حفظ حالة الدخول داخل التطبيق
      // ========================================================

      UserService.instance.isLoggedIn = true;

      // حاليًا UserService عندك يستخدم phone
      // لذلك نضع البريد مؤقتًا هنا
      UserService.instance.phone = user.email ?? '';

      setState(() {
        loading = false;
      });

      // ========================================================
      // الانتقال
      // ========================================================

      if (widget.fromCheckout) {
        Navigator.pop(context, true);
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const MainNavScreen(),
          ),
          (route) => false,
        );
      }
    } on GoogleSignInException catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _googleErrorMessage(e),
          ),
        ),
      );

      debugPrint(
        'Google Sign-In Error: ${e.code}',
      );

      debugPrint(
        'Google Sign-In Description: '
        '${e.description}',
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        loading = false;
      });

      debugPrint(
        'Firebase Google Auth Error: ${e.code}',
      );

      debugPrint(
        'Firebase Google Auth Message: ${e.message}',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'خطأ في Firebase:\n'
            '${e.message ?? e.code}',
          ),
          duration: const Duration(
            seconds: 7,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ أثناء تسجيل الدخول عبر Google:\n$e',
          ),
          duration: const Duration(
            seconds: 7,
          ),
        ),
      );

      debugPrint(
        'Google Sign-In Unknown Error: $e',
      );
    }
  }

  // ============================================================
  // أخطاء Google
  // ============================================================

  String _googleErrorMessage(
    GoogleSignInException e,
  ) {
    switch (e.code) {
      case GoogleSignInExceptionCode.canceled:
        return 'تم إلغاء تسجيل الدخول عبر Google.';

      case GoogleSignInExceptionCode
          .clientConfigurationError:
        return 'إعدادات Google غير صحيحة. تأكدي من Package Name و SHA-1 و Web Client ID.';

      case GoogleSignInExceptionCode
          .providerConfigurationError:
        return 'خدمة Google غير متاحة أو إعداداتها غير صحيحة.';

      case GoogleSignInExceptionCode.uiUnavailable:
        return 'تعذر فتح شاشة تسجيل الدخول عبر Google.';

      case GoogleSignInExceptionCode.interrupted:
        return 'تمت مقاطعة تسجيل الدخول عبر Google.';

      case GoogleSignInExceptionCode.userMismatch:
        return 'حساب Google المستخدم غير متطابق.';

      case GoogleSignInExceptionCode.unknownError:
        return 'حدث خطأ أثناء تسجيل الدخول عبر Google: ${e.description ?? ''}';

      default:
        return 'حدث خطأ أثناء تسجيل الدخول عبر Google: ${e.description ?? ''}';
    }
  }

  // ============================================================
  // Apple
  // ============================================================

  Future<void> loginWithApple() async {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppStrings.appleLoginComingSoon,
        ),
      ),
    );
  }

  // ============================================================
  // الدخول كضيف
  // ============================================================

  void continueAsGuest() {
    if (widget.fromCheckout) {
      Navigator.pop(context, false);
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavScreen(
            isGuest: true,
          ),
        ),
        (route) => false,
      );
    }
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        constraints.maxHeight - 40,
                  ),
                  child: IntrinsicHeight(
                    child: Center(
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(
                          maxWidth: 360,
                        ),
                        child: Form(
                          key: formKey,
                          autovalidateMode:
                              AutovalidateMode
                                  .onUserInteraction,
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              // ==================================================
                              // زر الرجوع
                              // ==================================================

                              if (widget.fromCheckout)
                                Align(
                                  alignment: isArabic
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                        false,
                                      );
                                    },
                                    icon: Icon(
                                      isArabic
                                          ? Icons.arrow_forward
                                          : Icons.arrow_back,
                                      color: const Color(
                                        0xff0E4595,
                                      ),
                                    ),
                                  ),
                                ),

                              // ==================================================
                              // الشعار
                              // ==================================================

                              if (!widget.fromCheckout)
                                Image.asset(
                                  'lib/assets/alamal.png',
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.contain,
                                  errorBuilder:
                                      (
                                    context,
                                    error,
                                    stackTrace,
                                  ) {
                                    return const Icon(
                                      Icons
                                          .local_pharmacy_outlined,
                                      size: 70,
                                      color: Color(
                                        0xff0E4595,
                                      ),
                                    );
                                  },
                                ),

                              const SizedBox(
                                height: 15,
                              ),

                              // ==================================================
                              // العنوان
                              // ==================================================

                              Text(
                                widget.fromCheckout
                                    ? AppStrings
                                        .loginToCompleteOrder
                                    : AppStrings.loginTitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(
                                    0xff123B72,
                                  ),
                                  fontSize: 19,
                                  fontWeight:
                                      FontWeight.w800,
                                ),
                              ),

                              const SizedBox(
                                height: 8,
                              ),

                              // ==================================================
                              // الوصف
                              // ==================================================

                              Text(
                                widget.fromCheckout
                                    ? AppStrings
                                        .loginToContinueOrder
                                    : AppStrings.loginSubtitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(
                                    0xff7D8CA3,
                                  ),
                                  fontSize: 11.5,
                                ),
                              ),

                              const SizedBox(
                                height: 28,
                              ),

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
                                onFieldSubmitted: (_) =>
                                    login(),
                                decoration:
                                    InputDecoration(
                                  hintText: AppStrings
                                      .phoneNumber,
                                  prefixIcon:
                                      const Icon(
                                    Icons.phone_outlined,
                                    color: Color(
                                      0xff0E4595,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor:
                                      Colors.white,
                                  border:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(8),
                                    borderSide:
                                        const BorderSide(
                                      color: Color(
                                        0xffDDE5EF,
                                      ),
                                    ),
                                  ),
                                  enabledBorder:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(8),
                                    borderSide:
                                        const BorderSide(
                                      color: Color(
                                        0xffDDE5EF,
                                      ),
                                    ),
                                  ),
                                  focusedBorder:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(8),
                                    borderSide:
                                        const BorderSide(
                                      color: Color(
                                        0xff0E4595,
                                      ),
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
                                    r'^(05\d{8}|5\d{8}|\+9665\d{8})$',
                                  ).hasMatch(phone)) {
                                    return AppStrings
                                        .invalidSaudiPhone;
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(
                                height: 8,
                              ),

                              // ==================================================
                              // نسيت كلمة المرور
                              // ==================================================

                              if (!widget.fromCheckout)
                                Align(
                                  alignment: isArabic
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const ForgotPasswordScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      AppStrings
                                          .forgotPassword,
                                      style:
                                          const TextStyle(
                                        color: Color(
                                          0xff0E4595,
                                        ),
                                        fontSize: 11.5,
                                        fontWeight:
                                            FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),

                              const SizedBox(
                                height: 5,
                              ),

                              // ==================================================
                              // زر تسجيل الدخول
                              // ==================================================

                              SizedBox(
                                width: double.infinity,
                                height: 47,
                                child: ElevatedButton(
                                  onPressed:
                                      loading
                                          ? null
                                          : login,
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
                                              .circular(7),
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
                                          AppStrings.login,
                                          style:
                                              const TextStyle(
                                            fontSize: 13,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),

                              const SizedBox(
                                height: 22,
                              ),

                              // ==================================================
                              // أو الدخول عبر
                              // ==================================================

                              Row(
                                children: [
                                  const Expanded(
                                    child: Divider(
                                      color: Color(
                                        0xffDDE5EF,
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      AppStrings
                                          .orContinueWith,
                                      style:
                                          const TextStyle(
                                        color: Color(
                                          0xff7D8CA3,
                                        ),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),

                                  const Expanded(
                                    child: Divider(
                                      color: Color(
                                        0xffDDE5EF,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 16,
                              ),

                              // ==================================================
                              // Google + Apple
                              // ==================================================

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  _SocialButton(
                                    assetPath:
                                        'lib/assets/google_icon.png',
                                    fallbackIcon:
                                        Icons.g_mobiledata,
                                    onTap:
                                        loginWithGoogle,
                                  ),

                                  const SizedBox(
                                    width: 16,
                                  ),

                                  _SocialButton(
                                    assetPath:
                                        'lib/assets/apple_icon.png',
                                    fallbackIcon:
                                        Icons.apple,
                                    onTap:
                                        loginWithApple,
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 18,
                              ),

                              // ==================================================
                              // إنشاء حساب
                              // ==================================================

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppStrings
                                        .dontHaveAccount,
                                    style:
                                        const TextStyle(
                                      color: Color(
                                        0xff7D8CA3,
                                      ),
                                      fontSize: 11.5,
                                    ),
                                  ),

                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const CreateAccountScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      AppStrings
                                          .createAccount,
                                      style:
                                          const TextStyle(
                                        color: Color(
                                          0xff0E4595,
                                        ),
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 11.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // ==================================================
                              // الدخول كضيف
                              // ==================================================

                              if (!widget.fromCheckout)
                                TextButton(
                                  onPressed:
                                      continueAsGuest,
                                  child: Text(
                                    AppStrings
                                        .continueAsGuest,
                                    style:
                                        const TextStyle(
                                      color: Color(
                                        0xff123B72,
                                      ),
                                      fontWeight:
                                          FontWeight.w600,
                                      fontSize: 11.5,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ============================================================
// زر Google / Apple
// ============================================================

class _SocialButton extends StatelessWidget {
  final String assetPath;
  final IconData fallbackIcon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.assetPath,
    required this.fallbackIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 52,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(
              0xffDDE5EF,
            ),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(
          assetPath,
          width: 22,
          height: 22,
          fit: BoxFit.contain,
          errorBuilder:
              (context, error, stackTrace) {
            return Icon(
              fallbackIcon,
              size: 24,
              color: const Color(
                0xff123B72,
              ),
            );
          },
        ),
      ),
    );
  }
}