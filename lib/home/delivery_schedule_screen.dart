import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../models/delivery_address.dart';
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
  // عدد الأيام المعروضة
  static const int _daysCount = 7;

  // أقل مدة تحضير قبل بداية الموعد (بالساعات)
  static const int _minLeadHours = 1;

  late final List<DateTime> _days;
  late DateTime _selectedDay;

  List<_TimeSlot> _timeSlots = [];
  int? _selectedSlotIndex;

  bool _isLoading = true;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();

    _days = List.generate(
      _daysCount,
      (i) => DateTime(today.year, today.month, today.day + i),
    );

    _selectedDay = _days.first;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadSlots(_selectedDay, autoAdvance: true);
    });
  }

  // ======================================================
  // الأوقات المتاحة
  //
  // جاهزة للربط مع API: استبدل محتوى الدالة بطلب الشبكة
  // وأرجع نفس القائمة من _TimeSlot.
  // حاليًا تُحسب محليًا، والأوقات التي فات موعدها (أو أقل
  // من مدة التحضير) تظهر كغير متاحة لليوم الحالي.
  // ======================================================

  static const List<_SlotTemplate> _templates = [
    _SlotTemplate('08:00 - 09:00 ص', 8),
    _SlotTemplate('09:00 - 10:00 ص', 9),
    _SlotTemplate('10:00 - 11:00 ص', 10),
    _SlotTemplate('11:00 - 12:00 م', 11),
    _SlotTemplate('12:00 - 01:00 م', 12),
    _SlotTemplate('01:00 - 02:00 م', 13),
    _SlotTemplate('02:00 - 03:00 م', 14),
    _SlotTemplate('03:00 - 04:00 م', 15),
  ];

  Future<List<_TimeSlot>> _fetchTimeSlotsForDay(DateTime date) async {
    // محاكاة زمن الشبكة
    await Future.delayed(const Duration(milliseconds: 380));

    final earliest = DateTime.now().add(const Duration(hours: _minLeadHours));

    return _templates.map((t) {
      final start = DateTime(date.year, date.month, date.day, t.startHour);
      return _TimeSlot(
        label: t.label,
        startHour: t.startHour,
        available: start.isAfter(earliest),
      );
    }).toList();
  }

  Future<void> _loadSlots(DateTime day, {bool autoAdvance = false}) async {
    final id = ++_requestId;

    setState(() {
      _selectedDay = day;
      _isLoading = true;
      _selectedSlotIndex = null;
    });

    final slots = await _fetchTimeSlotsForDay(day);

    if (!mounted || id != _requestId) return;

    final firstAvailable = slots.indexWhere((s) => s.available);

    // إذا انتهت أوقات اليوم (مثلاً بعد العصر) ننتقل لأقرب يوم متاح
    if (firstAvailable == -1 && autoAdvance) {
      final next = _days.indexWhere((d) => d.isAfter(day));
      if (next != -1) {
        _loadSlots(_days[next], autoAdvance: true);
        return;
      }
    }

    setState(() {
      _timeSlots = slots;
      _selectedSlotIndex = firstAvailable == -1 ? null : firstAvailable;
      _isLoading = false;
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

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isToday(DateTime date) => _sameDay(date, DateTime.now());

  String _dayLabel(DateTime date) =>
      _isToday(date) ? AppStrings.today : _dayName(date);

  String _formattedDate(DateTime date) => '${date.day} ${_monthName(date)}';

  // ======================================================
  // التفاعل
  // ======================================================

  void _selectDay(DateTime day) {
    if (_sameDay(day, _selectedDay)) return;
    HapticFeedback.selectionClick();
    _loadSlots(day);
  }

  void _selectSlot(int index) {
    if (_selectedSlotIndex == index) return;
    HapticFeedback.selectionClick();
    setState(() => _selectedSlotIndex = index);
  }

  void _confirmSchedule() {
    final index = _selectedSlotIndex;

    if (index == null || index >= _timeSlots.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.selectDeliveryTime)),
      );
      return;
    }

    final slot = _timeSlots[index];
    if (!slot.available) return;

    HapticFeedback.lightImpact();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentMethodScreen(
          totalAmount: widget.totalAmount,
          isPickup: false,
          addressLine:
              '${widget.address.addressLine}, ${widget.address.city}',
          timeSlot: '${_formattedDate(_selectedDay)} - ${slot.label}',
          destinationLat: widget.address.latitude,
          destinationLng: widget.address.longitude,
        ),
      ),
    );
  }

  // ======================================================
  // البناء
  // ======================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryDark),
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
            const SizedBox(height: 8),
            _SectionHeader(
              title: AppStrings.chooseDay,
              subtitle: AppStrings.chooseDeliveryDayDescription,
            ),
            const SizedBox(height: 14),
            _buildDaysList(),
            const SizedBox(height: 26),
            _SectionHeader(
              title: AppStrings.chooseTime,
              subtitle: AppStrings.chooseDeliveryTimeDescription,
            ),
            const SizedBox(height: 14),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: KeyedSubtree(
                key: ValueKey('${_selectedDay.toIso8601String()}_$_isLoading'),
                child: _buildSlotsSection(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ---------------- الأيام ----------------

  Widget _buildDaysList() {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: true,
        clipBehavior: Clip.none,
        itemCount: _days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final day = _days[index];
          return _DayCard(
            dayLabel: _dayLabel(day),
            dayNumber: '${day.day}',
            monthLabel: _monthName(day),
            isSelected: _sameDay(day, _selectedDay),
            isToday: _isToday(day),
            onTap: () => _selectDay(day),
          );
        },
      ),
    );
  }

  // ---------------- الأوقات ----------------

  Widget _buildSlotsSection() {
    if (_isLoading) {
      return const _SlotsSkeleton();
    }

    final hasAvailable = _timeSlots.any((s) => s.available);

    if (_timeSlots.isEmpty || !hasAvailable) {
      return _EmptySlots(message: AppStrings.noDeliveryTimes);
    }

    final morning = <int>[];
    final afternoon = <int>[];

    for (var i = 0; i < _timeSlots.length; i++) {
      (_timeSlots[i].startHour < 12 ? morning : afternoon).add(i);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (morning.isNotEmpty) ...[
          _GroupLabel(
            icon: Icons.wb_sunny_outlined,
            label: _Labels.morning,
          ),
          const SizedBox(height: 10),
          _buildSlotGrid(morning),
        ],
        if (morning.isNotEmpty && afternoon.isNotEmpty)
          const SizedBox(height: 18),
        if (afternoon.isNotEmpty) ...[
          _GroupLabel(
            icon: Icons.wb_twilight_outlined,
            label: _Labels.afternoon,
          ),
          const SizedBox(height: 10),
          _buildSlotGrid(afternoon),
        ],
      ],
    );
  }

  Widget _buildSlotGrid(List<int> indices) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: indices.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.4,
      ),
      itemBuilder: (context, i) {
        final index = indices[i];
        final slot = _timeSlots[index];

        return _StaggeredIn(
          order: i,
          child: _SlotTile(
            label: slot.available ? slot.label : AppStrings.full,
            available: slot.available,
            isSelected: _selectedSlotIndex == index,
            onTap: slot.available ? () => _selectSlot(index) : null,
          ),
        );
      },
    );
  }

  // ---------------- الشريط السفلي ----------------

  Widget _buildBottomBar() {
    final index = _selectedSlotIndex;
    final hasSelection =
        index != null && index < _timeSlots.length && !_isLoading;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                alignment: Alignment.topCenter,
                child: hasSelection
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _SummaryRow(
                          title: AppStrings.deliverySummary,
                          dateText:
                              '${_dayLabel(_selectedDay)}، ${_formattedDate(_selectedDay)}',
                          timeText: _timeSlots[index].label,
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
              SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: hasSelection ? _confirmSchedule : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    disabledBackgroundColor: AppColors.border,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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
      ),
    );
  }
}

