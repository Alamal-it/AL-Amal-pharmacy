import 'package:flutter/material.dart';
import 'password_reset_success_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String phone;
  final String otp;

  const ResetPasswordScreen({super.key, required this.phone, required this.otp});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirm = true;
  bool loading = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) return;

    setState(() => loading = true);

    // TODO: استدعاء API حفظ كلمة السر الجديدة هنا، مع تمرير widget.phone و widget.otp
    // للتأكيد إن العملية تخص نفس طلب الاستعادة. لا تُرسلي كلمة السر إلا عبر HTTPS.
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;
    setState(() => loading = false);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const PasswordResetSuccessScreen()),
      (route) => false,
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
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'إعادة تعيين كلمة السر',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xff123B72), fontSize: 19, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'أدخل كلمة سر جديدة لحسابك',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xff7D8CA3), fontSize: 11.5),
                ),
                const SizedBox(height: 26),
                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: 'كلمة المرور الجديدة',
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xff0E4595)),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => obscurePassword = !obscurePassword),
                      icon: Icon(
                        obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: const Color(0xff7D8CA3),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xffDDE5EF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xffDDE5EF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xff0E4595), width: 1.5),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'يرجى إدخال كلمة المرور';
                    if (value.length < 6) return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    return null;
                  },
                ),
                const SizedBox(height: 13),
                TextFormField(
                  controller: confirmController,
                  obscureText: obscureConfirm,
                  textInputAction: TextInputAction.done,
                  enableSuggestions: false,
                  autocorrect: false,
                  onFieldSubmitted: (_) => save(),
                  decoration: InputDecoration(
                    hintText: 'تأكيد كلمة المرور',
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xff0E4595)),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => obscureConfirm = !obscureConfirm),
                      icon: Icon(
                        obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: const Color(0xff7D8CA3),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xffDDE5EF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xffDDE5EF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xff0E4595), width: 1.5),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'يرجى تأكيد كلمة المرور';
                    if (value != passwordController.text) return 'كلمتا المرور غير متطابقتين';
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                SizedBox(
                  height: 47,
                  child: ElevatedButton(
                    onPressed: loading ? null : save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2EAD59),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xffA9D7B8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                    ),
                    child: loading
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                          )
                        : const Text('حفظ كلمة السر', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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