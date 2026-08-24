import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../services/user_service.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});
  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: UserService.instance.name);
    phoneController = TextEditingController(text: UserService.instance.phone);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void saveChanges() {
    UserService.instance.name = nameController.text.trim();
    UserService.instance.phone = phoneController.text.trim();
    // TODO: إرسال التعديلات للـ API لما يجهز.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ التعديلات'),
        backgroundColor: AppColors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryDark),
        centerTitle: true,
        title: const Text(
          'معلومات الحساب',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      nameController.text.isNotEmpty
                          ? nameController.text.substring(0, 1)
                          : 'ض',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned( bottom: 0, left: 0, child: Container( padding: const EdgeInsets.all(4), decoration: const BoxDecoration( color: AppColors.green, shape: BoxShape.circle, ), child: const Icon(Icons.camera_alt, color: Colors.white, size: 14), ), ), ], ), ), const SizedBox(height: 28),
        const Align(
          alignment: Alignment.centerRight,
          child: Text('الاسم الكامل',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark)),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: nameController,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person_outline),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),

        const SizedBox(height: 18),
        const Align(
          alignment: Alignment.centerRight,
          child: Text('رقم الجوال',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark)),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: phoneController,
          textAlign: TextAlign.right,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.phone_outlined),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.check_circle,
                  color: AppColors.green, size: 18),
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),

        const SizedBox(height: 18),
        const Align(
          alignment: Alignment.centerRight,
          child: Text('البريد الإلكتروني (اختياري)',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark)),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: emailController,
          textAlign: TextAlign.right,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email_outlined),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),

        const SizedBox(height: 32),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'حفظ التعديلات',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);
} }