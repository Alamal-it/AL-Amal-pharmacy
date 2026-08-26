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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryProductsScreen(
          categoryName: categoryName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) ==
        TextDirection.rtl;

    return Directionality(
      textDirection:
          isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshProducts,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  30,
                  16,
                  0,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // ================================
                      // الموقع + تسجيل الدخول
                      // ================================

                      Row(
                        children: [
                          widget.isGuest
                              ? TextButton(
                                  onPressed: goToLogin,
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        AppColors.green
                                            .withOpacity(0.12),
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize
                                            .shrinkWrap,
                                  ),
                                  child: Text(
                                    AppStrings.loginRegister,
                                    style: const TextStyle(
                                      color: AppColors.green,
                                      fontSize: 12,
                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.notifications_none,
                                    color:
                                        AppColors.primaryDark,
                                  ),
                                ),

                          Expanded(
                            child: InkWell(
                              onTap:
                                  openDeliveryOptions,
                              borderRadius:
                                  BorderRadius.circular(8),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          deliveryMode ==
                                                  DeliveryMode
                                                      .pickup
                                              ? AppStrings
                                                  .pickupFromPharmacy
                                              : selectedAddress !=
                                                      null
                                                  ? '${AppStrings.deliveryTo} ${selectedAddress!.label}'
                                                  : AppStrings
                                                      .deliveryToHome,
                                          style:
                                              const TextStyle(
                                            color: AppColors
                                                .primaryDark,
                                            fontSize: 12.5,
                                            fontWeight:
                                                FontWeight.w700,
                                          ),
                                          overflow:
                                              TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons
                                            .keyboard_arrow_down,
                                        size: 16,
                                        color: AppColors
                                            .primaryDark,
                                      ),
                                    ],
                                  ),

                                  Text(
                                    deliveryMode ==
                                            DeliveryMode.pickup
                                        ? AppStrings
                                            .chooseNearestPharmacy
                                        : selectedAddress != null
                                            ? '${selectedAddress!.addressLine}, ${selectedAddress!.city}'
                                            : AppStrings
                                                .defaultAddress,
                                    style: const TextStyle(
                                      color:
                                          AppColors.textGray,
                                      fontSize: 10,
                                    ),
                                    maxLines: 1,
                                    overflow:
                                        TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // ================================
                      // البحث
                      // ================================

                      Row(
                        children: [
                          InkWell(
                            onTap: goToCategories,
                            borderRadius:
                                BorderRadius.circular(10),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: AppColors.green,
                                borderRadius:
                                    BorderRadius.circular(10),
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
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius:
                                    BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.border,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.search,
                                    color:
                                        AppColors.textGray,
                                    size: 20,
                                  ),

                                  const SizedBox(width: 8),

                                  Expanded(
                                    child: TextField(
                                      controller:
                                          searchController,
                                      textAlign: isArabic
                                          ? TextAlign.right
                                          : TextAlign.left,
                                      textInputAction:
                                          TextInputAction.search,
                                      onChanged: (value) {
                                        setState(() {
                                          searchQuery =
                                              value.trim();
                                        });
                                      },
                                      decoration:
                                          InputDecoration(
                                        isCollapsed: true,
                                        border:
                                            InputBorder.none,
                                        hintText: AppStrings
                                            .searchProductsHint,
                                        hintStyle:
                                            const TextStyle(
                                          color: AppColors
                                              .textGray,
                                          fontSize: 12,
                                        ),
                                      ),
                                      style:
                                          const TextStyle(
                                        color: AppColors
                                            .primaryDark,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),

                                  if (searchQuery.isNotEmpty)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          searchController
                                              .clear();
                                          searchQuery = '';
                                        });
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: AppColors
                                            .textGray,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const FavoritesScreen(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.favorite_border,
                              color:
                                  AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // ================================
                      // البانر
                      // ================================

                      if (searchQuery.isEmpty) ...[
                        PromoBannerCarousel(
                          banners: banners,
                          onTapButton: (banner) {},
                        ),

                        const SizedBox(height: 18),

                        // ==============================
                        // الاختصارات
                        // ==============================

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            CategoryIconItem(
                              icon: Icons
                                  .receipt_long_outlined,
                              label: AppStrings.myOrders,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const OrdersScreen(),
                                  ),
                                );
                              },
                            ),

                            CategoryIconItem(
                              icon:
                                  Icons.favorite_border,
                              label:
                                  AppStrings.healthCare,
                              onTap: () {
                                goToCategory(
                                  AppStrings.healthCare,
                                );
                              },
                            ),

                            CategoryIconItem(
                              icon: Icons
                                  .medical_services_outlined,
                              label:
                                  AppStrings.medicalDevices,
                              onTap: () {
                                goToCategory(
                                  'اجهزة طبية',
                                );
                              },
                            ),

                            CategoryIconItem(
                              icon:
                                  Icons.camera_alt_outlined,
                              label:
                                  _uploadPrescriptionText(),
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

                        // ==============================
                        // تسوق حسب الفئة
                        // ==============================

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _shopByCategoryText(),
                              style: const TextStyle(
                                color:
                                    AppColors.primaryDark,
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),

                            TextButton(
                              onPressed:
                                  goToCategories,
                              child: Text(
                                AppStrings.seeAll,
                                style:
                                    const TextStyle(
                                  color:
                                      AppColors.primary,
                                  fontSize: 11.5,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            CategoryIconItem(
                              icon:
                                  Icons.child_care_outlined,
                              label:
                                  AppStrings.children,
                              onTap: () {},
                            ),
                            CategoryIconItem(
                              icon:
                                  Icons.water_drop_outlined,
                              label:
                                  AppStrings.skin,
                              onTap: () {},
                            ),
                            CategoryIconItem(
                              icon:
                                  Icons.add_circle_outline,
                              label:
                                  AppStrings.vitamins,
                              onTap: () {},
                            ),
                            CategoryIconItem(
                              icon:
                                  Icons.medication_outlined,
                              label:
                                  AppStrings.medicines,
                              onTap: () {},
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),
                      ],

                      // ================================
                      // العروض / نتائج البحث
                      // ================================

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            searchQuery.isEmpty
                                ? AppStrings.expiringOffers
                                : AppStrings.searchResults,
                            style: const TextStyle(
                              color:
                                  AppColors.primaryDark,
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),

                          if (searchQuery.isEmpty)
                            const CountdownTimer(
                              duration: Duration(
                                hours: 2,
                                minutes: 14,
                                seconds: 9,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),

              // ==========================================
              // المنتجات
              // ==========================================

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 150,
                  child: FutureBuilder<List<Product>>(
                    future: productsFuture,
                    builder:
                        (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child:
                              CircularProgressIndicator(
                            color:
                                AppColors.primary,
                          ),
                        );
                      }

                      final allProducts =
                          snapshot.data ?? [];

                      final products =
                          searchQuery.isEmpty
                              ? allProducts
                              : allProducts
                                  .where(
                                    (p) => p.name
                                        .toLowerCase()
                                        .contains(
                                          searchQuery
                                              .toLowerCase(),
                                        ),
                                  )
                                  .toList();

                      if (products.isEmpty) {
                        return Center(
                          child: Text(
                            searchQuery.isEmpty
                                ? AppStrings
                                    .noOffersCurrently
                                : AppStrings.noProductsFound,
                            style:
                                const TextStyle(
                              color:
                                  AppColors.textGray,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        scrollDirection:
                            Axis.horizontal,
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        physics:
                            const BouncingScrollPhysics(),
                        itemCount:
                            products.length,
                        itemBuilder:
                            (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(
                              left: 10,
                            ),
                            child: DealCard(
                              product:
                                  products[index],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _uploadPrescriptionText() {
    return LocaleServiceHelper.isArabic
        ? 'رفع وصفة'
        : 'Upload Prescription';
  }

  String _shopByCategoryText() {
    return LocaleServiceHelper.isArabic
        ? 'تسوقي حسب الفئة'
        : 'Shop by Category';
  }
}

// ============================================================
// مساعد بسيط للغة بدون تغيير باقي المشروع
// ============================================================

class LocaleServiceHelper {
  static bool get isArabic =>
      DirectionalityHelper.isArabic;
}

class DirectionalityHelper {
  static bool get isArabic =>
      WidgetsBinding.instance.platformDispatcher
          .locale.languageCode ==
      'ar';
}