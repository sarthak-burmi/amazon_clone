import 'package:amazon_clone/utils/colors.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyAppBar({
    super.key,
  });
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    final width = MediaQuery.of(context).size.width;
    return AppBar(
      backgroundColor: white,
      centerTitle: true,
      title: Image(
        image: AssetImage("assets/images/amazon_logo.png"),
        height: height * 0.04,
      ),
    );
  }
}
