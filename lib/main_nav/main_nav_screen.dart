import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../home/home_screen.dart';
import '../home/categories_screen.dart';
import '../home/cart_screen.dart';
import '../services/cart_service.dart';

class MainNavScreen extends StatefulWidget {
  final bool isGuest;

  const MainNavScreen({super.key, this.isGuest = false});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int currentIndex = 2; // الرئيسية هي الافتراضية

  final List<_NavItemData> items = const [
    _NavItemData(icon: Icons.person_outline, label: 'حسابي'),
    _NavItemData(icon: Icons.shopping_cart_outlined, label: 'سلة التسوق'),
    _NavItemData(icon: Icons.home_outlined, label: 'الرئيسية'),
    _NavItemData(icon: Icons.grid_view_outlined, label: 'الفئات'),
    _NavItemData(icon: Icons.card_giftcard_outlined, label: 'العروض'),
  ];

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
    if (mounted) setState(() {});
  }

  Widget bodyForIndex(int index) {
    switch (index) {
      case 2:
        return HomeScreen(isGuest: widget.isGuest);
      case 3:
        return const CategoriesScreen();
      case 1:
        return const CartScreen();
      default:
        // TODO: استبدال هذا بالشاشة الفعلية (عروض، حسابي) لما نبنيها.
        return Center(
          child: Text(
            '${items[index].label} — قريباً',
            style: const TextStyle(color: AppColors.textGray),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: bodyForIndex(currentIndex),
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
              children: List.generate(items.length, (index) {
                final selected = index == currentIndex;
                final item = items[index];

                return InkWell(
                  onTap: () {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                          if (index == 1 && CartService.instance.itemCount > 0)
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                    minWidth: 16, minHeight: 16),
                                child: Text(
                                  '${CartService.instance.itemCount}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 9,
                          color:
                              selected ? AppColors.primary : AppColors.textGray,
                          fontWeight:
                              selected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;

  const _NavItemData({required this.icon, required this.label});
}