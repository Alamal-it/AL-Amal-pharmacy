import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/product.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;

  int? get discountPercent {
    final p = widget.product;
    if (p.oldPrice == null || p.oldPrice! <= p.price) return null;
    return (((p.oldPrice! - p.price) / p.oldPrice!) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ===== شريط علوي: رجوع + مفضلة =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_forward,
                        color: AppColors.primaryDark),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: إضافة/إزالة من المفضلة لما تجهز.
                    },
                    icon: const Icon(Icons.favorite_border,
                        color: AppColors.primaryDark),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== صورة المنتج =====
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 260,
                          color: AppColors.border.withOpacity(0.2),
                          child: product.image.isEmpty
                              ? const Icon(Icons.image_outlined,
                                  size: 60, color: AppColors.textGray)
                              : Image.network(
                                  product.image,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(
                                      Icons.image_not_supported,
                                      size: 60,
                                      color: AppColors.textGray),
                                ),
                        ),
                        if (discountPercent != null)
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '-$discountPercent%',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [// ===== الفئة =====
                          Text(
                            product.category,
                            style: const TextStyle(
                              color: AppColors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // ===== اسم المنتج =====
                          Text(
                            product.name,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // ===== السعر =====
                          Row(
                            children: [
                              Text(
                                '${product.price} ر.س',
                                style: const TextStyle(
                                  color: AppColors.primaryDark,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (product.oldPrice != null) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '${product.oldPrice} ر.س',
                                  style: const TextStyle(
                                    color: AppColors.textGray,
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ],
                          ),

                          const SizedBox(height: 16),
                          const Divider(color: AppColors.border),
                          const SizedBox(height: 16),

                          // ===== الوصف (نص مؤقت لين يوصل من الـ API) =====
                          const Text(
                            'الوصف',
                            style: TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'سيتم إضافة وصف تفصيلي لهذا المنتج قريباً.',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: AppColors.textGray,
                              fontSize: 12.5,
                              height: 1.6,
                            ),
                          ),

                          const SizedBox(height: 20),
                          const Divider(color: AppColors.border),
                          const SizedBox(height: 16),

                          // ===== الكمية =====
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'الكمية',
                                style: TextStyle(
                                  color: AppColors.primaryDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Row(
                                children: [
                                  _QtyButton(
                                    icon: Icons.remove,
                                    onTap: () {
                                      if (quantity > 1) {
                                        setState(() => quantity--);
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    child: Text(
                                      '$quantity',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                                  ),
                                  _QtyButton(
                                    icon: Icons.add,
                                    onTap: () {
                                      setState(() => quantity++);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ===== زر أضيفي للسلة =====
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: ربط بمنطق سلة التسوق لما تجهز.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('تمت إضافة $quantity × ${product.name} للسلة'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined,
                      color: Colors.white),
                  label: const Text(
                    'أضيفي للسلة',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: AppColors.primaryDark),
      ),
    );
  }
}