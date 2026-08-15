import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: product.image.isEmpty
                        ? const Icon(
                            Icons.medication_outlined,
                            color: AppColors.primary,
                            size: 36,
                          )
                        : Image.network(
                            product.image,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.medication_outlined,
                              color: AppColors.primary,
                              size: 36,
                            ),
                          ),
                  ),
                ),
                if (product.discountPercent != null)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'خصم ${product.discountPercent}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '${product.price.toStringAsFixed(0)} ر.س',
                  style: const TextStyle(
                    color: AppColors.green,
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (product.oldPrice != null) ...[
                  const SizedBox(width: 5),
                  Text(
                    '${product.oldPrice!.toStringAsFixed(0)} ر.س',
                    style: const TextStyle(
                      color: AppColors.textGray,
                      fontSize: 10,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(width: double.infinity,
              height: 30,
              child: OutlinedButton.icon(
                onPressed: onAddToCart,
                icon: const Icon(Icons.add_shopping_cart, size: 14),
                label: const Text(
                  'أضف للسلة',
                  style: TextStyle(fontSize: 10.5),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}