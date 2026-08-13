import 'package:flutter/material.dart';

class SJButton extends StatelessWidget {
  const SJButton({
    Key? key,
    this.text,
    this.press,
    required this.bgcolor,
    required this.txtcolor,
    required this.width,
    required this.height,
    required this.radius,
  }) : super(key: key);

  final String? text;
  final Function? press;
  final Color bgcolor;
  final Color txtcolor;
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (width == 1) ? double.maxFinite : width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: txtcolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          backgroundColor: bgcolor,
        ),
        onPressed: press as void Function()?,
        child: Text(text!, style: TextStyle(fontSize: 25, color: txtcolor)),
      ),
    );
  }
}
