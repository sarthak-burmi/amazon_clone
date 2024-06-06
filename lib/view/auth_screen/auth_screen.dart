import 'package:amazon_clone/constant/common_function.dart';
import 'package:amazon_clone/utils/colors.dart';
// import 'package:amazon_clone/view/auth_screen/otp_screen.dart';
// import 'package:amazon_clone/view/home_screen.dart';
import 'package:amazon_clone/widgets/app_bar.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

import '../../controller/services/auth_services/auth_services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool inLogin = true;
  String currentcountryCode = '+91';
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: white,
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          //main Container
          child: Container(
            height: height,
            width: width,
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: width * 0.03,
              vertical: height * 0.02,
            ),
            //column1
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome",
                  style: textTheme.displaySmall!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                CommonFunction.blankSpace(height * 0.02, 0),
                Builder(
                  builder: (context) {
                    if (inLogin) {
                      return signIn(width, height, textTheme, context);
                    }
                    return createAccount(width, height, textTheme, context);
                  },
                ),
                //signIn(width, height, textTheme, context),
                //createAccount(width, height, textTheme, context),
                CommonFunction.blankSpace(height * 0.05, 0),
                // bottom text column
                const BottomAuthScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // create accout and sign in option container
  Container signIn(
      double width, double height, TextTheme textTheme, BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
          color: greyShade3,
        ),
      ),
      // create account and sign in option column
      child: Column(
        children: [
          //create account container
          Container(
            height: height * 0.06,
            width: width,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: greyShade3),
              ),
              color: greyShade1,
            ),
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: width * 0.03,
            ),
            // create account row
            child: Row(
              children: [
                //Selection Circle icon
                InkWell(
                  onTap: () {
                    setState(() {
                      inLogin = false;
                    });
                  },
                  child: Container(
                    height: height * 0.03,
                    width: height * 0.03,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: grey),
                      color: white,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.circle,
                      size: height * 0.02,
                      color: inLogin ? transparent : secondaryColor,
                    ),
                  ),
                ),
                CommonFunction.blankSpace(0, width * 0.02),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Create Account.",
                        style: textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " New to Amazon?",
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          // SignIn Container
          Container(
            width: width,
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
              vertical: height * 0.01,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    //Selection Circle icon
                    InkWell(
                      onTap: () {
                        setState(() {
                          inLogin = true;
                        });
                      },
                      child: Container(
                        height: height * 0.03,
                        width: height * 0.03,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: grey),
                          color: white,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.circle,
                          size: height * 0.02,
                          color: inLogin ? secondaryColor : transparent,
                        ),
                      ),
                    ),
                    CommonFunction.blankSpace(0, width * 0.02),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Sign in.",
                            style: textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: " Already a customer?",
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                CommonFunction.blankSpace(height * 0.01, 0),
                // Country Code and phone number textfield
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // country code picker
                    InkWell(
                      onTap: () {
                        showCountryPicker(
                          searchAutofocus: true,
                          context: context,
                          onSelect: (val) {
                            setState(
                              () {
                                currentcountryCode = '+${val.phoneCode}';
                              },
                            );
                          },
                          showPhoneCode: true,
                        );
                      },
                      child: Container(
                        height: height * 0.06,
                        width: width * 0.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: grey),
                          color: greyShade2,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          currentcountryCode,
                          style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    // enter phone number textfield
                    SizedBox(
                      height: height * 0.06,
                      width: width * 0.65,
                      child: TextFormField(
                        controller: phoneNumber,
                        cursorColor: black,
                        keyboardType: TextInputType.number,
                        style: textTheme.displaySmall,
                        decoration: InputDecoration(
                          hintText: 'Mobile Number',
                          hintStyle: textTheme.bodySmall,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: secondaryColor),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                CommonFunction.blankSpace(height * 0.02, 0),
                //continue button
                CommonAuthButton(
                  title: 'Continue',
                  onPressed: () {
                    AuthServices.receiveOTP(
                        context: context,
                        mobileNo:
                            '$currentcountryCode${phoneNumber.text.trim()}');
                  },
                  btnwidth: 0.88,
                ),
                CommonFunction.blankSpace(height * 0.02, 0),
                // Privacy policy text
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "By continuing ou agree to Amazons's",
                        style: textTheme.labelMedium,
                      ),
                      TextSpan(
                        text: "Condition of use ",
                        style: textTheme.labelMedium!.copyWith(color: blue),
                      ),
                      TextSpan(
                        text: "and ",
                        style: textTheme.labelMedium,
                      ),
                      TextSpan(
                        text: "Privacy Notice",
                        style: textTheme.labelMedium!.copyWith(color: blue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container createAccount(
      double width, double height, TextTheme textTheme, BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
          color: greyShade3,
        ),
      ),
      // create account and sign in option column
      child: Column(
        children: [
          // Create account Container
          Container(
            width: width,
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
              vertical: height * 0.01,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    //Selection Circle icon
                    InkWell(
                      onTap: () {
                        setState(() {
                          inLogin = false;
                        });
                      },
                      child: Container(
                        height: height * 0.03,
                        width: height * 0.03,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: grey),
                          color: white,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.circle,
                          size: height * 0.02,
                          color: inLogin ? transparent : secondaryColor,
                        ),
                      ),
                    ),
                    CommonFunction.blankSpace(0, width * 0.02),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Create Account.",
                            style: textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: " New to Amazon?",
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                CommonFunction.blankSpace(height * 0.01, 0),
                // enter name textfield
                SizedBox(
                  height: height * 0.06,
                  child: TextFormField(
                    controller: nameController,
                    cursorColor: black,
                    keyboardType: TextInputType.number,
                    style: textTheme.displaySmall,
                    decoration: InputDecoration(
                      hintText: 'First and Last Name',
                      hintStyle: textTheme.bodySmall,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: secondaryColor),
                      ),
                    ),
                  ),
                ),
                CommonFunction.blankSpace(height * 0.01, 0),
                // Country Code and phone number textfield
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // country code picker
                    InkWell(
                      onTap: () {
                        showCountryPicker(
                          searchAutofocus: true,
                          context: context,
                          onSelect: (val) {
                            setState(
                              () {
                                currentcountryCode = '+${val.phoneCode}';
                              },
                            );
                          },
                          showPhoneCode: true,
                        );
                      },
                      child: Container(
                        height: height * 0.06,
                        width: width * 0.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: grey),
                          color: greyShade2,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          currentcountryCode,
                          style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // enter phone number textfield
                    SizedBox(
                      height: height * 0.06,
                      width: width * 0.65,
                      child: TextFormField(
                        controller: phoneNumber,
                        cursorColor: black,
                        keyboardType: TextInputType.number,
                        style: textTheme.displaySmall,
                        decoration: InputDecoration(
                          hintText: 'Mobile Number',
                          hintStyle: textTheme.bodySmall,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: secondaryColor),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                CommonFunction.blankSpace(height * 0.02, 0),
                Text(
                  "By enrolling your mobile phone number, you concent to receive automated security notifications via text message from Amazon.\nMessage and data rates may apply.",
                  style: textTheme.bodyMedium,
                ),
                CommonFunction.blankSpace(height * 0.02, 0),
                //continue button
                CommonAuthButton(
                  onPressed: () {
                    AuthServices.receiveOTP(
                        context: context,
                        mobileNo:
                            '+$currentcountryCode${phoneNumber.text.trim()}');
                  },
                  title: 'Verify Mobile Number',
                  btnwidth: 0.88,
                ),
                CommonFunction.blankSpace(height * 0.02, 0),
                // Privacy policy text
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "By continuing ou agree to Amazons's",
                        style: textTheme.labelMedium,
                      ),
                      TextSpan(
                        text: "Condition of use ",
                        style: textTheme.labelMedium!.copyWith(color: blue),
                      ),
                      TextSpan(
                        text: "and ",
                        style: textTheme.labelMedium,
                      ),
                      TextSpan(
                        text: "Privacy Notice",
                        style: textTheme.labelMedium!.copyWith(color: blue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // sign in Container
          Container(
            height: height * 0.06,
            width: width,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: greyShade3),
              ),
              color: greyShade1,
            ),
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: width * 0.03,
            ),
            // create account row
            child: Row(
              children: [
                //Selection Circle icon
                InkWell(
                  onTap: () {
                    setState(() {
                      inLogin = true;
                    });
                  },
                  child: Container(
                    height: height * 0.03,
                    width: height * 0.03,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: grey),
                      color: white,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.circle,
                      size: height * 0.02,
                      color: inLogin ? secondaryColor : transparent,
                    ),
                  ),
                ),
                CommonFunction.blankSpace(0, width * 0.02),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Sign In.",
                        style: textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " Already a customer?",
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CommonAuthButton extends StatelessWidget {
  CommonAuthButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.btnwidth,
  });
  String title;
  VoidCallback onPressed;
  double btnwidth;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: amber,
          minimumSize: Size(width * btnwidth, height * 0.06)),
      child: Text(
        title,
        style: textTheme.displaySmall!.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class BottomAuthScreen extends StatelessWidget {
  const BottomAuthScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Container(
          height: 2,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [white, greyShade3, white],
            ),
          ),
        ),
        CommonFunction.blankSpace(height * 0.02, 0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Condition of Use",
              style: textTheme.bodyMedium!.copyWith(color: blue),
            ),
            Text(
              "Privacy Note",
              style: textTheme.bodyMedium!.copyWith(color: blue),
            ),
            Text(
              "Help",
              style: textTheme.bodyMedium!.copyWith(color: blue),
            ),
          ],
        ),
        CommonFunction.blankSpace(height * 0.01, 0),
        Text(
          "© 1996-2023, Amazon.com, Inc. or its affiliates",
          style: textTheme.labelMedium!.copyWith(color: grey),
        )
      ],
    );
  }
}
