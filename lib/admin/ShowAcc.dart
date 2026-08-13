import 'package:budget_mobile/MainPageAdmin.dart';
import '../global/ManageLogin.dart';
import 'AddUser.dart';
import 'package:budget_mobile/styles/colors.dart';
//import 'package:budget_mobile/routes.dart';
import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
//import '../global/GetUnitName.dart';
import '../global/MySQLService.dart';
import '../global/ResponseMessage.dart';
import '../models/Account.dart';
import '../models/UnitName.dart';
import 'EditAccDetail.dart';
//import 'ShowAccDetail.dart';

//String Aid = "";
var login;

class ShowAccount extends StatefulWidget {
  static String routeName = "/showacc";
  @override
  _ShowAccountState createState() => _ShowAccountState();
}

class _ShowAccountState extends State<ShowAccount>
    with SingleTickerProviderStateMixin {
  //===============defind var/object==================
  String seluid = "0";
  String unitNow = "0";

  late Future<List<Account>?>? accList = null;
  late Future<List<UnitName>?> unitList;
  late UnitName utmp;

  // late AnimationController _animationController;

  MySQLDB mydb = MySQLDB();

  _ShowAccountState() {
    ManageLogin _login = ManageLogin();
    _login.DefineBox().then((box) {
      login = box;
      //unitNow = login.get('uid').toString();
      //UserID = login.get('userid').toString();
      //Token = login.get('token').toString();
      //FullName = login.get('fullname').toString();
      //Status = login.get('status').toString();
    });
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

  //=========Controller Text==============
  final txtSearch = TextEditingController();

  //=============method class state===========
  @override
  void initState() {
    super.initState();
    // _animationController = AnimationController(vsync: this);
    AnimationController(vsync: this);
    // init data

    //unitNow = "30";
    //seluid = unitNow;

    unitList = mydb.getUnitList();
    //debugPrint(unitList.toString());

    //accList = getDataList(txtSearch.text.trim(), seluid);

    //   datList = getDataList(txtSearch.text.trim(), unitNow ?? '');
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   log("Work by didChangeDependencies");
  // }

  // @override
  // void didUpdateWidget(covariant ShowAccount oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   log("Work by didUpdateWidget");
  // }

  // @override
  // void deactivate() {
  //   super.deactivate();
  //   log("Deactivate Page Widget");
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _animationController.dispose();
  //   log("Dispose Page Widget");
  // }

  Future<List<Account>?> getDataList(String txtsearch, String uid) {
    Future<List<Account>?> tmplist;
    tmplist = mydb.getAccSearch(txtsearch, uid);
    return tmplist;
  }

  // void setDropDownItem(String v) {
  //   setState(() {
  //     unitNow = v;
  //   });
  // }

  //==========defind widget style=============
  TextStyle styleHead = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.purple,
  );

  TextStyle styleLabel = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16.0,
    color: Colors.green.shade900,
    //color: Colors.red,
    fontWeight: FontWeight.bold,
    //decorationColor: Colors.yellowAccent.shade100,
    backgroundColor: Colors.white,
  );

  TextStyle styleDropDownList = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16.0,
    color: Colors.green.shade900,
    //color: Colors.red,
    fontWeight: FontWeight.bold,
    //decorationColor: Colors.yellowAccent.shade100,
    //backgroundColor: white,
    backgroundColor: lightyellow2,
  );

  TextStyle styleError = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16.0,
    //color: Colors.green.shade900,
    color: Colors.red,
    fontWeight: FontWeight.bold,
    //decorationColor: Colors.yellowAccent.shade100,
    backgroundColor: Colors.white,
  );

  TextStyle styleNormal = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16.0,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "แสดงข้อมูลแอคเค้าท์",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            //fontFamily: 'Montserrat',
            //fontWeight: FontWeight.bold
          ),
        ),
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: mainBody(),
      //body: fb,
    );
  }

  Widget mainBody() {
    //==========defind var====================
    //MySQLDB db = MySQLDB();
    Widget fb;
    if (seluid == "0") {
      fb = Text('');
    } else {
      accList = getDataList(txtSearch.text.trim(), seluid);
      fb = buildFutureBuilder(accList);
    }

    //==========defind widget====================
    final txtsearch = TextField(
      style: styleNormal,
      //autofocus: true,
      controller: txtSearch,
      decoration: InputDecoration(
        focusColor: blue,
        contentPadding: EdgeInsets.fromLTRB(8.0, 2.0, 2.0, 2.0),
        //contentPadding: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
        filled: true,
        fillColor: Colors.yellowAccent.shade100,
        hintText: "ค้นหา",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
      ),

      //border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      //OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(2.0)))
      onSubmitted: (v) {
        //_fieldFocusChange(context, _focus, _nextFocus);
      },
    );

    final searchButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.greenAccent.shade700,
      child: MaterialButton(
        //minWidth: MediaQuery.of(context).size.width,
        minWidth: 60,
        padding: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
        //highlightColor: Colors.amber, //on press button change color
        highlightColor:
            Colors.greenAccent.shade400, //on press button change color
        onPressed: () {
          //Navigator.of(context).pop();
          //MessageDialog dlg = new MessageDialog();
          //dlg.msgBox(context, txtSearch.text);
          //cond = txtSearch.text;
          setState(() {
            //datList = getDataList(txtSearch.text.trim(), seluid.toString());
            accList = getDataList(txtSearch.text.trim(), seluid);
          });
        },
        child: Text(
          "ค้นหา",
          textAlign: TextAlign.center,
          style: styleNormal.copyWith(
            color: Colors.white,
            fontSize: 14,
            //fontWeight: FontWeight.bold
          ),
        ),
      ),
    );

    final backButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.blue,
      child: MaterialButton(
        //minWidth: MediaQuery.of(context).size.width,
        minWidth: 60,
        padding: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
        highlightColor: Colors.amber, //on press button change color
        onPressed: () {
          //Navigator.of(context).pop();
          Navigator.of(context).pushNamedAndRemoveUntil(
            MainPageAdmin.routeName,
            (Route<dynamic> route) => false,
          );
        },
        child: Text(
          "หน้าหลัก",
          textAlign: TextAlign.center,
          style: styleNormal.copyWith(
            color: Colors.white,
            fontSize: 14,
            //fontWeight: FontWeight.bold
          ),
        ),
      ),
    );

    final ResetButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.redAccent,
      child: MaterialButton(
        //minWidth: MediaQuery.of(context).size.width,
        minWidth: 60,
        padding: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
        highlightColor: Colors.amber, //on press button change color
        onPressed: () {
          //Navigator.of(context).pop();
          txtSearch.text = "";
          setState(() {
            seluid = "0";
            accList = getDataList("", seluid);
          });
        },
        child: Text(
          "Reset",
          textAlign: TextAlign.center,
          style: styleNormal.copyWith(
            color: Colors.white,
            fontSize: 14,
            //fontWeight: FontWeight.bold
          ),
        ),
      ),
    );

    //==========end defind widget====================

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              //crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text('เลือกหน่วยงาน', style: styleHead),
                ),
                SizedBox(width: 5),
                ddlUnit(unitList),
                // Padding(
                //   padding: EdgeInsets.fromLTRB(6, 6, 0, 0),
                //   child: Container(
                //       color: lightyellow2,
                //       //width: 300.0,
                //       child: ddlUnit(unitList)),
                // ),
                SizedBox(width: 1),
                IconButton(
                  icon: Icon(Icons.add_circle),
                  iconSize: 30,
                  onPressed: () {
                    Navigator.pushNamed(context, AddUser.routeName);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Wrap(
              spacing: 3,
              runSpacing: 3,
              children: [
                Text('ค้นหา', style: styleHead),
                Container(
                  width: 160.0,
                  //margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                  child: txtsearch,
                ),
                SizedBox(width: 3),
                searchButon,
                SizedBox(width: 3),
                backButon,
                SizedBox(width: 3),
                ResetButon,
              ],
            ),
          ),

          Flexible(fit: FlexFit.tight, child: fb),

          //SizedBox(  // can define heigh of ListView
          //height: 400, // constrain height
          //  child: fb,
          //)
          //Expanded(
          //  child: fb,
          //child: buildFutureBuilder(datList),
          //),

          //ddlYear,
          //txtsearch,
        ],
      ),
    );
  }

  Widget ddlUnit(udata) {
    return FutureBuilder<List<UnitName>?>(
      future: udata,
      builder: (context, snapshot) {
        //(BuildContext context, AsyncSnapshot<List<UnitName>?> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return Container(
          width: 280.0,
          height: 45,
          decoration: BoxDecoration(
            color: lightyellow2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade300, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: DropdownButton(
            //return DropdownButton<String>(
            isExpanded: true,
            underline: SizedBox(),
            items:
                snapshot.data
                    ?.map(
                      (item) => DropdownMenuItem(
                        //?.map((item) => DropdownMenuItem<String>(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(item.uint_name),
                        ),
                        value: item.uint.toString(),
                      ),
                    )
                    .toList(),
            value: seluid,
            //value: null,
            onChanged: (un) {
              setState(() {
                seluid = un.toString();
                print("select unit : " + seluid);
              });
              // ignore: unused_local_variable
              var msg = new ResponseMessage();
              //msg.Alert(context, "เลือกหน่วยงาน", unitNow.toString());
            },
            hint: Text(
              'เลือกหน่วยงาน',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            disabledHint: Text("Disabled"),
            elevation: 12,
            style: styleDropDownList.copyWith(fontSize: 14),
            //style: Theme.of(context).textTheme.labelMedium,
            //style: Theme.of(context).textTheme.bodyText2,
            //dropdownColor: Colors.white,
            dropdownColor: lightyellow2,
            //focusColor: Colors.yellow.shade100,
            focusColor: Colors.white,
            icon: Icon(
              Icons.arrow_drop_down_circle,
              color: Colors.blue.shade600,
            ),
            iconDisabledColor: Colors.red,
            iconEnabledColor: Colors.blue.shade600,
            iconSize: 28,
          ),
        );
      },
    );
  }

  Widget buildFutureBuilder(data) {
    return FutureBuilder(
      future: data,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          /* case ConnectionState.done:
          return */
          default:
            if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Text('ไม่พบข้อมูล');
            } else {
              if (snapshot.hasData) {
                return listAccountWidget(context, snapshot);
              } else {
                return Text('ไม่พบข้อมูล');
              }
            }
        }
      },
    );
  }
}

Widget listAccountWidget(context, snapshot) {
  //List<String> datList = snapshot.data;
  if (snapshot.data != null && snapshot.data.length > 0) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        Account acc = snapshot.data[index];
        return GestureDetector(
          onTap: () {
            //msgBox(context, '${acc.userid}');
            //Aid = acc.aid;
            //msgBox(context, '${spen.list_exp_spen}');
            //Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditAccDetail(acc.aid),
                //builder: (context) => ShowAccountDetail(Aid),
                //builder: (context) => ShowBudgetDetail('${spen.list_exp_spen}'),
              ),
            );
          },
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          '${index += 1}. ${acc.firstname} ${acc.lastname} => UserId : ${acc.userid}',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.blue[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditAccDetail(acc.aid),
                              ),
                            );
                          },
                          child: Text(
                            'รหัสผ่าน : ${acc.passwords}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  } else
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        "ไม่พบข้อมูลใดๆ กดปุ่ม Reset",
        style: TextStyle(
          fontSize: 16,
          color: Colors.red,
          backgroundColor: Colors.grey.shade100,
        ),
      ),
    );
}
