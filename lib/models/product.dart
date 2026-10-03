class Product {
  final String id;
  final String name;
  final double price;
  final double? oldPrice;
  final String image;
  final String category;
  final int stock;

  // تفاصيل إضافية للمنتج
  final String description;
  final String details;
  final double rating;
  final int reviewsCount;

  // عدد النقاط المطلوبة للحصول على المنتج
  final int pointsPrice;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.oldPrice,
    required this.image,
    required this.category,
    this.stock = 10,
    this.description = '',
    this.details = '',
    this.rating = 4.5,
    this.reviewsCount = 0,
    this.pointsPrice = 250,
  });

  int? get discountPercent {
    if (oldPrice == null || oldPrice! <= price) {
      return null;
    }

    return (((oldPrice! - price) / oldPrice!) * 100).round();
  }

  bool get hasDiscount {
    return oldPrice != null && oldPrice! > price;
  }

  bool get isAvailable {
    return stock > 0;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: _toDouble(json['price']),
      oldPrice: json['oldPrice'] == null
          ? null
          : _toDouble(json['oldPrice']),
      image: json['image']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      stock: _toInt(json['stock'], defaultValue: 10),
      description: json['description']?.toString() ?? '',
      details: json['details']?.toString() ?? '',
      rating: _toDouble(
        json['rating'],
        defaultValue: 4.5,
      ),
      reviewsCount: _toInt(
        json['reviewsCount'],
        defaultValue: 0,
      ),
      pointsPrice: _toInt(
        json['pointsPrice'],
        defaultValue: 250,
      ),
    );
  }

  static double _toDouble(
    dynamic value, {
    double defaultValue = 0,
  }) {
    if (value == null) {
      return defaultValue;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? defaultValue;
  }

  static int _toInt(
    dynamic value, {
    int defaultValue = 0,
  }) {
    if (value == null) {
      return defaultValue;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString()) ?? defaultValue;
  }
}