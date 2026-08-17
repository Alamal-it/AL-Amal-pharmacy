import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'payment_method_screen.dart';

enum DeliveryChoice { home, pickup }

class DeliveryMethodScreen extends StatefulWidget {
  final double totalAmount;

  const DeliveryMethodScreen({super.key, required this.totalAmount});

  @override
  State<DeliveryMethodScreen> createState() => _DeliveryMethodScreenState();
}

class _DeliveryMethodScreenState extends State<DeliveryMethodScreen> {
  DeliveryChoice selected = DeliveryChoice.home;

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
          'طريقة الاستلام',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _optionCard(
              choice: DeliveryChoice.home,
              icon: Icons.local_shipping_outlined,
              title: 'توصيل للمنزل',
              subtitle: 'يصلك طلبك خلال 30-60 دقيقة، رسوم التوصيل 15 ر.س',
            ),
            const SizedBox(height: 12),
            _optionCard(
              choice: DeliveryChoice.pickup,
              icon: Icons.storefront_outlined,
              title: 'استلام من الفرع',
              subtitle: 'استلمي طلبك من أقرب فرع لك بدون رسوم',
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentMethodScreen(
                      totalAmount: widget.totalAmount,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'متابعة',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _optionCard({
    required DeliveryChoice choice,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final bool isSelected = selected == choice;

    return InkWell(
      onTap: () => setState(() => selected = choice),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.green : AppColors.border,
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryDark, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isSelected ? AppColors.green : AppColors.border,
            ),
          ],
        ),
      ),
    );
  }
}