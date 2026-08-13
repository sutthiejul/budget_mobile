import 'package:flutter/material.dart';
import '../../../styles/TextStyle.dart';
import '../../../global/size_config.dart';
import '../../../styles/colors.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({Key? key, this.text, this.image}) : super(key: key);
  final String? text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Text(
          "DJC Budget Mobile",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(30),
            color: txtColor4,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text!,
          textAlign: TextAlign.center,
          //style: TextStyle(fontWeight: FontWeight.normal),
          style: styleSmall(txtColor3),
        ),
        Spacer(flex: 1),
        Flexible(
          flex: 5, // Increase flex value to make the image bigger
          child: Image.asset(
            image!,
            //height: MediaQuery.of(context).size.height * 1.0,
            //width: getProportionateScreenWidth(235),
            //height: getProportionateScreenHeight(295), // Remove fixed height
            //width: MediaQuery.of(context).size.width * 1.0,
            //width: getProportionateScreenWidth(350),
            fit: BoxFit.contain, // Use contain to maintain aspect ratio
            //fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }
}
