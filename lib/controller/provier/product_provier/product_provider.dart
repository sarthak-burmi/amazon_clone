import 'dart:io';

import 'package:flutter/material.dart';

import '../../../model/product_model.dart';
import '../../services/product_services/product_services.dart';

class SellerProductProvider extends ChangeNotifier {
  List<File> productImages = [];
  List<String> productImagesURL = [];
  List<ProductModel> products = [];
  bool sellerProductsFetched = false;

  fetchProductImagesFromGallery({required BuildContext context}) async {
    productImages = await ProductServices.getImages(context: context);
    notifyListeners();
  }

  updateProductImagesURL({required List<String> imageURLs}) async {
    productImagesURL = imageURLs;
    notifyListeners();
  }

  uploadProductImagesToFirebaseStotage({required BuildContext context}) async {
    productImagesURL = await ProductServices.uploadImageToFirebaseStorage(
        images: productImages, context: context);

    notifyListeners();
  }

  fetchSellerProduct() async {
    products = await ProductServices.getSellersProducts();
    sellerProductsFetched = true;
    notifyListeners();
  }
}
