import 'package:flutter/material.dart';
import 'package:online_shop/modal/products_provider.dart';
import 'package:online_shop/view/edit_product_screen.dart';
import 'package:online_shop/widget/app_drawer.dart';
import 'package:online_shop/widget/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const String routName = '/user_product_screen';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndShowProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productItem = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, EditProductScreen.routName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: productItem != null
          ? RefreshIndicator(
              onRefresh: () => _refreshProduct(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                //To Do
                child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: productItem.items.length,
                    itemBuilder: (context, index) => UserProductItem(
                          productItem.items[index].id,
                          productItem.items[index].title,
                          productItem.items[index].imageUrl,
                        )),
              ),
            )
          : Container(),
    );
  }
}
