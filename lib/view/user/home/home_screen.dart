// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:amazon_clone/constant/common_function.dart';
import 'package:amazon_clone/constant/constant.dart';
import 'package:amazon_clone/controller/provier/address_provier.dart';
import 'package:amazon_clone/controller/provier/deal_of_day_provider/deal_of_day_provider.dart';
import 'package:amazon_clone/controller/services/user_data_crud_service/user_data_CRUD_services.dart';
import 'package:amazon_clone/model/address_model.dart';
import 'package:amazon_clone/model/product_model.dart';
import 'package:amazon_clone/utils/colors.dart';
import 'package:amazon_clone/view/user/address_screen/address_screen.dart';
import 'package:amazon_clone/view/user/product_category_screen/Product_category_screen.dart';
import 'package:amazon_clone/view/user/product_page/product_screen.dart';
// import 'package:amazon_clone/view/user/profile/profile_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../controller/services/product_services/product_services.dart';
import '../searched_product_screen/searched_product_screen.dart';
//import '../../../widgets/user_persistant_nav_bar/user_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CarouselController todaysDealCarouselController = CarouselController();

  checkUserAddress() async {
    bool userAddressPresent = await UserDataCRUD.checkUsersAddress();
    log('user Address Present : ${userAddressPresent.toString()}');
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (userAddressPresent == false) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: height * 0.3,
            width: width,
            padding: EdgeInsetsDirectional.symmetric(
                vertical: height * 0.04, horizontal: width * 0.03),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Address",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: height * 0.15,
                  child: ListView.builder(
                    itemCount: 1,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (index == 0) {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: const AddressScreen(),
                                type: PageTransitionType.rightToLeft,
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: width * 0.35,
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: width * 0.03,
                            vertical: height * 0.01,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: greyShade3),
                          ),
                          alignment: Alignment.center,
                          child: Builder(
                            builder: (context) {
                              if (index == 0) {
                                return Text(
                                  "Add Address",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: greyShade3,
                                      ),
                                );
                              }
                              return Text(
                                "Add Address",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: greyShade3,
                                    ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  headphoneDeals(int index) {
    switch (index) {
      case 0:
        return 'Bose';
      case 1:
        return 'boAt';
      case 2:
        return 'Sony';
      case 3:
        return 'OnePlus';
    }
  }

  clothingDeals(int index) {
    switch (index) {
      case 0:
        return 'Kurtas,sarees & more';
      case 1:
        return 'Tops, dresses & more';
      case 2:
        return 'T-Shirt, jeans & more';
      case 3:
        return 'View all';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserAddress();
      context.read<AddressProvider>().getCurrentSelectedAddress();
      context.read<DealOfTheDayProvider>().fetchTodaysDeal();
    });
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
        child: HomePageAppBar(
          width: width,
          height: height,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HomeScreenUserAddressBar(),
            CommonFunction.divider(),
            const HomeScreenCategoriesList(),
            CommonFunction.blankSpace(height * 0.01, 0),
            CommonFunction.divider(),
            HomeScreenBanner(height: height),
            CommonFunction.blankSpace(height * 0.001, 0),
            CommonFunction.divider(),
            TodaysDealHomeScreenWidget(
                todaysDealCarouselController: todaysDealCarouselController),
            CommonFunction.divider(),
            otherOfferGridWidget(
              title: "Latest Launches in Headphones",
              textBtnName: "Explore More",
              productPicNameList: headphonesDeals,
              offerFor: "headphones",
            ),
            CommonFunction.divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: height * 0.40,
                  width: width,
                  child: const Image(
                    image: AssetImage(
                        "assets/images/offersNsponcered/insurance.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.001, vertical: height * 0.001),
                  child: Text(
                    "Sponoredⓘ",
                    style: textTheme.labelSmall!.copyWith(
                      color: grey,
                    ),
                  ),
                )
              ],
            ),
            CommonFunction.blankSpace(height * 0.002, 0),
            CommonFunction.divider(),
            otherOfferGridWidget(
              title: "Minimum 70% off | Top offers n clothing",
              textBtnName: "Sell all deals",
              productPicNameList: clothingDealsList,
              offerFor: "clothing",
            ),
            CommonFunction.divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonFunction.blankSpace(height * 0.001, 0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  child: Text(
                    "Watch Sixer only on miniTV",
                    style: textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  //height: height * 0.04,
                  width: width,
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: width * 0.03,
                    vertical: height * 0.01,
                  ),
                  child: const Image(
                    image:
                        AssetImage("assets/images/offersNsponcered/sixer.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container otherOfferGridWidget({
    required String title,
    required String textBtnName,
    required List<String> productPicNameList,
    required String offerFor,
  }) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: width * 0.03,
        vertical: height * 0.01,
      ),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
          ),
          CommonFunction.blankSpace(height * 0.01, 0),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 20,
            ),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(color: greyShade3),
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/images/offersNsponcered/${productPicNameList[index]}"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      offerFor == "headphones"
                          ? headphoneDeals(index)
                          : clothingDeals(index),
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            },
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              textBtnName,
              style: textTheme.bodySmall!.copyWith(color: blue),
            ),
          ),
        ],
      ),
    );
  }
}

