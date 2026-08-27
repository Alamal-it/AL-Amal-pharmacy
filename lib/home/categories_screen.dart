import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_strings.dart';
import 'category_products_screen.dart';

class CategoryData {
  final IconData icon;
  final String label; // النص المعروض (يترجم مع اللغة)
  final String actualCategory; // الاسم الحقيقي المخزن بالمنتجات (ثابت دايمًا)
  final Color color;

  const CategoryData({
    required this.icon,
    required this.label,
    required this.actualCategory,
    required this.color,
  });
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  // ملاحظة: actualCategory لازم يطابق بالضبط أسماء الفئات المخزنة
  // بـ product_service.dart (وهي ثابتة بالعربي دايمًا بغض النظر عن لغة
  // الواجهة). label هو النص المعروض بس، ويترجم تلقائيًا مع اللغة.
  static List<CategoryData> get categories => [
        CategoryData(
          icon: Icons.face_retouching_natural,
          label: AppStrings.skinCare,
          actualCategory: 'عناية بالبشرة',
          color: const Color(0xffF3D9D9),
        ),
        CategoryData(
          icon: Icons.medication_liquid_outlined,
          label: AppStrings.vitamins,
          actualCategory: 'الفيتامينات',
          color: const Color(0xffFCEBD5),
        ),
        CategoryData(
          icon: Icons.medication_outlined,
          label: AppStrings.medicines,
          actualCategory: 'أدوية',
          color: const Color(0xffD7E6F5),
        ),
        CategoryData(
          icon: Icons.child_friendly_outlined,
          label: AppStrings.motherAndBaby,
          actualCategory: 'الأم والطفل',
          color: const Color(0xffF9E2E2),
        ),
        CategoryData(
          icon: Icons.monitor_heart_outlined,
          label: AppStrings.medicalDevices,
          actualCategory: 'اجهزة طبية',
          color: const Color(0xffE3E3E3),
        ),
        CategoryData(
          icon: Icons.spa_outlined,
          label: AppStrings.hairCare,
          actualCategory: 'عناية بالشعر',
          color: const Color(0xffE7DCEB),
        ),
        CategoryData(
          icon: Icons.local_florist_outlined,
          label: AppStrings.perfumes,
          actualCategory: 'العطور',
          color: const Color(0xffF6E0EA),
        ),
        CategoryData(
          icon: Icons.back_hand_outlined,
          label: AppStrings.handCare,
          actualCategory: 'عناية باليدين',
          color: const Color(0xffFBEAF0),
        ),
        CategoryData(
          icon: Icons.face_outlined,
          label: AppStrings.beauty,
          actualCategory: 'الجمال',
          color: const Color(0xffFDEFE3),
        ),
        CategoryData(
          icon: Icons.cleaning_services_outlined,
          label: AppStrings.homeCare,
          actualCategory: 'العناية بالمنزل',
          color: const Color(0xffE0F0E9),
        ),
        CategoryData(
          icon: Icons.brush_outlined,
          label: AppStrings.dailyCare,
          actualCategory: 'العناية اليومية',
          color: const Color(0xffE3EFE0),
        ),
        CategoryData(
          icon: Icons.fitness_center_outlined,
          label: AppStrings.sportsNutrition,
          actualCategory: 'التغذية الرياضية',
          color: const Color(0xffE9E9E9),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final bool isArabic =
        Directionality.of(context) == TextDirection.rtl;

    return Directionality(
      textDirection: isArabic
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: AppColors.primaryDark,
          ),
          title: Text(
            AppStrings.allCategories,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(
                left: isArabic ? 16 : 0,
                right: isArabic ? 0 : 16,
              ),
              child: const Icon(
                Icons.search,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.82,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryProductsScreen(
                        // نمرر الاسم الحقيقي الثابت، مو النص المترجم،
                        // عشان الفلترة تلاقي المنتجات بأي لغة.
                        categoryName: category.actualCategory,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(14),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: category.color,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Icon(
                          category.icon,
                          color: AppColors.primaryDark,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      category.label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}