import 'package:flutter/material.dart';
import 'package:online_shop/modal/products_provider.dart';
import 'package:online_shop/view/product_detail.dart';
import 'package:provider/provider.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return themeData;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    final searchItem =
        Provider.of<Products>(context, listen: false).getSearchItem(query);
    return ListView.builder(
        itemCount: searchItem.length,
        itemBuilder: (context, index) => Column(
              children: <Widget>[
                ListTile(
                  title: Text(searchItem[index].title),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(searchItem[index].imageUrl),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, ProductDetailScreen.routeName,
                        arguments: searchItem[index].id);
                  },
                ),
                Divider(),
              ],
            ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text('Search Product Items'),
        )
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchItem = Provider.of<Products>(context).getSearchItem(query);
    return query.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text('Search Product Items'),
              )
            ],
          )
        : ListView.builder(
            itemCount: searchItem.length,
            itemBuilder: (context, index) => ListView.builder(
                itemCount: searchItem.length,
                itemBuilder: (context, index) => Column(
                      children: <Widget>[
                        ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ProductDetailScreen.routeName,
                                arguments: searchItem[index].id);
                          },
                          title: Text(searchItem[index].title),
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(searchItem[index].imageUrl),
                          ),
                        ),
                        Divider(),
                      ],
                    )));
  }
}
