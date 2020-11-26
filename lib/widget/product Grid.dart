import 'package:flutter/cupertino.dart';
import 'package:online_shop/modal/products_provider.dart';
import 'package:online_shop/widget/product_item.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool isFavourite;
  ProductGrid(this.isFavourite);
  @override
  Widget build(BuildContext context) {
    var products = isFavourite
        ? Provider.of<Products>(context).favourites
        : Provider.of<Products>(context).items;
    return GridView.builder(
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3 / 2),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(),
      ),
    );
  }
}
