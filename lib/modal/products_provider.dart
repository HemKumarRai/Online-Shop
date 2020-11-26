import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:online_shop/exception/http_exception.dart';
import 'package:online_shop/modal/product.dart';

class Products with ChangeNotifier {
  final String _authToken;
  final String _userId;

  List<Product> _items = [
//    Product(
//        id: "first",
//        title: "Watch",
//        price: 2000,
//        description: "The best watch you will find anywhere.",
//        imageUrl:
//            "https://www.surfstitch.com/on/demandware.static/-/Sites-ss-master-catalog/default/dwef31ef54/images/MBB-M43BLK/BLACK-WOMENS-ACCESSORIES-ROSEFIELD-WATCHES-MBB-M43BLK_1.JPG",
//        isFavourite: false),
//    Product(
//        id: "second",
//        title: "Shoes",
//        price: 1500,
//        description: "Quality and comfort shoes with fashionable style.",
//        imageUrl:
//            "https://assets.adidas.com/images/w_600,f_auto,q_auto:sensitive,fl_lossy/e06ae7c7b4d14a16acb3a999005a8b6a_9366/Lite_Racer_RBN_Shoes_White_F36653_01_standard.jpg",
//        isFavourite: false),
//    Product(
//        id: "third",
//        title: "Laptop",
//        price: 80000,
//        description: "The compact and powerful gaming laptop under the budget.",
//        imageUrl:
//            "https://d4kkpd69xt9l7.cloudfront.net/sys-master/images/h57/hdd/9010331451422/razer-blade-pro-hero-mobile.jpg",
//        isFavourite: false),
//    Product(
//        id: "four",
//        title: "T-Shirt",
//        price: 1000,
//        description: "A red color tshirt you can wear at any occassion.",
//        imageUrl:
//            "https://5.imimg.com/data5/LM/NA/MY-49778818/mens-round-neck-t-shirt-500x500.jpg",
//        isFavourite: false),
  ];

  Products(this._authToken, this._items, this._userId);

  // ---- this returns all items of the product list ---------
  List<Product> get items {
    return [..._items];
  }

  //find the product using id;
//  Product findById(String id) {
//    return items.firstWhere((prod) =>
//      return prod.id == id;
//    );
//  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

//  Product findById(String id) {
//    return _items.firstWhere((product) => product.id == id);
//  }

  //showAllFavourite
//  List<Product> get favourites {
//    return _items.where((prod) {
//      return prod.isFavourite;
//    }).toList();
//  }

  List<Product> get favourites {
    return _items.where((prod) {
      return prod.isFavourite;
    }).toList();
  }

//  void addProduct(Product product) {
//    final newProduct = Product(
//        id: DateTime.now().toString(),
//        title: product.title,
//        price: product.price,
//        description: product.description,
//        imageUrl: product.imageUrl);
//    _items.add(newProduct);
//    notifyListeners();
//  }

  Future<void> addProduct(Product product) async {
    final url =
        "https://online-shop-99264.firebaseio.com/product.json?auth=$_authToken";
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
          }));
//
//    print(json.decode(response.body)['name']);

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error.message);
      throw (error);
    }
  }

//function to update the current product
//  void updateProduct(String id, Product upProduct) {
//    final prodIndex = _items.indexWhere((prod) => prod.id == id);
//    if (prodIndex >= 0) {
//      _items[prodIndex] = upProduct;
//      notifyListeners();
//    }
//  }

  Future<void> updateProduct(String id, Product upProduct) async {
    try {
      final prodIndex = _items.indexWhere((prod) => prod.id == id);
      if (prodIndex >= 0) {
        final url =
            "https://online-shop-99264.firebaseio.com/product/$id.json?auth=$_authToken";
        await http.patch(url,
            body: json.encode({
              'title': upProduct.title,
              'description': upProduct.description,
              'imageUrl': upProduct.imageUrl,
              'price': upProduct.price,
            }));
        items[prodIndex] = upProduct;
        notifyListeners();
      }
    } catch (e) {
      print(e.message);
      throw (e);
    }
  }

  //function to delete the current product
  Future<void> deleteProduct(String id) async {
    final url =
        "https://online-shop-99264.firebaseio.com/product/$id.json?auth=$_authToken";

    final existingItemIndex = items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingItemIndex];
    _items.removeAt(existingItemIndex);
    notifyListeners();

    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        _items.insert(existingItemIndex, existingProduct);
        notifyListeners();
        throw HttpException('Couldnot delete Product');
      } else {
        existingProduct = null;
      }
    } catch (e) {
      _items.insert(existingItemIndex, existingProduct);
      notifyListeners();
      throw HttpException('Couldnot delete Product');
    }
  }

  //this function fetches the products from firebase

  Future<void> fetchAndShowProducts() async {
    //const==constant

    final url =
        "https://online-shop-99264.firebaseio.com/product.json?auth=$_authToken";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final favouriteResponse = await http.get(
          "https://online-shop-99264.firebaseio.com/userFavourites/$_userId.json?auth=$_authToken");
      final favouriteData = json.decode(favouriteResponse.body);
      final List<Product> loadedProduct = [];
      extractedData.forEach((prodId, prodData) {
        return loadedProduct.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: double.parse(prodData['price'].toString()),
            isFavourite:
                favouriteData == null ? false : favouriteData[prodId] ?? false,
            imageUrl: prodData['imageUrl']));
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (e) {}
  }

  //getSearchList

  List<Product> getSearchItem(String query) {
    if (query.isNotEmpty && query != null) {
      notifyListeners();
      return _items
          .where((prod) =>
              prod.title.toLowerCase().toUpperCase().startsWith(query))
          .toList();
    }
    notifyListeners();
    return [];
  }
}
