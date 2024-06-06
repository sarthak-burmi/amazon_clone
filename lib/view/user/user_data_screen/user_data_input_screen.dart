import 'package:amazon_clone/constant/common_function.dart';
import 'package:amazon_clone/constant/constant.dart';
import 'package:amazon_clone/controller/services/user_data_crud_service/user_data_CRUD_services.dart';
import 'package:flutter/material.dart';

import '../../../model/user_model.dart';
import '../../../utils/colors.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key});

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      phoneController.text = auth.currentUser!.phoneNumber ?? '';
    });
  }

  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.1),
        child: UserDataScrnAppBar(width: width, height: height),
      ),
      body: Container(
        // height: height,
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.02,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help us about knowing you more',
              style:
                  textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            CommonFunction.blankSpace(
              height * 0.03,
              0,
            ),
            Text(
              'Enter your Name',
              style: textTheme.bodyMedium,
            ),
            CommonFunction.blankSpace(
              height * 0.01,
              0,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                hintStyle: textTheme.bodySmall,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: secondaryColor,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
              ),
            ),
            CommonFunction.blankSpace(
              height * 0.02,
              0,
            ),
            Text(
              'Phone Number',
              style: textTheme.bodyMedium,
            ),
            CommonFunction.blankSpace(
              height * 0.01,
              0,
            ),
            TextField(
              controller: phoneController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Enter your phone number',
                hintStyle: textTheme.bodySmall,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: secondaryColor,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () async {
                  UserModel userModel = UserModel(
                    name: nameController.text.trim(),
                    mobileNum: phoneController.text.trim(),
                    userType: 'user',
                  );
                  await UserDataCRUD.addNewUser(
                      userModel: userModel, context: context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: amber,
                  minimumSize: Size(
                    width,
                    height * 0.06,
                  ),
                ),
                child: Text('Proceed', style: textTheme.bodyMedium))
          ],
        ),
      ),
    );
  }
}

class UserDataScrnAppBar extends StatelessWidget {
  const UserDataScrnAppBar({
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
