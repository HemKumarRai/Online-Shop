import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/modal/cart_providers.dart' show Cart;
import 'package:online_shop/modal/order.dart';
import 'package:online_shop/widget/cart_item.dart';
import 'package:provider/provider.dart';

class CartRoomScreen extends StatelessWidget {
  static const String routeName = "/cart_screen";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Cart"),
        ),
        body: Column(children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$${cart.totalAmount}",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(
                    cart: cart,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
//        Expanded(
//            child: ListView.builder(
//
////                itemCount: cart.itemCount,
////                itemBuilder: (context, i) => CartItem(
////                  id: cart.items.values.toList()[i].id,
////                  title: cart.items.values.toList()[i].title,
////                  productId: cart.items.keys.toList()[i],
////                  price: cart.items.values.toList()[i].price,
////                  quantity: cart.items.values.toList()[i].quantity,
//                )),
          Expanded(
            child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, i) => CartItem(
                      id: cart.items.values.toList()[i].id,
                      price: cart.items.values.toList()[i].price,
                      title: cart.items.values.toList()[i].title,
                      productId: cart.items.keys.toList()[i],
                      quantity: cart.items.values.toList()[i].quantity,
                    )),
          )
        ]));
  }
}

class OrderButton extends StatefulWidget {
  final cart;
  OrderButton({this.cart});
  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Orders>(context, listen: false);

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : FlatButton(
            child: Text(
              "ORDER NOW",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).primaryColor),
            ),
            onPressed: widget.cart.totalAmount <= 0
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await order.addOrder(widget.cart.items.values.toList(),
                        widget.cart.totalAmount);
                    widget.cart.clearCart();
                    setState(() {
                      _isLoading = false;
                    });
                  },
          );
  }
}
