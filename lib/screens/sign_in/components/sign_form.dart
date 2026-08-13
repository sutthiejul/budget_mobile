import 'dart:convert';
import 'package:budget_mobile/global/LocalDataShare.dart';
import 'package:budget_mobile/global/ResponseMessage.dart';
import 'package:budget_mobile/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../global/GetUnitName.dart';
import '../../../screens/login_success/login_success_screen.dart';
import '../../login_success/login_false_screen.dart';
import '../../../global/constants.dart';
import '../../../global/size_config.dart';
import '../../../global/globalVar.dart';
import '../../../global/MySQLService.dart';

// import 'package:bfriendapp/styles/TextStyle_Bfriend.dart';
var box;

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? userid;
  String? password;

  // เพิ่ม controllers
  late final TextEditingController userController;
  late final TextEditingController pwdController;

  bool? remember = false;
  final List<String?> errors = [];

  final FocusNode focus_userid = FocusNode();
  final FocusNode focus_pwd = FocusNode();
  //final FocusNode buttonLoginFocus = FocusNode();

  MySQLDB mysql = MySQLDB();

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  // เพิ่มสถานะสำหรับซ่อน/แสดงรหัสผ่าน
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    // สร้าง controllers
    userController = TextEditingController();
    pwdController = TextEditingController();

    // โหลดค่าจาก LocalDataShare แล้วตั้งลงใน controller.text
    LocalDataShare.getUserID().then((value) {
      userController.text = value ?? '';
      userid = value;
      if (value != null && value.isNotEmpty) {
        setState(() {
          remember = true;
        });
      } else {
        setState(() {
          remember = false;
        });
      }
      // ไม่จำเป็นต้อง setState แค่ controller.text ก็อัพเดต UI
    });
    LocalDataShare.getPassword().then((value) {
      pwdController.text = value ?? '';
      password = value;
    });
  }

  @override
  void dispose() {
    // ปิด controllers
    userController.dispose();
    pwdController.dispose();
    // ...ถ้ามี focus/dispose อื่น ๆ ให้เก็บไว้...
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //mysql.FocusChange(context, this.focus_userid, this.focus_userid);
    focus_userid.requestFocus();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(color: lightpurple, child: buildUserIdFormField()),
          SizedBox(height: getProportionateScreenHeight(30)),
          Container(color: lightpurple, child: buildPasswordFormField()),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: orange,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text(
                "Remember me",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                  fontSize: 18,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  //Navigator.pushNamed(context,ForgotPasswordScreen.routeName,),
                  ResponseMessage msg = new ResponseMessage();
                  msg.Alert(context, "ติดต่อแอดมิน", "Line ID: sjsell");
                },
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: bPrimaryColor,
              padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenHeight(15),
                horizontal: getProportionateScreenWidth(30),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              "เข้าระบบ",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(14),
                color: Colors.white,
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                print("userid : " + userid! + "\n");
                print("password : " + password! + "\n");

                //check in database by Rest API PHP

                mysql.chkLoginTokenJ6(userid!, password!).then((result) async {
                  String msg = "";

                  if (result.trim() == "") {
                    msg = "Login False!!!";

                    print("Result Authen : ${msg}");

                    //KeyboardUtil.hideKeyboard(context);
                    //Navigator.pushNamed(context, LoginFalseScreen.routeName);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginFalseScreen(errMsg: ''),
                      ),
                    );
                  } else {
                    //msg = "Login Success!!!";
                    //print("Result Authen : ${msg}");

                    var dat = json.decode(result.trim());

                    if (dat["errMsg"] != null) {
                      if (dat["errMsg"] != "") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    LoginFalseScreen(errMsg: dat["errMsg"]),
                          ),
                        );

                        return;
                      }
                    }

                    //=================set Hive for Global Data===================
                    await Hive.initFlutter();
                    box = await Hive.openBox('LoginData');
                    box.put('aid', dat["aid"]);
                    box.put('userid', dat['userid']);
                    box.put('uid', dat['Uint']);
                    box.put(
                      'fullname',
                      dat['firstname'] + " " + dat['lastname'],
                    );
                    box.put('mobile', dat['mobile']);
                    box.put('email', dat['email']);
                    box.put('status', dat["status"]);
                    box.put('token', dat["token"]);
                    //=================Get Unitname===============================
                    String uid = dat['Uint'];
                    var unit =
                        GetUnitName(); // create obj from class GetUnitName
                    //unitStr = unit.GetUnitStr(uid).toString();
                    unit.GetUnitStr(uid).then((value) {
                      box.put('unitname', value);
                      CurrentUnitName = value;
                    });
                    //============================================================
                    // print("Aid : " + Aid);
                    // print("UserID : " + UserID);
                    // print("Fullname : " + dat["fullname"]);
                    // print("Status : " + dat["status"]); // user , admin
                    // print("Token : " + Token);
                    //==============set Preferences==========================

                    if (remember!) //remember not null and true
                    {
                      // set remember me
                      LocalDataShare.saveUserID(userid!);
                      LocalDataShare.savePassword(password!);
                    } else {
                      // LocalDataShare.removeUserID();
                      // LocalDataShare.removePassword();

                      LocalDataShare.saveUserID("");
                      LocalDataShare.savePassword("");
                    }
                    // if all are valid then go to success screen
                    //KeyboardUtil.hideKeyboard(context);
                    Navigator.pushNamed(context, LoginSuccessScreen.routeName);
                  }
                });
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildUserIdFormField() {
    return TextFormField(
      // ใช้ controller แทน initialValue
      controller: userController,
      keyboardType: TextInputType.text,
      focusNode: focus_userid,
      onFieldSubmitted: (ValueKey) => focus_pwd.requestFocus(),
      onSaved: (newValue) => userid = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: bUserIDNullError);
        } else if (value.length >= 4) {
          removeError(error: bShortUserIDError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: bUserIDNullError);
          return "";
        } else if (value.length < 4) {
          addError(error: bShortUserIDError);
          return "";
        }
        return null;
      },
      style: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: new BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: new BorderRadius.circular(22),
        ),
        labelText: "UserID",
        labelStyle: TextStyle(
          fontSize: 24.0,
          color: red,
          fontWeight: FontWeight.bold,
        ),
        hintText: "Enter your UserId",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: pwdController,
      focusNode: focus_pwd,
      obscureText: _obscurePassword,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: bPassNullError);
        } else if (value.length >= 6) {
          removeError(error: bShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: bPassNullError);
          return "";
        } else if (value.length < 6) {
          addError(error: bShortPassError);
          return "";
        }
        return null;
      },
      style: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: new BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: new BorderRadius.circular(22),
        ),
        labelText: "Password",
        labelStyle: TextStyle(
          fontSize: 24.0,
          color: red,
          fontWeight: FontWeight.bold,
        ),
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.lock : Icons.lock_open,
            color: Colors.grey[700],
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }
}
