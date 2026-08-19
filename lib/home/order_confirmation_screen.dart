import 'dart:math';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/checkout_stepper.dart';
import '../main_nav/main_nav_screen.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final double totalAmount;
  final bool isPickup;
  final String? addressLine;
  final String? timeSlot;

  const OrderConfirmationScreen({
    super.key,
    required this.totalAmount,
    this.isPickup = true,
    this.addressLine,
    this.timeSlot,
  });

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  late final String orderNumber;

  @override
  void initState() {
    super.initState();
    orderNumber = (100000000 + Random().nextInt(899999999)).toString();
  }

  Future<void> finishOrder() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: AppColors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: Colors.white, size: 42),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.isPickup
                      ? 'تم استلام طلبك بنجاح'
                      : 'تم تأكيد طلبك بنجاح',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'شكراً لثقتك بصيدلية الأمل',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.5, color: AppColors.textGray),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.border.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'رقم الطلب: #$orderNumber',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'تم',
                      style: TextStyle(
                        fontSize: 14,
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
      },
    );

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          widget.isPickup ? 'استلام الطلب' : 'تتبع التوصيل',
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: const CheckoutStepper(currentStep: 2),
            ),
            const SizedBox(height: 10),
            Container(
              height: 190,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.border.withOpacity(0.25),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: widget.isPickup
                  ? Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: AppColors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    )
                  : const Icon(Icons.local_shipping_outlined,
                      size: 46, color: AppColors.primary),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isPickup
                        ? '01:30 ص - 01:20 ص'
                        : (widget.timeSlot ?? 'خلال 60-90 دقيقة'),
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.isPickup ? 'جاهز للاستلام' : 'قيد التجهيز',
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _dot(active: true),
                  _line(active: true),
                  _dot(active: false),
                  _line(active: false),
                  _dot(active: false),
                ],
              ),
            ),const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.isPickup
                    ? 'الصيدلية بتجهز طلبك الحين'
                    : 'طلبك قيد التجهيز، وسيتم التواصل معك لتوصيله',
                textAlign: TextAlign.right,
                style: const TextStyle(color: AppColors.textGray, fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: AppColors.border),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#$orderNumber',
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.isPickup
                        ? 'شارك الرقم مع الموظف'
                        : 'احتفظي برقم الطلب للمتابعة',
                    style: const TextStyle(color: AppColors.textGray, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.border),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.isPickup
                          ? Icons.storefront_outlined
                          : Icons.location_on_outlined,
                      size: 18,
                      color: AppColors.green,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.isPickup
                              ? 'صيدلية الأمل — الفرع الأقرب'
                              : 'التوصيل إلى عنوانك',
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.isPickup
                              ? 'مفتوح حتى 12:00 ص'
                              : (widget.addressLine ?? 'العنوان المحدد'),
                          style: const TextStyle(
                              color: AppColors.textGray, fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (widget.isPickup) ...[
              const SizedBox(height: 6),
              TextButton.icon(
                onPressed: () {
                  // TODO: فتح تطبيق الخرائط بموقع الفرع لما يجهز رابط حقيقي.
                },
                icon: const Icon(Icons.directions_outlined,
                    color: AppColors.primary, size: 18),
                label: const Text(
                  'احصل على الاتجاهات',
                  style: TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
            const SizedBox(height: 10),
            const Divider(color: AppColors.border),
            const SizedBox(height: 16),Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.totalAmount.toStringAsFixed(2)} ر.س',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const Text(
                    'إجمالي الطلب',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: finishOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.isPickup ? ' استلم طلبك الحين' : 'تم، متابعة',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot({required bool active}) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: active ? AppColors.green : AppColors.border,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _line({required bool active}) {
    return Expanded(
      child: Container(
        height: 3,
        color: active ? AppColors.green : AppColors.border,
      ),
    );
  }
}