import '../models/product.dart';
import 'api_client.dart';
import '../core/api_config.dart';

class ProductService {
  final ApiClient _client = ApiClient.instance;

  // ضعي false هنا يوم يجهز الـ API الحقيقي.
  static const bool useMockData = true;

  Future<List<Product>> getProducts() async {
    if (useMockData) {
      return _getMockProducts();
    }

    return _fetchFromApi();
  }

  Future<List<Product>> _fetchFromApi() async {
    final response = await _client.get(ApiConfig.products);

    final List<dynamic> list =
        response is List ? response : (response['data'] ?? []);

    return list
        .map(
          (json) => Product.fromJson(
            Map<String, dynamic>.from(json),
          ),
        )
        .toList();
  }

  Future<List<Product>> _getMockProducts() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    return const [
      // =========================================================
      // الأدوية
      // =========================================================

      Product(
        id: '1',
        name: 'أوجمنتين 1 غم',
        price: 52,
        oldPrice: 65,
        image:
            'https://placehold.co/800x800/123B72/FFFFFF/png?text=Augmentin',
        category: 'أدوية',
        stock: 25,
        rating: 4.8,
        reviewsCount: 126,
        pointsPrice: 520,
        description:
            'مضاد حيوي يستخدم لعلاج عدد من الالتهابات البكتيرية حسب وصف الطبيب.',
        details:
            'المادة الفعالة: أموكسيسيلين + حمض كلافولانيك\n'
            'التركيز: 1 غم\n'
            'النوع: أقراص\n'
            'الاستخدام: حسب وصف الطبيب.',
      ),

      Product(
        id: '4',
        name: 'باندول',
        price: 15,
        oldPrice: 18,
        image:
            'https://placehold.co/800x800/E63946/FFFFFF/png?text=Panadol',
        category: 'أدوية',
        stock: 40,
        rating: 4.7,
        reviewsCount: 89,
        pointsPrice: 150,
        description:
            'مسكن وخافض للحرارة للاستخدام حسب الإرشادات المدونة على العبوة.',
        details:
            'النوع: أقراص\n'
            'الاستخدام: مسكن وخافض للحرارة\n'
            'يستخدم وفق الجرعة الموصى بها.',
      ),

      Product(
        id: '6',
        name: 'بنادول اكسترا',
        price: 22,
        image:
            'https://placehold.co/800x800/E63946/FFFFFF/png?text=Panadol+Extra',
        category: 'أدوية',
        stock: 32,
        rating: 4.8,
        reviewsCount: 104,
        pointsPrice: 220,
        description:
            'تركيبة مسكنة للاستخدام عند الحاجة وفق الإرشادات المرفقة بالمنتج.',
        details:
            'النوع: أقراص\n'
            'الاستخدام: تسكين الألم\n'
            'يرجى الالتزام بالجرعة المحددة.',
      ),

      Product(
        id: '20',
        name: 'فولتارين جل',
        price: 28,
        oldPrice: 36,
        image:
            'https://placehold.co/800x800/D62828/FFFFFF/png?text=Voltaren',
        category: 'أدوية',
        stock: 18,
        rating: 4.6,
        reviewsCount: 71,
        pointsPrice: 280,
        description:
            'جل موضعي يستخدم لتخفيف آلام العضلات والمفاصل وفق الإرشادات.',
        details:
            'النوع: جل موضعي\n'
            'الاستخدام: آلام العضلات والمفاصل\n'
            'للاستخدام الخارجي فقط.',
      ),

      Product(
        id: '21',
        name: 'كونجستال',
        price: 19,
        oldPrice: 24,
        image:
            'https://placehold.co/800x800/D62828/FFFFFF/png?text=Congestal',
        category: 'أدوية',
        stock: 24,
        rating: 4.5,
        reviewsCount: 55,
        pointsPrice: 190,
        description:
            'منتج لأعراض الزكام والبرد يستخدم وفق الجرعة والإرشادات الموجودة على العبوة.',
        details:
            'النوع: أقراص\n'
            'الاستخدام: أعراض الزكام والبرد\n'
            'اقرئي النشرة الداخلية قبل الاستخدام.',
      ),

      Product(
        id: '22',
        name: 'زيرتك أقراص',
        price: 24,
        oldPrice: 30,
        image:
            'https://placehold.co/800x800/D62828/FFFFFF/png?text=Zyrtec',
        category: 'أدوية',
        stock: 20,
        rating: 4.7,
        reviewsCount: 63,
        pointsPrice: 240,
        description:
            'دواء مضاد للحساسية يستخدم حسب توصيات الطبيب أو الصيدلي.',
        details:
            'النوع: أقراص\n'
            'الاستخدام: أعراض الحساسية\n'
            'يستخدم وفق الجرعة الموصى بها.',
      ),

      Product(
        id: '23',
        name: 'نيوروفين أقراص',
        price: 17,
        image:
            'https://placehold.co/800x800/D62828/FFFFFF/png?text=Neurofen',
        category: 'أدوية',
        stock: 28,
        rating: 4.6,
        reviewsCount: 47,
        pointsPrice: 170,
        description:
            'مسكن للألم يستخدم وفق الإرشادات الطبية والنشرة الداخلية.',
        details:
            'النوع: أقراص\n'
            'الاستخدام: تسكين الألم\n'
            'لا تتجاوز الجرعة الموصى بها.',
      ),

      // =========================================================
      // الفيتامينات
      // =========================================================

      Product(
        id: '2',
        name: 'فيتامين د 1000 وحدة',
        price: 38,
        oldPrice: 45,
        image:
            'https://placehold.co/800x800/F4A261/FFFFFF/png?text=Vitamin+D',
        category: 'الفيتامينات',
        stock: 35,
        rating: 4.8,
        reviewsCount: 92,
        pointsPrice: 380,
        description:
            'مكمل غذائي يحتوي على فيتامين د للاستخدام ضمن نظام غذائي متوازن.',
        details:
            'النوع: مكمل غذائي\n'
            'المحتوى: فيتامين د\n'
            'الاستخدام: حسب الجرعة الموضحة على العبوة.',
      ),

      Product(
        id: '5',
        name: 'أوميغا 3',
        price: 32,
        oldPrice: 39,
        image:
            'https://placehold.co/800x800/F4A261/FFFFFF/png?text=Omega+3',
        category: 'الفيتامينات',
        stock: 29,
        rating: 4.8,
        reviewsCount: 113,
        pointsPrice: 320,
        description:
            'مكمل غذائي يحتوي على أحماض أوميغا 3 الدهنية.',
        details:
            'النوع: كبسولات\n'
            'المحتوى: أوميغا 3\n'
            'طريقة الاستخدام: حسب التعليمات الموجودة على العبوة.',
      ),

      Product(
        id: '24',
        name: 'فيتامين سي فوار',
        price: 29,
        oldPrice: 38,
        image:
            'https://placehold.co/800x800/F4A261/FFFFFF/png?text=Vitamin+C',
        category: 'الفيتامينات',
        stock: 30,
        rating: 4.7,
        reviewsCount: 86,
        pointsPrice: 290,
        description:
            'أقراص فوارة تحتوي على فيتامين سي.',
        details:
            'النوع: أقراص فوارة\n'
            'المحتوى: فيتامين سي\n'
            'تذاب في الماء حسب التعليمات.',
      ),

      Product(
        id: '25',
        name: 'زنك + فيتامين سي',
        price: 34,
        oldPrice: 42,
        image:
            'https://placehold.co/800x800/F4A261/FFFFFF/png?text=Zinc+C',
        category: 'الفيتامينات',
        stock: 22,
        rating: 4.6,
        reviewsCount: 58,
        pointsPrice: 340,
        description:
            'مكمل غذائي يجمع بين الزنك وفيتامين سي.',
        details:
            'النوع: مكمل غذائي\n'
            'المحتوى: زنك + فيتامين سي\n'
            'يستخدم حسب الإرشادات الموجودة على العبوة.',
      ),

      Product(
        id: '26',
        name: 'ملتي فيتامين يومي',
        price: 55,
        oldPrice: 70,
        image:
            'https://placehold.co/800x800/F4A261/FFFFFF/png?text=Multivitamin',
        category: 'الفيتامينات',
        stock: 15,
        rating: 4.8,
        reviewsCount: 97,
        pointsPrice: 550,
        description:
            'مكمل غذائي متعدد الفيتامينات للاستخدام اليومي.',
        details:
            'النوع: ملتي فيتامين\n'
            'الاستخدام: حسب الجرعة الموضحة على العبوة.',
      ),

      Product(
        id: '27',
        name: 'بيوتين للشعر والأظافر',
        price: 48,
        image:
            'https://placehold.co/800x800/F4A261/FFFFFF/png?text=Biotin',
        category: 'الفيتامينات',
        stock: 19,
        rating: 4.7,
        reviewsCount: 76,
        pointsPrice: 480,
        description:
            'مكمل غذائي يحتوي على البيوتين.',
        details:
            'النوع: مكمل غذائي\n'
            'المحتوى: بيوتين\n'
            'يستخدم حسب الجرعة الموجودة على العبوة.',
      ),

      // =========================================================
      // عناية بالبشرة
      // =========================================================

      Product(
        id: '3',
        name: 'كريم مرطب',
        price: 62,
        oldPrice: 78,
        image:
            'https://placehold.co/800x800/2A9D8F/FFFFFF/png?text=Cream',
        category: 'عناية بالبشرة',
        stock: 20,
        rating: 4.8,
        reviewsCount: 124,
        pointsPrice: 620,
        description:
            'كريم مرطب للاستخدام اليومي يساعد على ترطيب البشرة.',
        details:
            'الفئة: العناية بالبشرة\n'
            'الاستخدام: يومي\n'
            'مناسب للاستخدام حسب نوع البشرة.',
      ),

      Product(
        id: '7',
        name: 'غسول للوجه',
        price: 28,
        oldPrice: 35,
        image:
            'https://placehold.co/800x800/2A9D8F/FFFFFF/png?text=Face+Wash',
        category: 'عناية بالبشرة',
        stock: 27,
        rating: 4.7,
        reviewsCount: 88,
        pointsPrice: 280,
        description:
            'غسول للوجه للاستخدام اليومي وتنظيف البشرة.',
        details:
            'الفئة: العناية بالبشرة\n'
            'الاستخدام: تنظيف الوجه\n'
            'يستخدم حسب تعليمات المنتج.',
      ),

      Product(
        id: '28',
        name: 'واقي شمس SPF 50',
        price: 55,
        oldPrice: 69,
        image:
            'https://placehold.co/800x800/2A9D8F/FFFFFF/png?text=Sunscreen',
        category: 'عناية بالبشرة',
        stock: 24,
        rating: 4.9,
        reviewsCount: 143,
        pointsPrice: 550,
        description:
            'واقي شمس بمعامل حماية SPF 50 للاستخدام اليومي.',
        details:
            'الفئة: العناية بالبشرة\n'
            'معامل الحماية: SPF 50\n'
            'يستخدم حسب تعليمات الشركة المصنعة.',
      ),

      Product(
        id: '29',
        name: 'سيروم فيتامين سي',
        price: 89,
        oldPrice: 115,
        image:
            'https://placehold.co/800x800/2A9D8F/FFFFFF/png?text=Serum',
        category: 'عناية بالبشرة',
        stock: 12,
        rating: 4.8,
        reviewsCount: 119,
        pointsPrice: 890,
        description:
            'سيروم للعناية بالبشرة يحتوي على فيتامين سي.',
        details:
            'الفئة: العناية بالبشرة\n'
            'المحتوى: فيتامين سي\n'
            'يستخدم وفق تعليمات المنتج.',
      ),

      Product(
        id: '30',
        name: 'تونر منظف للبشرة',
        price: 42,
        image:
            'https://placehold.co/800x800/2A9D8F/FFFFFF/png?text=Toner',
        category: 'عناية بالبشرة',
        stock: 17,
        rating: 4.6,
        reviewsCount: 64,
        pointsPrice: 420,
        description:
            'تونر للعناية اليومية وتنظيف البشرة.',
        details:
            'الفئة: العناية بالبشرة\n'
            'الاستخدام: تنظيف البشرة\n'
            'يستخدم حسب تعليمات المنتج.',
      ),

      // =========================================================
      // الأم والطفل
      // =========================================================

      Product(
        id: '8',
        name: 'حليب أطفال',
        price: 72,
        oldPrice: 85,
        image:
            'https://placehold.co/800x800/8ECAE6/FFFFFF/png?text=Baby+Milk',
        category: 'الأم والطفل',
        stock: 18,
        rating: 4.8,
        reviewsCount: 91,
        pointsPrice: 720,
        description:
            'حليب أطفال للاستخدام حسب العمر والإرشادات الموجودة على العبوة.',
        details:
            'الفئة: الأم والطفل\n'
            'طريقة التحضير: حسب التعليمات الموجودة على العبوة\n'
            'العمر: حسب المنتج.',
      ),

      Product(
        id: '9',
        name: 'مناديل مبللة للأطفال',
        price: 12,
        oldPrice: 15,
        image:
            'https://placehold.co/800x800/8ECAE6/FFFFFF/png?text=Baby+Wipes',
        category: 'الأم والطفل',
        stock: 45,
        rating: 4.7,
        reviewsCount: 73,
        pointsPrice: 120,
        description:
            'مناديل مبللة للاستخدام اليومي للأطفال.',
        details:
            'الفئة: الأم والطفل\n'
            'الاستخدام: العناية اليومية\n'
            'تستخدم حسب إرشادات المنتج.',
      ),

      Product(
        id: '31',
        name: 'حفاضات أطفال مقاس 4',
        price: 65,
        oldPrice: 82,
        image:
            'https://placehold.co/800x800/8ECAE6/FFFFFF/png?text=Diapers',
        category: 'الأم والطفل',
        stock: 26,
        rating: 4.8,
        reviewsCount: 108,
        pointsPrice: 650,
        description:
            'حفاضات أطفال بمقاس 4 للاستخدام اليومي.',
        details:
            'الفئة: الأم والطفل\n'
            'المقاس: 4\n'
            'العدد: حسب العبوة.',
      ),

      Product(
        id: '32',
        name: 'كريم للطفح الجلدي',
        price: 22,
        oldPrice: 28,
        image:
            'https://placehold.co/800x800/8ECAE6/FFFFFF/png?text=Rash+Cream',
        category: 'الأم والطفل',
        stock: 19,
        rating: 4.7,
        reviewsCount: 67,
        pointsPrice: 220,
        description:
            'كريم مخصص للعناية ببشرة الأطفال.',
        details:
            'الفئة: الأم والطفل\n'
            'الاستخدام: حسب تعليمات المنتج\n'
            'للاستخدام الخارجي.',
      ),

      Product(
        id: '33',
        name: 'شامبو أطفال لطيف',
        price: 26,
        image:
            'https://placehold.co/800x800/8ECAE6/FFFFFF/png?text=Baby+Shampoo',
        category: 'الأم والطفل',
        stock: 23,
        rating: 4.7,
        reviewsCount: 61,
        pointsPrice: 260,
        description:
            'شامبو لطيف مخصص للعناية بشعر الأطفال.',
        details:
            'الفئة: الأم والطفل\n'
            'الاستخدام: تنظيف الشعر\n'
            'يستخدم حسب إرشادات المنتج.',
      ),

      // =========================================================
      // أجهزة طبية
      // =========================================================

      Product(
        id: '10',
        name: 'جهاز قياس الضغط',
        price: 129,
        oldPrice: 149,
        image:
            'https://placehold.co/800x800/6C757D/FFFFFF/png?text=BP+Monitor',
        category: 'اجهزة طبية',
        stock: 10,
        rating: 4.8,
        reviewsCount: 156,
        pointsPrice: 1290,
        description:
            'جهاز إلكتروني لقياس ضغط الدم للاستخدام المنزلي.',
        details:
            'الفئة: أجهزة طبية\n'
            'الاستخدام: قياس ضغط الدم\n'
            'يرجى اتباع تعليمات التشغيل المرفقة.',
      ),

      Product(
        id: '11',
        name: 'ترمومتر رقمي',
        price: 35,
        oldPrice: 45,
        image:
            'https://placehold.co/800x800/6C757D/FFFFFF/png?text=Thermometer',
        category: 'اجهزة طبية',
        stock: 25,
        rating: 4.7,
        reviewsCount: 82,
        pointsPrice: 350,
        description:
            'ميزان حرارة رقمي للاستخدام المنزلي.',
        details:
            'الفئة: أجهزة طبية\n'
            'النوع: رقمي\n'
            'طريقة الاستخدام: حسب دليل المنتج.',
      ),

      Product(
        id: '34',
        name: 'جهاز قياس السكر',
        price: 95,
        oldPrice: 120,
        image:
            'https://placehold.co/800x800/6C757D/FFFFFF/png?text=Glucose+Meter',
        category: 'اجهزة طبية',
        stock: 14,
        rating: 4.8,
        reviewsCount: 132,
        pointsPrice: 950,
        description:
            'جهاز لقياس مستوى سكر الدم للاستخدام المنزلي.',
        details:
            'الفئة: أجهزة طبية\n'
            'الاستخدام: قياس سكر الدم\n'
            'استخدم الجهاز حسب دليل الشركة المصنعة.',
      ),

      Product(
        id: '35',
        name: 'جهاز تبخير للأطفال',
        price: 110,
        oldPrice: 140,
        image:
            'https://placehold.co/800x800/6C757D/FFFFFF/png?text=Nebulizer',
        category: 'اجهزة طبية',
        stock: 8,
        rating: 4.7,
        reviewsCount: 54,
        pointsPrice: 1100,
        description:
            'جهاز تبخير للاستخدام حسب توجيهات الطبيب وتعليمات الجهاز.',
        details:
            'الفئة: أجهزة طبية\n'
            'الاستخدام: التبخير\n'
            'يرجى قراءة دليل الاستخدام.',
      ),

      // =========================================================
      // عناية بالشعر
      // =========================================================

      Product(
        id: '12',
        name: 'شامبو للشعر',
        price: 34,
        oldPrice: 42,
        image:
            'https://placehold.co/800x800/9B5DE5/FFFFFF/png?text=Shampoo',
        category: 'عناية بالشعر',
        stock: 31,
        rating: 4.6,
        reviewsCount: 77,
        pointsPrice: 340,
        description:
            'شامبو للعناية اليومية بالشعر.',
        details:
            'الفئة: العناية بالشعر\n'
            'الاستخدام: تنظيف الشعر\n'
            'يستخدم حسب تعليمات العبوة.',
      ),

      Product(
        id: '13',
        name: 'زيت للشعر',
        price: 22,
        oldPrice: 28,
        image:
            'https://placehold.co/800x800/9B5DE5/FFFFFF/png?text=Hair+Oil',
        category: 'عناية بالشعر',
        stock: 24,
        rating: 4.6,
        reviewsCount: 62,
        pointsPrice: 220,
        description:
            'زيت للعناية بالشعر.',
        details:
            'الفئة: العناية بالشعر\n'
            'الاستخدام: حسب تعليمات المنتج.',
      ),

      Product(
        id: '36',
        name: 'سيروم لتساقط الشعر',
        price: 78,
        oldPrice: 95,
        image:
            'https://placehold.co/800x800/9B5DE5/FFFFFF/png?text=Hair+Serum',
        category: 'عناية بالشعر',
        stock: 14,
        rating: 4.7,
        reviewsCount: 93,
        pointsPrice: 780,
        description:
            'سيروم مخصص للعناية بالشعر.',
        details:
            'الفئة: العناية بالشعر\n'
            'الاستخدام: حسب تعليمات المنتج.',
      ),

      Product(
        id: '37',
        name: 'بلسم مرطب للشعر',
        price: 30,
        image:
            'https://placehold.co/800x800/9B5DE5/FFFFFF/png?text=Conditioner',
        category: 'عناية بالشعر',
        stock: 21,
        rating: 4.6,
        reviewsCount: 48,
        pointsPrice: 300,
        description:
            'بلسم لترطيب والعناية بالشعر.',
        details:
            'الفئة: العناية بالشعر\n'
            'الاستخدام: بعد غسل الشعر.',
      ),

      // =========================================================
      // العطور
      // =========================================================

      Product(
        id: '14',
        name: 'عطر نسائي',
        price: 95,
        oldPrice: 120,
        image:
            'https://placehold.co/800x800/D291BC/FFFFFF/png?text=Perfume',
        category: 'العطور',
        stock: 12,
        rating: 4.8,
        reviewsCount: 85,
        pointsPrice: 950,
        description:
            'عطر نسائي برائحة مميزة للاستخدام اليومي والمناسبات.',
        details:
            'الفئة: العطور\n'
            'النوع: عطر نسائي\n'
            'الحجم: حسب العبوة.',
      ),

      Product(
        id: '38',
        name: 'عطر رجالي',
        price: 105,
        oldPrice: 135,
        image:
            'https://placehold.co/800x800/D291BC/FFFFFF/png?text=Men+Perfume',
        category: 'العطور',
        stock: 10,
        rating: 4.8,
        reviewsCount: 79,
        pointsPrice: 1050,
        description:
            'عطر رجالي مناسب للاستخدام اليومي والمناسبات.',
        details:
            'الفئة: العطور\n'
            'النوع: عطر رجالي\n'
            'الحجم: حسب العبوة.',
      ),

      Product(
        id: '39',
        name: 'مزيل عرق سبراي',
        price: 18,
        oldPrice: 24,
        image:
            'https://placehold.co/800x800/D291BC/FFFFFF/png?text=Deodorant',
        category: 'العطور',
        stock: 35,
        rating: 4.6,
        reviewsCount: 52,
        pointsPrice: 180,
        description:
            'مزيل عرق للاستخدام اليومي.',
        details:
            'الفئة: العطور والعناية الشخصية\n'
            'النوع: سبراي\n'
            'للاستخدام الخارجي.',
      ),

      // =========================================================
      // عناية باليدين
      // =========================================================

      Product(
        id: '15',
        name: 'كريم مرطب لليدين',
        price: 19,
        oldPrice: 25,
        image:
            'https://placehold.co/800x800/FFB4A2/FFFFFF/png?text=Hand+Cream',
        category: 'عناية باليدين',
        stock: 30,
        rating: 4.7,
        reviewsCount: 66,
        pointsPrice: 190,
        description:
            'كريم مرطب للعناية اليومية باليدين.',
        details:
            'الفئة: العناية باليدين\n'
            'الاستخدام: يومي\n'
            'للاستخدام الخارجي.',
      ),

      Product(
        id: '40',
        name: 'معقم يدين 500 مل',
        price: 16,
        oldPrice: 22,
        image:
            'https://placehold.co/800x800/FFB4A2/FFFFFF/png?text=Hand+Sanitizer',
        category: 'عناية باليدين',
        stock: 50,
        rating: 4.7,
        reviewsCount: 91,
        pointsPrice: 160,
        description:
            'معقم يدين للاستخدام اليومي.',
        details:
            'الفئة: العناية باليدين\n'
            'الحجم: 500 مل\n'
            'للاستخدام الخارجي.',
      ),

      // =========================================================
      // الجمال
      // =========================================================

      Product(
        id: '16',
        name: 'كريم أساس',
        price: 52,
        oldPrice: 65,
        image:
            'https://placehold.co/800x800/E5989B/FFFFFF/png?text=Foundation',
        category: 'الجمال',
        stock: 16,
        rating: 4.6,
        reviewsCount: 59,
        pointsPrice: 520,
        description:
            'كريم أساس للعناية بمظهر البشرة وتوحيد مظهرها.',
        details:
            'الفئة: الجمال\n'
            'النوع: كريم أساس\n'
            'الدرجة: حسب المنتج المختار.',
      ),

      Product(
        id: '41',
        name: 'أحمر شفاه',
        price: 35,
        oldPrice: 45,
        image:
            'https://placehold.co/800x800/E5989B/FFFFFF/png?text=Lipstick',
        category: 'الجمال',
        stock: 22,
        rating: 4.7,
        reviewsCount: 71,
        pointsPrice: 350,
        description:
            'أحمر شفاه للاستخدام اليومي والمناسبات.',
        details:
            'الفئة: الجمال\n'
            'النوع: أحمر شفاه\n'
            'اللون: حسب المنتج المختار.',
      ),

      Product(
        id: '42',
        name: 'ماسكارا',
        price: 40,
        image:
            'https://placehold.co/800x800/E5989B/FFFFFF/png?text=Mascara',
        category: 'الجمال',
        stock: 18,
        rating: 4.6,
        reviewsCount: 44,
        pointsPrice: 400,
        description:
            'ماسكارا للاستخدام اليومي.',
        details:
            'الفئة: الجمال\n'
            'النوع: ماسكارا.',
      ),

      // =========================================================
      // العناية بالمنزل
      // =========================================================

      Product(
        id: '17',
        name: 'معقم أسطح',
        price: 16,
        oldPrice: 20,
        image:
            'https://placehold.co/800x800/52B788/FFFFFF/png?text=Disinfectant',
        category: 'العناية بالمنزل',
        stock: 34,
        rating: 4.6,
        reviewsCount: 39,
        pointsPrice: 160,
        description:
            'منتج لتعقيم الأسطح وفق تعليمات الاستخدام.',
        details:
            'الفئة: العناية بالمنزل\n'
            'الاستخدام: الأسطح\n'
            'يستخدم حسب تعليمات العبوة.',
      ),

      Product(
        id: '43',
        name: 'مناديل معقمة',
        price: 10,
        oldPrice: 14,
        image:
            'https://placehold.co/800x800/52B788/FFFFFF/png?text=Wet+Wipes',
        category: 'العناية بالمنزل',
        stock: 42,
        rating: 4.5,
        reviewsCount: 33,
        pointsPrice: 100,
        description:
            'مناديل للاستخدام في تنظيف وتعقيم الأسطح.',
        details:
            'الفئة: العناية بالمنزل\n'
            'الاستخدام: حسب تعليمات المنتج.',
      ),

      // =========================================================
      // العناية اليومية
      // =========================================================

      Product(
        id: '18',
        name: 'معجون أسنان',
        price: 11,
        oldPrice: 14,
        image:
            'https://placehold.co/800x800/76C893/FFFFFF/png?text=Toothpaste',
        category: 'العناية اليومية',
        stock: 55,
        rating: 4.7,
        reviewsCount: 118,
        pointsPrice: 110,
        description:
            'معجون أسنان للعناية اليومية بصحة الفم والأسنان.',
        details:
            'الفئة: العناية اليومية\n'
            'الاستخدام: تنظيف الأسنان\n'
            'يستخدم حسب تعليمات المنتج.',
      ),

      Product(
        id: '44',
        name: 'فرشاة أسنان كهربائية',
        price: 68,
        oldPrice: 89,
        image:
            'https://placehold.co/800x800/76C893/FFFFFF/png?text=Toothbrush',
        category: 'العناية اليومية',
        stock: 9,
        rating: 4.8,
        reviewsCount: 73,
        pointsPrice: 680,
        description:
            'فرشاة أسنان كهربائية للعناية اليومية بالفم.',
        details:
            'الفئة: العناية اليومية\n'
            'النوع: فرشاة كهربائية\n'
            'تستخدم حسب دليل الجهاز.',
      ),

      Product(
        id: '45',
        name: 'غسول فم مطهر',
        price: 20,
        oldPrice: 26,
        image:
            'https://placehold.co/800x800/76C893/FFFFFF/png?text=Mouthwash',
        category: 'العناية اليومية',
        stock: 27,
        rating: 4.6,
        reviewsCount: 62,
        pointsPrice: 200,
        description:
            'غسول فم للاستخدام اليومي حسب تعليمات المنتج.',
        details:
            'الفئة: العناية اليومية\n'
            'الاستخدام: العناية بالفم\n'
            'لا يبتلع.',
      ),

      // =========================================================
      // العناية الصحية
      // =========================================================

      Product(
        id: '48',
        name: 'مطهر لليدين',
        price: 12,
        image:
            'https://placehold.co/800x800/52B788/FFFFFF/png?text=Sanitizer',
        category: 'العناية الصحية',
        stock: 60,
        rating: 4.7,
        reviewsCount: 85,
        pointsPrice: 120,
        description:
            'مطهر لليدين للاستخدام اليومي.',
        details:
            'الفئة: العناية الصحية\n'
            'الاستخدام: اليدين\n'
            'للاستخدام الخارجي.',
      ),

      Product(
        id: '49',
        name: 'كمامات طبية (50 قطعة)',
        price: 25,
        image:
            'https://placehold.co/800x800/76C893/FFFFFF/png?text=Masks',
        category: 'العناية الصحية',
        stock: 100,
        rating: 4.7,
        reviewsCount: 94,
        pointsPrice: 250,
        description:
            'كمامات للاستخدام اليومي.',
        details:
            'الفئة: العناية الصحية\n'
            'العدد: 50 قطعة\n'
            'تستخدم حسب الحاجة.',
      ),

      // =========================================================
      // التغذية الرياضية
      // =========================================================

      Product(
        id: '19',
        name: 'بروتين واي',
        price: 145,
        oldPrice: 175,
        image:
            'https://placehold.co/800x800/495057/FFFFFF/png?text=Whey+Protein',
        category: 'التغذية الرياضية',
        stock: 8,
        rating: 4.8,
        reviewsCount: 102,
        pointsPrice: 1450,
        description:
            'مكمل غذائي من بروتين مصل الحليب.',
        details:
            'الفئة: التغذية الرياضية\n'
            'النوع: Whey Protein\n'
            'طريقة الاستخدام: حسب تعليمات المنتج.',
      ),

      Product(
        id: '46',
        name: 'كرياتين مونوهيدرات',
        price: 85,
        oldPrice: 105,
        image:
            'https://placehold.co/800x800/495057/FFFFFF/png?text=Creatine',
        category: 'التغذية الرياضية',
        stock: 10,
        rating: 4.8,
        reviewsCount: 87,
        pointsPrice: 850,
        description:
            'مكمل غذائي يحتوي على الكرياتين مونوهيدرات.',
        details:
            'الفئة: التغذية الرياضية\n'
            'النوع: Creatine Monohydrate\n'
            'يستخدم حسب تعليمات المنتج.',
      ),

      Product(
        id: '47',
        name: 'BCAA أحماض أمينية',
        price: 95,
        oldPrice: 120,
        image:
            'https://placehold.co/800x800/495057/FFFFFF/png?text=BCAA',
        category: 'التغذية الرياضية',
        stock: 7,
        rating: 4.7,
        reviewsCount: 56,
        pointsPrice: 950,
        description:
            'مكمل غذائي يحتوي على أحماض أمينية متفرعة السلسلة.',
        details:
            'الفئة: التغذية الرياضية\n'
            'النوع: BCAA\n'
            'يستخدم حسب تعليمات المنتج.',
      ),
    ];
  }
}