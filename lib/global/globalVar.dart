// import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//library vars;
const String ipAddSrv = "10.130.228.1"; // flutterBudget
//const String ipAddSrv = "10.130.230.31";
//const String ipAddSrv = "10.130.230.64";
//const String ipAddress = "10.130.234.32";
//const String ipAddress = "172.17.192.1";
//const String ipAddress = "10.130.230.31"; // local ip addr
const String ipAddress = "10.130.228.1";
const String url_node = "10.130.228.3:3000"; //node.js ip addr
//const String url_node = "10.130.230.64:3000"; //node.js ip addr
//const String url_node = "http://172.17.192.1:3000";
//const String url_node = "http://10.130.230.148:3000";

//const String Budget_Site = "budget68";
const String titleApp = "ระบบติดตามเร่งรัด กคง.สส.ทหาร";
const String ownerApp = "CopyRight 2021-2027 by FS1.Sutthie J.";
const String Budget_Site = "budget1";
String SecretKey = "";

// set UserName for ChatPerson
String CurrentUName = "";

// set for UnitName
String CurrentUnitName = "";

// Global navigator key so code outside widgets can perform navigation safely
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// String Aid = "";
// String UserID = "";
// String FullName = "";
// String Token = "";
// String Email = "";
// bool admin=false;

// picture
// const String img_welcome = "welcome.jpg";
// const String img_bfriend = "BeeAuto-Logo-Footer.png";

// Budget
String idExpSpen = "00-0-000-00-00-00";

// set language baht money
// do not remember inclue intl: ^0.19.0 in pubspec.yaml
// CurrencyFormat thBahtSettings = CurrencyFormat(
//   code: 'th',
//   symbol: 'บาท',
//   symbolSide: SymbolSide.right,
//   thousandSeparator: ',',
//   decimalSeparator: '.',
//   symbolSeparator: ' ',
// );

const currencyRegExp = r'^\d+(?:[\.,]\d{0,2})?$';
final currencyFormatter = FilteringTextInputFormatter.allow(
  RegExp(currencyRegExp),
);

const TextInputType keyBoardTypeDecimal = TextInputType.numberWithOptions(
  decimal: true,
);
