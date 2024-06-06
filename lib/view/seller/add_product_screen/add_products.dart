// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:amazon_clone/constant/common_function.dart';
import 'package:amazon_clone/view/seller/add_product_screen/product_details_common_text_field.dart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../constant/constant.dart';
import '../../../controller/provier/product_provier/product_provider.dart';
import '../../../controller/services/product_services/product_services.dart';
import '../../../model/product_model.dart';
import '../../../utils/colors.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController brandNameController = TextEditingController();
  TextEditingController manufacturerNameController = TextEditingController();
  TextEditingController countryOfOriginController = TextEditingController();
  TextEditingController productSpecificationsController =
      TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController discountedProductPriceController =
      TextEditingController();
  String dropDownValue = 'Select Category';
  bool addProductBtnPressed = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        addProductBtnPressed = false;
      });
    });
  }

  onPressed() async {
    FirebaseFirestore.setLoggingEnabled(true);
    if (context.read<SellerProductProvider>().productImages.isNotEmpty) {
      setState(() {
        addProductBtnPressed = true;
      });
      await ProductServices.uploadImageToFirebaseStorage(
          images: context.read<SellerProductProvider>().productImages,
          context: context);
      List<String> imagesURLs =
          context.read<SellerProductProvider>().productImagesURL;
      Uuid uuid = const Uuid();
      String sellerID = auth.currentUser!.phoneNumber!;
      String productID = '$sellerID${uuid.v1()}';
      double discountAmount = double.parse(productPriceController.text.trim()) -
          double.parse(discountedProductPriceController.text.trim());
      double discountPercentage =
          (discountAmount / double.parse(productPriceController.text.trim())) *
              100;
      ProductModel model = ProductModel(
        imagesURL: imagesURLs,
        name: productNameController.text.trim(),
        category: dropDownValue,
        description: productDescriptionController.text.trim(),
        brandName: brandNameController.text.trim(),
        manufacturerName: manufacturerNameController.text.trim(),
        countryOfOrigin: countryOfOriginController.text.trim(),
        specifications: productSpecificationsController.text.trim(),
        price: double.parse(productPriceController.text.trim()),
        discountedPrice:
            double.parse(discountedProductPriceController.text.trim()),
        productID: productID,
        productSellerID: sellerID,
        inStock: true,
        uploadedAt: DateTime.now(),
        discountPercentage: int.parse(
          discountPercentage.toStringAsFixed(0),
        ),
      );

      await ProductServices.addProduct(context: context, productModel: model);
      CommonFunction.showSuccessToast(
          context: context, message: 'Product Added Successful');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.1),
        child: AddProductAppBar(
            width: width, height: height, textTheme: textTheme),
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
              ProductImageBanner(
                  height: height, width: width, textTheme: textTheme),
              CommonFunction.blankSpace(height * 0.02, 0),
              productDetails(height, textTheme, width),
              CommonFunction.blankSpace(height * 0.03, 0),
              ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: amber,
                    minimumSize: Size(
                      width,
                      height * 0.06,
                    ),
                  ),
                  child: addProductBtnPressed
                      ? CircularProgressIndicator(
                          color: white,
                        )
                      : Text(
                          'Add Product',
                          style: textTheme.bodyMedium,
                        )),
              CommonFunction.blankSpace(height * 0.03, 0),
            ],
          ),
        ),
      ),
    );
  }

  Column productDetails(double height, TextTheme textTheme, double width) {
    return Column(
      children: [
        AddProductCommonTextfield(
          title: 'Product Name',
          hintText: '',
          textController: productNameController,
        ),
        CommonFunction.blankSpace(height * 0.015, 0),
        productCategoryDropdown(textTheme, height, width),
        CommonFunction.blankSpace(height * 0.015, 0),
        AddProductCommonTextfield(
          title: 'Description',
          hintText: 'Description',
          textController: productDescriptionController,
        ),
        CommonFunction.blankSpace(height * 0.015, 0),
        AddProductCommonTextfield(
          title: 'Manufacturer Name',
          hintText: '',
          textController: manufacturerNameController,
        ),
        CommonFunction.blankSpace(height * 0.015, 0),
        AddProductCommonTextfield(
          title: 'Brand Name',
          hintText: '',
          textController: brandNameController,
        ),
        CommonFunction.blankSpace(height * 0.015, 0),
        AddProductCommonTextfield(
          title: 'Country of Origin',
          hintText: '',
          textController: countryOfOriginController,
        ),
        CommonFunction.blankSpace(height * 0.015, 0),
        AddProductCommonTextfield(
          title: 'Product Specification',
          hintText: 'Specification',
          textController: productSpecificationsController,
        ),
        CommonFunction.blankSpace(height * 0.015, 0),
        AddProductCommonTextfield(
          title: 'Product Price',
          hintText: 'Price',
          textController: productPriceController,
          textInputType: TextInputType.number,
        ),
        CommonFunction.blankSpace(height * 0.015, 0),
        AddProductCommonTextfield(
          title: 'Discounted Product Price',
          hintText: 'Discounted Price',
          textController: discountedProductPriceController,
          textInputType: TextInputType.number,
        ),
      ],
    );
  }

  Column productCategoryDropdown(
      TextTheme textTheme, double height, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Category',
          style: textTheme.bodyMedium,
        ),
        CommonFunction.blankSpace(
          height * 0.01,
          0,
        ),
        Container(
          height: height * 0.06,
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              10,
            ),
            border: Border.all(
              color: grey,
            ),
          ),
          child: DropdownButton(
            value: dropDownValue,
            underline: const SizedBox(),
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: productCategories.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  dropDownValue = newValue;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}

class AddProductAppBar extends StatelessWidget {
  const AddProductAppBar({
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
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Add Product',
            style:
                textTheme.displayMedium!.copyWith(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class ProductImageBanner extends StatelessWidget {
  const ProductImageBanner({
    super.key,
    required this.height,
    required this.width,
    required this.textTheme,
  });

  final double height;
  final double width;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Consumer<SellerProductProvider>(
        builder: (context, productProvider, child) {
      return Builder(builder: (context) {
        if (productProvider.productImages.isEmpty) {
          return InkWell(
            onTap: () {
              context
                  .read<SellerProductProvider>()
                  .fetchProductImagesFromGallery(context: context);
            },
            child: Container(
              height: height * 0.23,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: greyShade3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    size: height * 0.09,
                    color: greyShade3,
                  ),
                  Text(
                    'Add Product',
                    style: textTheme.displayMedium!.copyWith(
                      color: greyShade3,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          List<File> images =
              context.read<SellerProductProvider>().productImages;
          return Container(
            height: height * 0.23,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: greyShade3,
              ),
            ),
            padding: EdgeInsets.all(5),
            child: CarouselSlider(
              carouselController: CarouselController(),
              options: CarouselOptions(
                height: height * 0.23,
                autoPlay: true,
                viewportFraction: 1,
              ),
              items: images.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: white,
                        image: DecorationImage(
                          image: FileImage(File(i.path)),
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          );
        }
      });
    });
  }
}
