import 'package:flutter/material.dart';
import './cart_provider.dart' show CartItem;

class OrderItem {
  final String orderId;
  final DateTime orderDateTime;
  final double total;
  final List<CartItem> orderList;

  OrderItem({
    required this.orderId,
    required this.orderDateTime,
    required this.total,
    required this.orderList,
  });
}

class Orders with ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartItems, double total) {
    OrderItem orderItem = OrderItem(
        orderId: DateTime.now().toString(),
        orderDateTime: DateTime.now(),
        total: total,
        orderList: cartItems);

    _orders.add(orderItem);
    notifyListeners();
  }
}
