import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrder() async {
    final url =
        Uri.https('myshop-93017-default-rtdb.firebaseio.com', 'orders.json');
    try {
      final res = await http.get(url);

      if (!res.body.contains('null')) {
        final extractedData = jsonDecode(res.body) as Map<String, dynamic>;
        final List<OrderItem> loadedOrders = [];
        extractedData.forEach((orderId, orderData) {
          loadedOrders.add(
            OrderItem(
              id: orderId,
              amount: orderData['amount'],
              products: (orderData['products'] as List<dynamic>)
                  .map((item) => CartItem(
                      id: item['id'],
                      title: item['title'],
                      quantity: item['quantity'],
                      price: item['price']))
                  .toList(),
              dateTime: DateTime.parse(orderData['dateTime']),
            ),
          );
        });
        _orders = loadedOrders;
        notifyListeners();
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    if (cartProducts.isNotEmpty) {
      final timestamp = DateTime.now();
      final url =
          Uri.https('myshop-93017-default-rtdb.firebaseio.com', 'orders.json');

      try {
        final res = await http.post(url,
            body: jsonEncode({
              'amount': total,
              'dateTime': timestamp.toIso8601String(),
              'products': cartProducts
                  .map((e) => {
                        'id': e.id,
                        'title': e.title,
                        'quantity': e.quantity,
                        'price': e.price,
                      })
                  .toList(),
            }));
        _orders.insert(
          0,
          OrderItem(
            id: jsonDecode(res.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: timestamp,
          ),
        );
        notifyListeners();
      } catch (err) {
        rethrow;
      }
    }
  }
}
