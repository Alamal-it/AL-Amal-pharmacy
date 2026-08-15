class Product {
  final String id;
  final String name;
  final double price;
  final double? oldPrice;
  final String image;
  final String category;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.oldPrice,
    required this.image,
    required this.category,
    this.stock = 10,
  });

  int? get discountPercent {
    if (oldPrice == null || oldPrice! <= price) return null;
    return (((oldPrice! - price) / oldPrice!) * 100).round();
  }
}