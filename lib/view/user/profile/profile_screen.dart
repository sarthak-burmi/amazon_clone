import 'package:amazon_clone/constant/common_function.dart';
import 'package:amazon_clone/controller/services/user_product_services/user_product_services.dart';
import 'package:amazon_clone/model/product_model.dart';
import 'package:amazon_clone/model/user_product_model.dart';
import 'package:amazon_clone/utils/colors.dart';
import 'package:amazon_clone/view/user/orders_screen/order_screen.dart';
import 'package:amazon_clone/view/user/product_page/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.08),
        child: Container(
          padding: EdgeInsetsDirectional.only(
            top: height * 0.045,
            bottom: height * 0.012,
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
            children: [
              Image(
                image: const AssetImage("assets/images/amazon_black_logo.png"),
                height: height * 0.04,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_none,
                  color: black,
                  size: height * 0.035,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  size: height * 0.035,
                  color: black,
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          padding: EdgeInsetsDirectional.symmetric(vertical: height * 0.02),
          child: Column(
            children: [
              UserGreetingScreen(
                  width: width, textTheme: textTheme, height: height),
              CommonFunction.blankSpace(height * 0.01, 0),
              YouGridBtons(width: width, textTheme: textTheme),
              CommonFunction.blankSpace(height * 0.02, 0),
              UsersOrder(width: width, height: height, textTheme: textTheme),
              CommonFunction.blankSpace(height * 0.01, 0),
              CommonFunction.divider(),
              KeepShopping(width: width, height: height, textTheme: textTheme),
              CommonFunction.blankSpace(height * 0.01, 0),
              CommonFunction.divider(),
              BuyAgain(width: width, height: height, textTheme: textTheme),
            ],
          ),
        ),
      ),
    );
  }
}

class BuyAgain extends StatelessWidget {
  const BuyAgain({
    super.key,
    required this.width,
    required this.height,
    required this.textTheme,
  });

  final double width;
  final double height;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.04, vertical: height * 0.01),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Buy Again",
                style:
                    textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "See all",
                  style: textTheme.bodySmall!.copyWith(color: blue),
                ),
              ),
            ],
          ),
          CommonFunction.blankSpace(height * 0.02, 0),
          SizedBox(
            height: height * 0.14,
            child: ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const PageScrollPhysics(),
                itemBuilder: ((context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                    width: height * 0.14,
                    height: height * 0.14,
                    decoration: BoxDecoration(
                      border: Border.all(color: greyShade3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                })),
          )
        ],
      ),
    );
  }
}

class KeepShopping extends StatelessWidget {
  const KeepShopping({
    super.key,
    required this.width,
    required this.height,
    required this.textTheme,
  });

