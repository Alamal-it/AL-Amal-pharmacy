import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../main_nav/main_nav_screen.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final double totalAmount;

  const OrderConfirmationScreen({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: AppColors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 46),
              ),
              const SizedBox(height: 20),
              const Text(
                'تم تأكيد طلبك بنجاح',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'إجمالي الطلب: ${totalAmount.toStringAsFixed(2)} ر.س',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textGray,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'سيتم التواصل معك بمجرد تجهيز طلبك',
                style: TextStyle(fontSize: 12, color: AppColors.textGray),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainNavScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'العودة للرئيسية',
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
      ),
    );
  }
}