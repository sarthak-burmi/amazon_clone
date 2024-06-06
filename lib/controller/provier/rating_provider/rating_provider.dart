import 'dart:io';
import 'package:flutter/material.dart';

import '../../services/rating_services/rating_services.dart';

class RatingProvider extends ChangeNotifier {
  List<File> productImages = [];
  List<String> productImagesURL = [];
  bool productPurchased = false;
  bool userRatedTheProduct = false;
  fetchProductImagesFromGallery({required BuildContext context}) async {
    productImages = await RatingServices.getImages(context: context);
    notifyListeners();
  }

  updateProductImagesURL({required List<String> imageURLs}) async {
    productImagesURL = imageURLs;
    notifyListeners();
  }

  checkProductPurchase({required String productID}) async {
    productPurchased =
        await RatingServices.checkUserPurchasedTheProduct(productID: productID);

    notifyListeners();
  }

  reset() {
    productImages = [];
    productImagesURL = [];
    userRatedTheProduct = false;
    productPurchased = false;

    notifyListeners();
  }

  checkUserRating({required String productID}) async {
    userRatedTheProduct =
        await RatingServices.checkUserRating(productID: productID);
    notifyListeners();
  }
}
