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

  final TextEditingController phoneController = TextEditingController();

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

  // يمنع تنفيذ الانتقال أكثر من مرة
  bool _isNavigating = false;

  // يمنع فتح أكثر من نافذة OTP
  bool _otpDialogOpen = false;

  // مدة انتظار إغلاق نافذة الرمز + الكيبورد قبل الانتقال
  static const Duration _settleDelay = Duration(milliseconds: 450);

  // ============================================================
  // Web Client ID
  // ============================================================

  static const String webClientId =
      '674471536194-pefh07cnq060fthlk1310o3467ilppfir.apps.googleusercontent.com';

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  // ============================================================
  // تهيئة Google Sign-In
  // ============================================================

  Future<void> initializeGoogleSignIn() async {
    if (_googleInitialized) return;

    await _googleSignIn.initialize(serverClientId: webClientId);

    _googleInitialized = true;
  }

  // ============================================================
  // تحويل رقم الجوال السعودي
  // ============================================================

  String _formatSaudiPhone(String phone) {
    String value = phone.trim().replaceAll(' ', '');

    if (value.startsWith('+966')) return value;

    if (value.startsWith('00966')) return '+${value.substring(2)}';

    if (value.startsWith('05') && value.length == 10) {
      return '+966${value.substring(1)}';
    }

    if (value.startsWith('5') && value.length == 9) {
      return '+966$value';
    }

    return value;
  }

  // ============================================================
  // الانتقال بعد نجاح الدخول
  //
  // سبب الشاشة الحمراء سابقًا: كنا ننتقل (pushAndRemoveUntil)
  // والكيبورد ونافذة الرمز لسا يتحركون، فيحذف Flutter الشاشات
  // وفيها عناصر ما زالت تعتمد على MediaQuery.
  // الحل: نقفل الكيبورد وننتظر انتهاء الحركة ثم ننتقل.
  // ============================================================

  Future<void> _goAfterLogin({Duration delay = _settleDelay}) async {
    if (!mounted || _isNavigating) return;

    _isNavigating = true;

    FocusManager.instance.primaryFocus?.unfocus();

    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }

    if (!mounted) return;

    _goToMainScreen();
  }

  void _goToMainScreen() {
    if (!mounted) return;

    if (widget.fromCheckout) {
      Navigator.of(context).pop(true);
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainNavScreen()),
      (route) => false,
    );
  }

  // ============================================================
  // تسجيل الدخول بواسطة Firebase OTP
  // ============================================================

  Future<void> login() async {
    if (loading || _isNavigating || _otpDialogOpen) return;

    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) return;

    final String phone = _formatSaudiPhone(phoneController.text);

    setState(() => loading = true);

    debugPrint('Firebase Phone Login: $phone');

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),

        // التحقق التلقائي (أندرويد)
        verificationCompleted: (PhoneAuthCredential credential) async {
          if (_isNavigating) return;

          try {
            await _auth.signInWithCredential(credential);

            if (!mounted || _isNavigating) return;

            UserService.instance.isLoggedIn = true;
            UserService.instance.phone = phone;

            setState(() => loading = false);

            if (_otpDialogOpen) {
              // نغلق نافذة الرمز، وبعدها يكمل _showOtpDialog الانتقال
              Navigator.of(context, rootNavigator: true).pop(true);
            } else {
              await _goAfterLogin();
            }
          } on FirebaseAuthException catch (e) {
            if (!mounted) return;

            setState(() => loading = false);

            _showFirebaseError(e);
          }
        },

        // فشل Firebase
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('Firebase Phone Auth Error: ${e.code} / ${e.message}');

          if (!mounted) return;

          setState(() => loading = false);

          _showFirebaseError(e);
        },

        // تم إرسال الرمز
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;

          debugPrint('OTP تم إرساله بنجاح');

          if (!mounted) return;

          setState(() => loading = false);

          _showOtpDialog(phone);
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Error: ${e.code} / ${e.message}');

      if (!mounted) return;

      setState(() => loading = false);

      _showFirebaseError(e);
    } catch (e) {
      if (!mounted) return;

      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ غير متوقع:\n$e')),
      );
    }
  }

  // ============================================================
  // التحقق من OTP
  // يرجع null عند النجاح، أو رسالة الخطأ
  // ============================================================

  Future<String?> _verifyOtp(String otp, String phone) async {
    final String? verificationId = _verificationId;

    if (verificationId == null) {
      return 'لم يتم العثور على جلسة التحقق، حاولي إرسال الرمز مرة أخرى.';
    }

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);

      UserService.instance.isLoggedIn = true;
      UserService.instance.phone = phone;

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-verification-code':
          return 'رمز التحقق غير صحيح.';

        case 'session-expired':
          return 'انتهت صلاحية رمز التحقق. أرسلي رمزًا جديدًا.';

        case 'too-many-requests':
          return 'تم إجراء محاولات كثيرة. حاولي مرة أخرى لاحقًا.';

        case 'credential-already-in-use':
          return 'بيانات تسجيل الدخول مستخدمة بالفعل.';

        case 'invalid-credential':
          return 'رمز التحقق غير صالح أو انتهت صلاحيته.';

        default:
          return 'Firebase: ${e.code}\n${e.message ?? ''}';
      }
    } catch (e) {
      return 'حدث خطأ أثناء التحقق:\n$e';
    }
  }

  // ============================================================
  // نافذة OTP
  // ============================================================

  Future<void> _showOtpDialog(String phone) async {
    if (!mounted || _otpDialogOpen || _isNavigating) return;

    _otpDialogOpen = true;

    final bool? verified = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _OtpDialog(
        phone: phone,
        onVerify: (otp) => _verifyOtp(otp, phone),
      ),
    );

    _otpDialogOpen = false;

    if (verified == true) {
      await _goAfterLogin();
    }
  }

  // ============================================================
  // أخطاء Firebase
  // ============================================================

  void _showFirebaseError(FirebaseAuthException e) {
    if (!mounted) return;

    String message;

    switch (e.code) {
      case 'invalid-phone-number':
        message = 'رقم الجوال غير صحيح.';
        break;

      case 'too-many-requests':
        message = 'تم إجراء محاولات كثيرة. حاولي مرة أخرى لاحقًا.';
        break;

      case 'quota-exceeded':
        message = 'تم تجاوز الحد المسموح لإرسال الرسائل.';
        break;

      case 'operation-not-allowed':
        message = 'تسجيل الدخول برقم الجوال غير مفعّل في Firebase.';
        break;

      case 'app-not-authorized':
        message =
            'التطبيق غير مصرح له باستخدام Firebase Phone Authentication.\n'
            'تأكدي من SHA-1 و SHA-256 و Package Name.';
        break;

      case 'captcha-check-failed':
        message = 'فشل التحقق الأمني من Firebase. حاولي مرة أخرى.';
        break;

      case 'network-request-failed':
        message = 'تأكدي من اتصال الإنترنت ثم حاولي مرة أخرى.';
        break;

      default:
        message = 'Firebase: ${e.code}\n${e.message ?? ''}';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 8),
      ),
    );
  }

  // ============================================================
  // Google
  // ============================================================

  Future<void> loginWithGoogle() async {
    if (loading || _isNavigating || _otpDialogOpen) return;

    try {
      setState(() => loading = true);

      await initializeGoogleSignIn();

      if (!mounted) return;

      final GoogleSignInAccount account = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = account.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw Exception('لم يتم الحصول على Google ID Token');
      }

      final OAuthCredential credential =
          GoogleAuthProvider.credential(idToken: idToken);

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user == null) {
        throw Exception('لم يتم إنشاء مستخدم في Firebase');
      }

      debugPrint('Google Firebase Login SUCCESS: ${user.uid}');

      if (!mounted) return;

      UserService.instance.isLoggedIn = true;
      UserService.instance.phone = user.email ?? '';

      setState(() => loading = false);

      await _goAfterLogin(delay: Duration.zero);
    } on GoogleSignInException catch (e) {
      if (!mounted) return;

      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_googleErrorMessage(e))),
      );

      debugPrint('Google Sign-In Error: ${e.code} / ${e.description}');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() => loading = false);

      debugPrint('Firebase Google Auth Error: ${e.code} / ${e.message}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في Firebase:\n${e.message ?? e.code}'),
          duration: const Duration(seconds: 7),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء تسجيل الدخول عبر Google:\n$e'),
          duration: const Duration(seconds: 7),
        ),
      );

      debugPrint('Google Sign-In Unknown Error: $e');
    }
  }

  // ============================================================
  // أخطاء Google
  // ============================================================

  String _googleErrorMessage(GoogleSignInException e) {
    switch (e.code) {
      case GoogleSignInExceptionCode.canceled:
        return 'تم إلغاء تسجيل الدخول عبر Google.';

      case GoogleSignInExceptionCode.clientConfigurationError:
        return 'إعدادات Google غير صحيحة. تأكدي من Package Name و SHA-1 و Web Client ID.';

      case GoogleSignInExceptionCode.providerConfigurationError:
        return 'خدمة Google غير متاحة أو إعداداتها غير صحيحة.';

      case GoogleSignInExceptionCode.uiUnavailable:
        return 'تعذر فتح شاشة تسجيل الدخول عبر Google.';

      case GoogleSignInExceptionCode.interrupted:
        return 'تمت مقاطعة تسجيل الدخول عبر Google.';

      case GoogleSignInExceptionCode.userMismatch:
        return 'حساب Google المستخدم غير متطابق.';

      case GoogleSignInExceptionCode.unknownError:
        return 'حدث خطأ أثناء تسجيل الدخول عبر Google: ${e.description ?? ''}';
    }
  }

  // ============================================================
  // Apple
  // ============================================================

  Future<void> loginWithApple() async {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.appleLoginComingSoon)),
    );
  }

  // ============================================================
  // الدخول كضيف
  // ============================================================

  void continueAsGuest() {
    if (loading || _isNavigating || _otpDialogOpen) return;

    if (widget.fromCheckout) {
      Navigator.of(context).pop(false);
    } else {
      _isNavigating = true;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const MainNavScreen(isGuest: true),
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
    final bool isArabic = Directionality.of(context) == TextDirection.rtl;

    final Alignment startAlign =
        isArabic ? Alignment.centerRight : Alignment.centerLeft;

    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),
                child: IntrinsicHeight(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 360),
                      child: Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // زر الرجوع
                            if (widget.fromCheckout)
                              Align(
                                alignment: startAlign,
                                child: IconButton(
                                  onPressed: () {
                                    if (loading) return;
                                    Navigator.of(context).pop(false);
                                  },
                                  icon: Icon(
                                    isArabic
                                        ? Icons.arrow_forward
                                        : Icons.arrow_back,
                                    color: const Color(0xff0E4595),
                                  ),
                                ),
                              ),

                            // الشعار
                            if (!widget.fromCheckout)
                              Image.asset(
                                'lib/assets/alamal.png',
                                width: 90,
                                height: 90,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.local_pharmacy_outlined,
                                    size: 70,
                                    color: Color(0xff0E4595),
                                  );
                                },
                              ),

                            const SizedBox(height: 15),

                            // العنوان
                            Text(
                              widget.fromCheckout
                                  ? AppStrings.loginToCompleteOrder
                                  : AppStrings.loginTitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xff123B72),
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // الوصف
                            Text(
                              widget.fromCheckout
                                  ? AppStrings.loginToContinueOrder
                                  : AppStrings.loginSubtitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xff7D8CA3),
                                fontSize: 11.5,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // رقم الجوال
                            TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              textAlign:
                                  isArabic ? TextAlign.right : TextAlign.left,
                              textDirection: isArabic
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              autofillHints: const [
                                AutofillHints.telephoneNumber,
                              ],
                              onFieldSubmitted: (_) => login(),
                              decoration: InputDecoration(
                                hintText: AppStrings.phoneNumber,
                                prefixIcon: const Icon(
                                  Icons.phone_outlined,
                                  color: Color(0xff0E4595),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: _outline(const Color(0xffDDE5EF)),
                                enabledBorder:
                                    _outline(const Color(0xffDDE5EF)),
                                focusedBorder:
                                    _outline(const Color(0xff0E4595), 1.5),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.phoneRequired;
                                }

                                final phone = value.replaceAll(' ', '');

                                if (!RegExp(
                                  r'^(05\d{8}|5\d{8}|\+9665\d{8})$',
                                ).hasMatch(phone)) {
                                  return AppStrings.invalidSaudiPhone;
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 8),

                            // نسيت كلمة المرور
                            if (!widget.fromCheckout)
                              Align(
                                alignment: startAlign,
                                child: TextButton(
                                  onPressed: loading
                                      ? null
                                      : () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const ForgotPasswordScreen(),
                                            ),
                                          );
                                        },
                                  child: Text(
                                    AppStrings.forgotPassword,
                                    style: const TextStyle(
                                      color: Color(0xff0E4595),
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 5),

                            // زر تسجيل الدخول
                            SizedBox(
                              width: double.infinity,
                              height: 47,
                              child: ElevatedButton(
                                onPressed:
                                    loading || _isNavigating ? null : login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff2EAD59),
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor:
                                      const Color(0xffA9D7B8),
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
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        AppStrings.login,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            // أو الدخول عبر
                            Row(
                              children: [
                                const Expanded(
                                  child: Divider(color: Color(0xffDDE5EF)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    AppStrings.orContinueWith,
                                    style: const TextStyle(
                                      color: Color(0xff7D8CA3),
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(color: Color(0xffDDE5EF)),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Google + Apple
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _SocialButton(
                                  assetPath: 'lib/assets/google_icon.png',
                                  fallbackIcon: Icons.g_mobiledata,
                                  onTap: loginWithGoogle,
                                ),
                                const SizedBox(width: 16),
                                _SocialButton(
                                  assetPath: 'lib/assets/apple_icon.png',
                                  fallbackIcon: Icons.apple,
                                  onTap: loginWithApple,
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            // إنشاء حساب
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppStrings.dontHaveAccount,
                                  style: const TextStyle(
                                    color: Color(0xff7D8CA3),
                                    fontSize: 11.5,
                                  ),
                                ),
                                TextButton(
                                  onPressed: loading
                                      ? null
                                      : () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const CreateAccountScreen(),
                                            ),
                                          );
                                        },
                                  child: Text(
                                    AppStrings.createAccount,
                                    style: const TextStyle(
                                      color: Color(0xff0E4595),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // الدخول كضيف
                            if (!widget.fromCheckout)
                              TextButton(
                                onPressed: loading || _isNavigating
                                    ? null
                                    : continueAsGuest,
                                child: Text(
                                  AppStrings.continueAsGuest,
                                  style: const TextStyle(
                                    color: Color(0xff123B72),
                                    fontWeight: FontWeight.w600,
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
    );
  }
}

// ============================================================
// حدود الحقول
// ============================================================

OutlineInputBorder _outline(Color color, [double width = 1]) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: color, width: width),
  );
}

// ============================================================
// نافذة رمز التحقق
//
// widget مستقل يملك الـ controller ويتخلص منه بنفسه
// بعد ما تنتهي حركة الإغلاق (بدل التخلص منه يدويًا).
// ============================================================

class _OtpDialog extends StatefulWidget {
  final String phone;

  // يرجع null عند النجاح أو رسالة الخطأ
  final Future<String?> Function(String otp) onVerify;

  const _OtpDialog({
    required this.phone,
    required this.onVerify,
  });

  @override
  State<_OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<_OtpDialog> {
  final TextEditingController _controller = TextEditingController();

  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy) return;

    final String otp = _controller.text.trim();

    if (otp.length != 6) {
      setState(() => _error = 'أدخل رمز التحقق المكون من 6 أرقام');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final String? error = await widget.onVerify(otp);

    // قد تكون النافذة أُغلقت (تحقق تلقائي)
    if (!mounted) return;

    if (error == null) {
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _busy = false;
        _error = error;
      });
    }
  }

  void _cancel() {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
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
            widget.phone,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xff0E4595),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            maxLength: 6,
            textAlign: TextAlign.center,
            autofocus: true,
            enabled: !_busy,
            onSubmitted: (_) => _submit(),
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
              border: _outline(const Color(0xffDDE5EF)),
              enabledBorder: _outline(const Color(0xffDDE5EF)),
              focusedBorder: _outline(const Color(0xff0E4595), 1.5),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xffD32F2F),
                fontSize: 11.5,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: _busy ? null : _cancel,
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
            onPressed: _busy ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff2EAD59),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xffA9D7B8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            child: _busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
          border: Border.all(color: const Color(0xffDDE5EF)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(
          assetPath,
          width: 22,
          height: 22,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              fallbackIcon,
              size: 24,
              color: const Color(0xff123B72),
            );
          },
        ),
      ),
    );
  }
}