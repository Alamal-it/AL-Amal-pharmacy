import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'category_products_screen.dart';

class CategoryData {
  final IconData icon;
  final String label;
  final Color color;

  const CategoryData({
    required this.icon,
    required this.label,
    required this.color,
  });
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const List<CategoryData> categories = [
    CategoryData(icon: Icons.face_retouching_natural, label: 'عناية بالبشرة', color: Color(0xffF3D9D9)),
    CategoryData(icon: Icons.medication_liquid_outlined, label: 'الفيتامينات', color: Color(0xffFCEBD5)),
    CategoryData(icon: Icons.medication_outlined, label: 'أدوية', color: Color(0xffD7E6F5)),
    CategoryData(icon: Icons.child_friendly_outlined, label: 'الأم والطفل', color: Color(0xffF9E2E2)),
    CategoryData(icon: Icons.monitor_heart_outlined, label: 'اجهزة طبية', color: Color(0xffE3E3E3)),
    CategoryData(icon: Icons.spa_outlined, label: 'عناية بالشعر', color: Color(0xffE7DCEB)),
    CategoryData(icon: Icons.local_florist_outlined, label: 'العطور', color: Color(0xffF6E0EA)),
    CategoryData(icon: Icons.back_hand_outlined, label: 'عناية باليدين', color: Color(0xffFBEAF0)),
    CategoryData(icon: Icons.face_outlined, label: 'الجمال', color: Color(0xffFDEFE3)),
    CategoryData(icon: Icons.cleaning_services_outlined, label: 'العناية بالمنزل', color: Color(0xffE0F0E9)),
    CategoryData(icon: Icons.brush_outlined, label: 'العناية اليومية', color: Color(0xffE3EFE0)),
    CategoryData(icon: Icons.fitness_center_outlined, label: 'التغذية الرياضية', color: Color(0xffE9E9E9)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryDark),
        title: const Text(
          'جميع الفئات',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(Icons.search, color: AppColors.primaryDark),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      categoryName: category.label,
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
                      child: Icon(category.icon,
                          color: AppColors.primaryDark, size: 30),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category.label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11,
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
    );
  }
}