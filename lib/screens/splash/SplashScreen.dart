import 'dart:async';
import '../advert/AdvertScreen.dart';
import 'package:flutter/material.dart';
import '../../styles/colors.dart';
import '../../helper/keyboard.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _SplashScreenState() {}

  @override
  void initState() {
    super.initState();

    const delay = const Duration(seconds: 4);
    Future.delayed(delay, () => onTimerFinished());
  }

  void onTimerFinished() {
    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
        builder: (BuildContext context) {
          return AdvertScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: bgcolorApp,
      body: Center(child: splashScreenIcon(context)),
    );
  }
}

Widget splashScreenIcon(cont) {
  //String iconPath = "assets/icon/splash_screen_icon.svg";
  // return SvgPicture.asset(
  //   iconPath,
  // );
  KeyboardUtil.hideKeyboard(cont);

  return Container(
    //alignment: Alignment.center,
    child: SingleChildScrollView(
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            "assets/images/budget-banner.jpg",
            //fit: BoxFit.cover,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/images/traditional-budgeting.jpg",
              //height: getProportionateScreenHeight(295),
              //width: getProportionateScreenWidth(350),
              //fit: BoxFit.none,
              fit: BoxFit.fitWidth,
              //fit: BoxFit.scaleDown,
            ),
          ),
        ],
      ),
    ),
  );
}
