import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final double price;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.imageUrl,
      @required this.price,
      @required this.description,
      this.isFavourite = false});

  Future<void> toggleIsFavourite(String userId, String _authToken) async {
    final oldState = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        "https://online-shop-99264.firebaseio.com/userFavourites/$userId/$id.json?auth=$_authToken";
    try {
      final response = await http.put(url, body: json.encode(isFavourite));
      if (response.statusCode >= 400) {
        isFavourite = oldState;
        notifyListeners();
      }
    } catch (e) {
      isFavourite = oldState;

      notifyListeners();
    }
  }
}
