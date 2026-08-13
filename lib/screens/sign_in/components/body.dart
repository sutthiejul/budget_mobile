import 'package:flutter/material.dart';
import '../../../components/no_account_text.dart';
import '../../../global/size_config.dart';
import 'sign_form.dart';
import '../../../styles/TextStyle.dart';
import 'package:budget_mobile/styles/colors.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: lightpurple,
        //color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  Text(
                    'ยินดีต้อนรับเข้าสู่',
                    style: TextStyle(
                      color: blue,
                      fontSize: getProportionateScreenWidth(20),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ThaisarabunNew',
                    ),
                  ),
                  Text(
                    "ระบบติดตามเร่งรัดการใช้จ่ายงบประมาณ สส.ทหาร",
                    style: TextStyle(
                      color: greendark,
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                      //"Sign in with your email and password  \nor continue with social media",
                      "พิสูจน์สิทธิ์การใช้งาน",
                      textAlign: TextAlign.start,
                      //style: styleMedium(Colors.pink.shade200),
                      style: styleCustom('', 20.0, brown, true),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  SignForm(),
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  SizedBox(height: getProportionateScreenHeight(50)),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: NoAccountText(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