  final double width;
  final double height;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.04, vertical: height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Keep Shopping for",
                style:
                    textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Browsing History",
                  style: textTheme.bodySmall!.copyWith(color: blue),
                ),
              ),
            ],
          ),
          CommonFunction.blankSpace(height * 0.02, 0),
          StreamBuilder(
            stream: UsersProductService.fetchKeepShoppiingForProoducts(),
            builder: ((context, snapshot) {
              if (snapshot.data!.isEmpty) {
                return Container(
                  height: height * 0.15,
                  width: width,
                  alignment: Alignment.center,
                  child: Text(
                    "Start Browsing for Products",
                    style: textTheme.bodyMedium,
                  ),
                );
              }
              if (snapshot.hasData) {
                List<ProductModel> product = snapshot.data!;
                return GridView.builder(
                  physics: const PageScrollPhysics(),
                  itemCount: (product.length > 6) ? 6 : product.length,
                  // itemCount: 1,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    ProductModel currentProduct = product[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: ProductScreen(productModel: currentProduct),
                            type: PageTransitionType.rightToLeft,
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: greyShade3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image(
                                image: NetworkImage(
                                  currentProduct.imagesURL![0],
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          CommonFunction.blankSpace(height * 0.005, 0),
                          Text(
                            currentProduct.name!,
                            style: textTheme.labelMedium,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              if (snapshot.hasError) {
                return Container(
                  height: height * 0.15,
                  width: width,
                  alignment: Alignment.center,
                  child: Text(
                    "OOPS! where was an error",
                    style: textTheme.bodyMedium,
                  ),
                );
              } else {
                return Container(
                  height: height * 0.15,
                  width: width,
                  alignment: Alignment.center,
                  child: Text(
                    "OOPS! No Product was Found",
                    style: textTheme.bodyMedium,
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}

class UsersOrder extends StatelessWidget {
  const UsersOrder({
    super.key,
    required this.width,
    required this.height,
    required this.textTheme,
  });

  final double width;
  final double height;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserProductModel>>(
        stream: UsersProductService.fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Container(
                height: height * 0.2,
                width: width,
                alignment: Alignment.center,
                child: Text(
                  "OOPS! You did not Orderd Anything yet",
                  style: textTheme.displaySmall,
                ),
              );
            } else {
              List<UserProductModel> orders = snapshot.data!;
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04, vertical: height * 0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Your Orders",
                          style: textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "See all",
                            style: textTheme.bodySmall!.copyWith(color: blue),
                          ),
                        )
                      ],
                    ),
                    CommonFunction.blankSpace(height * 0.02, 0),
                    SizedBox(
                      height: height * 0.17,
                      child: ListView.builder(
                        itemCount: orders.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const PageScrollPhysics(),
                        itemBuilder: (context, index) {
                          UserProductModel currentProduct = orders[index];
                          return InkWell(
                            onTap: () {
                              ProductModel product = ProductModel(
                                imagesURL: currentProduct.imagesURL,
                                name: currentProduct.name,
                                category: currentProduct.category,
                                description: currentProduct.description,
                                brandName: currentProduct.brandName,
                                manufacturerName:
                                    currentProduct.manufacturerName,
                                countryOfOrigin: currentProduct.countryOfOrigin,
                                specifications: currentProduct.specifications,
                                price: currentProduct.price,
                                discountedPrice: currentProduct.discountedPrice,
                                productID: currentProduct.productID,
                                productSellerID: currentProduct.productSellerID,
                                inStock: currentProduct.inStock,
                                uploadedAt: currentProduct.time,
                                discountPercentage:
                                    currentProduct.discountPercentage,
                              );

                              Navigator.push(
                                context,
                                PageTransition(
                                  child: ProductScreen(productModel: product),
                                  type: PageTransitionType.rightToLeft,
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.02),
                              width: width * 0.4,
                              height: height * 0.17,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(color: greyShade3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image(
                                image: NetworkImage(
                                  currentProduct.imagesURL![0],
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          if (snapshot.hasError) {
            return Container(
              height: height * 0.2,
              width: width,
              alignment: Alignment.center,
              child: Text(
                "OOPS! There was an ERROR!!",
                style: textTheme.displayMedium,
              ),
            );
          } else {
            return Container(
              height: height * 0.2,
              width: width,
              alignment: Alignment.center,
              child: Text(
                "OOPS! No Orders Found",
                style: textTheme.displayMedium,
              ),
            );
          }
        });
  }
}

class YouGridBtons extends StatelessWidget {
  const YouGridBtons({
    super.key,
    required this.width,
    required this.textTheme,
  });

  final double width;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 4,
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3.4),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            if (index == 0) {
              Navigator.push(
                context,
                PageTransition(
                    child: const OrderSCreen(),
                    type: PageTransitionType.rightToLeft),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: grey,
              ),
              borderRadius: BorderRadius.circular(
                50,
              ),
              color: greyShade2,
            ),
            alignment: Alignment.center,
            child: Builder(builder: (context) {
              if (index == 0) {
                return Text(
                  'Your Orders',
                  style: textTheme.bodyMedium,
                );
              }
              if (index == 1) {
                return Text(
                  'Buy Again',
                  style: textTheme.bodyMedium,
                );
              }
              if (index == 2) {
                return Text(
                  'Your Account',
                  style: textTheme.bodyMedium,
                );
              }
              return Text(
                'Your Wish List',
                style: textTheme.bodyMedium,
              );
            }),
          ),
        );
      },
    );
  }
}

class UserGreetingScreen extends StatelessWidget {
  const UserGreetingScreen({
    super.key,
    required this.width,
    required this.textTheme,
    required this.height,
  });

  final double width;
  final TextTheme textTheme;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: "Hello, ", style: textTheme.bodyLarge),
                TextSpan(
                  text: "Sarthak",
                  style: textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Spacer(),
          CircleAvatar(
            backgroundColor: greyShade3,
            radius: height * 0.025,
          ),
        ],
      ),
    );
  }
}
