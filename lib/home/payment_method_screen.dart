import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../services/cart_service.dart';
import '../services/order_service.dart';
import 'order_confirmation_screen.dart';

enum PaymentChoice {
  mada,
  card,
  applePay,
  cashOnDelivery,
  tamara,
  wallet,
}

class PaymentMethodScreen extends StatefulWidget {
  final double totalAmount;

  // ===== معلومات إضافية لتمريرها لشاشة تأكيد الطلب =====
  final bool isPickup;
  final String? addressLine;
  final String? timeSlot;
  final double? destinationLat;
  final double? destinationLng;

  const PaymentMethodScreen({
    super.key,
    required this.totalAmount,
    this.isPickup = true,
    this.addressLine,
    this.timeSlot,
    this.destinationLat,
    this.destinationLng,
  });

  @override
  State<PaymentMethodScreen> createState() =>
      _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  PaymentChoice selected = PaymentChoice.mada;

  // ===== خيارات الدفع =====
  final List<_PaymentOption> options = const [
    _PaymentOption(
      choice: PaymentChoice.mada,
      label: 'مدى',
      assetPath: 'lib/assets/mada_icon.png',
      fallbackIcon: Icons.credit_card,
    ),
    _PaymentOption(
      choice: PaymentChoice.card,
      label: 'فيزا / ماستركارد',
      assetPath: 'lib/assets/visa_mastercard_icon.png',
      fallbackIcon: Icons.credit_card_outlined,
    ),
    _PaymentOption(
      choice: PaymentChoice.applePay,
      label: 'Apple Pay',
      assetPath: 'lib/assets/apple_pay_icon.png',
      fallbackIcon: Icons.apple,
    ),
    _PaymentOption(
      choice: PaymentChoice.cashOnDelivery,
      label: 'الدفع عند الاستلام',
      assetPath: null,
      fallbackIcon: Icons.payments_outlined,
    ),
    _PaymentOption(
      choice: PaymentChoice.tamara,
      label: 'تمارا / تقسيط',
      assetPath: 'lib/assets/tamara_icon.png',
      fallbackIcon: Icons.calendar_month_outlined,
    ),
    _PaymentOption(
      choice: PaymentChoice.wallet,
      label: 'المحفظة الداخلية',
      assetPath: null,
      fallbackIcon: Icons.account_balance_wallet_outlined,
    ),
  ];

  // =========================================================
  // تأكيد الدفع وإنشاء الطلب
  // =========================================================

  void confirmPayment() {
    // إنشاء رقم الطلب مرة واحدة فقط
    final orderNumber =
        (100000000 +
                DateTime.now().millisecondsSinceEpoch %
                    899999999)
            .toString();

    // حفظ الطلب مرة واحدة فقط
    OrderService.instance.addOrder(
      Order(
        orderNumber: orderNumber,
        items: List.from(CartService.instance.items),
        totalAmount: widget.totalAmount,
        date: DateTime.now(),
        isPickup: widget.isPickup,
      ),
    );

    // ملاحظة:
    // لا نحذف السلة هنا قبل دخول شاشة التأكيد،
    // لأن شاشة التأكيد قد تحتاج بيانات السلة.
    //
    // سيتم حذف السلة بعد إتمام الطلب من المكان المناسب.

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(
          totalAmount: widget.totalAmount,
          isPickup: widget.isPickup,
          addressLine: widget.addressLine,
          timeSlot: widget.timeSlot,
          destinationLat: widget.destinationLat,
          destinationLng: widget.destinationLng,
        ),
      ),
    );
  }

  // =========================================================
  // الواجهة
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.primaryDark,
        ),
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

        separatorBuilder: (_, __) =>
            const SizedBox(height: 10),

        itemBuilder: (context, index) {
          final option = options[index];

          final bool isSelected =
              selected == option.choice;

          return InkWell(
            onTap: () {
              setState(() {
                selected = option.choice;
              });
            },

            borderRadius: BorderRadius.circular(12),

            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),

              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),

                border: Border.all(
                  color: isSelected
                      ? AppColors.green
                      : AppColors.border,

                  width: isSelected ? 1.6 : 1,
                ),
              ),

              child: Row(
                children: [
                  // شعار طريقة الدفع
                  _PaymentLogo(
                    option: option,
                  ),

                  const SizedBox(width: 12),

                  // اسم طريقة الدفع
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

                  // دائرة الاختيار
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,

                    color: isSelected
                        ? AppColors.green
                        : AppColors.border,
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // =====================================================
      // زر تأكيد الدفع
      // =====================================================

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: SizedBox(
            width: double.infinity,
            height: 48,

            child: ElevatedButton(
              onPressed: confirmPayment,

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

// =========================================================
// شعار طريقة الدفع
// =========================================================

class _PaymentLogo extends StatelessWidget {
  final _PaymentOption option;

  const _PaymentLogo({
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    // إذا ما فيه صورة، نعرض الأيقونة
    if (option.assetPath == null) {
      return Icon(
        option.fallbackIcon,
        color: AppColors.primaryDark,
        size: 22,
      );
    }

    // محاولة عرض الصورة
    return Image.asset(
      option.assetPath!,
      width: 28,
      height: 28,
      fit: BoxFit.contain,

      // إذا الصورة غير موجودة
      // نعرض الأيقونة الاحتياطية
      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        return Icon(
          option.fallbackIcon,
          color: AppColors.primaryDark,
          size: 22,
        );
      },
    );
  }
}

// =========================================================
// بيانات خيار الدفع
// =========================================================

class _PaymentOption {
  final PaymentChoice choice;
  final String label;
  final String? assetPath;
  final IconData fallbackIcon;

  const _PaymentOption({
    required this.choice,
    required this.label,
    required this.assetPath,
    required this.fallbackIcon,
  });
}
