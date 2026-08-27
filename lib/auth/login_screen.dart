import 'package:flutter/material.dart';

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
  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>();

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

  // ============================================================
  // تسجيل الدخول
  // ============================================================

  Future<void> login() async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    // مؤقت إلى أن يتم ربط API الحقيقي
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    if (!mounted) return;

    UserService.instance.isLoggedIn = true;
    UserService.instance.phone =
        phoneController.text.trim();

    setState(() {
      loading = false;
    });

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
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppStrings.googleLoginComingSoon,
        ),
      ),
    );
  }

  // ============================================================
  // Apple
  // ============================================================

  Future<void> loginWithApple() async {
    if (!mounted) return;

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
                                MainAxisAlignment
                                    .center,
                            children: [

                              // ==================================================
                              // زر الرجوع
                              // ==================================================

                              if (widget.fromCheckout)
                                Align(
                                  alignment: isArabic
                                      ? Alignment
                                          .centerRight
                                      : Alignment
                                          .centerLeft,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                        false,
                                      );
                                    },
                                    icon: Icon(
                                      isArabic
                                          ? Icons
                                              .arrow_forward
                                          : Icons
                                              .arrow_back,
                                      color:
                                          const Color(
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
                                      color:
                                          Color(
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
                                textAlign:
                                    TextAlign.center,
                                style:
                                    const TextStyle(
                                  color:
                                      Color(
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
                                    : AppStrings
                                        .loginSubtitle,
                                textAlign:
                                    TextAlign.center,
                                style:
                                    const TextStyle(
                                  color:
                                      Color(
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
                                    TextInputAction.next,
                                textAlign: isArabic
                                    ? TextAlign.right
                                    : TextAlign.left,
                                textDirection: isArabic
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                autofillHints:
                                    const [
                                  AutofillHints
                                      .telephoneNumber,
                                ],
                                decoration:
                                    InputDecoration(
                                  hintText:
                                      AppStrings
                                          .phoneNumber,
                                  prefixIcon:
                                      const Icon(
                                    Icons
                                        .phone_outlined,
                                    color:
                                        Color(
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
                                            .circular(
                                      8,
                                    ),
                                    borderSide:
                                        const BorderSide(
                                      color:
                                          Color(
                                        0xffDDE5EF,
                                      ),
                                    ),
                                  ),
                                  enabledBorder:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      8,
                                    ),
                                    borderSide:
                                        const BorderSide(
                                      color:
                                          Color(
                                        0xffDDE5EF,
                                      ),
                                    ),
                                  ),
                                  focusedBorder:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      8,
                                    ),
                                    borderSide:
                                        const BorderSide(
                                      color:
                                          Color(
                                        0xff0E4595,
                                      ),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value
                                          .trim()
                                          .isEmpty) {
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
                                height: 13,
                              ),

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
                                textDirection: isArabic
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                autofillHints:
                                    const [
                                  AutofillHints
                                      .password,
                                ],
                                enableSuggestions:
                                    false,
                                autocorrect: false,
                                onFieldSubmitted:
                                    (_) => login(),
                                decoration:
                                    InputDecoration(
                                  hintText:
                                      AppStrings
                                          .password,
                                  prefixIcon:
                                      const Icon(
                                    Icons.lock_outline,
                                    color:
                                        Color(
                                      0xff0E4595,
                                    ),
                                  ),
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
                                  filled: true,
                                  fillColor:
                                      Colors.white,
                                  border:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      8,
                                    ),
                                    borderSide:
                                        const BorderSide(
                                      color:
                                          Color(
                                        0xffDDE5EF,
                                      ),
                                    ),
                                  ),
                                  enabledBorder:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      8,
                                    ),
                                    borderSide:
                                        const BorderSide(
                                      color:
                                          Color(
                                        0xffDDE5EF,
                                      ),
                                    ),
                                  ),
                                  focusedBorder:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      8,
                                    ),
                                    borderSide:
                                        const BorderSide(
                                      color:
                                          Color(
                                        0xff0E4595,
                                      ),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty) {
                                    return AppStrings
                                        .passwordRequired;
                                  }

                                  if (value.length < 6) {
                                    return AppStrings
                                        .passwordMinLength;
                                  }

                                  return null;
                                },
                              ),

                              // ==================================================
                              // نسيت كلمة المرور
                              // ==================================================

                              if (!widget.fromCheckout)
                                Align(
                                  alignment: isArabic
                                      ? Alignment
                                          .centerRight
                                      : Alignment
                                          .centerLeft,
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
                                        color:
                                            Color(
                                          0xff0E4595,
                                        ),
                                        fontSize: 11.5,
                                        fontWeight:
                                            FontWeight
                                                .w700,
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
                                width:
                                    double.infinity,
                                height: 47,
                                child:
                                    ElevatedButton(
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
                                            strokeWidth:
                                                2,
                                            valueColor:
                                                AlwaysStoppedAnimation<
                                                    Color>(
                                              Colors
                                                  .white,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          AppStrings
                                              .login,
                                          style:
                                              const TextStyle(
                                            fontSize:
                                                13,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
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
                                      color:
                                          Color(
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
                                        color:
                                            Color(
                                          0xff7D8CA3,
                                        ),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    child: Divider(
                                      color:
                                          Color(
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
                                    MainAxisAlignment
                                        .center,
                                children: [
                                  _SocialButton(
                                    assetPath:
                                        'lib/assets/google_icon.png',
                                    fallbackIcon:
                                        Icons
                                            .g_mobiledata,
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
                                    MainAxisAlignment
                                        .center,
                                children: [
                                  Text(
                                    AppStrings
                                        .dontHaveAccount,
                                    style:
                                        const TextStyle(
                                      color:
                                          Color(
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
                                        color:
                                            Color(
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
                                      color:
                                          Color(
                                        0xff123B72,
                                      ),
                                      fontWeight:
                                          FontWeight
                                              .w600,
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
      borderRadius:
          BorderRadius.circular(10),
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
          borderRadius:
              BorderRadius.circular(10),
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