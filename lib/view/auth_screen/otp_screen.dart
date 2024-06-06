import 'package:amazon_clone/constant/common_function.dart';
import 'package:amazon_clone/view/auth_screen/auth_screen.dart';
import 'package:amazon_clone/widgets/app_bar.dart';
import 'package:flutter/material.dart';

import '../../controller/services/auth_services/auth_services.dart';
import '../../utils/colors.dart';

// ignore: must_be_immutable
class OTPScreen extends StatefulWidget {
  OTPScreen({super.key, required this.mobileNumber});
  String mobileNumber;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: MyAppBar(),
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: width * 0.03,
            vertical: height * 0.02,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Authentication Required',
                  style: textTheme.displayMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CommonFunction.blankSpace(height * 0.01, 0),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.mobileNumber,
                        style: textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' Change',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                CommonFunction.blankSpace(
                  height * 0.02,
                  0,
                ),
                Text(
                  'We have send a One Time Password (OTP) to the mobile no. above. Please enter it to complete verification.',
                  style: textTheme.bodyMedium,
                ),
                CommonFunction.blankSpace(
                  height * 0.02,
                  0,
                ),
                TextField(
                  controller: otpController,
                  decoration: InputDecoration(
                    hintText: 'Enter OTP',
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
                  height * 0.01,
                  0,
                ),
                CommonAuthButton(
                  onPressed: () {
                    AuthServices.verifyOTP(
                      context: context,
                      otp: otpController.text.trim(),
                    );
                  },
                  title: "Continue",
                  btnwidth: 0.94,
                ),
                CommonFunction.blankSpace(
                  height * 0.01,
                  0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Resend OTP',
                        style: textTheme.bodyMedium!.copyWith(
                          color: blue,
                        ),
                      ),
                    ),
                  ],
                ),
                CommonFunction.blankSpace(
                  height * 0.02,
                  0,
                ),
                const BottomAuthScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
