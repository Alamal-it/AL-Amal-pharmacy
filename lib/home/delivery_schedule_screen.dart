import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
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
  late final List<DateTime> days;
  late DateTime selectedDay;

  List<_TimeSlot> timeSlots = [];

  int? selectedSlotIndex;

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();

    days = List.generate(
      4,
      (index) => DateTime(
        today.year,
        today.month,
        today.day + index,
      ),
    );

    selectedDay = days.first;

    _updateTimeSlots(selectedDay);
  }

  // ======================================================
  // الأوقات المتاحة حسب اليوم
  //
  // هذا الجزء جاهز لاحقًا للربط مع API.
  // حاليًا يتم عرض جدول محلي للتجربة.
  // ======================================================

  List<_TimeSlot> _getTimeSlotsForDay(DateTime date) {
    // أوقات التوصيل من 8 صباحًا إلى 4 عصرًا
    return const [
      _TimeSlot('08:00 - 09:00 ص', true),
      _TimeSlot('09:00 - 10:00 ص', true),
      _TimeSlot('10:00 - 11:00 ص', true),
      _TimeSlot('11:00 - 12:00 م', true),
      _TimeSlot('12:00 - 01:00 م', true),
      _TimeSlot('01:00 - 02:00 م', true),
      _TimeSlot('02:00 - 03:00 م', true),
      _TimeSlot('03:00 - 04:00 م', true),
    ];
  }

  void _updateTimeSlots(DateTime date) {
    final slots = _getTimeSlotsForDay(date);

    int? firstAvailable;

    for (int i = 0; i < slots.length; i++) {
      if (slots[i].available) {
        firstAvailable = i;
        break;
      }
    }

    setState(() {
      timeSlots = slots;
      selectedSlotIndex = firstAvailable;
    });
  }

  // ======================================================
  // أسماء الأيام والأشهر
  // ======================================================

  String _dayName(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return AppStrings.monday;
      case DateTime.tuesday:
        return AppStrings.tuesday;
      case DateTime.wednesday:
        return AppStrings.wednesday;
      case DateTime.thursday:
        return AppStrings.thursday;
      case DateTime.friday:
        return AppStrings.friday;
      case DateTime.saturday:
        return AppStrings.saturday;
      case DateTime.sunday:
        return AppStrings.sunday;
      default:
        return '';
    }
  }

  String _monthName(DateTime date) {
    switch (date.month) {
      case 1:
        return AppStrings.january;
      case 2:
        return AppStrings.february;
      case 3:
        return AppStrings.march;
      case 4:
        return AppStrings.april;
      case 5:
        return AppStrings.may;
      case 6:
        return AppStrings.june;
      case 7:
        return AppStrings.july;
      case 8:
        return AppStrings.august;
      case 9:
        return AppStrings.september;
      case 10:
        return AppStrings.october;
      case 11:
        return AppStrings.november;
      case 12:
        return AppStrings.december;
      default:
        return '';
    }
  }

  bool _isToday(DateTime date) {
    final today = DateTime.now();

    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  String _dayLabel(DateTime date) {
    if (_isToday(date)) {
      return AppStrings.today;
    }

    return _dayName(date);
  }

  String _formattedDate(DateTime date) {
    return '${date.day} ${_monthName(date)}';
  }

  // ======================================================
  // تأكيد الموعد
  // ======================================================

  void confirmSchedule() {
    if (selectedSlotIndex == null ||
        selectedSlotIndex! >= timeSlots.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.selectDeliveryTime),
        ),
      );
      return;
    }

    final selectedSlot = timeSlots[selectedSlotIndex!];

    if (!selectedSlot.available) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentMethodScreen(
          totalAmount: widget.totalAmount,
          isPickup: false,
          addressLine:
              '${widget.address.addressLine}, ${widget.address.city}',
          timeSlot: '${_formattedDate(selectedDay)} - ${selectedSlot.label}',
          destinationLat: widget.address.latitude,
          destinationLng: widget.address.longitude,
        ),
      ),
    );
  }

  // ======================================================
  // تغيير اليوم
  // ======================================================

  void _selectDay(DateTime day) {
    if (day == selectedDay) {
      return;
    }

    final slots = _getTimeSlotsForDay(day);

    int? firstAvailable;

    for (int i = 0; i < slots.length; i++) {
      if (slots[i].available) {
        firstAvailable = i;
        break;
      }
    }

    setState(() {
      selectedDay = day;
      timeSlots = slots;
      selectedSlotIndex = firstAvailable;
    });
  }

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
        title: Text(
          AppStrings.deliveryAppointment,
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ==================================================
            // شريط التقدم
            // ==================================================

            const CheckoutStepper(currentStep: 1),

            const SizedBox(height: 26),

            // ==================================================
            // اختيار اليوم
            // ==================================================

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                AppStrings.chooseDay,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ),

            const SizedBox(height: 4),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                AppStrings.chooseDeliveryDayDescription,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textGray,
                ),
              ),
            ),

            const SizedBox(height: 14),

            SizedBox(
              height: 86,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                reverse: true,
                itemCount: days.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final day = days[index];

                  final isSelected =
                      day.year == selectedDay.year &&
                          day.month == selectedDay.month &&
                          day.day == selectedDay.day;

                  return InkWell(
                    onTap: () => _selectDay(day),
                    borderRadius: BorderRadius.circular(14),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 76,
                      padding: const EdgeInsets.symmetric(
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.green
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.green
                              : AppColors.border,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.green
                                      .withOpacity(0.16),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(
                            _dayLabel(day),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textGray,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${day.day}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _monthName(day),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 26),

            // ==================================================
            // اليوم المختار
            // ==================================================

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAF8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calendar_month_outlined,
                      color: AppColors.green,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.selectedDeliveryDay,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textGray,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${_dayLabel(selectedDay)}، ${_formattedDate(selectedDay)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // ==================================================
            // اختيار الوقت
            // ==================================================

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                AppStrings.chooseTime,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ),

            const SizedBox(height: 4),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                AppStrings.chooseDeliveryTimeDescription,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textGray,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ==================================================
            // الأوقات
            // ==================================================

            if (timeSlots.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.schedule_outlined,
                      size: 34,
                      color: AppColors.textGray,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppStrings.noDeliveryTimes,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: timeSlots.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.25,
                ),
                itemBuilder: (context, index) {
                  final slot = timeSlots[index];

                  final isSelected =
                      selectedSlotIndex == index;

                  return InkWell(
                    onTap: slot.available
                        ? () {
                            setState(() {
                              selectedSlotIndex = index;
                            });
                          }
                        : null,
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 160),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: !slot.available
                            ? const Color(0xFFF4F4F4)
                            : isSelected
                                ? AppColors.green
                                : AppColors.white,
                        borderRadius:
                            BorderRadius.circular(12),
                        border: Border.all(
                          color: !slot.available
                              ? AppColors.border
                              : isSelected
                                  ? AppColors.green
                                  : AppColors.border,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.green
                                      .withOpacity(0.14),
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            slot.available
                                ? Icons.access_time_rounded
                                : Icons.block_outlined,
                            size: 18,
                            color: !slot.available
                                ? AppColors.textGray
                                : isSelected
                                    ? Colors.white
                                    : AppColors.green,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            slot.available
                                ? slot.label
                                : AppStrings.full,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: !slot.available
                                  ? AppColors.textGray
                                  : isSelected
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

            const SizedBox(height: 24),

            // ==================================================
            // ملخص الموعد
            // ==================================================

            if (selectedSlotIndex != null &&
                selectedSlotIndex! < timeSlots.length)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color:
                            AppColors.green.withOpacity(0.12),
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_shipping_outlined,
                        color: AppColors.green,
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.deliverySummary,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textGray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_dayLabel(selectedDay)}، ${_formattedDate(selectedDay)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color:
                                  AppColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            timeSlots[selectedSlotIndex!]
                                .label,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.green,
                      size: 22,
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // ==================================================
            // زر التأكيد
            // ==================================================

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: selectedSlotIndex != null
                    ? confirmSchedule
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  disabledBackgroundColor:
                      AppColors.border,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppStrings.confirmAppointment,
                  style: const TextStyle(
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

// ======================================================
// نموذج وقت التوصيل
// ======================================================

class _TimeSlot {
  final String label;
  final bool available;

  const _TimeSlot(
    this.label,
    this.available,
  );
}