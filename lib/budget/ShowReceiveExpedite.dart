import 'package:budget_mobile/MainPageAdmin.dart';
import 'package:budget_mobile/models/TBStatusSearch.dart';
import 'package:budget_mobile/styles/colors.dart';
import 'package:flutter/material.dart';
//import 'Dialog.dart';
import '../MainPage.dart';
import '../global/ManageLogin.dart';
import '../global/MySQLService.dart';
import '../global/ResponseMessage.dart';
import '../global/GetYearBudget.dart';
import 'ReceiveExpedite.dart';

var login;

class ShowReceiveExpedite extends StatefulWidget {
  static String routeName = "/showrxexp";

  final String uid;
  ShowReceiveExpedite(this.uid) {
    print(this.uid);
  }

  @override
  _ShowReceiveExpediteState createState() => _ShowReceiveExpediteState();
}

class _ShowReceiveExpediteState extends State<ShowReceiveExpedite>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  //String cond = "";

  // ====declare var========
  late Future<List<TBStatusSearch>?> datList;

  //==========dropdown init======
  // Default Drop Down Item.
  //String dropdownValue = '2565';
  // To show Selected Item in Text.
  String selyear = "";

  // init year now
  late int yearNow;

  //int yearNow = DateTime.now().year.toInt() + 543;
  late List<int> listyear;

  // var id_exp_spen;
  // var id_job;
  // var id_status;

  Future<List<TBStatusSearch>?> getDataList(String txtsearch, String ddlyear) {
    Future<List<TBStatusSearch>?> datlist;
    MySQLDB mydb = new MySQLDB();
    datlist = mydb.GetTBStatusSearch(txtsearch, ddlyear, widget.uid);
    return datlist;
  }

  void getDropDownItem() {
    setState(() {
      //selyear = dropdownValue;
      selyear = yearNow.toString();
    });
  }

  //=====Controller Text===========
  final txtSearch = TextEditingController();

  _ShowReceiveExpediteState() {
    // initHive Box Name : LoginData
    ManageLogin _login = ManageLogin();
    _login.DefineBox().then((box) {
      login = box;
      print('ShowReceiveExpedite login: ${login.toMap()}');
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    yearNow = GetYearBudget.getYearBudget();
    listyear = [for (var i = yearNow - 5; i <= yearNow + 2; i++) i];

    getDropDownItem();
    datList = getDataList(txtSearch.text.trim(), selyear);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle styleHead = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: Colors.purple,
    );

    TextStyle styleLabel = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16.0,
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      //decorationColor: Colors.yellowAccent.shade100,
      backgroundColor: Colors.white,
    );

    TextStyle styleInput = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16.0,
      color: Colors.black,
    );

    //Create ListView using data get from service
    Widget listTBStatusWidget(context, snapshot) {
      //final String idExpSpen = "";
      if (snapshot.data != null && snapshot.data.length > 0) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            TBStatusSearch tbs = snapshot.data[index];

            // String IdJob = tbs.id_job.toString();
            // get idJob for id_exp_spen in tbl_book_unit and get list_exp_spen in tbl_expedite_spending
            // String IdExpSpen = "";
            // IdExpSpen= func(IdJob);

            return GestureDetector(
              onTap: () {
                //msgBox(context, '${acc.userid}');
                //String id_exp_spen = '${spen.id_exp_spen}';
                //msgBox(context, '${spen.list_exp_spen}');
                //Navigator.of(context).pop();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => EditExpDetail(),
                //     //builder: (context) => ShowBudgetDetail('${spen.list_exp_spen}'),
                //   ),
                // );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // builder: (context) => ReceiveExpedite(
                    //     list_exp_spen: tbs.list_exp_spen,
                    //     id_status: tbs.id_status.toString(),
                    //     id_job: tbs.id_job.toString()),
                    builder: (context) => ReceiveExpedite(tbstatus: tbs),
                  ),
                );
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              '${tbs.title} | ${tbs.doc_unit_no}',
                              style: TextStyle(fontSize: 14.0, color: black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
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
                                // var msg = new ResponseMessage();
                                // msg.Alert(context, "รหัสงบ",
                                //     '${spen.id_exp_spen}');

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            ReceiveExpedite(tbstatus: tbs),
                                  ),
                                );
                              },
                              child: Text(
                                'หน่วยส่ง: ${tbs.unit_send_name}|วันเวลาส่ง : ${tbs.date_sent_real} \nผู้ส่ง : ${tbs.sender}',
                                style: TextStyle(fontSize: 12, color: purple),
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
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "ไม่พบข้อมูลใดๆ กดปุ่ม Reset",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
              backgroundColor: Colors.grey.shade100,

              //letterSpacing: 2.0,
            ),
          ),
        );
    }

    // call from Body Part in Scaffold
    // Main Display ListView call listExpenWidget for create ListView
    Widget listListExspenWidget(data) {
      return FutureBuilder(
        //future: mydb.getExpSearch("", years),
        future: data,
        builder: (context, tbDBSnap) {
          switch (tbDBSnap.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            /* case ConnectionState.done:
            return */
            default:
              if (tbDBSnap.hasError)
                return new Text('Error: ${tbDBSnap.error}');
              else
                return listTBStatusWidget(context, tbDBSnap);
          }
        },
      );
    }

    Widget txtsearch() {
      return TextField(
        style: styleInput,
        //autofocus: true,
        controller: txtSearch,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 2.0, 2.0, 2.0),
          filled: true,
          fillColor: Colors.yellowAccent.shade100,
          hintText: "ค้นหา",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.0)),
        ),
        onSubmitted: (v) {
          //_fieldFocusChange(context, _focus, _nextFocus);
        },
      );
    }

    final ddlYearNew = DropdownButton(
      //borderRadius: BorderRadius.circular(10),
      value: yearNow,
      items:
          listyear.map((int item) {
            return DropdownMenuItem<int>(child: Text('$item'), value: item);
          }).toList(),
      onChanged: (value) {
        selyear = value.toString();
        //if not found alert no found
        datList = getDataList(txtSearch.text.trim(), selyear);

        ResponseMessage resp = new ResponseMessage();

        datList.then((ret_value) {
          if (ret_value == null) {
            resp.Alert(context, "ไม่พบข้อมูล", "ไม่พบข้อมูลของปีที่เลือก !!!");
          }
          setState(() {
            yearNow = value as int;
          });
        });
      },
      //hint: Text("เลือกปีงบประมาณ"),
      disabledHint: Text("Disabled"),
      elevation: 8,
      //style: TextStyle(color: Colors.green, fontSize: 16),
      style: styleLabel,
      //dropdownColor: Colors.grey.shade200,
      icon: Icon(Icons.arrow_drop_down_circle),
      iconDisabledColor: Colors.red,
      iconEnabledColor: Colors.blue,
      iconSize: 30,
    );

    //======widget button==========
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
            datList = getDataList(txtSearch.text.trim(), yearNow.toString());
          });
        },
        child: Text(
          "ค้นหา",
          textAlign: TextAlign.center,
          style: styleInput.copyWith(
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
        minWidth: 45,
        padding: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
        highlightColor: Colors.amber, //on press button change color
        onPressed: () {
          //Navigator.of(context).pop();
          // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ShowReceiveExpedite(uid)),);

          if (login.get('status').toString() == '1') {
            Navigator.of(context).pushNamedAndRemoveUntil(
              MainPageAdmin.routeName,
              (Route<dynamic> route) => false,
            );
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
              MainPage.routeName,
              (Route<dynamic> route) => false,
            );
          }
        },
        child: Text(
          "Back",
          textAlign: TextAlign.center,
          style: styleInput.copyWith(
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
        minWidth: 45,
        padding: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
        highlightColor: Colors.amber, //on press button change color
        onPressed: () {
          //Navigator.of(context).pop();
          txtSearch.text = "";
          setState(() {
            yearNow = GetYearBudget.getYearBudget();
            datList = getDataList("", yearNow.toString());
          });
        },
        child: Text(
          "Reset",
          textAlign: TextAlign.center,
          style: styleInput.copyWith(
            color: Colors.white,
            fontSize: 14,
            //fontWeight: FontWeight.bold
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "บันทึกหลักฐานการรับงาน",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 0, 1, 0),
                child: Text('เลือกปีงบประมาณ', style: styleHead),
              ),
              SizedBox(width: 3),
              Container(
                margin: EdgeInsets.all(2),
                width: 75,
                height: 33,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1),
                ),
                child: Center(
                  // Center the DropdownButton horizontally
                  child: ddlYearNew,
                ),
              ),
            ],
          ),
          Container(
            height: 35,
            child: Container(
              height: 35,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 0, 1, 0),
                    child: Text('ค้นหา', style: styleHead),
                  ),
                  Container(width: 135.0, child: txtsearch()),
                  searchButon,
                  SizedBox(width: 3),
                  backButon,
                  SizedBox(width: 3),
                  ResetButon,
                  //ddlYear,
                  //txtsearch,
                ],
              ),
            ),
          ),

          /* Row(
                children: [
                  searchButon,
                ],
              ), */
          Flexible(fit: FlexFit.tight, child: listListExspenWidget(datList)),
        ],
      ),
    );
  }
}
