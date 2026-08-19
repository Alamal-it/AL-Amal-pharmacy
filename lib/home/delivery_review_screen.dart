import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/delivery_address.dart';
import '../widgets/checkout_stepper.dart';
import 'delivery_schedule_screen.dart';

class DeliveryReviewScreen extends StatefulWidget {
  final DeliveryAddress address;
  final double totalAmount;

  const DeliveryReviewScreen({
    super.key,
    required this.address,
    required this.totalAmount,
  });

  @override
  State<DeliveryReviewScreen> createState() => _DeliveryReviewScreenState();
}

class _DeliveryReviewScreenState extends State<DeliveryReviewScreen> {
  bool forSomeoneElse = false;
  final TextEditingController otherNameController = TextEditingController();
  final TextEditingController otherPhoneController = TextEditingController();

  @override
  void dispose() {
    otherNameController.dispose();
    otherPhoneController.dispose();
    super.dispose();
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
          'مراجعة التوصيل',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===== شريط التقدم =====
            const CheckoutStepper(currentStep: 0),
            const SizedBox(height: 26),

            // ===== خيار "لشخص آخر" =====
            InkWell(
              onTap: () => setState(() => forSomeoneElse = !forSomeoneElse),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'هذا الطلب لشخص آخر',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Checkbox(
                    value: forSomeoneElse,
                    activeColor: AppColors.green,
                    onChanged: (value) =>
                        setState(() => forSomeoneElse = value ?? false),
                  ),
                ],
              ),
            ),

            if (forSomeoneElse) ...[
              const SizedBox(height: 8),
              TextField(
                controller: otherNameController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'اسم المستلم',
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: otherPhoneController,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'رقم جوال المستلم',
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],

            const SizedBox(height: 20),
            const Divider(color: AppColors.border),
            const SizedBox(height: 16),

            // ===== بطاقة العنوان =====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.green.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.green, width: 1.4),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.delete_outline,
                          color: AppColors.textGray, size: 20),
                      Row(
                        children: [
                          Text(
                            widget.address.label,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.home_outlined,
                              size: 18, color: AppColors.primaryDark),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${widget.address.addressLine}, ${widget.address.city}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textGray,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            InkWell(
              onTap: () {
                // TODO: فتح شاشة إضافة عنوان جديد لما نربطها.
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'إضافة عنوان جديد',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.add, size: 18, color: AppColors.primary),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Divider(color: AppColors.border),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.totalAmount.toStringAsFixed(2)} ر.س',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                const Text(
                  'إجمالي الطلب',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // بدّلناها من الذهاب المباشر للدفع، لجدولة موعد التوصيل أول.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DeliveryScheduleScreen(
                        totalAmount: widget.totalAmount,
                        address: widget.address,
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
          ],),
      ),
    );
  }
}