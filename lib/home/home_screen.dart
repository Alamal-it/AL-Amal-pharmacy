import 'package:flutter/material.dart';

import '../core/app_colors.dart';
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

  // ============================================================
  // البانرات
  // ============================================================

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

  // ============================================================
  // بداية الصفحة
  // ============================================================

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

  // ============================================================
  // تحديث المنتجات
  // ============================================================

  Future<void> refreshProducts() async {
    setState(() {
      productsFuture = productService.getProducts();
    });
  }

  // ============================================================
  // تسجيل الدخول
  // ============================================================

  void goToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  // ============================================================
  // خيارات التوصيل
  // ============================================================

  Future<void> openDeliveryOptions() async {
    final result = await DeliveryOptionSheet.show(context);

    if (result != null && mounted) {
      setState(() {
        deliveryMode = result.mode;
        selectedAddress = result.address;
      });
    }
  }

  // ============================================================
  // فتح صفحة الفئات
  // ============================================================

  void goToCategories() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CategoriesScreen(),
      ),
    );
  }

  // ============================================================
  // فتح فئة معينة
  // ============================================================

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

  // ============================================================
  // البحث في المنتجات
  // ============================================================

  List<Product> filterProducts(List<Product> allProducts) {
    if (searchQuery.isEmpty) {
      return allProducts;
    }

    final query = normalizeArabic(searchQuery);

    return allProducts.where((product) {
      final productName =
          normalizeArabic(product.name);

      final category =
          normalizeArabic(product.category);

      return productName.contains(query) ||
          category.contains(query);
    }).toList();
  }

  // ============================================================
  // توحيد الحروف العربية للبحث
  // ============================================================

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

  // ============================================================
  // مسح البحث
  // ============================================================

  void clearSearch() {
    searchController.clear();

    setState(() {
      searchQuery = '';
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshProducts,
          child: CustomScrollView(
            slivers: [
              // ==================================================
              // الجزء العلوي
              // ==================================================

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
                      // ==================================================
                      // الموقع + تسجيل الدخول
                      // ==================================================

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
                                          BorderRadius.circular(
                                              20),
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize
                                            .shrinkWrap,
                                  ),
                                  child: const Text(
                                    'تسجيل الدخول / إنشاء حساب',
                                    style: TextStyle(
                                      color:
                                          AppColors.green,
                                      fontSize: 12,
                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons
                                        .notifications_none,
                                    color: AppColors
                                        .primaryDark,
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
                                              ? 'الاستلام من الصيدلية'
                                              : selectedAddress !=
                                                      null
                                                  ? 'التوصيل إلى ${selectedAddress!.label}'
                                                  : 'التوصيل إلى المنزل',
                                          style:
                                              const TextStyle(
                                            color: AppColors
                                                .primaryDark,
                                            fontSize: 12.5,
                                            fontWeight:
                                                FontWeight.w700,
                                          ),
                                          overflow:
                                              TextOverflow
                                                  .ellipsis,
                                        ),
                                      ),
                                      const SizedBox(
                                          width: 4),
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
                                        ? 'اختاري أقرب صيدلية'
                                        : selectedAddress !=
                                                null
                                            ? '${selectedAddress!.addressLine}, ${selectedAddress!.city}'
                                            : 'العنوان الافتراضي',
                                    style:
                                        const TextStyle(
                                      color: AppColors
                                          .textGray,
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

                      // ==================================================
                      // البحث
                      // ==================================================

                      Row(
                        children: [
                          // زر الفئات
                          InkWell(
                            onTap: goToCategories,
                            borderRadius:
                                BorderRadius.circular(10),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color:
                                    AppColors.green,
                                borderRadius:
                                    BorderRadius.circular(
                                        10),
                              ),
                              alignment:
                                  Alignment.center,
                              child: const Icon(
                                Icons
                                    .grid_view_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // مربع البحث
                          Expanded(
                            child: Container(
                              height: 42,
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 12,
                              ),
                              decoration:
                                  BoxDecoration(
                                color:
                                    AppColors.white,
                                borderRadius:
                                    BorderRadius.circular(
                                        10),
                                border: Border.all(
                                  color:
                                      AppColors.border,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.search,
                                    color: AppColors
                                        .textGray,
                                    size: 20,
                                  ),

                                  const SizedBox(
                                      width: 8),

                                  Expanded(
                                    child: TextField(
                                      controller:
                                          searchController,
                                      textAlign:
                                          TextAlign.right,
                                      textDirection:
                                          TextDirection.rtl,
                                      textInputAction:
                                          TextInputAction
                                              .search,
                                      decoration:
                                          const InputDecoration(
                                        isCollapsed: true,
                                        border:
                                            InputBorder
                                                .none,
                                        hintText:
                                            'ابحثي عن منتج أو دواء',
                                        hintStyle:
                                            TextStyle(
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
                                      onTap:
                                          clearSearch,
                                      child:
                                          const Icon(
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

                          // المفضلة
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
                              color: AppColors
                                  .primaryDark,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // ==================================================
                      // إذا ما فيه بحث
                      // ==================================================

                      if (searchQuery.isEmpty) ...[
                        PromoBannerCarousel(
                          banners: banners,
                          onTapButton: (banner) {},
                        ),

                        const SizedBox(height: 18),

                        // ==================================================
                        // الاختصارات
                        // ==================================================

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            CategoryIconItem(
                              icon: Icons
                                  .receipt_long_outlined,
                              label: 'طلباتي',
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
                              icon: Icons
                                  .favorite_border,
                              label: 'العناية الصحية',
                              onTap: () {
                                goToCategory(
                                    'العناية الصحية');
                              },
                            ),

                            CategoryIconItem(
                              icon: Icons
                                  .medical_services_outlined,
                              label: 'أجهزة طبية',
                              onTap: () {
                                goToCategory(
                                    'أجهزة طبية');
                              },
                            ),

                            CategoryIconItem(
                              icon: Icons
                                  .camera_alt_outlined,
                              label: 'رفع وصفة',
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

                        // ==================================================
                        // تسوق حسب الفئة
                        // ==================================================

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            const Text(
                              'تسوقي حسب الفئة',
                              style: TextStyle(
                                color: AppColors
                                    .primaryDark,
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),
                            TextButton(
                              onPressed:
                                  goToCategories,
                              child: const Text(
                                'عرض الكل',
                                style: TextStyle(
                                  color: AppColors
                                      .primary,
                                  fontSize: 11.5,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // ==================================================
                        // الفئات
                        // ==================================================

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            CategoryIconItem(
                              icon: Icons
                                  .child_care_outlined,
                              label: 'الأطفال',
                              onTap: () {
                                goToCategory(
                                    'الأطفال');
                              },
                            ),

                            CategoryIconItem(
                              icon: Icons
                                  .water_drop_outlined,
                              label: 'العناية بالبشرة',
                              onTap: () {
                                goToCategory(
                                    'العناية بالبشرة');
                              },
                            ),

                            CategoryIconItem(
                              icon: Icons
                                  .add_circle_outline,
                              label: 'الفيتامينات',
                              onTap: () {
                                goToCategory(
                                    'الفيتامينات');
                              },
                            ),

                            CategoryIconItem(
                              icon: Icons
                                  .medication_outlined,
                              label: 'الأدوية',
                              onTap: () {
                                goToCategory(
                                    'الأدوية');
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

              // ==========================================================
              // عنوان النتائج
              // ==========================================================

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        searchQuery.isEmpty
                            ? 'العروض التي تنتهي قريبًا'
                            : 'نتائج البحث',
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
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 10),
              ),

              // ==========================================================
              // المنتجات / نتائج البحث
              // ==========================================================

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 190,
                  child:
                      FutureBuilder<List<Product>>(
                    future: productsFuture,
                    builder:
                        (context, snapshot) {
                      // -----------------------------
                      // تحميل
                      // -----------------------------

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

                      // -----------------------------
                      // خطأ
                      // -----------------------------

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'حدث خطأ أثناء تحميل المنتجات',
                            style: TextStyle(
                              color:
                                  AppColors.textGray,
                            ),
                          ),
                        );
                      }

                      // -----------------------------
                      // كل المنتجات
                      // -----------------------------

                      final allProducts =
                          snapshot.data ?? [];

                      // -----------------------------
                      // فلترة البحث
                      // -----------------------------

                      final products =
                          filterProducts(
                              allProducts);

                      // -----------------------------
                      // لا توجد نتائج
                      // -----------------------------

                      if (products.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            children: [
                              const Icon(
                                Icons
                                    .search_off_rounded,
                                size: 40,
                                color: AppColors
                                    .textGray,
                              ),
                              const SizedBox(
                                  height: 8),
                              Text(
                                searchQuery.isEmpty
                                    ? 'لا توجد عروض حاليًا'
                                    : 'لم يتم العثور على منتجات',
                                style:
                                    const TextStyle(
                                  color: AppColors
                                      .textGray,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // -----------------------------
                      // عرض النتائج
                      // -----------------------------

                      return ListView.builder(
                        scrollDirection:
                            Axis.horizontal,
                        padding:
                            const EdgeInsets
                                .symmetric(
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
}