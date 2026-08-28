// ignore_for_file: prefer_const_constructors, file_names
import 'dart:convert';
import 'dart:developer';

import 'package:budget_mobile/admin/ShowAcc.dart';
//import 'package:budget_mobile/global/constants.dart';
import 'package:budget_mobile/styles/TextStyle.dart';
import 'package:budget_mobile/styles/colors.dart';
import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import '../global/MySQLService.dart';
import '../global/ResponseMessage.dart';
//import 'ShowAcc.dart';
// import '../global/globalVar.dart';
import '../models/Account.dart';
import '../models/UnitName.dart';
import '../global/ManageLogin.dart';

var login;

class EditAccDetail extends StatefulWidget {
  //const ShowAccountDetail({Key? key}) : super(key: key);
  final String aid;
  EditAccDetail(this.aid) {
    print("aid : " + this.aid);
  }

  @override
  _EditAccDetailState createState() => _EditAccDetailState();
}

class _EditAccDetailState extends State<EditAccDetail> {
  final oneSecond = Duration(seconds: 1);
  //String Token = "";
  //String FullName = "";
  //String Email = "";
  //String Status = "";

  //String unitNow = "30";
  late String? unitNow;

  late Future<List<UnitName>?> unitList;

  _EditAccDetailState() {
    // init 1 sec

    // initHive Box Name : LoginData
    ManageLogin _login = ManageLogin();
    _login.DefineBox().then((box) {
      login = box;

      print('status : ' + login.get('status'));
      print('uid : ' + login.get('uid'));

      //unitNow = login.get('uid');
    });

    //print('get status after get box : ' + login.get('status'));

    //unitNow = login.get('uid');
  }

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

  // DefineBox() async {
  //   await Hive.initFlutter();
  //   box = await Hive.openBox('GlobalData');
  //   // get from Hive
  //   Aid = box.get('aid');
  //   Status = box.get('status');
  //   FullName = box.get('fullname');
  //   // Email = box.get('email');
  //   Token = box.get('token');
  // }

  //=====define TextEditingController======
  final txtUser = TextEditingController();
  final txtPwd = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtMobile = TextEditingController();
  // final txtStatus = TextEditingController();

  // define FocusNode
  final FocusNode _focus = FocusNode(); // username
  final FocusNode _nextFocus1 = FocusNode(); //pwd
  final FocusNode _nextFocus2 = FocusNode(); //firstname
  final FocusNode _nextFocus3 = FocusNode(); //lastname
  final FocusNode _nextFocus4 = FocusNode(); //mobile
  final FocusNode _nextFocusBSave = FocusNode(); // button save
  final FocusNode ddlNode = FocusNode(); // ddl
  // defind string

  String fname = "";
  String lname = "";
  String userid = "";
  String password = "";
  String mobile = "";
  String uid = "";

  @override
  void initState() {
    super.initState();

    MySQLDB mydb = MySQLDB();
    //===init Unit ==================
    unitNow = null;
    unitList = mydb.getUnitList();

    // mydb.getUnitList().then((value) {
    //   unitList = value!;
    // });
    //=====init Data=================

    mydb.getAccDetail(widget.aid).then((Account? result) {
      setState(() {
        fname = result!.firstname;
        lname = result.lastname;
        userid = result.userid;
        password = result.passwords;
        mobile = result.mobile;
        uid = result.uid.toString();
        unitNow = uid;
      });

      txtFirstName.text = fname;
      txtLastName.text = lname;
      txtUser.text = userid;
      txtPwd.text = password;
      txtMobile.text = mobile;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //====TextStyle========

    TextStyle styleHead1 = const TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.brown,
    );

    TextStyle styleNormal = const TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16.0,
      color: Colors.black,
    );

    // ignore: unused_local_variable
    TextStyle styleLabel = const TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16.0,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      //backgroundColor: Colors.white,
    );

