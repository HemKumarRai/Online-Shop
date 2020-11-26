import 'package:flutter/material.dart';
import 'package:online_shop/modal/auth_provider.dart';
import 'package:online_shop/modal/cart_providers.dart';
import 'package:online_shop/modal/product.dart';
import 'package:online_shop/view/product_detail.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  Widget build(BuildContext context) {
    final loadedProduct = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return Container(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: GridTile(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, ProductDetailScreen.routeName,
                    arguments: loadedProduct.id);
              },
              child: Hero(
                tag: 'product${loadedProduct.id}',
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/loading.jpg'),
                  image: NetworkImage(
                    loadedProduct.imageUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black,
              title: Text(
                loadedProduct.title,
              ),
              leading: Consumer<Product>(
                builder: (_, product, child) {
                  return IconButton(
                    icon: Icon(
                      product.isFavourite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () {
                      product.toggleIsFavourite(
                        auth.userId,
                        auth.token,
                      );
                    },
                  );
                },
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  cart.addToCart(loadedProduct.id, loadedProduct.title,
                      loadedProduct.price);
                  Scaffold.of(context).removeCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    content: Text("Added item to the cart"),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: "Undo",
                      textColor: Colors.black,
                      onPressed: () {
                        cart.removeSingleItem(loadedProduct.id);
                      },
                    ),
                  ));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
