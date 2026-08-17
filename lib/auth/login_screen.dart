import 'package:flutter/material.dart';
import 'create_account_screen.dart';
import 'forgot_password_screen.dart';
import '../main_nav/main_nav_screen.dart';
import '../services/user_service.dart';

class LoginScreen extends StatefulWidget {
  // لو true: يعني وصلنا لهذي الشاشة من منتصف عملية (زي الدفع)،
  // فبعد تسجيل الدخول نرجع لنفس المكان بدل ما نصفّر التطبيق.
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

  final TextEditingController passwordController =
      TextEditingController();

  bool obscurePassword = true;
  bool loading = false;

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // =========================
  // تسجيل الدخول
  // =========================
  Future<void> login() async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    // TODO: هذا مكان استدعاء الـ API الحقيقي لتسجيل الدخول.
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    if (!mounted) return;

    // ===== تحديث حالة تسجيل الدخول في التطبيق كامل =====
    UserService.instance.isLoggedIn = true;
    UserService.instance.phone = phoneController.text.trim();

    setState(() {
      loading = false;
    });

    if (widget.fromCheckout) {
      // رجّعي لنفس المكان اللي جينا منه مع إشارة نجاح.
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

  // =========================
  // تسجيل الدخول بجوجل
  // =========================
  Future<void> loginWithGoogle() async {
    // TODO: اربطيها بحزمة google_sign_in + استدعاء API تسجيل الدخول بجوجل.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم ربط الدخول عبر Google'),
      ),
    );
  }

  // =========================
  // تسجيل الدخول بآبل
  // =========================
  Future<void> loginWithApple() async {
    // TODO: اربطيها بحزمة sign_in_with_apple + استدعاء API تسجيل الدخول بآبل.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم ربط الدخول عبر Apple'),
      ),
    );
  }

  // =========================
  // الدخول كضيف
  // =========================
  void continueAsGuest() {
    if (widget.fromCheckout) {
      // إذا جاي من الدفع وضغط "دخول كضيف"،
      // ما نقدر نكمل الطلب.
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

  // =========================
  // واجهة الصفحة
  // =========================
  @override
  Widget build(BuildContext context) {
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
                      constraints: const BoxConstraints(
                        maxWidth: 360,
                      ),
                      child: Form(
                        key: formKey,
                        autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            // =========================
                            // زر الرجوع
                            // =========================
                            if (widget.fromCheckout)
                              Align(
                                alignment:
                                    Alignment.centerRight,
                                child: IconButton(
                                  onPressed: () =>
                                      Navigator.pop(
                                    context,
                                    false,
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xff0E4595),
                                  ),
                                ),
                              ),

                            // =========================
                            // الشعار
                            // =========================
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
                                    color: Color(0xff0E4595),
                                  );
                                },
                              ),

                            const SizedBox(height: 15),

                            // =========================
                            // العنوان
                            // =========================
                            Text(
                              widget.fromCheckout
                                  ? 'سجّلي الدخول لإكمال الطلب'
                                  : 'تسجيل الدخول',
                              style: const TextStyle(
                                color: Color(0xff123B72),
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // =========================
                            // الوصف
                            // =========================
                            Text(
                              widget.fromCheckout
                                  ? 'سجّلي دخولك عشان نكمل طلبك ونتواصل معك'
                                  : 'سجّل دخولك للوصول إلى خدمات صيدلية الأمل',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xff7D8CA3),
                                fontSize: 11.5,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // =========================
                            // رقم الجوال
                            // =========================
                            TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              textInputAction:
                                  TextInputAction.next,
                              autofillHints: const [
                                AutofillHints.telephoneNumber,
                              ],
                              decoration: InputDecoration(
                                hintText: 'رقم الجوال',
                                prefixIcon: const Icon(
                                  Icons.phone_outlined,
                                  color: Color(0xff0E4595),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xffDDE5EF),
                                  ),
                                ),
                                enabledBorder:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xffDDE5EF),
                                  ),
                                ),
                                focusedBorder:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xff0E4595),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty) {
                                  return 'يرجى إدخال رقم الجوال';
                                }

                                final phone =
                                    value.replaceAll(' ', '');

                                if (!RegExp(
                                  r'^(05\d{8}|5\d{8}|\+9665\d{8})$',
                                ).hasMatch(phone)) {
                                  return 'أدخل رقم جوال سعودي صحيح';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 13),

                            // =========================
                            // كلمة المرور
                            // =========================
                            TextFormField(
                              controller:
                                  passwordController,
                              obscureText: obscurePassword,
                              textInputAction:
                                  TextInputAction.done,
                              autofillHints: const [
                                AutofillHints.password,
                              ],
                              enableSuggestions: false,
                              autocorrect: false,
                              onFieldSubmitted: (_) => login(),
                              decoration: InputDecoration(
                                hintText: 'كلمة المرور',
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
                                    color: const Color(
                                      0xff7D8CA3,
                                    ),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xffDDE5EF),
                                  ),
                                ),
                                enabledBorder:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xffDDE5EF),
                                  ),
                                ),
                                focusedBorder:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xff0E4595),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty) {
                                  return 'يرجى إدخال كلمة المرور';
                                }

                                if (value.length < 6) {
                                  return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                                }

                                return null;
                              },
                            ),

                            // =========================
                            // نسيت كلمة المرور
                            // =========================
                            if (!widget.fromCheckout)
                              Align(
                                alignment:
                                    Alignment.centerRight,
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
                                  child: const Text(
                                    'نسيت كلمة المرور؟',
                                    style: TextStyle(
                                      color: Color(0xff0E4595),
                                      fontSize: 11.5,
                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 5),

                            // =========================
                            // زر تسجيل الدخول
                            // =========================
                            SizedBox(
                              width: double.infinity,
                              height: 47,
                              child: ElevatedButton(
                                onPressed:
                                    loading ? null : login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xff2EAD59),
                                  foregroundColor: Colors.white,
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
                                        'تسجيل الدخول',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            // =========================
                            // أو الدخول عبر
                            // =========================
                            Row(
                              children: const [
                                Expanded(
                                  child: Divider(
                                    color: Color(0xffDDE5EF),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    'أو الدخول عبر',
                                    style: TextStyle(
                                      color:
                                          Color(0xff7D8CA3),
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Color(0xffDDE5EF),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // =========================
                            // Google + Apple
                            // =========================
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                _SocialButton(
                                  assetPath:
                                      'lib/assets/google_icon.png',
                                  fallbackIcon:
                                      Icons.g_mobiledata,
                                  onTap: loginWithGoogle,
                                ),
                                const SizedBox(width: 16),
                                _SocialButton(
                                  assetPath:
                                      'lib/assets/apple_icon.png',
                                  fallbackIcon: Icons.apple,
                                  onTap: loginWithApple,
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            // =========================
                            // إنشاء حساب
                            // =========================
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'ليس لديك حساب؟',
                                  style: TextStyle(
                                    color:
                                        Color(0xff7D8CA3),
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
                                  child: const Text(
                                    'إنشاء حساب',
                                    style: TextStyle(
                                      color:
                                          Color(0xff0E4595),
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 11.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // =========================
                            // الدخول كضيف
                            // =========================
                            if (!widget.fromCheckout)
                              TextButton(
                                onPressed: continueAsGuest,
                                child: const Text(
                                  'الدخول كضيف',
                                  style: TextStyle(
                                    color:
                                        Color(0xff123B72),
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
    );
  }
}

// ======================================================
// أزرار Google و Apple
// ======================================================

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
            color: const Color(0xffDDE5EF),
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
              color: const Color(0xff123B72),
            );
          },
        ),
      ),
    );
  }
}