import 'package:flutter/material.dart';
import 'package:online_shop/modal/products_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = "/product_detail";
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final selectedProduct =
        Provider.of<Products>(context, listen: false).findById(id);
    return Scaffold(
//      appBar: AppBar(
//        title: Text(selectedProduct.title),
//      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(selectedProduct.title),
              background: Hero(
                child: Container(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    selectedProduct.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                tag: 'product$id',
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 15.0,
              ),
              Text(
                '\$${selectedProduct.price}',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                selectedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(
                height: 500.0,
              ),
            ]),
          )
        ],
      ),
    );
  }
}
