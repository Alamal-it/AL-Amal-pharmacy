import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import '../services/favorites_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;

  Product get product => widget.product;

  bool get isFavorite =>
      FavoritesService.instance.isFavorite(product.id);

  int? get discountPercent {
    if (product.oldPrice == null || product.oldPrice! <= product.price) {
      return null;
    }

    return (((product.oldPrice! - product.price) /
                product.oldPrice!) *
            100)
        .round();
  }

  double get savingAmount {
    if (product.oldPrice == null || product.oldPrice! <= product.price) {
      return 0;
    }

    return product.oldPrice! - product.price;
  }

  String get productDescription {
    final name = product.name.toLowerCase();

    if (name.contains('أوجمنتين') ||
        name.contains('augmentin')) {
      return 'أوجمنتين من المنتجات الدوائية التي تحتوي على أموكسيسيلين مع حمض الكلافولانيك. يستخدم حسب وصف الطبيب والنشرة الطبية المرفقة.';
    }

    if (name.contains('بنادول اكسترا')) {
      return 'بنادول إكسترا مسكن يستخدم لتخفيف الألم وخفض الحرارة، ويحتوي على باراسيتامول مع الكافيين. يستخدم وفق التعليمات المرفقة.';
    }

    if (name.contains('باندول') ||
        name.contains('بنادول')) {
      return 'منتج مسكن يستخدم لتخفيف الألم وخفض الحرارة. يجب استخدامه وفق الجرعة والتعليمات الموضحة على العبوة أو حسب توجيه المختص.';
    }

    if (name.contains('فولتارين')) {
      return 'جل موضعي يستخدم لتخفيف الألم في المناطق المستهدفة، ويُستخدم حسب التعليمات الموجودة على العبوة.';
    }

    if (name.contains('كونجستال')) {
      return 'منتج مخصص لتخفيف بعض أعراض الزكام والبرد. يستخدم وفق التعليمات والنشرة المرفقة.';
    }

    if (name.contains('زيرتك')) {
      return 'منتج مضاد للحساسية يستخدم لتخفيف أعراض الحساسية، ويستخدم حسب النشرة الطبية أو توجيه المختص.';
    }

    if (name.contains('نيوروفين')) {
      return 'مسكن وخافض للحرارة من المنتجات المحتوية على الإيبوبروفين. يستخدم وفق التعليمات والنشرة الطبية.';
    }

    if (name.contains('فيتامين د')) {
      return 'مكمل غذائي يحتوي على فيتامين د، ويستخدم للمساعدة في تلبية احتياجات الجسم من هذا الفيتامين حسب الإرشادات.';
    }

    if (name.contains('أوميغا')) {
      return 'مكمل غذائي يحتوي على أحماض أوميغا 3، مناسب للاستخدام اليومي وفق التعليمات الموجودة على العبوة.';
    }

    if (name.contains('فيتامين سي')) {
      return 'مكمل غذائي يحتوي على فيتامين سي، مناسب للاستخدام اليومي وفق الجرعة والتعليمات الموضحة على العبوة.';
    }

    if (name.contains('زنك')) {
      return 'مكمل غذائي يجمع بين الزنك وفيتامين سي، ويستخدم وفق الإرشادات الموجودة على العبوة.';
    }

    if (name.contains('ملتي فيتامين')) {
      return 'مكمل غذائي متعدد الفيتامينات مصمم للاستخدام اليومي وفق الاحتياج والتعليمات الموجودة على العبوة.';
    }

    if (name.contains('بيوتين')) {
      return 'مكمل غذائي يحتوي على البيوتين، ويستخدم وفق التعليمات الموجودة على العبوة.';
    }

    if (name.contains('كريم مرطب')) {
      return 'كريم مرطب للعناية بالبشرة والمساعدة على الحفاظ على ترطيبها ونعومتها.';
    }

    if (name.contains('غسول للوجه')) {
      return 'غسول مخصص لتنظيف بشرة الوجه وإزالة الأوساخ والشوائب ضمن روتين العناية اليومي.';
    }

    if (name.contains('واقي شمس')) {
      return 'واقي شمس للاستخدام اليومي للمساعدة على حماية البشرة من أشعة الشمس وفق مستوى الحماية الموضح على العبوة.';
    }

    if (name.contains('سيروم فيتامين سي')) {
      return 'سيروم للعناية بالبشرة يحتوي على فيتامين سي، مناسب للإضافة إلى روتين العناية بالبشرة حسب تعليمات المنتج.';
    }

    if (name.contains('تونر')) {
      return 'تونر مخصص للعناية بالبشرة وتنظيفها ضمن خطوات روتين العناية اليومية.';
    }

    if (name.contains('حليب أطفال')) {
      return 'حليب مخصص للأطفال، ويجب اختيار النوع المناسب لعمر الطفل واستخدامه وفق تعليمات الشركة المختصة.';
    }

    if (name.contains('مناديل مبللة')) {
      return 'مناديل مبللة مخصصة للعناية اليومية بالأطفال والتنظيف اللطيف.';
    }

    if (name.contains('حفاضات')) {
      return 'حفاضات أطفال مصممة للاستخدام اليومي وتوفير الراحة والحماية أثناء الاستخدام.';
    }

    if (name.contains('طفح جلدي')) {
      return 'كريم مخصص للعناية ببشرة الأطفال والمساعدة في الحفاظ على راحة البشرة. يستخدم وفق تعليمات المنتج.';
    }

    if (name.contains('شامبو أطفال')) {
      return 'شامبو لطيف مخصص للعناية بشعر الأطفال وتنظيفه بلطف.';
    }

    if (name.contains('جهاز قياس الضغط')) {
      return 'جهاز مخصص لقياس ضغط الدم في المنزل. للحصول على قراءة دقيقة يجب اتباع تعليمات الاستخدام المرفقة.';
    }

    if (name.contains('ترمومتر')) {
      return 'ميزان حرارة رقمي لقياس درجة الحرارة، ويستخدم وفق تعليمات التشغيل المرفقة.';
    }

    if (name.contains('جهاز قياس السكر')) {
      return 'جهاز مخصص لقياس مستوى سكر الدم، ويستخدم مع المستلزمات الخاصة به وفق دليل الاستخدام.';
    }

    if (name.contains('جهاز تبخير')) {
      return 'جهاز تبخير مخصص للاستخدام المنزلي وفق تعليمات الشركة المصنعة وطريقة التشغيل الموضحة في الدليل.';
    }

    if (name.contains('شامبو للشعر')) {
      return 'شامبو للعناية بالشعر وتنظيفه ضمن روتين العناية اليومي.';
    }

    if (name.contains('زيت للشعر')) {
      return 'زيت مخصص للعناية بالشعر وترطيبه، ويستخدم وفق طريقة الاستخدام الموضحة على العبوة.';
    }

    if (name.contains('سيروم لتساقط الشعر')) {
      return 'سيروم مخصص للعناية بالشعر وفروة الرأس، ويستخدم حسب تعليمات المنتج.';
    }

    if (name.contains('بلسم')) {
      return 'بلسم مرطب يساعد على العناية بالشعر وتحسين ملمسه بعد الغسل.';
    }

    if (name.contains('عطر نسائي')) {
      return 'عطر نسائي للاستخدام اليومي والمناسبات، برائحة مميزة تضيف لمسة أنيقة.';
    }

    if (name.contains('عطر رجالي')) {
      return 'عطر رجالي للاستخدام اليومي والمناسبات، بتركيبة عطرية مناسبة للاستخدام الشخصي.';
    }

    if (name.contains('مزيل عرق')) {
      return 'مزيل عرق للاستخدام اليومي للمساعدة على الحفاظ على الانتعاش طوال اليوم.';
    }

    if (name.contains('كريم مرطب لليدين')) {
      return 'كريم مخصص لترطيب اليدين والعناية بالبشرة والمساعدة على الحفاظ على نعومتها.';
    }

    if (name.contains('معقم يدين') ||
        name.contains('مطهر لليدين')) {
      return 'معقم لليدين للاستخدام اليومي للمساعدة على تنظيف اليدين والحفاظ على النظافة.';
    }

    if (name.contains('كريم أساس')) {
      return 'كريم أساس للعناية بالمظهر وتوحيد مظهر البشرة ضمن روتين المكياج اليومي.';
    }

    if (name.contains('أحمر شفاه')) {
      return 'أحمر شفاه لإضافة اللون والمظهر الجذاب للشفاه.';
    }

    if (name.contains('ماسكارا')) {
      return 'ماسكارا مخصصة لتجميل الرموش وإبراز مظهر العينين.';
    }

    if (name.contains('معقم أسطح')) {
      return 'منتج مخصص لتنظيف وتعقيم الأسطح وفق تعليمات الاستخدام الموجودة على العبوة.';
    }

    if (name.contains('مناديل معقمة')) {
      return 'مناديل مخصصة لتنظيف وتعقيم الأسطح أو الاستخدام المحدد على العبوة.';
    }

    if (name.contains('معجون أسنان')) {
      return 'معجون أسنان للاستخدام اليومي ضمن روتين العناية بصحة ونظافة الفم والأسنان.';
    }

    if (name.contains('فرشاة أسنان كهربائية')) {
      return 'فرشاة أسنان كهربائية مصممة للمساعدة في تنظيف الأسنان ضمن روتين العناية اليومي.';
    }

    if (name.contains('غسول فم')) {
      return 'غسول فم للاستخدام ضمن روتين العناية اليومية بالفم وفق التعليمات الموجودة على العبوة.';
    }

    if (name.contains('كمامات')) {
      return 'كمامات طبية للاستخدام اليومي، مناسبة للاستخدام وفق الإرشادات الموضحة على العبوة.';
    }

    if (name.contains('بروتين واي')) {
      return 'مكمل بروتين واي للاستخدام ضمن النظام الغذائي، ويستخدم وفق تعليمات المنتج والاحتياج الغذائي.';
    }

    if (name.contains('كرياتين')) {
      return 'مكمل كرياتين مونوهيدرات يستخدم ضمن النظام الغذائي الرياضي وفق تعليمات المنتج.';
    }

    if (name.contains('BCAA')) {
      return 'مكمل يحتوي على أحماض أمينية متفرعة السلسلة، ويستخدم وفق تعليمات المنتج.';
    }

    return 'منتج متوفر لدى صيدلية الأمل، تم اختياره بعناية لتلبية احتياجاتك الصحية والعناية الشخصية.';
  }

  _ProductDetails get productDetails {
    final name = product.name;

    if (name.contains('أوجمنتين')) {
      return const _ProductDetails(
        brand: 'أوجمنتين',
        type: 'دواء',
        form: 'أقراص',
        size: '1 غم',
        usage: 'حسب وصف الطبيب',
        country: 'حسب بيانات العبوة',
      );
    }

    if (name.contains('باندول') ||
        name.contains('بنادول')) {
      return const _ProductDetails(
        brand: 'بنادول',
        type: 'دواء',
        form: 'أقراص',
        size: 'حسب العبوة',
        usage: 'حسب النشرة الطبية',
        country: 'حسب بيانات العبوة',
      );
    }

    if (name.contains('فولتارين')) {
      return const _ProductDetails(
        brand: 'فولتارين',
        type: 'دواء',
        form: 'جل موضعي',
        size: 'حسب العبوة',
        usage: 'استخدام موضعي',
        country: 'حسب بيانات العبوة',
      );
    }

    if (name.contains('كونجستال')) {
      return const _ProductDetails(
        brand: 'كونجستال',
        type: 'دواء',
        form: 'أقراص',
        size: 'حسب العبوة',
        usage: 'حسب النشرة الطبية',
        country: 'حسب بيانات العبوة',
      );
    }

    if (name.contains('زيرتك')) {
      return const _ProductDetails(
        brand: 'زيرتك',
        type: 'دواء',
        form: 'أقراص',
        size: 'حسب العبوة',
        usage: 'حسب النشرة الطبية',
        country: 'حسب بيانات العبوة',
      );
    }

    if (name.contains('نيوروفين')) {
      return const _ProductDetails(
        brand: 'نيوروفين',
        type: 'دواء',
        form: 'أقراص',
        size: 'حسب العبوة',
        usage: 'حسب النشرة الطبية',
        country: 'حسب بيانات العبوة',
      );
    }

    if (name.contains('واقي شمس')) {
      return const _ProductDetails(
        brand: 'حسب المنتج',
        type: 'عناية بالبشرة',
        form: 'كريم / واقي شمس',
        size: 'حسب العبوة',
        usage: 'للاستخدام الخارجي',
        country: 'حسب بيانات العبوة',
      );
    }

    if (name.contains('حليب أطفال')) {
      return const _ProductDetails(
        brand: 'حسب المنتج',
        type: 'تغذية أطفال',
        form: 'حليب',
        size: 'حسب العبوة',
        usage: 'حسب العمر والتعليمات',
        country: 'حسب بيانات العبوة',
      );
    }

    if (name.contains('حفاضات')) {
      return const _ProductDetails(
        brand: 'حسب المنتج',
        type: 'منتجات أطفال',
        form: 'حفاضات',
        size: 'مقاس 4',
        usage: 'للاستخدام اليومي',
        country: 'حسب بيانات العبوة',
      );
    }

    if (name.contains('جهاز')) {
      return const _ProductDetails(
        brand: 'حسب المنتج',
        type: 'جهاز صحي',
        form: 'جهاز',
        size: 'حسب المنتج',
        usage: 'حسب دليل الاستخدام',
        country: 'حسب بيانات الجهاز',
      );
    }

    if (name.contains('عطر')) {
      return const _ProductDetails(
        brand: 'حسب المنتج',
        type: 'عطور',
        form: 'عطر',
        size: 'حسب العبوة',
        usage: 'للاستخدام الخارجي',
        country: 'حسب بيانات العبوة',
      );
    }

    if (name.contains('فيتامين') ||
        name.contains('أوميغا') ||
        name.contains('زنك') ||
        name.contains('بيوتين') ||
        name.contains('بروتين') ||
        name.contains('كرياتين') ||
        name.contains('BCAA')) {
      return const _ProductDetails(
        brand: 'حسب المنتج',
        type: 'مكمل غذائي',
        form: 'مكمل غذائي',
        size: 'حسب العبوة',
        usage: 'حسب تعليمات المنتج',
        country: 'حسب بيانات العبوة',
      );
    }

    return _ProductDetails(
      brand: 'حسب المنتج',
      type: product.category,
      form: 'منتج للعناية',
      size: 'حسب العبوة',
      usage: 'حسب تعليمات المنتج',
      country: 'حسب بيانات العبوة',
    );
  }

  Future<void> _shareProduct() async {
    await Share.share(
      'اكتشف ${product.name}\n'
      'السعر: ${product.price.toStringAsFixed(2)} ${AppStrings.currency}\n'
      'متوفر الآن لدى صيدلية الأمل.',
      subject: product.name,
    );
  }

  void _toggleFavorite() {
    FavoritesService.instance.toggleFavorite(product);

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? 'تمت إضافة المنتج إلى المفضلة'
              : 'تمت إزالة المنتج من المفضلة',
          style: const TextStyle(fontFamily: 'Cairo'),
          textDirection: TextDirection.rtl,
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addToCart() {
    CartService.instance.addToCart(
      product,
      quantity: quantity,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppStrings.addedToCart(quantity, product.name),
          style: const TextStyle(fontFamily: 'Cairo'),
          textDirection: TextDirection.rtl,
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final discount = discountPercent;
    final details = productDetails;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: _buildTopBar(),
                    ),
                    SliverToBoxAdapter(
                      child: _buildProductImage(discount),
                    ),
                    SliverToBoxAdapter(
                      child: _buildProductSummary(discount),
                    ),
                    SliverToBoxAdapter(
                      child: _buildInstallments(),
                    ),
                    SliverToBoxAdapter(
                      child: _buildRewardPoints(),
                    ),
                    SliverToBoxAdapter(
                      child: _buildDescriptionAndDetails(details),
                    ),
                    SliverToBoxAdapter(
                      child: _buildBenefits(),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 24),
                    ),
                  ],
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _circleButton(
            icon: Icons.arrow_forward_ios_rounded,
            onTap: () => Navigator.of(context).pop(),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            size: 21,
            color: color ?? AppColors.primaryDark,
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // صورة المنتج + الإعجاب والمشاركة
  // ------------------------------------------------------------

  Widget _buildProductImage(int? discount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Container(
        height: 310,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 20,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Stack(
          children: [
            // الصورة في المنتصف
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  60,
                  25,
                  25,
                  25,
                ),
                child: Center(
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) {
                      return Icon(
                        Icons.medication_outlined,
                        size: 100,
                        color:
                            AppColors.primary.withValues(alpha: 0.25),
                      );
                    },
                    loadingBuilder:
                        (context, child, progress) {
                      if (progress == null) return child;

                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // الخصم
            if (discount != null)
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '-$discount%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

            // أزرار الإعجاب والمشاركة
            // موجودة على يسار الصورة ومحاذية لمنتصفها
            Positioned(
              left: 14,
              top: 0,
              bottom: 0,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _imageActionButton(
                      icon: isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color:
                          isFavorite ? Colors.red : AppColors.primaryDark,
                      onTap: _toggleFavorite,
                    ),
                    const SizedBox(height: 12),
                    _imageActionButton(
                      icon: Icons.share_outlined,
                      color: AppColors.primaryDark,
                      onTap: _shareProduct,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            icon,
            size: 22,
            color: color,
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // معلومات المنتج
  // ------------------------------------------------------------

  Widget _buildProductSummary(int? discount) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.category,
            style: TextStyle(
              color: AppColors.primary,
              fontFamily: 'Cairo',
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            product.name,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.primaryDark,
              fontFamily: 'Cairo',
              fontSize: 21,
              fontWeight: FontWeight.w800,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${product.price.toStringAsFixed(2)} ${AppStrings.currency}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontFamily: 'Cairo',
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 10),
              if (product.oldPrice != null &&
                  product.oldPrice! > product.price)
                Text(
                  '${product.oldPrice!.toStringAsFixed(2)} ${AppStrings.currency}',
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              if (discount != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'خصم $discount%',
                    style: const TextStyle(
                      color: Colors.red,
                      fontFamily: 'Cairo',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (savingAmount > 0) ...[
            const SizedBox(height: 6),
            Text(
              'وفّري ${savingAmount.toStringAsFixed(2)} ${AppStrings.currency}',
              style: TextStyle(
                color: AppColors.green,
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // التقسيط
  // ------------------------------------------------------------

  Widget _buildInstallments() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.payments_outlined,
                color: AppColors.primary,
                size: 21,
              ),
              const SizedBox(width: 8),
              Text(
                'التقسيط متاح بدون فوائد',
                style: TextStyle(
                  color: AppColors.primaryDark,
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _paymentLogo(
                  asset: 'lib/assets/tabby_icon.png',
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: _paymentLogo(
                  asset: 'lib/assets/tamara_icon.png',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _paymentLogo({
    required String asset,
  }) {
    return Container(
      height: 76,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.45),
        ),
      ),
      child: Image.asset(
        asset,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          return Icon(
            Icons.credit_card_outlined,
            color: AppColors.primary,
            size: 28,
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // نقاط المكافآت
  // ------------------------------------------------------------

  Widget _buildRewardPoints() {
    final rewardPoints = product.price.round();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            Color(0xFFFFF8D9),
            Color(0xFFFFFDF2),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFFD54F).withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE082),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.stars_rounded,
              color: Color(0xFFB8860B),
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نقاط المكافآت',
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'احصل على نقاط مع كل عملية شراء',
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontFamily: 'Cairo',
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$rewardPoints نقطة',
            style: const TextStyle(
              color: Color(0xFFB8860B),
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // الوصف + تفاصيل المنتج
  // ------------------------------------------------------------

  Widget _buildDescriptionAndDetails(
    _ProductDetails details,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'وصف المنتج',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            productDescription,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.textGray,
              fontFamily: 'Cairo',
              fontSize: 13,
              height: 1.9,
            ),
          ),

          const SizedBox(height: 22),

          Divider(
            color: AppColors.border.withValues(alpha: 0.55),
            height: 1,
          ),

          const SizedBox(height: 20),

          Text(
            'تفاصيل المنتج',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 14),

          _simpleDetail(
            title: 'البراند',
            value: details.brand,
          ),

          _simpleDetail(
            title: 'نوع المنتج',
            value: details.type,
          ),

          _simpleDetail(
            title: 'شكل المنتج',
            value: details.form,
          ),

          _simpleDetail(
            title: 'الحجم / العبوة',
            value: details.size,
          ),

          _simpleDetail(
            title: 'طريقة الاستخدام',
            value: details.usage,
          ),

          _simpleDetail(
            title: 'بلد الصنع',
            value: details.country,
          ),
        ],
      ),
    );
  }

  Widget _simpleDetail({
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.textGray,
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.primaryDark,
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // المميزات
  // ------------------------------------------------------------

  Widget _buildBenefits() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.fromLTRB(10, 18, 10, 18),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: _benefitItem(
              icon: Icons.local_shipping_outlined,
              title: 'توصيل سريع',
            ),
          ),
          Expanded(
            child: _benefitItem(
              icon: Icons.verified_outlined,
              title: 'منتجات موثوقة',
            ),
          ),
          Expanded(
            child: _benefitItem(
              icon: Icons.lock_outline_rounded,
              title: 'دفع آمن',
            ),
          ),
        ],
      ),
    );
  }

  Widget _benefitItem({
    required IconData icon,
    required String title,
  }) {
    return Column(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.07),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 22,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.primaryDark,
            fontFamily: 'Cairo',
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // زر إضافة للسلة
  // ------------------------------------------------------------

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        height: 54,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _addToCart,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  size: 22,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                AppStrings.addToCart,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: AppColors.border.withValues(alpha: 0.55),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.025),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

class _ProductDetails {
  final String brand;
  final String type;
  final String form;
  final String size;
  final String usage;
  final String country;

  const _ProductDetails({
    required this.brand,
    required this.type,
    required this.form,
    required this.size,
    required this.usage,
    required this.country,
  });
}