class TodaysDealHomeScreenWidget extends StatelessWidget {
  const TodaysDealHomeScreenWidget({
    super.key,
    required this.todaysDealCarouselController,
  });

  final CarouselController todaysDealCarouselController;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "50%-80% off | Latest Deals",
              style:
                  textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w600),
            ),
            Consumer<DealOfTheDayProvider>(
              builder: (context, dealOftheProvider, child) {
                if (dealOftheProvider.dealsFetched == false) {
                  return Container(
                    height: height * 0.2,
                    width: width,
                    alignment: Alignment.center,
                    child: Text(
                      "Loading Latest Deals",
                      style: textTheme.bodyMedium,
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      CarouselSlider(
                        carouselController: todaysDealCarouselController,
                        options: CarouselOptions(
                          height: height * 0.27,
                          autoPlay: true,
                          viewportFraction: 1,
                        ),
                        items: dealOftheProvider.deals.map((i) {
                          ProductModel currentProduct = i;
                          return Builder(
                            builder: (BuildContext context) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: ProductScreen(
                                          productModel: currentProduct),
                                      type: PageTransitionType.rightToLeft,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  //margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    //color: Colors.amber,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        currentProduct.imagesURL![0],
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      CommonFunction.blankSpace(height * 0.02, 0),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsetsDirectional.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: red,
                            ),
                            child: Text(
                              "Upto 62% off",
                              style: textTheme.labelMedium!.copyWith(
                                color: white,
                              ),
                            ),
                          ),
                          CommonFunction.blankSpace(0, width * 0.03),
                          Text(
                            "Deal of the Day",
                            style: textTheme.labelMedium!.copyWith(
                                color: red, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      CommonFunction.blankSpace(height * 0.01, 0),
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: dealOftheProvider.deals.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 20,
                        ),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          ProductModel currentProduct =
                              dealOftheProvider.deals[index];
                          return InkWell(
                            onTap: () {
                              log(index.toString());
                              todaysDealCarouselController.animateToPage(index);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: greyShade3),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      currentProduct.imagesURL![0]),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "See all Deals",
                style: textTheme.bodySmall!.copyWith(color: blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreenBanner extends StatelessWidget {
  const HomeScreenBanner({
    super.key,
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: height * 0.27,
        autoPlay: true,
        viewportFraction: 1,
      ),
      items: carouselPictures.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              //margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                //color: Colors.amber,
                image: DecorationImage(
                  image: AssetImage("assets/images/carousel_slideshow/${i}"),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class HomeScreenCategoriesList extends StatelessWidget {
  const HomeScreenCategoriesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: height * 0.10,
      width: width,
      child: ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: ProductCategoryScreen(
                        productCategory: categories[index],
                      ),
                      type: PageTransitionType.rightToLeft));
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: width * 0.01,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                    image: AssetImage(
                        "assets/images/categories/${categories[index]}.png"),
                    height: height * 0.07,
                  ),
                  Text(
                    categories[index],
                    style: textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class HomeScreenUserAddressBar extends StatelessWidget {
  const HomeScreenUserAddressBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: height * 0.06,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: addressBarGradientColor,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          if (addressProvider.fetchedCurrentSelectedAddress &&
              addressProvider.addressPresent) {
            AddressModel selectedAddress =
                addressProvider.currentSelectedAddress;
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.location_pin),
                CommonFunction.blankSpace(width * 0.02, 0),
                Flexible(
                  child: Text(
                    "Deliver to ${selectedAddress.name} - ${selectedAddress.area} ",
                    style: textTheme.labelMedium,
                  ),
                ),
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.location_pin),
                CommonFunction.blankSpace(width * 0.02, 0),
                Text(
                  "Deliver to user - City, State",
                  style: textTheme.bodySmall,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar({
    super.key,
    required this.width,
    required this.height,
  });
  final double width;
  final double height;

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
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: const SearchedProductScreen(),
                  type: PageTransitionType.rightToLeft,
                ),
              );
            },
            child: Container(
              width: width * 0.81,
              height: height * 0.06,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  5,
                ),
                border: Border.all(
                  color: grey,
                ),
                color: white,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: black,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.03,
                    ),
                    child: Text(
                      'Search Amazon.in',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: grey),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.camera_alt_sharp,
                    color: grey,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                ProductServices.getImages(context: context);
              },
              icon: Icon(
                Icons.mic,
                color: black,
              ))
        ],
      ),
    );
  }
}
