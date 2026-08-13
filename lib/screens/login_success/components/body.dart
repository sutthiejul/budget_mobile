import 'package:budget_mobile/MainPage.dart';
import 'package:budget_mobile/MainPageAdmin.dart';
import 'package:budget_mobile/budget/ShowReceiveExpedite.dart';
import 'package:flutter/material.dart';
import '../../../components/default_button.dart';
//import '../../../screens/home/MainScreen.dart';
import '../../../../global/size_config.dart';
import '../../../global/GetYearBudget.dart';
import '../../../global/ManageLogin.dart';
import '../../../global/MySQLService.dart';

var login;

// ignore: must_be_immutable
class Body extends StatelessWidget {
  late String uid;
  //late String status;
  //String cnt_work = "";
  late int yearBud;

  final txtIncome = TextEditingController();
  final txtcntSend = TextEditingController();

  Body() {
    yearBud = GetYearBudget.getYearBudget();
    print("Year Budget : " + yearBud.toString());

    ManageLogin _login = ManageLogin();
    // box.put('status', dat["status"]);
    // box.put('token', dat["token"]);
    _login.DefineBox().then((box) {
      login = box;
      uid = login.get('uid').toString();
      //status = login.get('status').toString();
      // print("UID : " + uid);
      // print("Status : " + status);

      //Get Status Income Job
      MySQLDB mydb = MySQLDB();
      mydb.getStatusInCome(uid, yearBud.toString()).then((String result) {
        print(result);

        txtIncome.text = result;
      });

      //Get Status Send Job
      mydb.getStatusSend(uid, yearBud.toString()).then((String result) {
        print(result);

        txtcntSend.text = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle styleLabel = const TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    final TxtField_cntIncome = TextField(
      controller: txtIncome,
      readOnly: true,
      textAlign: TextAlign.center,
      style: styleLabel,
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.all(3),
      ),
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ShowReceiveExpedite(uid)),
          (Route<dynamic> route) => false,
        );
      },
    );

    final TxtField_cntSend = TextField(
      controller: txtcntSend,
      readOnly: true,
      textAlign: TextAlign.center,
      style: styleLabel,
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.all(3),
      ),
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ShowReceiveExpedite(uid)),
          (Route<dynamic> route) => false,
        );
      },
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(height: SizeConfig.screenHeight * 0.04),
          Image.asset(
            "assets/images/success.png",
            height: SizeConfig.screenHeight * 0.4, //40%
          ),
          // SizedBox(height: SizeConfig.screenHeight * 0.08),
          Text(
            "Login Success",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(30),
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent.shade700,
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.01),
          Text(
            "มีงานยังไม่ได้รับ",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
          ),
          SizedBox(height: 8),
          TxtField_cntIncome,
          SizedBox(height: SizeConfig.screenHeight * 0.01),
          Text(
            "มีงานยังไม่ได้ส่ง",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              fontWeight: FontWeight.bold,
              color: Colors.lightGreenAccent,
            ),
          ),
          SizedBox(height: 8),
          TxtField_cntSend,
          SizedBox(height: SizeConfig.screenHeight * 0.01),
          SizedBox(
            width: SizeConfig.screenWidth * 0.6,
            child: DefaultButton(
              text: "ไปหน้าหลัก",
              press: () {
                if (login.get('status') == '1')
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPageAdmin()),
                  );
                else
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    MainPage.routeName,
                    (Route<dynamic> route) => true,
                  );
                // Navigator.pushReplacementNamed(context, MainPage.routeName);
              },
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.03),
        ],
      ),
    );
  }
}
