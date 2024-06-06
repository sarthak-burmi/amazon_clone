// ignore_for_file: use_build_context_synchronously
import 'package:amazon_clone/constant/common_function.dart';
import 'package:amazon_clone/controller/services/user_product_services/user_product_services.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../constant/constant.dart';
import '../../../controller/services/product_services/product_services.dart';
import '../../../model/user_product_model.dart';
import '../../../utils/colors.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  final razorpay = Razorpay();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    });
  }

  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    List<UserProductModel> cartItems = await UsersProductService.fetchCart();
    DateTime currentTime = DateTime.now();

    for (var product in cartItems) {
      UserProductModel model = UserProductModel(
        imagesURL: product.imagesURL,
        name: product.name,
        category: product.category,
        description: product.description,
        brandName: product.brandName,
        manufacturerName: product.manufacturerName,
        countryOfOrigin: product.countryOfOrigin,
        specifications: product.specifications,
        price: product.price,
        discountedPrice: product.discountedPrice,
        productID: product.productID,
        productSellerID: product.productSellerID,
        inStock: product.inStock,
        discountPercentage: product.discountPercentage,
        productCount: product.productCount,
        time: currentTime,
      );
      await ProductServices.addSalesData(
        context: context,
        productModel: model,
        userID: auth.currentUser!.phoneNumber!,
      );
      await UsersProductService.addOrder(
        context: context,
        productModel: model,
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    CommonFunction.showErrorToast(
      context: context,
      message: 'Opps! Product Purchase Failed',
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}
  executePayment() {
    var options = {
      'key': keyID,
      // 'amount': widget.productModel.discountedPrice! * 100,
      'amount': 1 * 100, // Amount is rs 1,
      // here amount * 100 because razorpay counts amount in paisa
      //i.e 100 paisa = 1 Rupee
      // 'image' : '<YOUR BUISNESS EMAIL>'
      'name': 'Multiple Product',
      'description': 'Multiple Product',
      'prefill': {
        'contact': auth.currentUser!.phoneNumber, //<USERS CONTACT NO.>
        'email': 'test@razorpay.com' // <USERS EMAIL NO.>
      }
    };

    razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width * 1, height * 0.1),
        child: const HomePageAppBar(),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(
              horizontal: width * 0.03, vertical: height * 0.02),
          height: height,
          width: width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder(
                  stream:
                      UsersProductService.fetchCartProduct(title: toString()),
                  builder: (context, snapshot) {
                    if (snapshot.data!.isEmpty) {
                      return Column(
                        children: [
                          CommonFunction.blankSpace(height * 0.04, 0),
                          const Image(
                            image: AssetImage(
                                "assets/images/no_product_in-cart_image.jpeg"),
                          ),
                          CommonFunction.blankSpace(height * 0.01, 0),
                          Center(
                            child: Text(
                              "OOPS! \nNo Product \nAdded to Cart",
                              style: textTheme.displayLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          CommonFunction.blankSpace(height * 0.02, 0),
                          SizedBox(
                            width: width * 0.8,
                            // child: ElevatedButton(
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: white,
                            //     shadowColor: grey,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius:
                            //           BorderRadiusDirectional.circular(5),
                            //     ),
                            //   ),
                            //   onPressed: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => HomeScreen(),
                            //       ),
                            //     );
                            //   },
                            //   child: Text(
                            //     "Keep Shopping",
                            //     style: textTheme.bodyMedium,
                            //   ),
                            // ),
                          )
                        ],
                      );
                    }
                    if (snapshot.hasData) {
                      List<UserProductModel> cartProducts = snapshot.data!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Subtotal: ",
                                  style: textTheme.bodyLarge,
                                ),
                                TextSpan(
                                  text:
                                      '₹ ${cartProducts.fold(0.0, (previousValue, product) => previousValue + (product.productCount! * product.discountedPrice!)).toStringAsFixed(0)}',
                                  style: textTheme.displaySmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CommonFunction.blankSpace(height * 0.01, 0),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "EMI Available ",
                                  style: textTheme.bodySmall,
                                ),
                                TextSpan(
                                  text: "Details",
                                  style: textTheme.bodySmall!.copyWith(
                                    color: teal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CommonFunction.blankSpace(height * 0.01, 0),
                          SizedBox(
                            height: height * 0.06,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: teal,
                                ),
                                CommonFunction.blankSpace(0, width * 0.01),
                                Expanded(
                                  child: Column(
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.justify,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  "Your order is eligible for FREE delivery. ",
                                              style: textTheme.bodySmall!
                                                  .copyWith(color: teal),
                                            ),
                                            TextSpan(
                                              text:
                                                  "Select this option at checkout.",
                                              style: textTheme.bodySmall,
                                            ),
                                            TextSpan(
                                              text: " Details",
                                              style: textTheme.bodySmall!
                                                  .copyWith(color: blue),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: executePayment,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadiusDirectional.circular(10),
                              ),
                              backgroundColor: amber,
                              minimumSize: Size(width, height * 0.06),
                            ),
                            child: Text(
                              "Proceed to Buy",
                              style: textTheme.bodyMedium,
                            ),
                          ),
                          CommonFunction.blankSpace(height * 0.02, 0),
                          SendGiftToggelButton(),
                          CommonFunction.blankSpace(height * 0.03, 0),
                          CommonFunction.divider(),
                          CommonFunction.blankSpace(height * 0.02, 0),
                          ListView.builder(
                            itemCount: cartProducts.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              UserProductModel currentProduct =
                                  cartProducts[index];
                              return Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: width * 0.02,
                                  vertical: height * 0.01,
                                ),
                                // height: height * 0.2,
                                width: width,
                                margin: EdgeInsetsDirectional.symmetric(
                                  vertical: height * 0.01,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: greyShade1,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image(
                                            image: NetworkImage(
                                              currentProduct.imagesURL![0],
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                          CommonFunction.blankSpace(
                                              height * 0.045, 0),
                                          Container(
                                            height: height * 0.06,
                                            width: width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border:
                                                  Border.all(color: greyShade3),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      if (currentProduct
                                                              .productCount ==
                                                          1) {
                                                        await UsersProductService
                                                            .removeProductfromCart(
                                                                productId:
                                                                    currentProduct
                                                                        .productID!,
                                                                context:
                                                                    context);
                                                      }
                                                      await UsersProductService
                                                          .updateCount(
                                                        productId:
                                                            currentProduct
                                                                .productID!,
                                                        newCount: currentProduct
                                                                .productCount! -
                                                            1,
                                                        context: context,
                                                      );
                                                    },
                                                    child: Container(
                                                      height: double.infinity,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          right: BorderSide(
                                                            color: greyShade3,
                                                          ),
                                                        ),
                                                      ),
                                                      child: Icon(
                                                        Icons.remove,
                                                        color: black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    color: white,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      currentProduct
                                                          .productCount!
                                                          .toString(),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      await UsersProductService
                                                          .updateCount(
                                                        productId:
                                                            currentProduct
                                                                .productID!,
                                                        newCount: currentProduct
                                                                .productCount! +
                                                            1,
                                                        context: context,
                                                      );
                                                    },
                                                    child: Container(
                                                      height: double.infinity,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          left: BorderSide(
                                                            color: greyShade3,
                                                          ),
                                                        ),
                                                      ),
                                                      child: Icon(
                                                        Icons.add,
                                                        color: black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    CommonFunction.blankSpace(0, width * 0.02),
                                    Expanded(
                                      flex: 9,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            currentProduct.name!,
                                            maxLines: 2,
                                            style: textTheme.bodySmall,
                                          ),
                                          CommonFunction.blankSpace(
                                              height * 0.01, 0),
                                          Row(
                                            children: [
                                              Text(
                                                "₹${currentProduct.discountedPrice!.toStringAsFixed(0)}",
                                                style: textTheme.bodyMedium!
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "\t\tM.R.P\t₹",
                                                style: textTheme.labelLarge!
                                                    .copyWith(
                                                  color: grey,
                                                ),
                                              ),
                                              Text(
                                                "${currentProduct.price!.toStringAsFixed(0)}",
                                                style: textTheme.bodySmall!
                                                    .copyWith(
                                                        color: grey,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough),
                                              ),
                                            ],
                                          ),
                                          CommonFunction.blankSpace(
                                              height * 0.01, 0),
                                          Text(
                                            currentProduct.discountedPrice! >
                                                    499
                                                ? "Eligible for free Shipping"
                                                : "Extra Delivery Charges Applied",
                                            style: textTheme.bodySmall!
                                                .copyWith(color: grey),
                                          ),
                                          CommonFunction.blankSpace(
                                              height * 0.01, 0),
                                          Text(
                                            "In Stock",
                                            style: textTheme.bodySmall!
                                                .copyWith(color: teal),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await UsersProductService
                                                      .removeProductfromCart(
                                                          productId:
                                                              currentProduct
                                                                  .productID!,
                                                          context: context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: white,
                                                  side: BorderSide(
                                                    color: greyShade3,
                                                  ),
                                                ),
                                                child: Text(
                                                  "Delete",
                                                  style: textTheme.labelMedium,
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: white,
                                                  side: BorderSide(
                                                      color: greyShade3),
                                                ),
                                                child: Text(
                                                  "Save for Later",
                                                  style: textTheme.labelMedium,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                    if (snapshot.hasError) {
                      return const Text("OPPS! Error Found");
                    } else {
                      return const Text("OPPS! No Product Added to Cart");
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsetsDirectional.only(
        bottom: height * 0.012,
        top: height * 0.045,
        start: width * 0.03,
        end: width * 0.03,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: appBarGradientColor,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: width * 0.81,
            child: TextField(
              cursorColor: black,
              decoration: InputDecoration(
                fillColor: white,
                filled: true,
                prefixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search, color: black),
                ),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.qr_code_scanner, color: black),
                ),
                hintText: "Search Amazon.in",
                contentPadding: EdgeInsetsDirectional.symmetric(
                  horizontal: width * 0.03,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.mic,
              color: black,
            ),
          ),
        ],
      ),
    );
  }
}

class SendGiftToggelButton extends StatefulWidget {
  @override
  _SendGiftToggelButtonState createState() => _SendGiftToggelButtonState();
}

class _SendGiftToggelButtonState extends State<SendGiftToggelButton> {
  bool sendGift = false;

  void _toggleSendGift() {
    setState(() {
      sendGift = !sendGift;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        InkWell(
          onTap: _toggleSendGift,
          child: Container(
            height: height * 0.03,
            width: height * 0.03,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: grey),
              borderRadius: BorderRadius.circular(5),
              color: sendGift ? white : transparent,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.check,
              size: height * 0.02,
              color: sendGift ? secondaryColor : transparent,
            ),
          ),
        ),
        CommonFunction.blankSpace(0, width * 0.02),
        Text(
          "Send as a gift. Include custom message.",
          style: textTheme.bodySmall,
        ),
      ],
    );
  }
}
