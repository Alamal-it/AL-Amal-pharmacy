import '../models/product.dart';

class ProductService {
  // TODO: استبدال هذا بـ GET /products من الـ API لما يجهزه المدير.
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return const [
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
        price: 18,
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
        id: '2',
        name: 'فيتامين د 1000 وحدة',
        price: 45,
        image: 'https://placehold.co/400x400/F4A261/FFFFFF/png?text=Vitamin+D',
        category: 'الفيتامينات',
      ),
      Product(
        id: '5',
        name: 'أوميغا 3',
        price: 39,
        image: 'https://placehold.co/400x400/F4A261/FFFFFF/png?text=Omega+3',
        category: 'الفيتامينات',
      ),
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
        price: 35,
        image: 'https://placehold.co/400x400/2A9D8F/FFFFFF/png?text=Face+Wash',
        category: 'عناية بالبشرة',
      ),
      Product(
        id: '8',
        name: 'حليب أطفال',
        price: 85,
        image: 'https://placehold.co/400x400/8ECAE6/FFFFFF/png?text=Baby+Milk',
        category: 'الأم والطفل',
      ),
      Product(
        id: '9',
        name: 'مناديل مبللة للأطفال',
        price: 15,
        image: 'https://placehold.co/400x400/8ECAE6/FFFFFF/png?text=Baby+Wipes',
        category: 'الأم والطفل',
      ),
      Product(
        id: '10',
        name: 'جهاز قياس الضغط',
        price: 149,
        image: 'https://placehold.co/400x400/6C757D/FFFFFF/png?text=BP+Monitor',
        category: 'اجهزة طبية',
      ),
      Product(
        id: '11',
        name: 'ترمومتر رقمي',
        price: 45,
        image: 'https://placehold.co/400x400/6C757D/FFFFFF/png?text=Thermometer',
        category: 'اجهزة طبية',
      ),
      Product(
        id: '12',
        name: 'شامبو للشعر',
        price: 42,
        image: 'https://placehold.co/400x400/9B5DE5/FFFFFF/png?text=Shampoo',
        category: 'عناية بالشعر',
      ),
      Product(
        id: '13',
        name: 'زيت للشعر',
        price: 28,
        image: 'https://placehold.co/400x400/9B5DE5/FFFFFF/png?text=Hair+Oil',
        category: 'عناية بالشعر',
      ),
      Product(
        id: '14',
        name: 'عطر نسائي',
        price: 120,
        image: 'https://placehold.co/400x400/D291BC/FFFFFF/png?text=Perfume',
        category: 'العطور',
      ),
      Product(
        id: '15',
        name: 'كريم مرطب لليدين',
        price: 25,
        image: 'https://placehold.co/400x400/FFB4A2/FFFFFF/png?text=Hand+Cream',
        category: 'عناية باليدين',
      ),
      Product(
        id: '16',
        name: 'كريم أساس',
        price: 65,
        image: 'https://placehold.co/400x400/E5989B/FFFFFF/png?text=Foundation',
        category: 'الجمال',
      ),
      Product(
        id: '17',
        name: 'معقم أسطح',
        price: 20,
        image: 'https://placehold.co/400x400/52B788/FFFFFF/png?text=Disinfectant',
        category: 'العناية بالمنزل',
      ),
      Product(
        id: '18',
        name: 'معجون أسنان',
        price: 14,
        image: 'https://placehold.co/400x400/76C893/FFFFFF/png?text=Toothpaste',
        category: 'العناية اليومية',
      ),
      Product(
        id: '19',
        name: 'بروتين واي',
        price: 175,
        image: 'https://placehold.co/400x400/495057/FFFFFF/png?text=Whey+Protein',
        category: 'التغذية الرياضية',
      ),
    ];
  }
}