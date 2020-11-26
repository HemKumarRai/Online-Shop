import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:online_shop/modal/cart_providers.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  final String _authToken;
  List<OrderItem> _orders = [];
  Orders(this._authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  //add item from cart to order
  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url =
        "https://online-shop-99264.firebaseio.com/orders.json?auth=$_authToken";
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': DateTime.now().toIso8601String(),
            'products': cartProduct
                .map((cp) => {
                      'id': cp.id,
                      'quantity': cp.quantity,
                      'price': cp.price,
                      'title': cp.title,
                    })
                .toList(),
          }));
      _orders.insert(
          0,
          OrderItem(
              id: DateTime.now().toString(),
              amount: total,
              products: cartProduct,
              dateTime: DateTime.now()));
    } catch (e) {
      throw (e);
    }

//
  }
  //fetching Orders from the DataBase

  Future<void> fetchAndSetOrder() async {
    final url =
        "https://online-shop-99264.firebaseio.com/orders.json?auth=$_authToken";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> _loadedOrder = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((orderId, orderData) {
        _loadedOrder.add(OrderItem(
            id: orderId,
            amount: double.parse(orderData['amount'].toString()),
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                      id: item['id'],
                      price: double.parse(item['price'].toString()),
                      quantity: item['quantity'],
                      title: item['title'],
                    ))
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime'])));
      });

      _orders = _loadedOrder;
      notifyListeners();
    } catch (e) {}
  }
}
