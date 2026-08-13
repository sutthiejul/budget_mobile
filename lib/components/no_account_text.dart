import 'package:flutter/material.dart';
import 'package:budget_mobile/global/ResponseMessage.dart';
import '../global//constants.dart';
import '../global/size_config.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "ถ้าไม่มีแอคเค้าท์??? ",
          style: TextStyle(fontSize: getProportionateScreenWidth(15)),
        ),
        GestureDetector(
          //onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
          onTap: () {
            ResponseMessage msg = new ResponseMessage();
            msg.Alert(context, "ติดต่อแอดมิน", "Line ID: sjsell");
            // Navigator.pushNamed(context, SignUpScreen.routeName);
          },
          child: Text(
            "ลงทะเบียนใหม่",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(15),
              color: bPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
