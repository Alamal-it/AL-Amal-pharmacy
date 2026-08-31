import 'package:flutter/foundation.dart';
import 'cart_service.dart';

enum OrderStatus { processing, onTheWay, delivered, cancelled }

class Order {
  final String orderNumber;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime date;
  final bool isPickup;
  OrderStatus status;

  Order({
    required this.orderNumber,
    required this.items,
    required this.totalAmount,
    required this.date,
    required this.isPickup,
    this.status = OrderStatus.processing,
  });
}

class OrderService extends ChangeNotifier {
  OrderService._internal();
  static final OrderService instance = OrderService._internal();

  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders.reversed);

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }
}