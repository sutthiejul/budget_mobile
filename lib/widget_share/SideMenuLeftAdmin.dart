// ignore_for_file: prefer_const_constructors, file_names

import 'package:budget_mobile/screens/theme/SetTheme.dart';
import 'package:budget_mobile/styles/colors.dart';
import 'package:flutter/material.dart';
import '../admin/ShowAccDetail.dart';
import '../budget/ShowExpedite.dart';
import '../budget/ShowReceiveExpedite.dart';
import '../budget/ShowStartBook.dart';
import '../chat/ChatPerson.dart';
// import '../admin/AddUser.dart';
import '../admin/ShowAcc.dart';
import '../global/MySQLService.dart';
import '../global/globalVar.dart';
import '../global/ManageLogin.dart';
import '../global/ResponseMessage.dart';

var login;

//draw side menu
class SideMenuLeftAdmin extends StatelessWidget {
  // const SideMenuLeftAdmin({Key? key}) : super(key: key);

  SideMenuLeftAdmin() {
    // initHive Box Name : LoginData
    ManageLogin _login = ManageLogin();
    _login.DefineBox().then((box) {
      login = box;
    });
  }

  //late final login;

  //=================set Hive for Global Data===================
  // await Hive.initFlutter();
  // box = await Hive.openBox('LoginData');
  // box.put('aid', dat["aid"]);
  // box.put('userid', dat['userid']);
  // box.put('uid', dat['Uint']);
  // box.put('fullname', dat['fullname']);
  // box.put('mobile', dat["mobile"]);
  // box.put('email', dat['email']);
  // box.put('status', dat["status"]);
  // box.put('token', dat["token"]);

  //============================================================

  String getStatusUser(String i) {
    String str = "";

    switch (i) {
      case '1':
        str = "ผู้ดูแลระบบ";
        break;
      case '2':
        str = "เจ้าหน้าที่";
        break;
      case '3':
        str = "ผู้บังคับบัญชา";
        break;
      case '4':
        str = "ผู้บังคับบัญชาโดยตรง";
        break;
    }

    return str;
  }

  @override
  Widget build(BuildContext context) {
    //=================check token expired===================
    MySQLDB mysql = MySQLDB();
    ResponseMessage resp = new ResponseMessage();

    mysql.VerifyTokenExpireJ6(login.get('token')!).then((result) async {
      if (result.trim() == "") {
        // token expire or invalid
        resp.Alert(context, "Session Expired or Invalid", "Token หมดอายุ !!!");
        mysql.delay(2, () => mysql.redirectSignIn(context));
      }
    });
    //=================================================================

    return Drawer(
      child: Container(
        color: lightpurple2,
        child: SingleChildScrollView(
          child: Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'เมนูหลัก',
                        //textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Row(
                          children: [
                            Text(
                              "ชื่อผู้ใช้ : ",
                              //textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "${login.get('fullname')}",
                              //textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Row(
                          children: [
                            Text(
                              //"สถานะ : ${login.get('status')}",
                              "สถานะ : ",
                              //textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              //"สถานะ : ${login.get('status')}",
                              "${getStatusUser(login.get('status'))}",
                              //textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Row(
                          children: [
                            Text(
                              //"สถานะ : ${login.get('status')}",
                              //"หน่วยงาน : ${getStatusUser(login.get('unitname'))}",
                              "หน่วยงาน : ",
                              //textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              //"สถานะ : ${login.get('status')}",
                              //"หน่วยงาน : ${getStatusUser(login.get('unitname'))}",
                              "${CurrentUnitName}",
                              //textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.cyan.shade50,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(color: bgcolorApp),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text(
                  'ข้อมูลแอคเค้าท์',
                  style: TextStyle(color: Colors.brown, fontSize: 15),
                ),
                onTap:
                    () => {
                      //Navigator.of(context).pop()
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          //builder: (context) => ShowAccountDetail(login.get('aid')),
                          builder:
                              (context) => ShowAccountDetail(login.get('aid')),
                          //builder: (context) => ShowAccount(),
                        ),
                      ),
                    },
              ),
              // ListTile(
              //   leading: const Icon(Icons.person_add),
              //   title: const Text('เพิ่มข้อมูลผู้ใช้'),
              //   onTap: () => {
              //     //Navigator.of(context).pop()
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => AddUser(),
              //       ),
              //     ),
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.border_color),
                title: const Text(
                  'ข้อมูลงบประมาณ(User)',
                  style: TextStyle(color: Colors.brown, fontSize: 15),
                ),
                onTap:
                    () => {
                      //Navigator.of(context).pop()
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShowExpedite()),
                      ),
                    },
              ),

              ListTile(
                leading: const Icon(Icons.border_color),
                title: const Text(
                  'หน่วยต้นเรื่องส่งต่อ',
                  style: TextStyle(color: Colors.brown, fontSize: 15),
                ),
                onTap:
                    () => {
                      //Navigator.of(context).pop()
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowStartBook(),
                        ),
                      ),
                    },
              ),
              ListTile(
                leading: const Icon(Icons.border_color),
                title: const Text(
                  'บันทึกรับงานของหน่วย',
                  style: TextStyle(color: Colors.brown, fontSize: 15),
                ),
                onTap:
                    () => {
                      //Navigator.of(context).pop()
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  ShowReceiveExpedite(login.get('uid')),
                        ),
                      ),
                    },
              ),
              ListTile(
                leading: const Icon(Icons.border_color),
                title: const Text(
                  'Theme-ชุดการแสดงผล',
                  style: TextStyle(color: Colors.brown, fontSize: 15),
                ),
                onTap:
                    () => {
                      //Navigator.of(context).pop()
                      Navigator.pushNamed(context, SetTheme.routeName),
                      /*
                      navigatorKey.currentState?.pushNamedAndRemoveUntil(
                        SignInScreen.routeName,
                        (Route<dynamic> route) => false,
                      );
                      */
                    },
              ),
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text(
                  'คุยกัน',
                  style: TextStyle(color: Colors.brown, fontSize: 15),
                ),
                onTap:
                    () => {
                      //Navigator.of(context).pop()
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPerson(title: ''),
                        ),
                      ),
                    },
              ),
              ListTile(
                //leading: const Icon(Icons.chat),
                title: const Text(
                  '-----------ฟังก์ชันแอดมิน------------',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.manage_accounts),
                title: const Text(
                  'บริหารรายชื่อผู้ใช้',
                  style: TextStyle(color: Colors.brown, fontSize: 15),
                ),
                onTap:
                    () => {
                      //Navigator.of(context).pop()
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShowAccount()),
                      ),
                    },
              ),

              ListTile(
                //leading: const Icon(Icons.chat),
                title: const Text(
                  '------------------------------------------',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.brown, fontSize: 15),
                ),
                onTap:
                    () => {
                      // Navigator.of(context).pushNamedAndRemoveUntil(
                      //     SignInScreen.routeName, (Route<dynamic> route) => false),
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => SignInScreen(),
                      //   ),
                      // ),
                      mysql.delay(2, () => mysql.redirectSignIn(context)),
                    },
              ),
              /* ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Test List Page'),
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TestListPage(),
                    ),
                  ),
                },
              ), */
            ],
          ),
        ),
      ),
    );
  }
}
