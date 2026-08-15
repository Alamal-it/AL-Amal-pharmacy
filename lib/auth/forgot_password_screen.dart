import 'package:flutter/material.dart';
import 'verify_code_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<void> sendCode() async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) return;

    setState(() => loading = true);

    // TODO: استدعاء API إرسال رمز OTP لرقم الجوال هنا.
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;
    setState(() => loading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VerifyCodeScreen(phone: phoneController.text.trim()),
      ),
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
                const SizedBox(height: 12),
                const Text(
                  'نسيت كلمة السر',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xff123B72), fontSize: 19, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'أدخل رقم جوالك وسيتم إرسال رمز التحقق OTP',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xff7D8CA3), fontSize: 11.5),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  onFieldSubmitted: (_) => sendCode(),
                  decoration: InputDecoration(
                    hintText: 'رقم الجوال',
                    prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xff0E4595)),
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
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال رقم الجوال';
                    }
                    final phone = value.replaceAll(' ', '');
                    if (!RegExp(r'^(05\d{8}|5\d{8}|\+9665\d{8})$').hasMatch(phone)) {
                      return 'أدخل رقم جوال سعودي صحيح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                SizedBox(
                  height: 47,
                  child: ElevatedButton(
                    onPressed: loading ? null : sendCode,
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
                        : const Text('إرسال الرمز', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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