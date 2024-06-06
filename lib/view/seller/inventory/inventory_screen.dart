import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../constant/common_function.dart';
import '../../../controller/provier/product_provier/product_provider.dart';
import '../../../model/product_model.dart';
import '../../../utils/colors.dart';
import '../add_product_screen/add_products.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SellerProductProvider>().fetchSellerProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    child: const AddProductScreen(),
                    type: PageTransitionType.rightToLeft));
          },
          backgroundColor: amber,
          child: Icon(
            Icons.add,
            color: black,
          ),
        ),
        appBar: PreferredSize(
          preferredSize: Size(width, height * 0.1),
          child: Container(
            padding: EdgeInsets.only(
                left: width * 0.03,
                right: width * 0.03,
                bottom: height * 0.012,
                top: height * 0.045),
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
                  image: const AssetImage(
                    'assets/images/amazon_black_logo.png',
                  ),
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
                    color: black,
                    size: height * 0.035,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          width: width,
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.03,
            vertical: height * 0.02,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Consumer<SellerProductProvider>(
                    builder: (context, sellerProductProvider, child) {
                  if (sellerProductProvider.sellerProductsFetched == false) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: amber,
                      ),
                    );
                  } else if (sellerProductProvider.products.isEmpty) {
                    return Center(
                      child: Text(
                        'No Products Found',
                        style: textTheme.bodyMedium,
                      ),
                    );
                  }
                  return ListView.builder(
                      itemCount: sellerProductProvider.products.length,
                      shrinkWrap: true,
                      physics: const PageScrollPhysics(),
                      itemBuilder: (context, index) {
                        ProductModel currentModel =
                            sellerProductProvider.products[index];
                        return Container(
                          height: height * 0.31,
                          width: width,
                          margin: EdgeInsets.symmetric(
                            vertical: height * 0.01,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                              vertical: height * 0.01),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            border: Border.all(
                              color: grey,
                            ),
                          ),
                          child: Column(
                            children: [
                              CarouselSlider(
                                options: CarouselOptions(
                                  height: height * 0.2,
                                  autoPlay: true,
                                  viewportFraction: 1,
                                ),
                                items: currentModel.imagesURL!.map((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: white,
                                          image: DecorationImage(
                                            image: NetworkImage(i),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                              CommonFunction.blankSpace(
                                0,
                                height * 0.02,
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          currentModel.name!,
                                          style: textTheme.bodyMedium!.copyWith(
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          currentModel.description!,
                                          // textAlign: TextAlign.justify,
                                          maxLines: 2,
                                          style: textTheme.bodySmall!.copyWith(
                                              overflow: TextOverflow.ellipsis,
                                              color: grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CommonFunction.blankSpace(
                                    0,
                                    width * 0.02,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          '₹ ${currentModel.discountedPrice.toString()}',
                                          style: textTheme.bodyMedium,
                                        ),
                                        Text(
                                          '₹ ${currentModel.price.toString()}',
                                          style: textTheme.labelMedium!
                                              .copyWith(
                                                  color: grey,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                        ),
                                        Text(
                                          currentModel.inStock!
                                              ? 'in Stock'
                                              : 'Out of Stock',
                                          style: textTheme.bodySmall!.copyWith(
                                              color: currentModel.inStock!
                                                  ? teal
                                                  : red),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      });
                })
              ],
            ),
          ),
        ));
  }
}
