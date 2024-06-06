import 'package:amazon_clone/controller/provier/address_provier.dart';
import 'package:amazon_clone/controller/provier/auth_provier/auth_provier.dart';
import 'package:amazon_clone/controller/provier/deal_of_day_provider/deal_of_day_provider.dart';
import 'package:amazon_clone/controller/provier/product_by_category_provider/product_by_category_provider.dart';
import 'package:amazon_clone/controller/provier/rating_provider/rating_provider.dart';
import 'package:amazon_clone/controller/provier/user_product_provider/user_product_provider.dart';
import 'package:amazon_clone/utils/theme.dart';
import 'package:amazon_clone/view/auth_screen/signIn_logic.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/provier/product_provier/product_provider.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Amazon());
}

class Amazon extends StatelessWidget {
  const Amazon({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<AddressProvider>(
            create: (_) => AddressProvider()),
        ChangeNotifierProvider<SellerProductProvider>(
            create: (_) => SellerProductProvider()),
        ChangeNotifierProvider<UsersProductProvider>(
            create: (_) => UsersProductProvider()),
        ChangeNotifierProvider<DealOfTheDayProvider>(
            create: (_) => DealOfTheDayProvider()),
        ChangeNotifierProvider<ProductsBasedOnCategoryProvider>(
            create: (_) => ProductsBasedOnCategoryProvider()),
        ChangeNotifierProvider<RatingProvider>(create: (_) => RatingProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SignInLogic(),
        //home: SellerBottomNavBar(),
        theme: theme,
      ),
    );
  }
}
