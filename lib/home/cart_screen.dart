import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../services/cart_service.dart';
import '../services/user_service.dart';
import '../widgets/delivery_option_sheet.dart';
import 'guest_login_sheet.dart';
import 'branch_picker_screen.dart';
import 'payment_method_screen.dart';
import 'delivery_review_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService cart = CartService.instance;
  final TextEditingController couponController = TextEditingController();

  static const double taxRate = 0.15; // 15% ضريبة
  static const double deliveryFee = 15;

  @override
  void initState() {
    super.initState();
    cart.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    cart.removeListener(_onCartChanged);
    couponController.dispose();
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) setState(() {});
  }

  double get subtotal => cart.totalPrice;
  double get tax => subtotal * taxRate;
  double get total => subtotal + tax + deliveryFee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'السلة',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: cart.items.isEmpty ? _buildEmptyState() : _buildCartContent(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.border.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_cart_outlined,
                size: 40, color: AppColors.textGray),
          ),
          const SizedBox(height: 16),
          const Text(
            'سلتك فارغة',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'أضف منتجات لبدء التسوق',
            style: TextStyle(color: AppColors.textGray, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cart.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.product.image,
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 55,
                              height: 55,color: AppColors.border.withOpacity(0.3),
                              child: const Icon(Icons.image_outlined,
                                  color: AppColors.textGray),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                item.product.name,
                                textAlign: TextAlign.right,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item.product.price} ر.س',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textGray,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _qtyBtn(
                                    icon: Icons.remove,
                                    onTap: () => cart
                                        .decreaseQuantity(item.product.id),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  _qtyBtn(
                                    icon: Icons.add,
                                    onTap: () => cart
                                        .increaseQuantity(item.product.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: InkWell(
                      onTap: () => cart.removeFromCart(item.product.id),
                      child: const Icon(Icons.close,
                          size: 18, color: AppColors.textGray),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // ===== كود الخصم + ملخص السعر =====
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 12),decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: couponController,
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            hintText: 'أدخل كود الخصم',
                            hintStyle: TextStyle(
                                color: AppColors.textGray, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 42,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: ربط كود الخصم بالـ API لما يجهز.
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('تطبيق',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                _summaryRow('المجموع الفرعي', subtotal),
                const SizedBox(height: 6),
                _summaryRow('الضريبة (15%)', tax),
                const SizedBox(height: 6),
                _summaryRow('رسوم التوصيل', deliveryFee),
                const Divider(height: 20, color: AppColors.border),
                _summaryRow('الإجمالي', total, bold: true),

                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      // ===== بوابة تسجيل الضيف قبل إتمام الطلب =====
                      if (!UserService.instance.isLoggedIn) {
                        final loggedIn = await GuestLoginSheet.show(context);
                        if (loggedIn != true || !mounted) return;
                      }

                      final result = await DeliveryOptionSheet.show(context);
                      if (result == null || !mounted) return;

                      if (result.mode == DeliveryMode.pickup) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                BranchPickerScreen(totalAmount: total),
                          ),
                        );
                      } else {
                        if (result.address != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DeliveryReviewScreen(
                                address: result.address!,
                                totalAmount: total,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'إتمام الشراء',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, double value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: bold ? 14 : 12.5,
            fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
            color: bold ? AppColors.primaryDark : AppColors.textGray,
          ),
        ),
        Text(
          '${value.toStringAsFixed(2)} ر.س',
          style: TextStyle(
            fontSize: bold ? 15 : 12.5,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }

  Widget _qtyBtn({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 13, color: AppColors.primaryDark),
      ),
    );
  }
}