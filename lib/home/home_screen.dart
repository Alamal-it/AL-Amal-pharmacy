import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/promo_banner_carousel.dart';
import '../widgets/category_icon_item.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/deal_card.dart';
import '../auth/login_screen.dart';
import '../widgets/delivery_option_sheet.dart';
import '../models/delivery_address.dart';
import 'categories_screen.dart';
import 'favorites_screen.dart';
import 'upload_prescription_screen.dart';
import 'orders_screen.dart';
import 'category_products_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isGuest;

  const HomeScreen({
    super.key,
    this.isGuest = false,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService productService = ProductService();

  late Future<List<Product>> productsFuture;

  final TextEditingController searchController =
      TextEditingController();

  String searchQuery = '';

  DeliveryMode? deliveryMode;
  DeliveryAddress? selectedAddress;

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

    searchController.addListener(() {
      if (!mounted) return;

      setState(() {
        searchQuery = searchController.text.trim();
      });
    });
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
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> openDeliveryOptions() async {
    final result = await DeliveryOptionSheet.show(context);

    if (result != null && mounted) {
      setState(() {
        deliveryMode = result.mode;
        selectedAddress = result.address;
      });
    }
  }

  void goToCategories() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CategoriesScreen(),
      ),
    );
  }

  void goToCategory(String categoryName) {
    String actualCategory;

    switch (categoryName) {
      case 'أجهزة طبية':
        actualCategory = 'اجهزة طبية';
        break;

      case 'الأطفال':
        actualCategory = 'الأم والطفل';
        break;

      case 'العناية بالبشرة':
        actualCategory = 'عناية بالبشرة';
        break;

      case 'الأدوية':
        actualCategory = 'أدوية';
        break;

      case 'الفيتامينات':
        actualCategory = 'الفيتامينات';
        break;

      case 'العناية بالشعر':
        actualCategory = 'عناية بالشعر';
        break;

      case 'العطور':
        actualCategory = 'العطور';
        break;

      case 'عناية باليدين':
        actualCategory = 'عناية باليدين';
        break;

      case 'الجمال':
        actualCategory = 'الجمال';
        break;

      case 'العناية بالمنزل':
        actualCategory = 'العناية بالمنزل';
        break;

      case 'العناية اليومية':
        actualCategory = 'العناية اليومية';
        break;

      case 'العناية الصحية':
        actualCategory = 'العناية الصحية';
        break;

      case 'التغذية الرياضية':
        actualCategory = 'التغذية الرياضية';
        break;

      default:
        actualCategory = categoryName;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryProductsScreen(
          categoryName: actualCategory,
        ),
      ),
    );
  }

  List<Product> filterProducts(List<Product> allProducts) {
    if (searchQuery.isEmpty) {
      return allProducts;
    }

    final query = normalizeArabic(searchQuery);

    return allProducts.where((product) {
      final productName = normalizeArabic(product.name);
      final category = normalizeArabic(product.category);

      return productName.contains(query) ||
          category.contains(query);
    }).toList();
  }

  String normalizeArabic(String text) {
    return text
        .toLowerCase()
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .replaceAll('ـ', '')
        .trim();
  }

  void clearSearch() {
    searchController.clear();

    setState(() {
      searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    // ملاحظة: ما نثبت اتجاه الشاشة هنا. الاتجاه (RTL/LTR) يتحدد تلقائيًا
    // من MaterialApp بالأعلى حسب اللغة المختارة (شوفي main.dart).
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshProducts,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                child: Text(
                                  AppStrings.loginOrCreateAccount,
                                  style: const TextStyle(
                                    color: AppColors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const NotificationsScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.notifications_none,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                        Expanded(
                          child: InkWell(
                            onTap: openDeliveryOptions,
                            borderRadius: BorderRadius.circular(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        deliveryMode == DeliveryMode.pickup
                                            ? AppStrings.pickupFromPharmacy
                                            : selectedAddress != null
                                                ? AppStrings.deliverTo(
                                                    selectedAddress!.label)
                                                : AppStrings.deliverToHome,
                                        style: const TextStyle(
                                          color: AppColors.primaryDark,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 16,
                                      color: AppColors.primaryDark,
                                    ),
                                  ],
                                ),
                                Text(
                                  deliveryMode == DeliveryMode.pickup
                                      ? AppStrings.chooseNearestPharmacy
                                      : selectedAddress != null
                                          ? '${selectedAddress!.addressLine}, ${selectedAddress!.city}'
                                          : AppStrings.defaultAddress,
                                  style: const TextStyle(
                                    color: AppColors.textGray,
                                    fontSize: 10,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        InkWell(
                          onTap: goToCategories,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.grid_view_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 42,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                    textAlign: TextAlign.start,
                                    textInputAction: TextInputAction.search,
                                    decoration: InputDecoration(
                                      isCollapsed: true,
                                      border: InputBorder.none,
                                      hintText: AppStrings.searchHint,
                                      hintStyle: const TextStyle(
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
                                    onTap: clearSearch,
                                    child: const Icon(Icons.close,
                                        color: AppColors.textGray, size: 17),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FavoritesScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.favorite_border,
                              color: AppColors.primaryDark),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (searchQuery.isEmpty) ...[
                      PromoBannerCarousel(
                        banners: banners,
                        onTapButton: (banner) {},
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryIconItem(
                            icon: Icons.receipt_long_outlined,
                            label: AppStrings.myOrdersShort,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const OrdersScreen(),
                                ),
                              );
                            },
                          ),
                          CategoryIconItem(
                            icon: Icons.favorite_border,
                            label: AppStrings.healthCare,
                            onTap: () {
                              goToCategory('العناية الصحية');
                            },
                          ),
                          CategoryIconItem(
                            icon: Icons.medical_services_outlined,
                            label: AppStrings.medicalDevices,
                            onTap: () {
                              goToCategory('أجهزة طبية');
                            },
                          ),
                          CategoryIconItem(
                            icon: Icons.camera_alt_outlined,
                            label: AppStrings.uploadPrescription,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const UploadPrescriptionScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.shopByCategory,
                            style: const TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton(
                            onPressed: goToCategories,
                            child: Text(
                              AppStrings.viewAll,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 11.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryIconItem(
                            icon: Icons.child_care_outlined,
                            label: AppStrings.kids,
                            onTap: () {
                              goToCategory('الأطفال');
                            },
                          ),
                          CategoryIconItem(
                            icon: Icons.water_drop_outlined,
                            label: AppStrings.skinCare,
                            onTap: () {
                              goToCategory('العناية بالبشرة');
                            },
                          ),
                          CategoryIconItem(
                            icon: Icons.add_circle_outline,
                            label: AppStrings.vitamins,
                            onTap: () {
                              goToCategory('الفيتامينات');
                            },
                          ),
                          CategoryIconItem(
                            icon: Icons.medication_outlined,
                            label: AppStrings.medicines,
                            onTap: () {
                              goToCategory('الأدوية');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                    ],
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      searchQuery.isEmpty
                          ? AppStrings.endingSoonOffers
                          : AppStrings.searchResults,
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (searchQuery.isEmpty)
                      const CountdownTimer(
                        duration: Duration(hours: 2, minutes: 14, seconds: 9),
                      ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 190,
                child: FutureBuilder<List<Product>>(
                  future: productsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child:
                            CircularProgressIndicator(color: AppColors.primary),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          AppStrings.errorLoadingProducts,
                          style: const TextStyle(color: AppColors.textGray),
                        ),
                      );
                    }

                    final allProducts = snapshot.data ?? [];
                    final products = filterProducts(allProducts);

                    if (products.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off_rounded,
                                size: 40, color: AppColors.textGray),
                            const SizedBox(height: 8),
                            Text(
                              searchQuery.isEmpty
                                  ? AppStrings.noOffersNow
                                  : AppStrings.noProductsFound,
                              style: const TextStyle(
                                  color: AppColors.textGray, fontSize: 13),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              const EdgeInsetsDirectional.only(start: 10),
                          child: DealCard(product: products[index]),
                        );
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