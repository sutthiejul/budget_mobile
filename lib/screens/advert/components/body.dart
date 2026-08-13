import 'package:budget_mobile/global/MySQLService.dart';
import 'package:budget_mobile/styles/TextStyle.dart';
import 'package:flutter/material.dart';
import '../../../global/constants.dart';
import '../../../global/BannerMsg.dart';
import '../../../screens/sign_in/sign_in_screen.dart';
import '../../../global/size_config.dart';

// This is the best practice
import '../components/splash_content.dart';
import '../../../styles/colors.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  final TextNetworkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chkNetwork();
  }

  _chkNetwork() async {
    MySQLDB mysql = MySQLDB();
    int _networkOK = await mysql.chkStatusNetwork();
    if (_networkOK == 1) {
      TextNetworkController.text = "สถานะเครือข่ายปกติ";
    } else {
      TextNetworkController.text = "ไม่มีสัญญาณเครือข่าย";
      // final snackBar = SnackBar(
      //   content: const Text('ไม่มีสัญญาณอินเตอร์เน็ต'),
      //   backgroundColor: Colors.red,
      // );
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    TextNetworkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgcolorApp,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder:
                    (context, index) => SplashContent(
                      image: splashData[index]["image"],
                      text: splashData[index]['text'],
                    ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                ),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    Spacer(flex: 1),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: TextNetworkController,
                      builder:
                          (context, value, _) => Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/internet.png",
                                  height: 70.0,
                                  width: 70.0,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  value.text,
                                  style: styleCustom(
                                    "GoogleSans",
                                    16.0,
                                    Colors.white,
                                    FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ),
                    Spacer(flex: 1),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: bPrimaryColor,
                        padding: EdgeInsets.symmetric(
                          vertical: getProportionateScreenHeight(15),
                          horizontal: getProportionateScreenWidth(30),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(14),
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, SignInScreen.routeName);
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: bAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? bPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
