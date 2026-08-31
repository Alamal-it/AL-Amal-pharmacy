import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../services/order_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderService orderService = OrderService.instance;

  @override
  void initState() {
    super.initState();
    orderService.addListener(_onChanged);
  }@override
  void dispose() {
    orderService.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return 'قيد التجهيز';
      case OrderStatus.onTheWay:
        return 'في الطريق';
      case OrderStatus.delivered:
        return 'تم التسليم';
      case OrderStatus.cancelled:
        return 'ملغي';
    }
  }Color _statusColor(OrderStatus status) { switch (status) { case OrderStatus.processing: return AppColors.primary; case OrderStatus.onTheWay: return Colors.orange; case OrderStatus.delivered: return AppColors.green; case OrderStatus.cancelled: return Colors.red; } }
@override Widget build(BuildContext context) { final orders = orderService.orders;
return Scaffold(
  backgroundColor: AppColors.white,
  appBar: AppBar(
    backgroundColor: AppColors.white,
    elevation: 0,
    iconTheme: const IconThemeData(color: AppColors.primaryDark),
    centerTitle: true,
    title: const Text(
      'طلباتي',
      style: TextStyle(
        color: AppColors.primaryDark,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
    ),
  ),
  body: orders.isEmpty
      ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration:BoxDecoration(
                      color: AppColors.border.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.receipt_long_outlined,
                        size: 40, color: AppColors.textGray),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'لا توجد طلبات سابقة',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'طلباتك ستظهر هنا بعد أول عملية شراء',
                    style: TextStyle(color: AppColors.textGray, fontSize: 12),
                  ),
                ],
              ),
            ): ListView.separated( padding: const EdgeInsets.all(16), itemCount: orders.length, separatorBuilder: (_, __) => const SizedBox(height: 12), itemBuilder: (context, index) { final order = orders[index];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusColor(order.status)
                              .withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _statusLabel(order.status),
                          style: TextStyle(
                            color: _statusColor(order.status),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        '#${order.orderNumber}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),const SizedBox(height: 10),
                      Text(
                        order.isPickup
                            ? 'استلام من الفرع'
                            : 'توصيل للمنزل',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textGray,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${order.items.length} منتج — ${order.totalAmount.toStringAsFixed(2)} ر.س',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDark,
                        ),
                      ),const SizedBox(height: 4), Text( '{order.date.day}/{order.date.month}/${order.date.year}', style: const TextStyle( fontSize: 11, color: AppColors.textGray, ), ), ], ), ); }, ), ); } }