// ======================================================
// نصوص محلية للتجميع الزمني
// (يفضّل نقلها لاحقًا إلى AppStrings)
// ======================================================

class _Labels {
  static const String morning = 'الفترة الصباحية';
  static const String afternoon = 'فترة الظهيرة';
}

// ======================================================
// عناصر الواجهة
// ======================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const _GroupLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.green),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final String dayLabel;
  final String dayNumber;
  final String monthLabel;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const _DayCard({
    required this.dayLabel,
    required this.dayNumber,
    required this.monthLabel,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mainColor = isSelected ? Colors.white : AppColors.primaryDark;
    final subColor = isSelected ? Colors.white : AppColors.textGray;

    return AnimatedScale(
      scale: isSelected ? 1.04 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: 78,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.green : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.green : AppColors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.green.withValues(alpha: 0.28),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ]
              : const [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: subColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dayNumber,
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: mainColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    monthLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10, color: subColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SlotTile extends StatelessWidget {
  final String label;
  final bool available;
  final bool isSelected;
  final VoidCallback? onTap;

  const _SlotTile({
    required this.label,
    required this.available,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = !available
        ? const Color(0xFFF4F4F4)
        : isSelected
            ? AppColors.green
            : AppColors.white;

    final Color borderColor =
        available && isSelected ? AppColors.green : AppColors.border;

    final Color iconColor = !available
        ? AppColors.textGray
        : isSelected
            ? Colors.white
            : AppColors.green;

    final Color textColor = !available
        ? AppColors.textGray
        : isSelected
            ? Colors.white
            : AppColors.primaryDark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.green.withValues(alpha: 0.22),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : const [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                available
                    ? (isSelected
                        ? Icons.check_circle_rounded
                        : Icons.access_time_rounded)
                    : Icons.block_outlined,
                size: 17,
                color: iconColor,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    decoration: available ? null : TextDecoration.none,
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

class _SummaryRow extends StatelessWidget {
  final String title;
  final String dateText;
  final String timeText;

  const _SummaryRow({
    required this.title,
    required this.dateText,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.green.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textGray,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$dateText  •  $timeText',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: AppColors.green, size: 22),
        ],
      ),
    );
  }
}

class _EmptySlots extends StatelessWidget {
  final String message;

  const _EmptySlots({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.schedule_outlined,
            size: 38,
            color: AppColors.textGray,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// هيكل التحميل (Skeleton)
// ======================================================

class _SlotsSkeleton extends StatefulWidget {
  const _SlotsSkeleton();

  @override
  State<_SlotsSkeleton> createState() => _SlotsSkeletonState();
}

class _SlotsSkeletonState extends State<_SlotsSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final color = Color.lerp(
          const Color(0xFFF1F3F2),
          const Color(0xFFE4E8E6),
          _controller.value,
        )!;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 8,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.4,
          ),
          itemBuilder: (_, __) => DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      },
    );
  }
}

// ======================================================
// ظهور متدرج للعناصر
// ======================================================

class _StaggeredIn extends StatelessWidget {
  final int order;
  final Widget child;

  const _StaggeredIn({required this.order, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 260 + order * 50),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 14),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

// ======================================================
// النماذج
// ======================================================

class _SlotTemplate {
  final String label;
  final int startHour;

  const _SlotTemplate(this.label, this.startHour);
}

class _TimeSlot {
  final String label;
  final int startHour;
  final bool available;

  const _TimeSlot({
    required this.label,
    required this.startHour,
    required this.available,
  });
}