    // ignore: unused_local_variable
    TextStyle styleError = const TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 18.0,
      color: Colors.red,
    );

    //======define ddl widget=======
    Widget ddlUnit(udata) {
      return FutureBuilder<List<UnitName>?>(
        future: udata,
        //builder: (BuildContext context, AsyncSnapshot<List<UnitName>?> snapshot) {
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return CircularProgressIndicator();
          //return Center(child: CircularProgressIndicator());
          else
            return DropdownButton<String>(
              focusNode: ddlNode,
              isExpanded: true,
              underline: SizedBox.shrink(),
              borderRadius: BorderRadius.circular(10),
              items:
                  snapshot.data
                      ?.map(
                        (item) => DropdownMenuItem<String>(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item.uint_name,
                              style: TextStyle(
                                //backgroundColor: white,
                                decoration: TextDecoration.underline,
                                color: Colors.blueAccent.shade700,
                                //backgroundColor: lightgreen
                              ),
                            ),
                          ),
                          value: item.uint,
                        ),
                      )
                      .toList(),
              value: unitNow,
              //value: "",
              //value: null,
              onChanged: (un) {
                setState(() {
                  unitNow = un.toString();
                });
                // ignore: unused_local_variable
                var msg = new ResponseMessage();
                //msg.Alert(context, "เลือกหน่วยงาน", unitNow.toString());
              },
              //isExpanded: true,
              hint: Text('กรุณาเลือกหน่วยที่ต้องการ'),
              disabledHint: Text("Disabled"),
              elevation: 8,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
              //style: Theme.of(context).textTheme.labelMedium,
              //style: Theme.of(context).textTheme.bodyText2,
              //dropdownColor: Colors.white,
              dropdownColor: lightyellow2,
              //focusColor: Colors.yellow.shade100,
              icon: Icon(Icons.arrow_drop_down_circle),
              iconDisabledColor: Colors.red,
              iconEnabledColor: Colors.blue,
              iconSize: 30,
            );
        },
      );
    }

    final userField = TextField(
      style: styleNormal,
      //autofocus: true,
      //focusNode: focusNode,
      focusNode: _focus,
      controller: txtUser,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "UserName",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      onTap: () {
        //FocusScope.of(context).requestFocus(_focus);
        //_focus.requestFocus();
      },
      onSubmitted: (v) {
        _fieldFocusChange(context, _focus, _nextFocus1);
        //_nextFocus1.requestFocus();
      },
    );

    final passwordField = TextField(
      //obscureText: true,
      controller: txtPwd,
      focusNode: _nextFocus1,
      //enabled: false,
      style: styleNormal,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      onTap: () {
        //FocusScope.of(context).requestFocus(_nextFocus1);
        //_nextFocus1.requestFocus();
      },
      onSubmitted: (v) {
        _fieldFocusChange(context, _nextFocus1, _nextFocus2);
      },
      onEditingComplete: () {
        //FocusScope.of(context).requestFocus(FocusNode());
        //_fieldFocusChange(context, _nextFocus1, _nextFocus2);
      },
      onChanged: (txt) {
        //FocusScope.of(context).requestFocus(_nextFocus1);
        //  setState(() {
        //     log(txt);
        //   });
      },
    );

    final firstnameField = TextField(
      //obscureText: true,
      controller: txtFirstName,
      focusNode: _nextFocus2,
      //enabled: false,
      style: styleNormal,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "FirstName",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      onTap: () {
        //FocusScope.of(context).requestFocus(_focus);
        // _nextFocus2.requestFocus();
      },
      onSubmitted: (v) {
        _fieldFocusChange(context, _nextFocus2, _nextFocus3);
      },
      /*   onChanged: (txt) {
        setState(() {
          log(txt);
        }); 
      },*/
    );

    final lastnameField = TextField(
      //obscureText: true,
      controller: txtLastName,
      focusNode: _nextFocus3,
      //enabled: false,
      style: styleNormal,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "LastName",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      onTap: () {
        //FocusScope.of(context).requestFocus(_focus);
        //_nextFocus3.requestFocus();
      },
      onSubmitted: (v) {
        _fieldFocusChange(context, _nextFocus3, _nextFocus4);
      },
      /*   onChanged: (txt) {
        setState(() {
          log(txt);
        }); 
      },*/
    );

    final mobileField = TextField(
      //obscureText: true,
      controller: txtMobile,
      focusNode: _nextFocus4,
      //enabled: false,
      style: styleNormal,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "Mobile",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      onTap: () {
        //FocusScope.of(context).requestFocus(_focus);
        //_nextFocus4.requestFocus();
      },
      onSubmitted: (v) {
        _fieldFocusChange(context, _nextFocus4, _nextFocusBSave);
        //FocusScope.of(context).requestFocus(_nextFocus4);
      },
      /*   onChanged: (txt) {
        setState(() {
          log(txt);
        });
      },*/
    );
    //=========================================

    final updateButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: orange,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        highlightColor: Colors.amber, //on press button change color
        onPressed: () {
          // check input
          //bool chk = true;
          bool chk1 = false;
          bool chk2 = false;

          ResponseMessage amsg = new ResponseMessage();

          // check form
          if (txtUser.text.trim() == '' ||
              txtPwd.text.trim() == '' ||
              txtFirstName.text.trim() == '' ||
              txtLastName.text.trim() == '' ||
              txtMobile.text.trim() == '' ||
              unitNow == null) {
            chk1 = false;
          } else {
            chk1 = true;
          }

          if (chk1 == false) {
            amsg.Alert(context, "กรอกข้อมูลไม่ครบ", "กรุณากรอกข้อมูลให้ครบ!!!");
          } else if (chk1 == true) {
            chk2 = txtMobile.text.trim().contains(new RegExp(r'^\d{10}$'));
            if (chk2 == false) {
              amsg.Alert(
                context,
                "กรอกข้อมูลผิดรูปแบบ",
                "กรุณากรอกเบอร์โทรให้ถูกต้อง",
              );
              FocusScope.of(context).requestFocus(_nextFocus4);
            } else {
              //====== check login=============
              MySQLDB mysql = MySQLDB();

              var Dat = <String, dynamic>{};
              Dat['aid'] = widget.aid;
              Dat['userid'] = txtUser.text;
              Dat['password'] = txtPwd.text;
              Dat['firstname'] = txtFirstName.text;
              Dat['lastname'] = txtLastName.text;
              Dat['mobile'] = txtMobile.text;
              Dat['uid'] = unitNow;

              mysql.UpdateUser(Dat).then((String result) {
                var ret = json.decode(result);

                String msg = "";
                if (ret["result"] == "false") {
                  msg = "ผิดพลาดในการบันทึก : ${ret["msg"]} ";
                } else if (ret["result"] == "true") {
                  msg = "ปรับปรุงข้อมูลเรียบร้อยแล้ว";

                  log("Status Update : $msg");
                }

                amsg.Alert(context, "ปรับปรุงข้อมูล", "ผลคือ : ${msg}");

                Future.delayed(oneSecond * 2, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ShowAccount()),
                  );
                });
              });
            }
          }
        },
        child: Text(
          "บันทึก",
          textAlign: TextAlign.center,
          style: styleNormal.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final deleteButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.red,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        highlightColor: Colors.amber, //on press button change color
        onPressed: () {
          //=== show dialog confirm delete===
          showDialog(
            context: context,
            builder:
                (BuildContext context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ), // ทำขอบ Dialog ให้โค้งมน
                  ),
                  title: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                        size: 28,
                      ), // เพิ่มไอคอนแจ้งเตือน
                      const SizedBox(width: 8),
                      Text(
                        'ยืนยันการลบ',
                        style: styleHead1.copyWith(
                          color: Colors.red,
                        ), // ใช้ฟอนต์ที่มีอยู่และปรับเป็นสีแดง
                      ),
                    ],
                  ),
                  content: Text(
                    'คุณแน่ใจหรือไม่ที่จะลบข้อมูลผู้ใช้นี้?\nหากลบแล้วจะไม่สามารถกู้คืนได้',
                    style: styleNormal,
                  ),
                  actionsPadding: const EdgeInsets.only(
                    bottom: 16,
                    right: 16,
                    left: 16,
                  ),
                  actionsAlignment:
                      MainAxisAlignment.spaceEvenly, // จัดปุ่มให้ห่างเท่าๆ กัน
                  actions: [
                    // ปุ่ม ยกเลิก
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor:
                            Colors.grey.shade300, // สีพื้นหลังปุ่มยกเลิก
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // ปิดหน้าต่าง Dialog
                      },
                      child: Text(
                        'ยกเลิก',
                        style: styleNormal.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // ปุ่ม ยืนยัน
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red, // สีพื้นหลังปุ่มยืนยัน
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pop(); // ปิด Dialog ยืนยันก่อนทำงานต่อไป

                        //========= เริ่มกระบวนการลบ (Logic เดิม) =============
                        bool chk1 = widget.aid != '';
                        ResponseMessage amsg = new ResponseMessage();

                        if (chk1 == false) {
                          amsg.Alert(
                            context,
                            "ข้อมูลไม่พบ",
                            "กรุณาเลือกข้อมูลให้ครบ!!!",
                          );
                        } else if (chk1 == true) {
                          MySQLDB mysql = MySQLDB();

                          var Dat = <String, dynamic>{};
                          Dat['aid'] = widget.aid;
                          Dat['table'] = "account";

                          mysql.DeleteUser(Dat).then((String result) {
                            var ret = json.decode(result);

                            String msg = "";
                            if (ret["result"] == "false") {
                              msg = "ผิดพลาดในการลบ : ${ret["msg"]} ";
                            } else if (ret["result"] == "true") {
                              msg = "ลบข้อมูลเรียบร้อยแล้ว";
                              log("Status Delete : $msg");
                            }

                            amsg.Alert(context, "ลบข้อมูล", "ผลคือ : ${msg}");

                            Future.delayed(oneSecond * 2, () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowAccount(),
                                ),
                              );
                            });
                          });
                        }
                        //============================
                      },
                      child: Text(
                        'ยืนยัน',
                        style: styleNormal.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
          );
        },
        child: Text(
          "ลบ",
          textAlign: TextAlign.center,
          style: styleNormal.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final backButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: green,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        highlightColor: Colors.amber, //on press button change color
        onPressed: () {
          Navigator.of(context).pop();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ShowAccount(),
          //     //builder: (context) => ShowBudgetDetail('${spen.list_exp_spen}'),
          //   ),
          // );

          // Navigator.of(context).pushNamedAndRemoveUntil(
          //     '/account', (Route<dynamic> route) => false);
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(builder: (context) => ShowAccount()),
          //     (Route<dynamic> route) => false);
        },
        child: Text(
          "ย้อนกลับ",
          textAlign: TextAlign.center,
          style: styleNormal.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    _focus.requestFocus();
    return Scaffold(
      // แนะนำให้เอา resizeToAvoidBottomInset: false ออก เพื่อให้คีย์บอร์ดดันหน้าจอขึ้นได้
      backgroundColor: lightpurple,
      appBar: AppBar(
        title: Text("ปรับปรุงข้อมูลผู้ใช้", style: styleHeadWhite4),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('รายละเอียด Account', style: styleHeadPurple),
                const SizedBox(height: 16),

                // UserId
                Row(
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text('UserId', style: styleHead1),
                    ),
                    Expanded(
                      child: userField,
                    ), // ใช้ Expanded แทนการกำหนด width
                  ],
                ),
                const SizedBox(height: 12),

                // Password
                Row(
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text('Password(>10)', style: styleHead1),
                    ),
                    Expanded(child: passwordField),
                  ],
                ),
                const SizedBox(height: 12),

                // หน่วยงาน
                Row(
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text('หน่วยงาน', style: styleHead1),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ddlUnit(unitList),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ยศ ชื่อ-สกุล
                Row(
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text('ยศ ชื่อ-สกุล', style: styleHead1),
                    ),
                    Expanded(child: firstnameField),
                  ],
                ),
                const SizedBox(height: 12),

                // นามสกุล
                Row(
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text('นามสกุล', style: styleHead1),
                    ),
                    Expanded(child: lastnameField),
                  ],
                ),
                const SizedBox(height: 12),

                // มือถือ
                Row(
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text('มือถือ', style: styleHead1),
                    ),
                    Expanded(child: mobileField),
                  ],
                ),
                const SizedBox(height: 24),

                // ปุ่ม บันทึก
                updateButton,
                const SizedBox(height: 8.0),

                // ปุ่ม ลบ (ซ่อน/แสดง ตามสถานะ)
                if (login?.get('status') == '1') ...[
                  deleteButton,
                  const SizedBox(height: 8.0),
                ],

                // ปุ่ม ย้อนกลับ
                backButon,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

_fieldFocusChange(
  BuildContext context,
  FocusNode currentFocus,
  FocusNode nextFocus,
) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
