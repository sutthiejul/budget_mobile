import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import '../global/constants.dart';

ThemeData theme() {
  return ThemeData(
    //scaffoldBackgroundColor: Colors.blue,
    scaffoldBackgroundColor: bgcolorTitlebar,
    fontFamily: "Muli",
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: BorderSide(color: bTextColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    // If  you are using latest version of flutter then lable text and hint text shown like this
    // if you r using flutter less then 1.20.* then maybe this is not working properly
    // if we are define our floatingLabelBehavior in our theme then it's not applayed
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}

TextTheme textTheme() {
  return TextTheme(
    bodyLarge: TextStyle(color: bTextColor),
    bodyMedium: TextStyle(color: bTextColor),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    //color: Colors.blue,
    backgroundColor: bgcolorTitlebar,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    toolbarTextStyle:
        TextTheme(
          titleLarge: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
        ).bodyMedium,
    titleTextStyle:
        TextTheme(
          titleLarge: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
        ).titleLarge,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );
}
