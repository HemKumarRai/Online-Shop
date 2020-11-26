import 'package:flutter/material.dart';
import 'package:online_shop/modal/order.dart' show Orders;
import 'package:online_shop/widget/app_drawer.dart';
import 'package:online_shop/widget/order_Item.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const routName = "/order_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Order"),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAndSetOrder(),
            builder: (context, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapshot.hasError) {
                  return Center(
                    child:
                        Text("Error Occured Something went wrong :Try Agaiin!"),
                  );
                } else {
                  return Consumer<Orders>(
                      builder: (context, orderData, child) => ListView.builder(
                          itemCount: orderData.orders.length,
                          itemBuilder: (context, index) =>
                              OrderItem(orderData.orders[index])));
                }
              }
            }));
  }
}
