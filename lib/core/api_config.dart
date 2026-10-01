class ApiConfig {
  // TODO: استبدلي هذا برابط السيرفر الحقيقي لما يجهزه هاني.
  // مثال: 'https://api.pharmacy-alamal.com/api'
  static const String baseUrl = 'https://REPLACE_ME.example.com/api';

  // ===== مسارات المنتجات والفئات =====
  static String get products => '$baseUrl/products';
  static String get categories => '$baseUrl/categories';

  // ===== مسارات العناوين والفروع =====
  static String get addresses => '$baseUrl/addresses';
  static String get branches => '$baseUrl/branches';

  // ===== مسارات السلة والطلبات =====
  static String get cart => '$baseUrl/cart';
  static String get orders => '$baseUrl/orders';

  // ===== مهلة الاتصال =====
  static const Duration timeout = Duration(seconds: 15);
}