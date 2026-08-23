import '../models/product.dart';

class ProductService {
  // TODO: استبدال هذا بـ GET /products من الـ API لما يجهزه المدير.
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return const [
      // ===== أدوية =====
      Product(
        id: '1',
        name: 'أوجمنتين 1 غم',
        price: 52,
        oldPrice: 65,
        image: 'https://placehold.co/400x400/123B72/FFFFFF/png?text=Augmentin',
        category: 'أدوية',
      ),
      Product(
        id: '4',
        name: 'باندول',
        price: 15,
        oldPrice: 18,
        image: 'https://placehold.co/400x400/E63946/FFFFFF/png?text=Panadol',
        category: 'أدوية',
      ),
      Product(
        id: '6',
        name: 'بنادول اكسترا',
        price: 22,
        image: 'https://placehold.co/400x400/E63946/FFFFFF/png?text=Panadol+Extra',
        category: 'أدوية',
      ),
      Product(
        id: '20',
        name: 'فولتارين جل',
        price: 28,
        oldPrice: 36,
        image: 'https://placehold.co/400x400/D62828/FFFFFF/png?text=Voltaren',
        category: 'أدوية',
      ),
      Product(
        id: '21',
        name: 'كونجستال',
        price: 19,
        oldPrice: 24,
        image: 'https://placehold.co/400x400/D62828/FFFFFF/png?text=Congestal',
        category: 'أدوية',
      ),
      Product(
        id: '22',
        name: 'زيرتك أقراص',
        price: 24,
        oldPrice: 30,
        image: 'https://placehold.co/400x400/D62828/FFFFFF/png?text=Zyrtec',
        category: 'أدوية',
      ),
      Product(
        id: '23',
        name: 'نيوروفين أقراص',
        price: 17,
        image: 'https://placehold.co/400x400/D62828/FFFFFF/png?text=Neurofen',
        category: 'أدوية',
      ),

      // ===== الفيتامينات =====
      Product(
        id: '2',
        name: 'فيتامين د 1000 وحدة',
        price: 38,
        oldPrice: 45,
        image: 'https://placehold.co/400x400/F4A261/FFFFFF/png?text=Vitamin+D',
        category: 'الفيتامينات',
      ),
      Product(
        id: '5',
        name: 'أوميغا 3',
        price: 32,
        oldPrice: 39,
        image: 'https://placehold.co/400x400/F4A261/FFFFFF/png?text=Omega+3',
        category: 'الفيتامينات',
      ),
      Product(
        id: '24',
        name: 'فيتامين سي فوار',
        price: 29,
        oldPrice: 38,
        image: 'https://placehold.co/400x400/F4A261/FFFFFF/png?text=Vitamin+C',
        category: 'الفيتامينات',
      ),
      Product(
        id: '25',
        name: 'زنك + فيتامين سي',
        price: 34,
        oldPrice: 42,
        image: 'https://placehold.co/400x400/F4A261/FFFFFF/png?text=Zinc+C',
        category: 'الفيتامينات',
      ),
      Product(
        id: '26',
        name: 'ملتي فيتامين يومي',
        price: 55,
        oldPrice: 70,
        image: 'https://placehold.co/400x400/F4A261/FFFFFF/png?text=Multivitamin',
        category: 'الفيتامينات',
      ),
      Product(
        id: '27',
        name: 'بيوتين للشعر والأظافر',
        price: 48,
        image: 'https://placehold.co/400x400/F4A261/FFFFFF/png?text=Biotin',
        category: 'الفيتامينات',
      ),

      // ===== عناية بالبشرة =====
      Product(
        id: '3',
        name: 'كريم مرطب',
        price: 62,
        oldPrice: 78,
        image: 'https://placehold.co/400x400/2A9D8F/FFFFFF/png?text=Cream',
        category: 'عناية بالبشرة',
      ),
      Product(
        id: '7',
        name: 'غسول للوجه',
        price: 28,
        oldPrice: 35,
        image: 'https://placehold.co/400x400/2A9D8F/FFFFFF/png?text=Face+Wash',
        category: 'عناية بالبشرة',
      ),
      Product(
        id: '28',
        name: 'واقي شمس SPF 50',
        price: 55,
        oldPrice: 69,
        image: 'https://placehold.co/400x400/2A9D8F/FFFFFF/png?text=Sunscreen',
        category: 'عناية بالبشرة',
      ),
      Product(
        id: '29',
        name: 'سيروم فيتامين سي',
        price: 89,
        oldPrice: 115,
        image: 'https://placehold.co/400x400/2A9D8F/FFFFFF/png?text=Serum',
        category: 'عناية بالبشرة',
      ),
      Product(
        id: '30',
        name: 'تونر منظف للبشرة',
        price: 42,
        image: 'https://placehold.co/400x400/2A9D8F/FFFFFF/png?text=Toner',
        category: 'عناية بالبشرة',
      ),

      // ===== الأم والطفل =====
      Product(
        id: '8',
        name: 'حليب أطفال',
        price: 72,
        oldPrice: 85,
        image: 'https://placehold.co/400x400/8ECAE6/FFFFFF/png?text=Baby+Milk',
        category: 'الأم والطفل',
      ),
      Product(
        id: '9',
        name: 'مناديل مبللة للأطفال',
        price: 12,
        oldPrice: 15,
        image: 'https://placehold.co/400x400/8ECAE6/FFFFFF/png?text=Baby+Wipes',
        category: 'الأم والطفل',
      ),
      Product(
        id: '31',
        name: 'حفاضات أطفال مقاس 4',
        price: 65,
        oldPrice: 82,
        image: 'https://placehold.co/400x400/8ECAE6/FFFFFF/png?text=Diapers',
        category: 'الأم والطفل',
      ),
      Product(
        id: '32',
        name: 'كريم للطفح الجلدي',
        price: 22,
        oldPrice: 28,
        image: 'https://placehold.co/400x400/8ECAE6/FFFFFF/png?text=Rash+Cream',
        category: 'الأم والطفل',
      ),
      Product(
        id: '33',
        name: 'شامبو أطفال لطيف',
        price: 26,
        image: 'https://placehold.co/400x400/8ECAE6/FFFFFF/png?text=Baby+Shampoo',
        category: 'الأم والطفل',
      ),

      // ===== أجهزة طبية =====
      Product(
        id: '10',
        name: 'جهاز قياس الضغط',
        price: 129,
        oldPrice: 149,
        image: 'https://placehold.co/400x400/6C757D/FFFFFF/png?text=BP+Monitor',
        category: 'اجهزة طبية',
      ),
      Product(
        id: '11',
        name: 'ترمومتر رقمي',
        price: 35,
        oldPrice: 45,
        image: 'https://placehold.co/400x400/6C757D/FFFFFF/png?text=Thermometer',
        category: 'اجهزة طبية',
      ),
      Product(
        id: '34',
        name: 'جهاز قياس السكر',
        price: 95,
        oldPrice: 120,
        image: 'https://placehold.co/400x400/6C757D/FFFFFF/png?text=Glucose+Meter',
        category: 'اجهزة طبية',
      ),
      Product(
        id: '35',
        name: 'جهاز تبخير للأطفال',
        price: 110,
        oldPrice: 140,
        image: 'https://placehold.co/400x400/6C757D/FFFFFF/png?text=Nebulizer',
        category: 'اجهزة طبية',
      ),

      // ===== عناية بالشعر =====
      Product(
        id: '12',
        name: 'شامبو للشعر',
        price: 34,
        oldPrice: 42,
        image: 'https://placehold.co/400x400/9B5DE5/FFFFFF/png?text=Shampoo',
        category: 'عناية بالشعر',
      ),
      Product(
        id: '13',
        name: 'زيت للشعر',
        price: 22,
        oldPrice: 28,
        image: 'https://placehold.co/400x400/9B5DE5/FFFFFF/png?text=Hair+Oil',
        category: 'عناية بالشعر',
      ),
      Product(
        id: '36',
        name: 'سيروم لتساقط الشعر',
        price: 78,
        oldPrice: 95,
        image: 'https://placehold.co/400x400/9B5DE5/FFFFFF/png?text=Hair+Serum',
        category: 'عناية بالشعر',
      ),
      Product(
        id: '37',
        name: 'بلسم مرطب للشعر',
        price: 30,
        image: 'https://placehold.co/400x400/9B5DE5/FFFFFF/png?text=Conditioner',
        category: 'عناية بالشعر',
      ),

      // ===== العطور =====
      Product(
        id: '14',
        name: 'عطر نسائي',
        price: 95,
        oldPrice: 120,
        image: 'https://placehold.co/400x400/D291BC/FFFFFF/png?text=Perfume',
        category: 'العطور',
      ),
      Product(
        id: '38',
        name: 'عطر رجالي',
        price: 105,
        oldPrice: 135,
        image: 'https://placehold.co/400x400/D291BC/FFFFFF/png?text=Men+Perfume',
        category: 'العطور',
      ),
      Product(
        id: '39',
        name: 'مزيل عرق سبراي',
        price: 18,
        oldPrice: 24,
        image: 'https://placehold.co/400x400/D291BC/FFFFFF/png?text=Deodorant',
        category: 'العطور',
      ),

      // ===== عناية باليدين =====
      Product(
        id: '15',
        name: 'كريم مرطب لليدين',
        price: 19,
        oldPrice: 25,
        image: 'https://placehold.co/400x400/FFB4A2/FFFFFF/png?text=Hand+Cream',
        category: 'عناية باليدين',
      ),
      Product(
        id: '40',
        name: 'معقم يدين 500 مل',
        price: 16,
        oldPrice: 22,
        image: 'https://placehold.co/400x400/FFB4A2/FFFFFF/png?text=Hand+Sanitizer',
        category: 'عناية باليدين',
      ),

      // ===== الجمال =====
      Product(
        id: '16',
        name: 'كريم أساس',
        price: 52,
        oldPrice: 65,
        image: 'https://placehold.co/400x400/E5989B/FFFFFF/png?text=Foundation',
        category: 'الجمال',
      ),
      Product(
        id: '41',
        name: 'أحمر شفاه',
        price: 35,
        oldPrice: 45,
        image: 'https://placehold.co/400x400/E5989B/FFFFFF/png?text=Lipstick',
        category: 'الجمال',
      ),
      Product(
        id: '42',
        name: 'ماسكارا',
        price: 40,
        image: 'https://placehold.co/400x400/E5989B/FFFFFF/png?text=Mascara',
        category: 'الجمال',
      ),

      // ===== العناية بالمنزل =====
      Product(
        id: '17',
        name: 'معقم أسطح',
        price: 16,
        oldPrice: 20,
        image: 'https://placehold.co/400x400/52B788/FFFFFF/png?text=Disinfectant',
        category: 'العناية بالمنزل',
      ),
      Product(
        id: '43',
        name: 'مناديل معقمة',
        price: 10,
        oldPrice: 14,
        image: 'https://placehold.co/400x400/52B788/FFFFFF/png?text=Wet+Wipes',
        category: 'العناية بالمنزل',
      ),

      // ===== العناية اليومية =====
      Product(
        id: '18',
        name: 'معجون أسنان',
        price: 11,
        oldPrice: 14,
        image: 'https://placehold.co/400x400/76C893/FFFFFF/png?text=Toothpaste',
        category: 'العناية اليومية',
      ),
      Product(
        id: '44',
        name: 'فرشاة أسنان كهربائية',
        price: 68,
        oldPrice: 89,
        image: 'https://placehold.co/400x400/76C893/FFFFFF/png?text=Toothbrush',
        category: 'العناية اليومية',
      ),
      Product(
        id: '45',
        name: 'غسول فم مطهر',
        price: 20,
        oldPrice: 26,
        image: 'https://placehold.co/400x400/76C893/FFFFFF/png?text=Mouthwash',
        category: 'العناية اليومية',
      ),

      // ===== التغذية الرياضية =====
      Product(
        id: '19',
        name: 'بروتين واي',
        price: 145,
        oldPrice: 175,
        image: 'https://placehold.co/400x400/495057/FFFFFF/png?text=Whey+Protein',
        category: 'التغذية الرياضية',
      ),
      Product(
        id: '46',
        name: 'كرياتين مونوهيدرات',
        price: 85,
        oldPrice: 105,
        image: 'https://placehold.co/400x400/495057/FFFFFF/png?text=Creatine',
        category: 'التغذية الرياضية',
      ),
      Product(
        id: '47',
        name: 'BCAA أحماض أمينية',
        price: 95,
        oldPrice: 120,
        image: 'https://placehold.co/400x400/495057/FFFFFF/png?text=BCAA',
        category: 'التغذية الرياضية',




        
      ),
    ];
  }
}