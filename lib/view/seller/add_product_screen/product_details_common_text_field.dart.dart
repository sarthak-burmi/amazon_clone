// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import '../../../constant/common_function.dart';
import '../../../utils/colors.dart';

class AddProductCommonTextfield extends StatelessWidget {
  AddProductCommonTextfield({
    super.key,
    required this.textController,
    required this.hintText,
    required this.title,
    this.textInputType,
  });

  final TextEditingController textController;
  final String title;
  final String hintText;
  TextInputType? textInputType;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.bodyMedium,
        ),
        CommonFunction.blankSpace(
          height * 0.01,
          0,
        ),
        TextField(
          controller: textController,
          keyboardType: textInputType,
          decoration: InputDecoration(
            contentPadding: EdgeInsetsDirectional.symmetric(
              horizontal: width * 0.03,
              vertical: 0,
            ),
            hintText: hintText,
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
      ],
    );
  }
}
