import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/helper/custom_rooute.dart';
import 'package:online_shop/modal/cart_providers.dart';
import 'package:online_shop/modal/order.dart';
import 'package:online_shop/modal/products_provider.dart';
import 'package:online_shop/view/auth_screen.dart';

import 'package:online_shop/view/cart%20screen.dart';
import 'package:online_shop/view/edit_product_screen.dart';
import 'package:online_shop/view/orderscreen.dart';
import 'package:online_shop/view/product_detail.dart';
import 'package:online_shop/view/product_grid_overview.dart';
import 'package:online_shop/view/user_product_screen.dart';
import 'package:provider/provider.dart';

import 'modal/auth_provider.dart';

void main() => runApp(SplashClass());

class SplashClass extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
              update: (_, Auth auth, Products previousProduct) {
            return Products(
                auth.token,
                previousProduct == null ? [] : previousProduct.items,
                auth.userId);
          }),
          ChangeNotifierProvider(
            create: (_) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (_, Auth auth, Orders previousOrder) {
              return Orders(auth.token,
                  previousOrder == null ? [] : previousOrder.orders);
            },
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primaryColor: Colors.blueGrey,
              accentColor: Colors.red,
              fontFamily: "Lato",
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              })),
          home: SplashBetween(),

//          auth.isAuth ? ProductGridOverView() : AuthScreen(),
          routes: {
            AuthScreen.routeName: (context) => AuthScreen(),
            ProductGridOverView.routeName: (context) => ProductGridOverView(),
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartRoomScreen.routeName: (context) => CartRoomScreen(),
            OrderScreen.routName: (context) => OrderScreen(),
            UserProductScreen.routName: (context) => UserProductScreen(),
            EditProductScreen.routName: (context) => EditProductScreen(),
          },
          debugShowCheckedModeBanner: false,
        ));
  }
}

class SplashBetween extends StatefulWidget {
  @override
  _SplashBetweenState createState() => _SplashBetweenState();
}

class _SplashBetweenState extends State<SplashBetween> {
  bool _isInit = true;
  bool isLoggedIn = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      checkLogIn();
    }
    _isInit = false;
  }

  void checkLogIn() async {
    isLoggedIn = await Provider.of<Auth>(context).autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen.navigate(
          alignment: Alignment.center,
          name: 'assets/images/splash.flr',
          backgroundColor: Colors.blueGrey,
          startAnimation: 'Untitled',
          loopAnimation: 'Untitled',
          until: () => Future.delayed(Duration(seconds: 3)),
          next: (_) => AuthScreen()),
    );
  }
}
