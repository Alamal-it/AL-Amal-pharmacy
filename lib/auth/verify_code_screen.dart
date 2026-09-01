import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_strings.dart';
import 'reset_password_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String phone;

  const VerifyCodeScreen({
    super.key,
    required this.phone,
  });

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  static const int codeLength = 4;

  final List<TextEditingController> controllers =
      List.generate(codeLength, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
      List.generate(codeLength, (_) => FocusNode());

  Timer? timer;
  int secondsLeft = 45;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

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
            setState(() => secondsLeft--);
          }
        }
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();

    for (final c in controllers) {
      c.dispose();
    }

    for (final f in focusNodes) {
      f.dispose();
    }

    super.dispose();
  }

  String get code => controllers.map((c) => c.text).join();

  Future<void> resend() async {
    // TODO: استدعاء API إعادة إرسال الرمز هنا.

    _startTimer();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.codeResent),
      ),
    );
  }

  Future<void> verify() async {
    FocusScope.of(context).unfocus();

    if (code.length != codeLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.enterFullCode),
        ),
      );
      return;
    }

    setState(() => loading = true);

    // TODO: استدعاء API تأكيد رمز التحقق هنا.
    //
    // لا تتحققي من الرمز محليًا فقط،
    // السيرفر هو من يقرر هل الرمز صحيح ولسا ساري المفعول.

    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    if (!mounted) return;

    setState(() => loading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResetPasswordScreen(
          phone: widget.phone,
          otp: code,
        ),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  codeLength,
                  (i) {
                    return Container(
                      width: 52,
                      height: 52,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 6,
                      ),
                      child: TextField(
                        controller: controllers[i],
                        focusNode: focusNodes[i],
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
                        onChanged: (value) {
                          if (value.isNotEmpty &&
                              i < codeLength - 1) {
                            focusNodes[i + 1].requestFocus();
                          }

                          if (value.isEmpty && i > 0) {
                            focusNodes[i - 1].requestFocus();
                          }

                          if (i == codeLength - 1 &&
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
                    onPressed: resend,
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

              SizedBox(
                height: 47,
                child: ElevatedButton(
                  onPressed: loading ? null : verify,
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