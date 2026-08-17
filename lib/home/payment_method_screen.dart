import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../services/cart_service.dart';
import 'order_confirmation_screen.dart';

enum PaymentChoice { mada, card, applePay, cashOnDelivery, tamara, wallet }

class PaymentMethodScreen extends StatefulWidget {
  final double totalAmount;

  const PaymentMethodScreen({super.key, required this.totalAmount});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  PaymentChoice selected = PaymentChoice.mada;

  final List<_PaymentOption> options = const [
    _PaymentOption(PaymentChoice.mada, Icons.credit_card, 'مدى'),
    _PaymentOption(PaymentChoice.card, Icons.credit_card_outlined,
        'فيزا / ماستركارد'),
    _PaymentOption(PaymentChoice.applePay, Icons.apple, 'Apple Pay'),
    _PaymentOption(PaymentChoice.cashOnDelivery, Icons.payments_outlined,
        'الدفع عند الاستلام'),
    _PaymentOption(PaymentChoice.tamara, Icons.calendar_month_outlined,
        'تمارا / تقسيط'),
    _PaymentOption(PaymentChoice.wallet, Icons.account_balance_wallet_outlined,
        'المحفظة الداخلية'),
  ];

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
          'طريقة الدفع',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final option = options[index];
          final bool isSelected = selected == option.choice;

          return InkWell(
            onTap: () => setState(() => selected = option.choice),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 14),
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
                  Icon(option.icon, color: AppColors.primaryDark, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option.label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDark,
                      ),
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
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                // TODO: ربط عملية الدفع الفعلية بالـ API لما تجهز.
                CartService.instance.clearCart();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderConfirmationScreen(
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
                'تأكيد الدفع',
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
}

class _PaymentOption {
  final PaymentChoice choice;
  final IconData icon;
  final String label;

  const _PaymentOption(this.choice, this.icon, this.label);
}