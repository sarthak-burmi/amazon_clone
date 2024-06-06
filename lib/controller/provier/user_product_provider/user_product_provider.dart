import 'package:amazon_clone/controller/services/user_product_services/user_product_services.dart';
import 'package:amazon_clone/model/product_model.dart';
import 'package:flutter/material.dart';

class UsersProductProvider extends ChangeNotifier {
  List<ProductModel> searchedProduct = [];
  bool productFetched = false;

  emptySearchedProductsList() {
    searchedProduct = [];
    productFetched = false;
    notifyListeners();
  }

  getSearchedProducts({required String productName}) async {
    searchedProduct = await UsersProductService.getProducts(
      productName,
    );
    productFetched = true;
    notifyListeners();
  }
}
