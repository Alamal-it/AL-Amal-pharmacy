import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../main_nav/main_nav_screen.dart';

class OrderRatingScreen extends StatefulWidget {
  final String orderNumber;
  final bool isPickup;

  const OrderRatingScreen({
    super.key,
    required this.orderNumber,
    required this.isPickup,
  });

  @override
  State<OrderRatingScreen> createState() => _OrderRatingScreenState();
}

class _OrderRatingScreenState extends State<OrderRatingScreen> {
  int selectedStars = 0;
  final TextEditingController notesController = TextEditingController();
  bool submitting = false;

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  void goToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainNavScreen()),
      (route) => false,
    );
  }

  Future<void> submitRating() async {
    if (selectedStars == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختاري تقييمًا قبل الإرسال')),
      );
      return;
    }

    setState(() => submitting = true);

    // TODO: هنا مكان استدعاء API الحقيقي لحفظ التقييم:
    // { orderNumber: widget.orderNumber, stars: selectedStars, notes: notesController.text }
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('شكرًا لتقييمك! ⭐')),
    );

    goToHome();
  }

  String get _starHint {
    switch (selectedStars) {
      case 1:
        return 'سيئة جدًا 😞';
      case 2:
        return 'دون المتوسط 🙁';
      case 3:
        return 'مقبولة 🙂';
      case 4:
        return 'جيدة جدًا 😃';
      case 5:
        return 'ممتازة! 🤩';
      default:
        return 'اضغطي على النجوم للتقييم';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              // ===== أيقونة النجاح =====
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: Colors.white, size: 30),
                  ),
                ),
              ),
              const SizedBox(height: 22),

              Text(
                widget.isPickup
                    ? 'تم استلام طلبك بنجاح!'
                    : 'تم توصيل طلبك بنجاح!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.isPickup
                    ? 'كيف كانت تجربتك في استلام طلبك؟'
                    : 'كيف كانت تجربة التوصيل؟',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textGray,
                ),
              ),

              const SizedBox(height: 32),

              // ===== النجوم =====
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starValue = index + 1;
                  final isFilled = starValue <= selectedStars;

                  return GestureDetector(
                    onTap: () => setState(() => selectedStars = starValue),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                        size: 42,
                        color: isFilled
                            ? const Color(0xffFFB800)
                            : AppColors.border,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),
              Text(
                _starHint,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: selectedStars == 0
                      ? AppColors.textGray
                      : AppColors.primaryDark,
                ),
              ),

              const SizedBox(height: 28),

              // ===== ملاحظات اختيارية =====
              TextField(
                controller: notesController,
                textAlign: TextAlign.right,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'أضيفي ملاحظاتك (اختياري)',
                  hintStyle:
                      const TextStyle(color: AppColors.textGray, fontSize: 12.5),
                  filled: true,
                  fillColor: const Color(0xffF7F9FC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),

              const Spacer(),

              // ===== زر الإرسال =====
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: submitting ? null : submitRating,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: submitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'إرسال التقييم',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 10),

              // ===== تخطي =====
              TextButton(
                onPressed: submitting ? null : goToHome,
                child: const Text(
                  'تخطي',
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
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