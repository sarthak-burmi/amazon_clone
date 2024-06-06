// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:amazon_clone/constant/common_function.dart';
import 'package:amazon_clone/controller/provier/product_by_category_provider/product_by_category_provider.dart';
import 'package:amazon_clone/controller/provier/user_product_provider/user_product_provider.dart';
import 'package:amazon_clone/controller/services/user_product_services/user_product_services.dart';
import 'package:amazon_clone/model/product_model.dart';
import 'package:amazon_clone/view/user/product_page/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../../model/user_product_model.dart';
import '../../../utils/colors.dart';

class ProductCategoryScreen extends StatefulWidget {
  ProductCategoryScreen({super.key, required this.productCategory});
  String productCategory;

  @override
  State<ProductCategoryScreen> createState() => _SearchedProductScreenState();
}

class _SearchedProductScreenState extends State<ProductCategoryScreen> {
  TextEditingController searchController = TextEditingController();
  getDay(int dayNum) {
    switch (dayNum % 7) {
      case 0:
        return 'Monday';
      case 1:
        return 'Tuesday';
      case 2:
        return 'Wednesday';
      case 3:
        return 'Thursday';
      case 4:
        return 'Friday';
      case 5:
        return 'Saturday';
      case 6:
        return 'Sunday';
      default:
        'Sunday';
    }
  }

