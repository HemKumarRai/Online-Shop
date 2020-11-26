import 'package:flutter/material.dart';
import 'package:online_shop/modal/cart_providers.dart';
import 'package:online_shop/modal/products_provider.dart';
import 'package:online_shop/view/cart%20screen.dart';
import 'package:online_shop/widget/app_drawer.dart';
import 'package:online_shop/widget/badge.dart';
import 'package:online_shop/widget/custom_search_delegate.dart';
import 'package:online_shop/widget/product%20Grid.dart';
import 'package:provider/provider.dart';

enum showFilters { Favourite, All }

class ProductGridOverView extends StatefulWidget {
  static const String routeName = "/product_overview";
  @override
  _ProductGridOverViewState createState() => _ProductGridOverViewState();
}

class _ProductGridOverViewState extends State<ProductGridOverView> {
  bool _showFavourite = false;
  bool _isInit = true;
  bool _isLoading = false;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndShowProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Online Shop"),
        leading: IconButton(
          icon: Icon(Icons.person_outline),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AppDrawer()));
          },
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (showFilters selectedItem) {
              setState(() {
                if (selectedItem == showFilters.Favourite) {
                  _showFavourite = true;
                } else {
                  _showFavourite = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: showFilters.Favourite,
                child: Text("Show Favourites"),
              ),
              PopupMenuItem(
                value: showFilters.All,
                child: Text("Show All"),
              )
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, child) {
              return Badge(
                child: child,
                value: cart.getItemCount().toString(),
              );
            },
            child: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartRoomScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFavourite),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSearch(context: context, delegate: CustomSearchDelegate());
        },
        child: Icon(
          Icons.search,
        ),
      ),
    );
  }
}
