import 'package:amazon_clone/constant/common_function.dart';
import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width * 1, height * 0.1),
        child: const HomePageAppBar(),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.03,
            vertical: height * 0.02,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: appBarGradientColor,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Column(
            children: [
              GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.7),
                  shrinkWrap: true,
                  physics: const PageScrollPhysics(),
                  itemCount: 18,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage('assets/images/menu_pics/$index.png'),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        border: Border.all(
                          color: greyShade3,
                        ),
                      ),
                    );
                  }),
              CommonFunction.blankSpace(
                height * 0.02,
                0,
              ),
              ListView.builder(
                  itemCount: 2,
                  shrinkWrap: true,
                  physics: const PageScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: height * 0.005),
                      padding: EdgeInsets.symmetric(
                        vertical: height * 0.005,
                        horizontal: width * 0.03,
                      ),
                      height: height * 0.06,
                      width: width,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        border: Border.all(
                          color: teal,
                        ),
                      ),
                      child: Row(children: [
                        Text(
                          index == 0 ? 'Settings' : 'Customer Service',
                          style: textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: black,
                        )
                      ]),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar({
    super.key,
  });

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
          SizedBox(
            width: width * 0.81,
            child: TextField(
              cursorColor: black,
              decoration: InputDecoration(
                fillColor: white,
                filled: true,
                prefixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search, color: black),
                ),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.qr_code_scanner, color: black),
                ),
                hintText: "Search Amazon.in",
                contentPadding: EdgeInsetsDirectional.symmetric(
                  horizontal: width * 0.03,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.mic,
              color: black,
            ),
          ),
        ],
      ),
    );
  }
}
