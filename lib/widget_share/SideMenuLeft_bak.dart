import 'package:budget_mobile/admin/ShowAccDetail.dart';
import 'package:budget_mobile/styles/colors.dart';
import 'package:flutter/material.dart';
import '../MainPage.dart';
import '../budget/ShowExpedite.dart';
import '../global/ManageLogin.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import '../admin/ShowAcc.dart';
// import '../screens/advert/AdvertScreen.dart';
import '../screens/sign_in/sign_in_screen.dart';
import '../upload/TestFormFileUp.dart';
import '../upload/TestUploadFile.dart';
import '../upload/TestUploadFile1.dart';

var login;

//draw side menu
class SideMenuLeft extends StatelessWidget {
  //SideMenuLeft({Key? key}) : super(key: key);

  SideMenuLeft() {
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
  // box.put('uid', dat['uid']);
  // box.put('fullname', dat['fullname']);
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
    return Drawer(
      child: Container(
        color: lightpurple2,
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
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Text(
                        "ชื่อผู้ใช้ : ${login.get('fullname')}",
                        //textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.yellow, fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(
                        //"สถานะ : ${login.get('status')}",
                        "สถานะ : ${getStatusUser(login.get('status'))}",
                        //textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.cyan.shade50,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(color: bgcolorApp),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                'หน้าหลัก',
                style: TextStyle(color: Colors.brown, fontSize: 18),
              ),
              onTap:
                  () => {
                    //Navigator.of(context).pop()
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MainPage(),
                    //     //builder: (context) => MainScreen(),
                    //     //builder: (context) => AdvertScreen(),
                    //   ),
                    // ),
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      MainPage.routeName,
                      (Route<dynamic> route) => false,
                    ),
                  },
            ),

            /*
           if (admin == true)
              ListTile(
                leading: const Icon(Icons.border_color),
                title: const Text('ปรับปรุงข้อมูลสินค้า'),
                onTap: () => {
                  //Navigator.of(context).pop()
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminProduct(),
                    ),
                  ),
                },
              ),
      */
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(
                'ข้อมูลแอคเค้าท์',
                style: TextStyle(color: Colors.brown, fontSize: 18),
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
            ListTile(
              leading: const Icon(Icons.border_color),
              title: const Text(
                'ข้อมูลงบประมาณ',
                style: TextStyle(color: Colors.brown, fontSize: 18),
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
              leading: const Icon(Icons.chat),
              title: const Text(
                'คุยกัน',
                style: TextStyle(color: Colors.brown, fontSize: 18),
              ),
              onTap:
                  () => {
                    //Navigator.of(context).pop()
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ChatPerson(
                    //       title: '',
                    //     ),
                    //   ),
                    // ),
                  },
            ),

            // if (login.get('status') == '1')
            //   ListTile(
            //     leading: const Icon(Icons.manage_accounts),
            //     title: const Text('บริหารระบบ'),
            //     onTap: () => {
            //       //Navigator.of(context).pop()
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => AdminSystem(),
            //         ),
            //       ),
            //     },
            //   ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.brown, fontSize: 18),
              ),
              onTap:
                  () => {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => SignInScreen(),
                    //   ),
                    // ),
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      SignInScreen.routeName,
                      (Route<dynamic> route) => false,
                    ),
                  },
            ),
            ListTile(
              leading: Icon(Icons.run_circle),
              title: const Text(
                'TestUploadFile',
                style: TextStyle(color: Colors.brown, fontSize: 18),
              ),
              onTap:
                  () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TestUploadFile()),
                    ),
                  },
            ),
            ListTile(
              leading: Icon(Icons.run_circle),
              title: const Text(
                'TestUploadFile1',
                style: TextStyle(color: Colors.brown, fontSize: 18),
              ),
              onTap:
                  () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TestUploadFile1(),
                      ),
                    ),
                  },
            ),
            ListTile(
              leading: Icon(Icons.run_circle),
              title: const Text(
                'Test Form File Upload',
                style: TextStyle(color: Colors.brown, fontSize: 18),
              ),
              onTap:
                  () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TestFormFileUp()),
                    ),
                  },
            ),
          ],
        ),
      ),
    );
  }
}
