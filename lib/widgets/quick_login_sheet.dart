import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../services/auth_service.dart';

class QuickLoginSheet extends StatefulWidget {
  const QuickLoginSheet({super.key});

  /// يفتح البوتوم شيت. يرجع true لو المستخدم سجّل بنجاح، و false/null لو ألغى.
  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const QuickLoginSheet(),
    );
  }

  @override
  State<QuickLoginSheet> createState() => _QuickLoginSheetState();
}

class _QuickLoginSheetState extends State<QuickLoginSheet> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => loading = true);

    // TODO: هنا مكان استدعاء API الحقيقي (إرسال/تحقق OTP مثلاً).
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    AuthService.instance.loginQuick(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context, false),
                    icon: const Icon(Icons.close, color: AppColors.primaryDark),
                  ),
                  const Text(
                    'سجّلي الدخول لإكمال الطلب',
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'نحتاج اسمك ورقم جوالك بس عشان نكمل طلبك ونتواصل معك',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textGray, fontSize: 11.5),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'الاسم',
                  prefixIcon: const Icon(Icons.person_outline,
                      color: AppColors.primary),
                  filled: true,
                  fillColor: const Color(0xffF7F9FC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال الاسم';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'رقم الجوال',
                  prefixIcon: const Icon(Icons.phone_outlined,
                      color: AppColors.primary),
                  filled: true,
                  fillColor: const Color(0xffF7F9FC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال رقم الجوال';
                  }
                  final phone = value.replaceAll(' ', '');
                  if (!RegExp(r'^(05\d{8}|5\d{8}|\+9665\d{8})$')
                      .hasMatch(phone)) {
                    return 'أدخلي رقم جوال سعودي صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 47,
                child: ElevatedButton(
                  onPressed: loading ? null : submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
                      : const Text(
                          'متابعة الطلب',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
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