import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/delivery_address.dart';
import '../widgets/checkout_stepper.dart';
import 'payment_method_screen.dart';

class DeliveryScheduleScreen extends StatefulWidget {
  final double totalAmount;
  final DeliveryAddress address;

  const DeliveryScheduleScreen({
    super.key,
    required this.totalAmount,
    required this.address,
  });

  @override
  State<DeliveryScheduleScreen> createState() =>
      _DeliveryScheduleScreenState();
}

class _DeliveryScheduleScreenState extends State<DeliveryScheduleScreen> {
  static const List<String> _arabicWeekdays = [
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  static const List<String> _arabicMonths = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  late final List<DateTime> days;
  late DateTime selectedDay;

  final List<_TimeSlot> timeSlots = const [
    _TimeSlot('10:00 - 11:00 ص', true),
    _TimeSlot('12:00 - 1:00 م', true),
    _TimeSlot('7:00 - 6:00 م', true),
    _TimeSlot('9:00 - 8:00 ص', true),
    _TimeSlot('4:00 - 3:00 م', false), // غير متاحة
    _TimeSlot('1:00 - 12:00 م', true),
  ];

  int selectedSlotIndex = 5; // نفس الافتراضي بالتصميم المرجعي

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    days = List.generate(4, (i) => today.add(Duration(days: i)));
    selectedDay = days.first;
  }

  String _dayLabel(DateTime date) {
    final today = DateTime.now();
    final isToday = date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
    return isToday ? 'اليوم' : _arabicWeekdays[date.weekday - 1];
  }

  void confirmSchedule() {
    final selectedSlot = timeSlots[selectedSlotIndex];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentMethodScreen(
          totalAmount: widget.totalAmount,
          isPickup: false,
          addressLine:
              '${widget.address.addressLine}, ${widget.address.city}',
          timeSlot: selectedSlot.label,
        ),
      ),
    );
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
          'موعد التوصيل',
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
            const CheckoutStepper(currentStep: 1),
            const SizedBox(height: 26),

            // ===== اختيار اليوم =====
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'اختاري اليوم',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 66,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                reverse: true, // عشان يبدأ من اليمين زي التصميم
                itemCount: days.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final day = days[index];
                  final isSelected = day.year == selectedDay.year &&
                      day.month == selectedDay.month &&
                      day.day == selectedDay.day;

                  return InkWell(
                    onTap: () => setState(() => selectedDay = day),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 64,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.green : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isSelected ? AppColors.green : AppColors.border,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _dayLabel(day),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color:
                                  isSelected ? Colors.white : AppColors.textGray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${day.day} ${_arabicMonths[day.month - 1].substring(0, 4)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // ===== اختيار الوقت =====
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'اختاري الوقت',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: timeSlots.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.6,
              ),
              itemBuilder: (context, index) {
                final slot = timeSlots[index];
                final isSelected = selectedSlotIndex == index;

                return InkWell(
                  onTap: slot.available
                      ? () => setState(() => selectedSlotIndex = index)
                      : null,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: !slot.available
                          ? const Color(0xffF2F2F2)
                          : (isSelected ? AppColors.green : AppColors.white),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: !slot.available
                            ? AppColors.border
                            : (isSelected
                                ? AppColors.green
                                : AppColors.border),
                      ),
                    ),
                    child: Text(
                      slot.available ? slot.label : '${slot.label}\n(ممتلئ)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: !slot.available
                            ? AppColors.textGray
                            : (isSelected
                                ? Colors.white
                                : AppColors.primaryDark),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: confirmSchedule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'تأكيد الموعد',
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
  }
}

class _TimeSlot {
  final String label;
  final bool available;

  const _TimeSlot(this.label, this.available);
}