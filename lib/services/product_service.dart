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
        image: '',
        category: 'مضادات حيوية',
      ),
      Product(
        id: '2',
        name: 'فيتامين د 1000 وحدة',
        price: 45,
        image: '',
        category: 'فيتامينات',
      ),
      Product(
        id: '3',
        name: 'كريم مرطب',
        price: 62,
        oldPrice: 78,
        image: '',
        category: 'عناية بالبشرة',
      ),
      Product(
        id: '4',
        name: 'باندول',
        price: 18,
        image: '',
        category: 'مسكنات',
      ),
    ];
  }
}