import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_strings.dart';

import '../home/home_screen.dart';
import '../home/categories_screen.dart';
import '../home/cart_screen.dart';
import '../home/offers_screen.dart';
import '../home/profile_screen.dart';

import '../services/cart_service.dart';

class MainNavScreen extends StatefulWidget {
  final bool isGuest;

  const MainNavScreen({
    super.key,
    this.isGuest = false,
  });

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  // الرئيسية هي الصفحة الافتراضية
  int currentIndex = 2;

  @override
  void initState() {
    super.initState();

    CartService.instance.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    CartService.instance.removeListener(_onCartChanged);

    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  // ============================================================
  // عناصر شريط التنقل
  // ============================================================

  List<_NavItemData> get items {
    return [
      _NavItemData(
        icon: Icons.person_outline,
        label: AppStrings.myAccount,
      ),

      _NavItemData(
        icon: Icons.shopping_cart_outlined,
        label: AppStrings.shoppingCart,
      ),

      _NavItemData(
        icon: Icons.home_outlined,
        label: AppStrings.home,
      ),

      _NavItemData(
        icon: Icons.grid_view_outlined,
        label: AppStrings.categories,
      ),

      _NavItemData(
        icon: Icons.card_giftcard_outlined,
        label: AppStrings.offers,
      ),
    ];
  }

  // ============================================================
  // الشاشة حسب رقم التبويب
  // ============================================================

  Widget bodyForIndex(int index) {
    switch (index) {
      // حسابي
      case 0:
        return const ProfileScreen();

      // السلة
      case 1:
        return const CartScreen();

      // الرئيسية
      case 2:
        return HomeScreen(
          isGuest: widget.isGuest,
        );

      // الفئات
      case 3:
        return const CategoriesScreen();

      // العروض
      case 4:
        return const OffersScreen();

      default:
        return Center(
          child: Text(
            AppStrings.error,
            style: const TextStyle(
              color: AppColors.textGray,
            ),
          ),
        );
    }
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final navItems = items;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: bodyForIndex(currentIndex),

      // ========================================================
      // Bottom Navigation
      // ========================================================

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),

        child: SafeArea(
          child: SizedBox(
            height: 62,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: List.generate(
                navItems.length,
                (index) {
                  final bool selected =
                      index == currentIndex;

                  final item = navItems[index];

                  return Expanded(
                    child: InkWell(
                      onTap: () {
                        if (currentIndex == index) {
                          return;
                        }

                        setState(() {
                          currentIndex = index;
                        });
                      },

                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [
                          // ======================================
                          // الأيقونة + عدد المنتجات في السلة
                          // ======================================

                          Stack(
                            clipBehavior: Clip.none,

                            children: [
                              Container(
                                width: 38,
                                height: 38,

                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppColors.primary
                                      : Colors.transparent,

                                  shape: BoxShape.circle,
                                ),

                                child: Icon(
                                  item.icon,

                                  color: selected
                                      ? Colors.white
                                      : AppColors.textGray,

                                  size: 20,
                                ),
                              ),

                              // ==================================
                              // عدد المنتجات في السلة
                              // ==================================

                              if (index == 1 &&
                                  CartService
                                          .instance
                                          .itemCount >
                                      0)
                                Positioned(
                                  top: -2,
                                  right: -2,

                                  child: Container(
                                    padding:
                                        const EdgeInsets.all(3),

                                    decoration:
                                        const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),

                                    constraints:
                                        const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),

                                    child: Text(
                                      '${CartService.instance.itemCount}',

                                      textAlign:
                                          TextAlign.center,

                                      style:
                                          const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 3),

                          // ======================================
                          // اسم الصفحة
                          // ======================================

                          Text(
                            item.label,

                            maxLines: 1,

                            overflow:
                                TextOverflow.ellipsis,

                            textAlign: TextAlign.center,

                            style: TextStyle(
                              fontSize: 9,

                              color: selected
                                  ? AppColors.primary
                                  : AppColors.textGray,

                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// بيانات عنصر التنقل
// ================================================================

class _NavItemData {
  final IconData icon;
  final String label;

  const _NavItemData({
    required this.icon,
    required this.label,
  });
}