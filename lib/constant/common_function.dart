import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import '../model/user_product_model.dart';
import '../utils/colors.dart';
import 'constant.dart';

class CommonFunction {
  static blankSpace(double? height, double? width) {
    return SizedBox(
      height: height ?? 0,
      width: width ?? 0,
    );
  }

  static divider() {
    return Divider(
      thickness: 3,
      height: 0,
      color: greyShade3,
    );
  }

  static showToast({required BuildContext context, required String message}) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: white,
        textColor: black,
        fontSize: 16.0);
  }

  static showSuccessToast(
      {required BuildContext context, required String message}) {
    return MotionToast.success(
      title: const Text('Success'),
      description: Text(message),
      position: MotionToastPosition.top,
    ).show(context);
  }

  static showErrorToast(
      {required BuildContext context, required String message}) {
    return MotionToast.error(
      title: const Text('Error'),
      description: Text(message),
      position: MotionToastPosition.top,
    ).show(context);
  }

  static showWarningToast(
      {required BuildContext context, required String message}) {
    return MotionToast.warning(
      title: const Text('Opps!'),
      description: Text(message),
      position: MotionToastPosition.top,
    ).show(context);
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
}
