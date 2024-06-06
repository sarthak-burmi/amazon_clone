// ignore_for_file: unused_local_variable

import 'dart:developer';
import 'package:amazon_clone/constant/common_function.dart';
import 'package:amazon_clone/constant/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../model/product_model.dart';
import '../../../model/user_product_model.dart';

class UsersProductService {
  static Future<List<ProductModel>> getProducts(String productName) async {
    List<ProductModel> sellersProducts = [];
    if (productName.isEmpty) {
      return sellersProducts;
    }
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Products')
          .orderBy('name')
          .startAt([productName.toUpperCase()]).endAt(
              ['${productName.toLowerCase()}\uf8ff']).get();

      snapshot.docs.forEach((element) {
        sellersProducts.add(ProductModel.fromMap(element.data()));
      });
      log(sellersProducts.toList().toString());
    } catch (e) {
      log('error Found');
      log(e.toString());
    }
    log(sellersProducts.toList().toString());
    return sellersProducts;
  }

  static Future addProductToCart({
    required BuildContext context,
    required UserProductModel productModel,
  }) async {
    try {
      await firestore
          .collection('Cart')
          .doc(auth.currentUser!.phoneNumber)
          .collection('myCart')
          .where('productID', isEqualTo: productModel.productID)
          .get()
          .then((value) async {
        if (value.size < 1) {
          await firestore
              .collection('Cart')
              .doc(auth.currentUser!.phoneNumber)
              .collection('myCart')
              .doc(productModel.productID)
              .set(productModel.toMap())
              .whenComplete(() {
            log('Data Added');

            CommonFunction.showSuccessToast(
                context: context, message: 'Product Added Successful');
          });
        }
      });
    } catch (e) {
      log(e.toString());
      CommonFunction.showErrorToast(context: context, message: e.toString());
    }
  }

  static Future addRecentlySeenProduct(
      {required BuildContext context,
      required ProductModel productModel}) async {
    try {
      await firestore
          .collection("Recently_Seen_Products")
          .doc(auth.currentUser!.phoneNumber)
          .collection("products")
          .where("productID", isEqualTo: productModel.productID)
          .get()
          .then((value) async {
        if (value.size < 1) {
          await firestore
              .collection("Recently_Seen_Products")
              .doc(auth.currentUser!.phoneNumber)
              .collection("products")
              .doc(productModel.productID)
              .set(productModel.toMap());
        }
      });
    } catch (e) {
      log(e.toString());
      CommonFunction.showErrorToast(context: context, message: e.toString());
    }
  }

  static Stream<List<UserProductModel>> fetchCartProduct(
          {required String title}) =>
      firestore
          .collection("Cart")
          .doc(auth.currentUser!.phoneNumber)
          .collection("myCart")
          .orderBy("time", descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs.map((doc) {
              return UserProductModel.fromMap(doc.data());
            }).toList(),
          );
  static Future<void> updateCount(
      {required String productId,
      required int newCount,
      required BuildContext context}) async {
    final collectionRef = firestore
        .collection("Cart")
        .doc(auth.currentUser!.phoneNumber)
        .collection("myCart");

    try {
      final snapshot =
          await collectionRef.where("productID", isEqualTo: productId).get();

      if (snapshot.docs.isNotEmpty) {
        final docID = snapshot.docs[0].id;
        await collectionRef.doc(docID).update({"productCount": newCount});
      }
    } catch (e) {
      CommonFunction.showToast(context: context, message: e.toString());
    }
  }

  static Future<void> removeProductfromCart({
    required String productId,
    required BuildContext context,
  }) async {
    final collectionRef = firestore
        .collection('Cart')
        .doc(auth.currentUser!.phoneNumber)
        .collection('myCart');

    try {
      final snapshot =
          await collectionRef.where('productID', isEqualTo: productId).get();

      if (snapshot.docs.isNotEmpty) {
        final docId = snapshot.docs[0].id;
        await collectionRef.doc(docId).delete();
      }
    } catch (e) {
      CommonFunction.showErrorToast(context: context, message: e.toString());
    }
  }

  static Stream<List<ProductModel>> fetchKeepShoppiingForProoducts() =>
      firestore
          .collection("Recently_Seen_Products")
          .doc(auth.currentUser!.phoneNumber)
          .collection("products")
          .orderBy("uploadedAt", descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs.map(
              (doc) {
                return ProductModel.fromMap(
                  doc.data(),
                );
              },
            ).toList(),
          );
  static Future featchDealOfTheDay() async {
    List<ProductModel> sellersProducts = [];
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Products')
          .orderBy('discountPercentage', descending: true)
          .limit(4)
          .get();
      snapshot.docs.forEach((element) {
        sellersProducts.add(ProductModel.fromMap(element.data()));
      });
      log(sellersProducts.toList().toString());
    } catch (e) {
      log('error Found');
      log(e.toString());
    }
    log(sellersProducts.toList().toString());
    return sellersProducts;
  }

  static Future fetchProductBasedOnCategory({required String category}) async {
    List<ProductModel> sellersProducts = [];
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Products')
          .where('category', isEqualTo: category)
          .get();
      snapshot.docs.forEach((element) {
        sellersProducts.add(ProductModel.fromMap(element.data()));
      });
      log(sellersProducts.toList().toString());
    } catch (e) {
      log('error Found');
      log(e.toString());
    }
    log(sellersProducts.toList().toString());
    return sellersProducts;
  }

  static Future addOrder({
    required BuildContext context,
    required UserProductModel productModel,
  }) async {
    try {
      Uuid uuid = Uuid();
      await firestore
          .collection('Orders')
          .doc(auth.currentUser!.phoneNumber)
          .collection('myOrders')
          .doc(productModel.productID! + uuid.v1())
          .set(productModel.toMap())
          .whenComplete(() {
        log('Data Added');

        CommonFunction.showSuccessToast(
            context: context, message: 'Product Ordered Successful');
      });
    } catch (e) {
      log(e.toString());
      CommonFunction.showErrorToast(context: context, message: e.toString());
    }
  }

  static Stream<List<UserProductModel>> fetchOrders() => firestore
      .collection('Orders')
      .doc(auth.currentUser!.phoneNumber)
      .collection('myOrders')
      .orderBy('time', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            return UserProductModel.fromMap(doc.data());
          }).toList());

  static Future fetchCart() async {
    List<UserProductModel> sellersProducts = [];
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Cart')
          .doc(auth.currentUser!.phoneNumber)
          .collection('myCart')
          .get();
      snapshot.docs.forEach((element) {
        sellersProducts.add(UserProductModel.fromMap(element.data()));
      });
      log(sellersProducts.toList().toString());
    } catch (e) {
      log('error Found');
      log(e.toString());
    }
    log(sellersProducts.toList().toString());
    log(sellersProducts.toList().toString());
    return sellersProducts;
  }
}
