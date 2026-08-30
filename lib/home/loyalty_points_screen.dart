import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class LoyaltyPointsScreen extends StatelessWidget {
  const LoyaltyPointsScreen({super.key});

  // TODO: استبدال هذي القيم ببيانات حقيقية من الـ API لما يجهز.
  final int currentPoints = 0;
  final int pointsToNextReward = 100;

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
          'نقاط الولاء',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== بطاقة الرصيد =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                const Icon(Icons.card_giftcard_rounded,
                    color: Colors.white, size: 36),
                const SizedBox(height: 10),
                Text(
                  '$currentPoints',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'نقطة',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),const SizedBox(height: 20),
      // ===== شريط تقدم نحو المكافأة القادمة =====
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'يتبقى $pointsToNextReward نقطة للحصول على مكافأة',
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: currentPoints / (currentPoints + pointsToNextReward),
                minHeight: 8,
                backgroundColor: AppColors.border.withOpacity(0.4),
                color: AppColors.green,
              ),
            ),
          ],
        ),
      ),const SizedBox(height: 24),
      const Align(
        alignment: Alignment.centerRight,
        child: Text(
          'كيف تكسبين النقاط؟',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
      ),
      const SizedBox(height: 12),

      _InfoRow(
        icon: Icons.shopping_bag_outlined,
        text: 'احصلي على نقطة عن كل 10 ريال من مشترياتك',
      ),
      _InfoRow(
        icon: Icons.person_add_outlined,
        text: 'ادعي صديقة واكسبي نقاط إضافية عند أول طلب لها',
      ),
      _InfoRow(
        icon: Icons.cake_outlined,
        text: 'استلمي نقاط مضاعفة في شهر ميلادك',
      ),

      const SizedBox(height: 10),
      const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            'يمكنك استبدال نقاطك بخصومات على طلباتك القادمة قريباً',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.5, color: AppColors.textGray),
          ),
        ),
      ),
    ],
  ),
);
}}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.green, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}