// ignore_for_file: use_build_context_synchronously, unused_local_variable
import 'dart:developer';
import 'dart:io';
import 'package:amazon_clone/constant/common_function.dart';
import 'package:amazon_clone/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../constant/constant.dart';
import '../../../model/user_product_model.dart';
import '../../provier/product_provier/product_provider.dart';

class ProductServices {
  static Future getImages({required BuildContext context}) async {
    List<File> selectedImages = [];
    final pickedFile = await picker.pickMultiImage(imageQuality: 100);
    List<XFile> filePick = pickedFile;

    if (filePick.isNotEmpty) {
      for (var i = 0; i < filePick.length; i++) {
        selectedImages.add(File(filePick[i].path));
      }
    } else {
      CommonFunction.showErrorToast(
          context: context, message: "No Image Selcted");
    }
    log("The Images are \n${selectedImages.toList().toString()}");
    return selectedImages;
  }

  static uploadImageToFirebaseStorage({
    required List<File> images,
    required BuildContext context,
  }) async {
    List<String> imagesURL = [];
    String sellerUID = auth.currentUser!.phoneNumber!;
    Uuid uuid = const Uuid();

    await Future.forEach(images, (image) async {
      String imageName = '$sellerUID${uuid.v1().toString()}';
      Reference ref = storage.ref().child('Product_Images').child(imageName);
      await ref.putFile(File(image.path));
      String imageURL = await ref.getDownloadURL();
      imagesURL.add(imageURL);
    });

    context
        .read<SellerProductProvider>()
        .updateProductImagesURL(imageURLs: imagesURL);
  }

  static Future addProduct({
    required BuildContext context,
    required ProductModel productModel,
  }) async {
    try {
      await firestore
          .collection('Products')
          .doc(productModel.productID)
          .set(productModel.toMap())
          .whenComplete(() {
        log('Data Added');
        Navigator.pop(context);
        CommonFunction.showToast(
            context: context, message: "Product Added Succefully");
      });
    } catch (e) {
      log(e.toString());
      CommonFunction.showToast(context: context, message: e.toString());
    }
  }

  static Future<List<ProductModel>> getSellersProducts() async {
    List<ProductModel> sellersProducts = [];

    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Products')
          .orderBy("uploadedAt", descending: true)
          .where('productSellerID', isEqualTo: auth.currentUser!.phoneNumber)
          .get();

      snapshot.docs.forEach((element) {
        sellersProducts.add(ProductModel.fromMap(element.data()));
        ProductModel currentAddresss = ProductModel.fromMap(element.data());
      });
    } catch (e) {
      log('error Found');
      log(e.toString());
    }

    return sellersProducts;
  }

  static Future addSalesData({
    required BuildContext context,
    required UserProductModel productModel,
    required String userID,
  }) async {
    try {
      Uuid uuid = const Uuid();
      await firestore
          .collection('productSaleData')
          .doc(productModel.productID)
          .collection('purchase_history')
          .doc(userID + uuid.v1())
          .set(productModel.toMap())
          .whenComplete(() {
        log('Data Added');

        // CommonFunctions.showSuccessToast(
        //     context: context, message: 'Product Added Successful');
      });
    } catch (e) {
      log(e.toString());
      CommonFunction.showErrorToast(context: context, message: e.toString());
    }
  }

  static Stream<List<UserProductModel>> fetchSalesPerProduct(
          {required String productID}) =>
      firestore
          .collection('productSaleData')
          .doc(productID)
          .collection('purchase_history')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                return UserProductModel.fromMap(doc.data());
              }).toList());
}
