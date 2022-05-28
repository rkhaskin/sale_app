import 'dart:convert';
import 'package:flutter/material.dart';
import './cart_provider.dart' show CartItem;
import 'package:http/http.dart' as http;

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
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = Uri.https(
        'flutter-sales-app-default-rtdb.firebaseio.com', '/orders.json');
    final orders = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = jsonDecode(orders.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, data) {
      loadedOrders.add(OrderItem(
        orderId: orderId,
        orderDateTime: DateTime.parse(data['dateTime']),
        total: data['amount'],
        // convert to list, then map over instances
        orderList: (data['products'] as List<dynamic>).map((cartItem) {
          // create CartItem
          CartItem ci = CartItem(
              id: cartItem['id'],
              title: cartItem['title'],
              price: double.parse((cartItem['price']).toStringAsFixed(2)),
              quantity: cartItem['quantity']);
          return ci;
        }).toList(), // from Iterable to List
      ));
    });
    // sort in descending order
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartItems, double total) async {
    final timestamp = DateTime.now();
    final url = Uri.https(
        'flutter-sales-app-default-rtdb.firebaseio.com', '/orders.json');
    final response = await http.post(url,
        body: jsonEncode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartItems
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity,
                  })
              .toList(),
        }));

    OrderItem orderItem = OrderItem(
        orderId: DateTime.now().toString(),
        orderDateTime: timestamp,
        total: total,
        orderList: cartItems);

    _orders.add(orderItem);
    notifyListeners();
  }
}
