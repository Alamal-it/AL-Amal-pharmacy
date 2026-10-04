import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/promo_banner_carousel.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/deal_card.dart';
import '../auth/login_screen.dart';
import '../widgets/delivery_option_sheet.dart';
import '../models/delivery_address.dart';
import 'categories_screen.dart';
import 'favorites_screen.dart';
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

  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';

  DeliveryMode? deliveryMode;
  DeliveryAddress? selectedAddress;

  // خلفية الصفحة (رمادي فاتح يخلي الكروت البيضاء تبرز)
  static const Color _background = Color(0xFFF6F8FA);

  // ============================================================
  // صور التصنيفات (من مجلد lib/assets/)
  // عدلي أسماء الملفات هنا لتطابق الصور اللي عندك.
  // ============================================================

  static const String _imgKids = 'lib/assets/kids.jpg';
  static const String _imgSkinCare = 'lib/assets/skin_care.jpg';
  static const String _imgVitamins = 'lib/assets/vitamins.jpg';
  static const String _imgMedicines = 'lib/assets/medicines.jpg';

  // ============================================================
  // البنرات
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
  // مطابقة أسماء التصنيفات (الاسم المعروض -> الاسم في الـ API)
  // أي اسم غير موجود هنا يُستخدم كما هو.
  // ============================================================

  static const Map<String, String> _categoryAliases = {
    'أجهزة طبية': 'اجهزة طبية',
    'الأطفال': 'الأم والطفل',
    'العناية بالبشرة': 'عناية بالبشرة',
    'الأدوية': 'أدوية',
    'العناية بالشعر': 'عناية بالشعر',
  };

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
  // التنقل
  // ============================================================

  void goToCategories() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CategoriesScreen(),
      ),
    );
  }

  void goToCategory(String categoryName) {
    final actualCategory = _categoryAliases[categoryName] ?? categoryName;

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
  // البحث الذكي
  // ------------------------------------------------------------
  //  - يتجاهل التشكيل والهمزات والتاء المربوطة و"ال" التعريف
  //  - يفهم أكثر من كلمة (مثال: "ادوية بندول")
  //  - يتحمل الأخطاء الإملائية البسيطة (مثال: "بندوول")
  //  - يفهم أسماء بديلة (مثال: Panadol = بندول)
  //  - يرتّب النتائج الأقرب أول
  // ============================================================

  /// كلمات بديلة (المفاتيح والقيم مكتوبة بعد التوحيد: بدون همزات/تشكيل).
  /// زيدي عليها أي أسماء تجارية أو مرادفات تحتاجينها.
  static const Map<String, List<String>> _synonyms = {
    'panadol': ['بندول'],
    'بنادول': ['بندول'],
    'paracetamol': ['باراسيتامول', 'بندول'],
    'باراسيتامول': ['paracetamol', 'بندول'],
    'vitamin': ['فيتامين'],
    'vitamins': ['فيتامين'],
    'فيتامينات': ['فيتامين'],
    'baby': ['طفل', 'اطفال'],
    'kids': ['طفل', 'اطفال'],
    'cream': ['كريم'],
    'shampoo': ['شامبو'],
    'perfume': ['عطر', 'عطور'],
    'sunscreen': ['واقي', 'شمس'],
  };

  /// كلمات عامة تُتجاهل إذا كُتبت مع كلمات ثانية.
  static const Set<String> _stopWords = {
    'ابغي', 'ابغا', 'ابي', 'اريد', 'عندكم', 'عندك', 'فيه', 'في', 'من',
    'على', 'مع', 'لي', 'لو', 'هل', 'ممكن',
  };

  List<Product> filterProducts(List<Product> allProducts) {
    final query = normalizeArabic(searchQuery);

    if (query.isEmpty) {
      return allProducts;
    }

    var tokens = _words(query);
    final meaningful = tokens.where((t) => !_stopWords.contains(t)).toList();
    if (meaningful.isNotEmpty) tokens = meaningful;

    final hits = <_SearchHit>[];

    for (final product in allProducts) {
      final nameNorm = normalizeArabic(product.name);
      final nameWords = _words(nameNorm);
      final categoryWords = _words(normalizeArabic(product.category));

      int matched = 0;
      double score = 0;

      for (final token in tokens) {
        final alternatives = <String>{token, ...?_synonyms[token]};

        double best = 0;
        for (final alt in alternatives) {
          for (final w in nameWords) {
            final sc = _wordScore(alt, w).toDouble();
            if (sc > best) best = sc;
          }
          for (final w in categoryWords) {
            final sc = _wordScore(alt, w) * 0.6;
            if (sc > best) best = sc;
          }
        }

        if (best > 0) {
          matched++;
          score += best;
        }
      }

      if (matched == 0) continue;

      // مكافأة لو اسم المنتج يحتوي عبارة البحث كاملة
      if (nameNorm.contains(query)) score += 50;

      hits.add(_SearchHit(product, matched, score));
    }

    // 1) لو فيه منتجات تطابق كل الكلمات نعرضها فقط
    final full = hits.where((h) => h.matched == tokens.length).toList();
    final result = full.isNotEmpty ? full : hits;

    // 2) الأعلى تطابقاً أول
    result.sort((a, b) {
      final byMatched = b.matched.compareTo(a.matched);
      if (byMatched != 0) return byMatched;
      return b.score.compareTo(a.score);
    });

    return result.map((h) => h.product).toList();
  }

  /// درجة تطابق كلمة البحث مع كلمة من المنتج (0 = ما تطابق).
  int _wordScore(String token, String word) {
    if (word == token) return 100;
    if (token.length >= 2 && word.startsWith(token)) return 80;
    if (token.length >= 3 && word.contains(token)) return 60;

    // تحمل الأخطاء الإملائية
    if (token.length >= 4) {
      final maxDist = token.length >= 7 ? 2 : 1;

      if ((word.length - token.length).abs() <= maxDist &&
          _editDistance(token, word) <= maxDist) {
        return 40;
      }

      // خطأ إملائي أثناء كتابة بداية الكلمة
      if (word.length > token.length &&
          _editDistance(token, word.substring(0, token.length)) <= 1) {
        return 30;
      }
    }

    return 0;
  }

  /// مسافة التعديل (Levenshtein).
  int _editDistance(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    var prev = List<int>.generate(b.length + 1, (i) => i);
    var curr = List<int>.filled(b.length + 1, 0);

    for (var i = 1; i <= a.length; i++) {
      curr[0] = i;
      for (var j = 1; j <= b.length; j++) {
        final cost = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;
        final del = prev[j] + 1;
        final ins = curr[j - 1] + 1;
        final sub = prev[j - 1] + cost;
        var m = del < ins ? del : ins;
        if (sub < m) m = sub;
        curr[j] = m;
      }
      final tmp = prev;
      prev = curr;
      curr = tmp;
    }

    return prev[b.length];
  }

  /// تقسيم النص (بعد التوحيد) إلى كلمات مع إزالة "ال" التعريف.
  List<String> _words(String normalized) {
    return normalized
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => (w.length > 3 && w.startsWith('ال')) ? w.substring(2) : w)
        .toList();
  }

  /// توحيد النص العربي/الإنجليزي للبحث.
  String normalizeArabic(String text) {
    var t = text.toLowerCase();

    // التشكيل والتطويل
    t = t.replaceAll(RegExp(r'[\u064B-\u065F\u0670\u0640]'), '');

    // الأرقام العربية -> إنجليزية
    const arabicDigits = '٠١٢٣٤٥٦٧٨٩';
    for (var i = 0; i < arabicDigits.length; i++) {
      t = t.replaceAll(arabicDigits[i], '$i');
    }

    t = t
        .replaceAll(RegExp('[أإآٱ]'), 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي');

    // أي رمز غير حرف/رقم يتحول لمسافة
    t = t.replaceAll(RegExp(r'[^\u0621-\u063A\u0641-\u064Aa-z0-9\s]'), ' ');

    return t.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // أيقونات الستاتس بار بيضاء فوق الهيدر الملوّن
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: ColoredBox(
        color: _background,
        child: RefreshIndicator(
          color: AppColors.green,
          onRefresh: refreshProducts,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ==================================================
              // الهيدر الملوّن (شريط الإعلان + العنوان + البحث)
              // ==================================================
              SliverToBoxAdapter(child: _buildHeader(context)),

              // ==================================================
              // البنرات + الاختصارات + التصنيفات
              // ==================================================
              if (searchQuery.isEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                  sliver: SliverToBoxAdapter(child: _buildHomeContent()),
                ),

              // ==================================================
              // العروض / نتائج البحث
              // ==================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    searchQuery.isEmpty ? 24 : 18,
                    16,
                    0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SectionTitle(
                        searchQuery.isEmpty
                            ? AppStrings.endingSoonOffers
                            : AppStrings.searchResults,
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

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // ==================================================
              // المنتجات
              // ==================================================
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 190,
                  child: _buildProducts(),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // الهيدر
  // ============================================================

  Widget _buildHeader(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.28),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, topInset + 14, 16, 24),
        child: Column(
          children: [
            _buildTopRow(),
            const SizedBox(height: 18),
            _buildSearchRow(),
          ],
        ),
      ),
    );
  }

  // ---------- الصف العلوي: الحساب/الإشعارات + عنوان التوصيل ----------

  Widget _buildTopRow() {
    final isPickup = deliveryMode == DeliveryMode.pickup;

    return Row(
      children: [
        widget.isGuest
            ? TextButton(
                onPressed: goToLogin,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  AppStrings.loginOrCreateAccount,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : _HeaderIconButton(
                icon: Icons.notifications_none_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                },
              ),

        const SizedBox(width: 12),

        // ---------- عنوان التوصيل ----------
        Expanded(
          child: InkWell(
            onTap: openDeliveryOptions,
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              isPickup
                                  ? AppStrings.pickupFromPharmacy
                                  : selectedAddress != null
                                      ? AppStrings.deliverTo(
                                          selectedAddress!.label,
                                        )
                                      : AppStrings.deliverToHome,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isPickup
                            ? AppStrings.chooseNearestPharmacy
                            : selectedAddress != null
                                ? '${selectedAddress!.addressLine}, ${selectedAddress!.city}'
                                : AppStrings.defaultAddress,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Icon(
                    isPickup
                        ? Icons.storefront_outlined
                        : Icons.location_on_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------- صف البحث: حقل بيضاوي + زر التصنيفات + المفضلة ----------

  Widget _buildSearchRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsetsDirectional.only(start: 16, end: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.14),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  color: AppColors.textGray,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.search,
                    cursorColor: AppColors.green,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      filled: false,
                      fillColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      hintText: AppStrings.searchHint,
                      hintStyle: const TextStyle(
                        color: AppColors.textGray,
                        fontSize: 12.5,
                      ),
                    ),
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 13,
                    ),
                  ),
                ),
                if (searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: clearSearch,
                    child: Container(
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: AppColors.border.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.primaryDark,
                        size: 14,
                      ),
                    ),
                  ),

                // زر التصنيفات (دائري أخضر داخل الحقل)
                InkWell(
                  onTap: goToCategories,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.grid_view_rounded,
                      color: Colors.white,
                      size: 19,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 10),

        _HeaderIconButton(
          icon: Icons.favorite_border_rounded,
          size: 50,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const FavoritesScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // محتوى الصفحة الرئيسية (بدون بحث)
  // ============================================================

  Widget _buildHomeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- البنرات ----------
        _HomeBannerCarousel(
          banners: banners,
          // TODO: اربطي البنرات بصفحة التصنيف/العرض المناسب.
          onTapBanner: (banner) {},
          onTapButton: (banner) {},
        ),

        const SizedBox(height: 18),

        // ---------- الاختصارات ----------
        _WhiteCard(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ShortcutItem(
                icon: Icons.receipt_long_rounded,
                label: AppStrings.myOrdersShort,
                color: AppColors.primary,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OrdersScreen(),
                    ),
                  );
                },
              ),
              _ShortcutItem(
                icon: Icons.health_and_safety_rounded,
                label: AppStrings.healthCare,
                color: AppColors.green,
                onTap: () => goToCategory('العناية الصحية'),
              ),
              _ShortcutItem(
                icon: Icons.monitor_heart_rounded,
                label: AppStrings.medicalDevices,
                color: AppColors.primary,
                onTap: () => goToCategory('أجهزة طبية'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // ---------- تصفح حسب التصنيف ----------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SectionTitle(AppStrings.shopByCategory),
            TextButton(
              onPressed: goToCategories,
              child: Text(
                AppStrings.viewAll,
                style: const TextStyle(
                  color: AppColors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _CategoryImageItem(
              imagePath: _imgKids,
              fallbackIcon: Icons.child_care_outlined,
              label: AppStrings.kids,
              onTap: () => goToCategory('الأطفال'),
            ),
            _CategoryImageItem(
              imagePath: _imgSkinCare,
              fallbackIcon: Icons.water_drop_outlined,
              label: AppStrings.skinCare,
              onTap: () => goToCategory('العناية بالبشرة'),
            ),
            _CategoryImageItem(
              imagePath: _imgVitamins,
              fallbackIcon: Icons.add_circle_outline,
              label: AppStrings.vitamins,
              onTap: () => goToCategory('الفيتامينات'),
            ),
            _CategoryImageItem(
              imagePath: _imgMedicines,
              fallbackIcon: Icons.medication_outlined,
              label: AppStrings.medicines,
              onTap: () => goToCategory('الأدوية'),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // المنتجات
  // ============================================================

  Widget _buildProducts() {
    return FutureBuilder<List<Product>>(
      future: productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.green),
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

        final products = filterProducts(snapshot.data ?? []);

        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search_off_rounded,
                  size: 40,
                  color: AppColors.textGray,
                ),
                const SizedBox(height: 8),
                Text(
                  searchQuery.isEmpty
                      ? AppStrings.noOffersNow
                      : AppStrings.noProductsFound,
                  style: const TextStyle(
                    color: AppColors.textGray,
                    fontSize: 13,
                  ),
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
              padding: const EdgeInsetsDirectional.only(start: 10),
              child: DealCard(product: products[index]),
            );
          },
        );
      },
    );
  }
}

// ============================================================
//  عناصر مشتركة
// ============================================================

/// زر دائري شفاف فوق الهيدر الملوّن.
class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

/// عنوان قسم مع خط أخضر جانبي.
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

/// كرت أبيض بظل ناعم.
class _WhiteCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _WhiteCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// عنصر تصنيف بصورة (مربع مدوّر + اسم التصنيف تحته).
/// لو الصورة مو موجودة يظهر بدالها أيقونة بدون ما يتعطل التطبيق.
class _CategoryImageItem extends StatelessWidget {
  final String imagePath;
  final IconData fallbackIcon;
  final String label;
  final VoidCallback onTap;

  const _CategoryImageItem({
    required this.imagePath,
    required this.fallbackIcon,
    required this.label,
    required this.onTap,
  });

  static const double _size = 72;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: 78,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: _size,
              height: _size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.10),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.green.withValues(alpha: 0.12),
                    alignment: Alignment.center,
                    child: Icon(
                      fallbackIcon,
                      color: AppColors.green,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// اختصار سريع: أيقونة داخل مربع مدوّر بتدرج لوني خفيف + اسم تحتها.
class _ShortcutItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ShortcutItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 92,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.20),
                    color.withValues(alpha: 0.07),
                  ],
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withValues(alpha: 0.18)),
              ),
              child: Icon(icon, color: color, size: 27),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// نتيجة بحث داخلية (المنتج + عدد الكلمات المطابقة + الدرجة).
