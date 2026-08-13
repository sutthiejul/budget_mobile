import 'package:flutter/material.dart';
//import 'Dialog.dart';
import '../models/Expedite.dart';
import '../global/MySQLService.dart';
import '../budget/ShowExpDetail.dart';
import '../global/ResponseMessage.dart';
import '../global/GetYearBudget.dart';

class ShowExpediteOwn extends StatefulWidget {
  @override
  _ShowExpediteOwnState createState() => _ShowExpediteOwnState();
}

class _ShowExpediteOwnState extends State<ShowExpediteOwn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  //String cond = "";

  // ====declare var========
  late Future<List<Expedite>?> datList;

  //==========dropdown init======
  // Default Drop Down Item.
  //String dropdownValue = '2565';
  // To show Selected Item in Text.
  String selyear = "";

  // init year now
  GetYearBudget yb = new GetYearBudget();
  late int yearNow;

  //int yearNow = DateTime.now().year.toInt() + 543;
  late List<int> listyear;

  var id_exp_spen;

  Future<List<Expedite>?> getDataList(String txtsearch, String ddlyear) {
    Future<List<Expedite>?> datlist;
    MySQLDB mydb = new MySQLDB();
    datlist = mydb.getExpSearch(txtsearch, ddlyear);
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // init data
    yearNow = GetYearBudget.getYearBudget();
    listyear = [for (var i = yearNow - 5; i <= yearNow; i++) i];

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
    Widget listExpenWidget(context, snapshot) {
      //final String idExpSpen = "";
      if (snapshot.data != null && snapshot.data.length > 0) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            Expedite spen = snapshot.data[index];

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
                    builder:
                        (context) =>
                            ShowExpDetail(id_exp_spen: '${spen.id_exp_spen}'),
                    //builder: (context) => ShowBudgetDetail('${spen.list_exp_spen}'),
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
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${spen.list_exp_spen}',
                              style: const TextStyle(fontSize: 16.0),
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
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                // var msg = new ResponseMessage();
                                // msg.Alert(context, "รหัสงบ",
                                //     '${spen.id_exp_spen}');

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => StartExpedite(
                                //       id_exp_spen: '${spen.id_exp_spen}',
                                //     ),
                                //     //builder: (context) => ShowBudgetDetail('${spen.list_exp_spen}'),
                                //   ),
                                // );
                              },
                              child: Text(
                                'รหัสงบ : ${spen.id_exp_spen}',
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
                return listExpenWidget(context, tbDBSnap);
          }
        },
      );
    }

    //======define widget=======
    // ignore: unused_local_variable
    /*     final txtsearch = TextField(
          style: styleInput,
          //autofocus: true,
          //focusNode: focusNode,
          //focusNode: _focus,
          controller: txtSearch,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              filled: true,
              fillColor: Colors.white,
              //hintText: "ชื่องบ",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16.0))),
          onSubmitted: (v) {
            //_fieldFocusChange(context, _focus, _nextFocus);
          },
        ); */

    Widget txtsearch() {
      return TextField(
        style: styleInput,
        //autofocus: true,
        controller: txtSearch,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
          filled: true,
          fillColor: Colors.yellowAccent.shade100,
          hintText: "ค้นหา",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        onSubmitted: (v) {
          //_fieldFocusChange(context, _focus, _nextFocus);
        },
      );
    }

    // final ddlYear = DropdownButton<String>(
    //   value: dropdownValue,
    //   icon: const Icon(Icons.arrow_downward),
    //   iconSize: 24,
    //   elevation: 16,
    //   style: styleLabel,
    //   underline: Container(
    //     height: 2,
    //     color: Colors.deepPurpleAccent,
    //   ),
    //   onChanged: (String newValue) {
    //     setState(() {
    //       dropdownValue = newValue;
    //     });
    //   },
    //   items: <String>['2561', '2562', '2563', '2564', '2565']
    //       .map<DropdownMenuItem<String>>((String value) {
    //     return DropdownMenuItem<String>(
    //       value: value,
    //       child: Text(value),
    //     );
    //   }).toList(),
    // );

    final ddlYearNew = DropdownButton(
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
      icon: Icon(Icons.arrow_drop_down_circle),
      iconDisabledColor: Colors.red,
      iconEnabledColor: Colors.blue,
      iconSize: 40,
    );

    //======widget button==========
    final searchButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.greenAccent.shade700,
      child: MaterialButton(
        //minWidth: MediaQuery.of(context).size.width,
        minWidth: 70,
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
          Navigator.of(context).pop();
        },
        child: Text(
          "Main",
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
        title: Text("งบประมาณประจำปี", style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text('เลือกปีงบประมาณ', style: styleHead),
              ),
              SizedBox(width: 5),
              ddlYearNew,
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text('ค้นหา', style: styleHead),
              ),
              Container(width: 140.0, child: txtsearch()),
              searchButon,
              SizedBox(width: 3),
              backButon,
              SizedBox(width: 3),
              ResetButon,
              //ddlYear,
              //txtsearch,
            ],
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
