import 'package:flutter/material.dart';
import 'package:king_frontend/providers/auth_provider.dart';
import 'package:king_frontend/providers/product_provider.dart';
import 'package:king_frontend/providers/wishlist_provider.dart';
import 'package:king_frontend/screens/cart_screen.dart';
import 'package:king_frontend/screens/checkout_screen.dart';
import 'package:king_frontend/screens/checkout_succes.dart';
import 'package:king_frontend/screens/detail_chat_screen.dart';
import 'package:king_frontend/screens/detail_product_screen.dart';
import 'package:king_frontend/screens/edit_profile_screen.dart';
import 'package:king_frontend/screens/home/main_screen.dart';
import 'package:king_frontend/screens/sign_in_screen.dart';
import 'package:king_frontend/screens/sign_up_screen.dart';
import 'package:king_frontend/screens/splash_screen.dart';
import 'package:provider/provider.dart';

//ext.kotlin_version = '1.6.10' sebelumnya 1.3.50
//gradle-7.4-all.zip sebelumnya 6.7.4-bin

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WishlistProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => SplashScreen(),
          '/sign-in': (context) => SigninScreen(),
          '/sign-up': (context) => SignupScreen(),
          '/home': (context) => MainScreen(),
          '/chat': (context) => DetailChatScreen(),
          '/edit-profile': (context) => EditProfileScreen(),
          '/cart': (context) => CartScreen(),
          '/checkout': (context) => CheckoutScreen(),
          '/checkout-success': (context) => CheckoutSuccess(),
        },
      ),
    );
  }
}