class _SearchHit {
  final Product product;
  final int matched;
  final double score;

  const _SearchHit(this.product, this.matched, this.score);
}

// ============================================================
//  البنرات الإعلانية (كبيرة + تمرير تلقائي + مؤشرات)
// ============================================================

class _HomeBannerCarousel extends StatefulWidget {
  final List<PromoBanner> banners;
  final void Function(PromoBanner banner) onTapBanner;
  final void Function(PromoBanner banner) onTapButton;

  const _HomeBannerCarousel({
    required this.banners,
    required this.onTapBanner,
    required this.onTapButton,
  });

  @override
  State<_HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<_HomeBannerCarousel> {
  static const double _height = 200;
  static const Duration _autoPlayEvery = Duration(seconds: 4);

  final PageController _controller = PageController();
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _scheduleNext();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // تمرير تلقائي: يُعاد ضبط المؤقت مع كل تغيير صفحة (حتى لو المستخدمة مرّرت بيدها)
  void _scheduleNext() {
    _timer?.cancel();
    if (widget.banners.length < 2) return;

    _timer = Timer(_autoPlayEvery, () {
      if (!mounted || !_controller.hasClients) return;
      final next = (_index + 1) % widget.banners.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: _height,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.banners.length,
            onPageChanged: (i) {
              setState(() => _index = i);
              _scheduleNext();
            },
            itemBuilder: (_, i) => _buildCard(widget.banners[i]),
          ),
        ),

        if (widget.banners.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.banners.length, (i) {
              final active = i == _index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 22 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.green
                      : AppColors.border.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildCard(PromoBanner b) {
    final dark = Color.lerp(b.color, Colors.black, 0.38)!;

    // البنر محتواه عربي دائماً: النص يمين والرسمة يسار
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: () => widget.onTapBanner(b),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [b.color, dark],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: b.color.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // دوائر زخرفية
              PositionedDirectional(
                top: -60,
                end: -40,
                child: _circle(190, 0.07),
              ),
              PositionedDirectional(
                bottom: -80,
                start: -50,
                child: _circle(210, 0.06),
              ),
              PositionedDirectional(
                top: 24,
                start: 130,
                child: _circle(18, 0.12),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(22, 20, 14, 20),
                child: Row(
                  children: [
                    // ---------- النص + الزر ----------
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            b.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              height: 1.15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            b.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12.5,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            child: InkWell(
                              onTap: () => widget.onTapButton(b),
                              borderRadius: BorderRadius.circular(22),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 9,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      b.buttonText,
                                      style: TextStyle(
                                        color: b.color,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(
                                      Icons.arrow_back_rounded,
                                      color: b.color,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // ---------- الرسمة ----------
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Container(
                            width: 78,
                            height: 78,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                            child: Icon(b.icon, color: Colors.white, size: 40),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _circle(double size, double alpha) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: alpha),
        ),
      );
}