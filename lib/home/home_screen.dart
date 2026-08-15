import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner_carousel.dart';
import '../widgets/category_icon_item.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/deal_card.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isGuest;

  const HomeScreen({super.key, this.isGuest = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService productService = ProductService();

  late Future<List<Product>> productsFuture;

  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  final List<PromoBanner> banners = const [
    PromoBanner(
      title: 'خصم 20%',
      subtitle: 'على جميع الفيتامينات والمكملات',
      buttonText: 'تسوقي الآن',
      color: AppColors.primary,
      icon: Icons.local_offer_outlined,
    ),
    PromoBanner(
      title: 'توصيل مجاني',
      subtitle: 'لطلبات أكثر من 100 ريال',
      buttonText: 'اطلبي الآن',
      color: AppColors.green,
      icon: Icons.local_shipping_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    productsFuture = productService.getProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> refreshProducts() async {
    setState(() {
      productsFuture = productService.getProducts();
    });
  }

  void goToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshProducts,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== شريط الموقع + الإشعارات / تسجيل الدخول =====
                    Row(
                      children: [
                        widget.isGuest
                            ? TextButton(
                                onPressed: goToLogin,
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      AppColors.green.withOpacity(0.12),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'دخول / تسجيل',
                                  style: TextStyle(
                                    color: AppColors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  // TODO: فتح شاشة الإشعارات لما تجهز.
                                },
                                icon: const Icon(
                                  Icons.notifications_none,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Text(
                                    'التوصيل إلى المنزل',
                                    style: TextStyle(
                                      color: AppColors.primaryDark,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.keyboard_arrow_down,
                                      size: 16, color: AppColors.primaryDark),
                                ],
                              ),
                              const Text(
                                'حي السويس، جازان',
                                style: TextStyle(
                                  color: AppColors.textGray,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ===== البحث + المفضلة + الصورة الشخصية =====
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'ع',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 42,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search,
                                    color: AppColors.textGray, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: searchController,
                                    textAlign: TextAlign.right,
                                    textInputAction: TextInputAction.search,
                                    onChanged: (value) {
                                      setState(() {
                                        searchQuery = value.trim();
                                      });
                                    },
                                    onSubmitted: (value) {
                                      setState(() {
                                        searchQuery = value.trim();
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      isCollapsed: true,
                                      border: InputBorder.none,
                                      hintText: 'ابحثي عن دواء أو منتج...',
                                      hintStyle: TextStyle(
                                        color: AppColors.textGray,
                                        fontSize: 12,
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: AppColors.primaryDark,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                if (searchQuery.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        searchController.clear();
                                        searchQuery = '';
                                      });
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: AppColors.textGray,
                                      size: 17,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            // TODO: فتح شاشة قائمة الأمنيات لما تجهز.
                          },
                          icon: const Icon(Icons.favorite_border,
                              color: AppColors.primaryDark),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ===== البانر المتحرك (يختفي أثناء البحث) =====
                    if (searchQuery.isEmpty) ...[
                      PromoBannerCarousel(
                        banners: banners,
                        onTapButton: (banner) {
                          // TODO: فتح شاشة العروض/الفئة المرتبطة بالبانر لما تجهز.
                        },
                      ),
                      const SizedBox(height: 18),

                      // ===== صف الأيقونات الأول =====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryIconItem(
                            icon: Icons.receipt_long_outlined,
                            label: 'طلباتي',
                            onTap: () {},
                          ),
                          CategoryIconItem(
                            icon: Icons.favorite_border,
                            label: 'العناية الصحية',
                            onTap: () {},
                          ),
                          CategoryIconItem(
                            icon: Icons.medical_services_outlined,
                            label: 'أدوات طبية',
                            onTap: () {},
                          ),
                          CategoryIconItem(
                            icon: Icons.camera_alt_outlined,
                            label: 'رفع وصفة',
                            onTap: () {
                              // TODO: فتح شاشة رفع الوصفة الطبية لما تجهز.
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ===== تسوقي حسب الفئة =====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'تسوقي حسب الفئة',
                            style: TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: فتح شاشة "جميع الفئات" لما تجهز.
                            },
                            child: const Text(
                              'عرض الكل',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 11.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // ===== صف الأيقونات الثاني =====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryIconItem(
                            icon: Icons.child_care_outlined,
                            label: 'أطفال',
                            onTap: () {},
                          ),
                          CategoryIconItem(
                            icon: Icons.water_drop_outlined,
                            label: 'بشرة',
                            onTap: () {},
                          ),
                          CategoryIconItem(
                            icon: Icons.add_circle_outline,
                            label: 'فيتامينات',
                            onTap: () {},
                          ),
                          CategoryIconItem(
                            icon: Icons.medication_outlined,
                            label: 'أدوية',
                            onTap: () {},
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),
                    ],

                    // ===== عروض تنتهي قريباً / نتائج البحث =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          searchQuery.isEmpty
                              ? 'عروض تنتهي قريباً'
                              : 'نتائج البحث',
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (searchQuery.isEmpty)
                          const CountdownTimer(
                            duration:
                                Duration(hours: 2, minutes: 14, seconds: 9),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            // ===== قائمة عروض أفقية / نتائج البحث =====
            SliverToBoxAdapter(
              child: SizedBox(
                height: 150,
                child: FutureBuilder<List<Product>>(
                  future: productsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child:
                            CircularProgressIndicator(color: AppColors.primary),
                      );
                    }

                    final allProducts = snapshot.data ?? [];

                    final products = searchQuery.isEmpty
                        ? allProducts
                        : allProducts
                            .where((p) => p.name.contains(searchQuery))
                            .toList();

                    if (products.isEmpty) {
                      return Center(
                        child: Text(
                          searchQuery.isEmpty
                              ? 'لا توجد عروض حالياً'
                              : 'لا توجد نتائج لـ "$searchQuery"',
                          style: const TextStyle(color: AppColors.textGray),
                        ),
                      );
                    }

                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: products.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        return DealCard(product: products[index]);
                      },
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}