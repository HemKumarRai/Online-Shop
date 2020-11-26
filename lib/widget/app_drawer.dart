import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_shop/helper/custom_rooute.dart';
import 'package:online_shop/modal/auth_provider.dart';
import 'package:online_shop/view/auth_screen.dart';
import 'package:online_shop/view/orderscreen.dart';
import 'package:online_shop/view/product_grid_overview.dart';
import 'package:online_shop/view/user_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String email = "";
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      getUserData();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  void getUserData() async {
    final preferences = await SharedPreferences.getInstance();
    final extractedData =
        json.decode(preferences.getString('userData')) as Map<String, Object>;
    setState(() {
      email = extractedData['email'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Hem'),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Shop'),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, ProductGridOverView.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
//              Navigator.pushReplacementNamed(context, OrderScreen.routName);
              Navigator.of(context).pushReplacement(
                  CustomRoute(builder: (context) => OrderScreen()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, UserProductScreen.routName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log Out'),
            onTap: () async {
              Navigator.of(context).pop();
              await Provider.of<Auth>(context, listen: false).logOut();

              Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}
