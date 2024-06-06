import 'package:amazon_clone/controller/services/user_data_crud_service/user_data_CRUD_services.dart';
import 'package:amazon_clone/model/address_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../constant/common_function.dart';
import '../../../constant/constant.dart';
import '../../../utils/colors.dart';
import 'address_screen_text_field.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController homeNoController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController landMarkController = TextEditingController();
  TextEditingController pinCodeNoController = TextEditingController();
  TextEditingController townController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.1),
        child: AddressScreenAppBar(width: width, height: height),
      ),
      body: Container(
        width: width,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AddressScreenTextfield(
                textController: nameController,
                hintText: "Enter your name",
                title: "Enter your name",
              ),
              CommonFunction.blankSpace(height * 0.02, 0),
              AddressScreenTextfield(
                textController: mobileNoController,
                hintText: "Enter your Mobile No.",
                title: "Enter your Mobile Number",
              ),
              CommonFunction.blankSpace(height * 0.02, 0),
              AddressScreenTextfield(
                textController: homeNoController,
                hintText: "Enter your House No.",
                title: "Enter your House No.",
              ),
              CommonFunction.blankSpace(height * 0.02, 0),
              AddressScreenTextfield(
                textController: areaController,
                hintText: "Enter your Area",
                title: "Area & Locality",
              ),
              CommonFunction.blankSpace(height * 0.02, 0),
              AddressScreenTextfield(
                textController: landMarkController,
                hintText: "Enter Landmark",
                title: "Landmark",
              ),
              CommonFunction.blankSpace(height * 0.02, 0),
              AddressScreenTextfield(
                textController: pinCodeNoController,
                hintText: "Enter your PINCODE",
                title: "Pin Code",
              ),
              CommonFunction.blankSpace(height * 0.02, 0),
              AddressScreenTextfield(
                textController: townController,
                hintText: "Enter your Town",
                title: "Town",
              ),
              CommonFunction.blankSpace(height * 0.02, 0),
              AddressScreenTextfield(
                textController: stateController,
                hintText: "Enter your State",
                title: "State",
              ),
              CommonFunction.blankSpace(height * 0.04, 0),
              ElevatedButton(
                onPressed: () {
                  Uuid uuid = Uuid();
                  String docID = uuid.v1();
                  AddressModel addressModel = AddressModel(
                    name: nameController.text.trim(),
                    mobileNumber: mobileNoController.text.trim(),
                    authenticatedMobileNumber: auth.currentUser!.phoneNumber,
                    houseNumber: homeNoController.text.trim(),
                    area: areaController.text.trim(),
                    landMark: landMarkController.text.trim(),
                    pincode: pinCodeNoController.text.trim(),
                    town: townController.text.trim(),
                    state: stateController.text.trim(),
                    docID: docID,
                    isDefault: true,
                  );
                  UserDataCRUD.addUserAddress(
                    context: context,
                    addressModel: addressModel,
                    docID: docID,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: amber,
                  minimumSize: Size(width, height * 0.06),
                ),
                child: Text("Add Address", style: textTheme.bodyMedium),
              ),
              CommonFunction.blankSpace(height * 0.02, 0),
            ],
          ),
        ),
      ),
    );
  }
}

class AddressScreenAppBar extends StatelessWidget {
  const AddressScreenAppBar({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.only(
          end: width * 0.03,
          start: width * 0.03,
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(
            image: const AssetImage("assets/images/amazon_black_logo.png"),
            height: height * 0.04,
          ),
        ],
      ),
    );
  }
}