  getMonth(int deliveryDate) {
    if (DateTime.now().month == 2) {
      if (deliveryDate > 28) {
        return 'March';
      } else {
        return 'Febuary';
      }
    }
    if (DateTime.now().month == 4 ||
        DateTime.now().month == 6 ||
        DateTime.now().month == 8 ||
        DateTime.now().month == 10 ||
        DateTime.now().month == 12) {
      if ((deliveryDate > 30) && (DateTime.now().month == 12)) {
        return 'January';
      }
      if (deliveryDate > 30) {
        int month = DateTime.now().month + 1;
        switch (month) {
          case 1:
            return 'January';

          case 2:
            return 'February';

          case 3:
            return 'March';

          case 4:
            return 'April';

          case 5:
            return 'May';

          case 6:
            return 'June';

          case 7:
            return 'July';

          case 8:
            return 'August';

          case 9:
            return 'September';

          case 10:
            return 'October';

          case 11:
            return 'November';
          case 12:
            return 'December';
        }
      } else {
        int month = DateTime.now().month;
        switch (month) {
          case 1:
            return 'January';

          case 2:
            return 'February';

          case 3:
            return 'March';

          case 4:
            return 'April';

          case 5:
            return 'May';

          case 6:
            return 'June';

          case 7:
            return 'July';

          case 8:
            return 'August';

          case 9:
            return 'September';

          case 10:
            return 'October';

          case 11:
            return 'November';
          case 12:
            return 'December';
        }
      }
    }
    log(DateTime.now().month.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    context
        .read<ProductsBasedOnCategoryProvider>()
        .fetchProducts(category: widget.productCategory);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width * 1, height * 0.1),
        child: Container(
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
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: black,
                ),
              ),
              SizedBox(
                width: width * 0.68,
                child: TextField(
                  onSubmitted: (productName) {
                    //log(productName);
                    context
                        .read<UsersProductProvider>()
                        .getSearchedProducts(productName: productName);
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsetsDirectional.symmetric(
                      horizontal: width * 0.03,
                    ),
                    filled: true,
                    fillColor: white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.mic,
                  color: black,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Consumer<ProductsBasedOnCategoryProvider>(
        builder: (context, usersProductProvider, child) {
          if (usersProductProvider.productsFetched == false) {
            // return Center(
            //   child: CircularProgressIndicator(color: amber),
            // );
            return SizedBox();
          } else {
            if (usersProductProvider.products.isEmpty) {
              return const Center(
                child: Text("OOPS PRODUCT NOT FOUND"),
              );
            } else {
              return ListView.builder(
                itemCount: usersProductProvider.products.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  ProductModel currentProduct =
                      usersProductProvider.products[index];
                  return InkWell(
                    onTap: () async {
                      await UsersProductService.addRecentlySeenProduct(
                          context: context, productModel: currentProduct);
                      Navigator.push(
                          context,
                          PageTransition(
                              child:
                                  ProductScreen(productModel: currentProduct),
                              type: PageTransitionType.rightToLeft));
                    },
                    child: Container(
                      height: height * 0.44,
                      width: width,
                      decoration: BoxDecoration(
                        border: Border.all(color: greyShade3),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: width * 0.03,
                        vertical: height * 0.007,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: greyShade1,
                              child: Image.network(
                                currentProduct.imagesURL![0],
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02,
                                  vertical: height * 0.03),
                              child: Column(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentProduct.name ?? "",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  CommonFunction.blankSpace(height * 0.005, 0),
                                  Row(
                                    children: [
                                      Text(
                                        "0.0",
                                        style: textTheme.bodyMedium!
                                            .copyWith(color: teal),
                                      ),
                                      CommonFunction.blankSpace(
                                          width * 0.01, 0),
                                      RatingBar(
                                        initialRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: width * 0.07,
                                        ratingWidget: RatingWidget(
                                          full: Icon(
                                            Icons.star,
                                            color: amber,
                                          ),
                                          half: Icon(
                                            Icons.star_half,
                                            color: amber,
                                          ),
                                          empty: Icon(
                                            Icons.star_outline_sharp,
                                            color: amber,
                                          ),
                                        ),
                                        itemPadding: EdgeInsets.zero,
                                        onRatingUpdate: (rating) {},
                                      ),
                                      CommonFunction.blankSpace(
                                          width * 0.02, 0),
                                      Text(
                                        "0",
                                        style: textTheme.bodyMedium!
                                            .copyWith(color: black),
                                      ),
                                    ],
                                  ),
                                  CommonFunction.blankSpace(height * 0.01, 0),
                                  RichText(
                                    maxLines: 2,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "₹",
                                          style: textTheme.bodyMedium,
                                        ),
                                        TextSpan(
                                          text: currentProduct.discountedPrice!
                                              .toStringAsFixed(0),
                                          style: textTheme.bodyLarge!.copyWith(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        TextSpan(
                                          text: "\tMRP:\t",
                                          style: textTheme.labelMedium!
                                              .copyWith(color: grey),
                                        ),
                                        TextSpan(
                                          text:
                                              "₹${currentProduct.price!.toStringAsFixed(0)}",
                                          style:
                                              textTheme.labelMedium!.copyWith(
                                            color: grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              "\t${currentProduct.discountPercentage!.toStringAsFixed(0)}% Off)",
                                          style:
                                              textTheme.labelMedium!.copyWith(
                                            color: grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "Save extra with No Cost EMI",
                                    style: textTheme.labelMedium!
                                        .copyWith(color: grey),
                                  ),
                                  CommonFunction.blankSpace(height * 0.01, 0),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Get it by ",
                                          style: textTheme.labelMedium!
                                              .copyWith(color: grey),
                                        ),
                                        TextSpan(
                                          text: getDay(
                                              DateTime.now().weekday + 3),
                                          style: textTheme.labelMedium!
                                              .copyWith(
                                                  color: black,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        TextSpan(
                                          text: ', ${DateTime.now().day + 3} ',
                                          style: textTheme.labelMedium!
                                              .copyWith(
                                                  color: black,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        TextSpan(
                                          text: getMonth(DateTime.now().month),
                                          style: textTheme.labelMedium!
                                              .copyWith(
                                                  color: black,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CommonFunction.blankSpace(height * 0.01, 0),
                                  Text(
                                    currentProduct.discountedPrice! > 500
                                        ? "FREE Delivery by Amazon"
                                        : "Extra Delivery Charges Applied",
                                    style: textTheme.labelMedium!
                                        .copyWith(color: grey),
                                  ),
                                  CommonFunction.blankSpace(height * 0.01, 0),
                                  ElevatedButton(
                                    onPressed: () async {
                                      UserProductModel model = UserProductModel(
                                        imagesURL: currentProduct.imagesURL,
                                        name: currentProduct.name,
                                        category: currentProduct.category,
                                        description: currentProduct.description,
                                        brandName: currentProduct.brandName,
                                        manufacturerName:
                                            currentProduct.manufacturerName,
                                        countryOfOrigin:
                                            currentProduct.countryOfOrigin,
                                        specifications:
                                            currentProduct.specifications,
                                        price: currentProduct.price,
                                        discountedPrice:
                                            currentProduct.discountedPrice,
                                        productID: currentProduct.productID,
                                        productSellerID:
                                            currentProduct.productSellerID,
                                        inStock: currentProduct.inStock,
                                        discountPercentage:
                                            currentProduct.discountPercentage,
                                        productCount: 1,
                                        time: DateTime.now(),
                                      );
                                      await UsersProductService
                                          .addProductToCart(
                                        context: context,
                                        productModel: model,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(width, height * 0.05),
                                      backgroundColor: amber,
                                      maximumSize: Size(width, height),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "Add to Cart",
                                      style: textTheme.bodyMedium,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}