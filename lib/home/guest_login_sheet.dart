import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/app_colors.dart';
import '../services/user_service.dart';
import '../auth/verify_code_screen.dart';

class GuestLoginSheet extends StatefulWidget {
  const GuestLoginSheet({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const GuestLoginSheet(),
    );
  }

  @override
  State<GuestLoginSheet> createState() =>
      _GuestLoginSheetState();
}

class _GuestLoginSheetState
    extends State<GuestLoginSheet> {
  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  String? errorText;

  bool isLoading = false;

  // ==========================================================
  // تحويل رقم الجوال السعودي
  // ==========================================================

  String _formatSaudiPhone(String phone) {
    String value = phone.trim();

    value = value.replaceAll(' ', '');

    if (value.startsWith('+966')) {
      return value;
    }

    if (value.startsWith('00966')) {
      return '+${value.substring(2)}';
    }

    if (value.startsWith('05') &&
        value.length == 10) {
      return '+966${value.substring(1)}';
    }

    if (value.startsWith('5') &&
        value.length == 9) {
      return '+966$value';
    }

    return value;
  }

  // ==========================================================
  // إرسال رمز التحقق
  // ==========================================================

  Future<void> submit() async {
    FocusScope.of(context).unfocus();

    final String name =
        nameController.text.trim();

    final String phone =
        _formatSaudiPhone(
      phoneController.text,
    );

    // ========================================================
    // التحقق من البيانات
    // ========================================================

    if (name.isEmpty) {
      setState(() {
        errorText = 'الرجاء إدخال الاسم';
      });

      return;
    }

    if (!phone.startsWith('+966') ||
        phone.length != 13) {
      setState(() {
        errorText =
            'الرجاء إدخال رقم جوال سعودي صحيح';
      });

      return;
    }

    setState(() {
      errorText = null;
      isLoading = true;
    });

    // ========================================================
    // Firebase Phone Auth
    // ========================================================

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,

        verificationCompleted:
            (PhoneAuthCredential credential) async {
          // نترك المستخدم يدخل الرمز يدويًا
          // حتى يكون نفس مسار التحقق دائمًا.
        },

        verificationFailed:
            (FirebaseAuthException e) {
          if (!mounted) return;

          setState(() {
            isLoading = false;
          });

          String message =
              'تعذر إرسال رمز التحقق';

          if (e.code ==
              'invalid-phone-number') {
            message =
                'رقم الجوال غير صحيح';
          } else if (e.code ==
              'too-many-requests') {
            message =
                'تمت محاولات كثيرة، حاولي مرة أخرى لاحقًا';
          } else if (e.message != null &&
              e.message!.isNotEmpty) {
            message = e.message!;
          }

          setState(() {
            errorText = message;
          });
        },

        codeSent: (
          String verificationId,
          int? resendToken,
        ) async {
          if (!mounted) return;

          setState(() {
            isLoading = false;
          });

          // ==================================================
          // فتح شاشة OTP
          // ==================================================

          final bool? verified =
              await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  VerifyCodeScreen(
                phone: phone,
                name: name,
                verificationId:
                    verificationId,
                resendToken:
                    resendToken,

                // مهم جدًا:
                // هذا التحقق قادم من السلة
                isGuest: true,
              ),
            ),
          );

          // ==================================================
          // بعد نجاح OTP
          // ==================================================

          if (!mounted) return;

          if (verified == true) {
            // إغلاق نافذة بيانات الضيف
            // والرجوع للشاشة التي فتحتها
            Navigator.pop(
              context,
              true,
            );
          }
        },

        codeAutoRetrievalTimeout:
            (String verificationId) {},
        
        timeout:
            const Duration(seconds: 60),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorText =
            'حدث خطأ أثناء إرسال رمز التحقق';
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration:
            const BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        padding:
            const EdgeInsets.all(20),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 40,
              height: 4,
              margin:
                  const EdgeInsets.only(
                bottom: 16,
              ),
              alignment:
                  Alignment.center,
              decoration:
                  BoxDecoration(
                color:
                    AppColors.border,
                borderRadius:
                    BorderRadius.circular(2),
              ),
            ),

            const Text(
              'أكملي بياناتك لإتمام الطلب',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight:
                    FontWeight.w700,
                color:
                    AppColors.primaryDark,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'نحتاج اسمك ورقم جوالك للتواصل بخصوص طلبك',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                color:
                    AppColors.textGray,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  nameController,
              textAlign:
                  TextAlign.right,
              textInputAction:
                  TextInputAction.next,
              decoration:
                  InputDecoration(
                hintText:
                    'الاسم الكامل',
                prefixIcon:
                    const Icon(
                  Icons.person_outline,
                ),
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller:
                  phoneController,
              textAlign:
                  TextAlign.right,
              keyboardType:
                  TextInputType.phone,
              textDirection:
                  TextDirection.ltr,
              decoration:
                  InputDecoration(
                hintText:
                    '05xxxxxxxx',
                prefixIcon:
                    const Icon(
                  Icons.phone_outlined,
                ),
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),
              ),
            ),

            if (errorText != null) ...[
              const SizedBox(height: 8),

              Text(
                errorText!,
                textAlign:
                    TextAlign.right,
                style:
                    const TextStyle(
                  color: Colors.red,
                  fontSize: 11.5,
                ),
              ),
            ],

            const SizedBox(height: 18),

            SizedBox(
              height: 48,
              child:
                  ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : submit,
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.green,
                  disabledBackgroundColor:
                      AppColors.green
                          .withValues(
                    alpha: 0.5,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
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
                        style:
                            TextStyle(
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w700,
                          color:
                              Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}