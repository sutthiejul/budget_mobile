import 'dart:convert';
import 'dart:core';
import 'dart:io';
// import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';
import 'package:budget_mobile/budget/ShowStartBook.dart';
import 'package:budget_mobile/models/BookUnit.dart';
import 'package:flutter/material.dart';
import '../global/FormatMoney.dart';
import '../global/MySQLService.dart';
import '../global/size_config.dart';
import '../models/Expedite.dart';
import '../global/globalVar.dart';
import '../global/ResponseMessage.dart';
import '../global/GetYearBudget.dart';
// import 'package:currency_formatter/currency_formatter.dart';
import '../models/UnitName.dart';
import 'package:budget_mobile/styles/colors.dart';
import 'package:budget_mobile/styles/TextStyle.dart';
import '../global/DateTimes.dart';
import '../global/ManageLogin.dart';
import '../upload/UploadFileBudget.dart';
import '../widget_share/SnackBarMsg.dart';

import '../widget_share/ViewPDF.dart';
import '../download/OpenUrlBrowser.dart';
import '../global/GetHoliday.dart';

var login;

class StartExpediteUser extends StatefulWidget {
  // get value from ShowStartBook
  final String id_exp_spen;
  final String id_job;
  final String sel_year;

  const StartExpediteUser({
    super.key,
    required this.id_exp_spen,
    required this.id_job,
    required this.sel_year,
  });

  @override
  _StartExpediteUserState createState() => _StartExpediteUserState();
}

class _StartExpediteUserState extends State<StartExpediteUser> {
  late MySQLDB mydb;
  late ResponseMessage msg;
  late DateTimes dtClass = DateTimes();
  String DateString = "";
  //String DateReal = "";
  String msgStr = "";

  // ddl unit data
  late Future<List<UnitName>?> unitList;
  late String sent_to;
  String txt_sent_to = "";
  String url = "";

  File? _file;
  String FileNameOriginal = "";
  String FileName = "";
  UploadFileClass upc = UploadFileClass();

  // download file attach original
  late final OpenUrlBrowser open;

  SnackBarMsg snackMsg = SnackBarMsg();
  //=========data ddl==============
  List<String> itemStatusJob = [
    'กรุณาเลือกสถานะงาน',
    'กรณีปฏิบัติงาน',
    'กรณีการจัดหา',
    'กรณีค่าสาธารณูปโภค',
    'กรณีเป็นงานฝึกอบรม/สัมมนา',
  ];

  List<String> itemStatusJobDetail = ['กรุณาเลือกรายละเอียดสถานะงาน'];
  // day timeline in status_detail
  List<int> itemStatusJobDetailDay = [0];

  //String sel_status_job = "กรุณาเลือกสถานะงาน";
  String sel_status_job = "0";
  String txt_status_job = "";

  String sel_status_job_detail = "0";
  String txt_status_job_detail = "";
  // int days = 0;

  String id_use_int = "0";
  //String send_to = "0";

  List<String> itemSecret = ['ปกติ', 'ลับ', 'ลับมาก', 'ลับที่สุด'];
  List<String> itemAcc = ['ปกติ', 'ด่วน', 'ด่วนมาก', 'ด่วนที่สุด'];

  final GetHoliday holidayService = GetHoliday();

  //=====Controller Text===========
  // show only
  final txtListName = TextEditingController();
  final txtTitle = TextEditingController();
  final txtAmout = TextEditingController();
  final txtDateOriginal = TextEditingController();
  //final txtResponse = TextEditingController();
  final txtSender = TextEditingController();
  //final txtMobile= TextEditingController();
  final txtResponseOriginal = TextEditingController();
  final txtYear = TextEditingController();
  final txtBookNo = TextEditingController();
  final txtAcc = TextEditingController();
  final txtSecret = TextEditingController();
  final txtUnitName = TextEditingController();
  final txtTypeJob = TextEditingController();
  final txtFile = TextEditingController();

  final txtDateStart = TextEditingController();
  final txtDateStop = TextEditingController();
  final txtDays = TextEditingController();

  // add,edit textfield
  final txtDate = TextEditingController();
  final txtETC = TextEditingController();

  // Keep a single list of all controllers on this page for easy disposal
  late final List<TextEditingController> AllTextControllerinWidget;

  // ddl unit
  // ddl job status
  // ddl job status detail
  // text show file upload

  // define FocusNode
  final FocusNode _focus_ddl_status = FocusNode();
  final FocusNode _focus_ddl_status_detail = FocusNode();
  final FocusNode _focus_ddl_to_unit = FocusNode();

  //==========set==fullname=====
  String fullname = ""; // for response person

  // ==== set year====
  int yearNow = 0;

  @override
  void initState() {
    super.initState();

    // initHive Box Name : LoginData
    ManageLogin _login = ManageLogin();

    _login.DefineBox().then((box) {
      login = box;
      fullname = login.get('fullname');
      id_use_int = login.get("uid");
      //txtSender.text = fullname + " " + login.get("unitname");
      txtSender.text = fullname;
      txtUnitName.text = login.get("unitname");
    });

    msg = ResponseMessage();
    mydb = MySQLDB();
    open = OpenUrlBrowser();

    //=====init Data=================
    yearNow = GetYearBudget.getYearBudget();
    txtYear.text = yearNow.toString();

    //=====init UNIT Name==============
    sent_to = "0";
    unitList = mydb.getUnitList();

    //======init Date to TextField========
    DateString = dtClass.DateThaiNow();
    txtDateStart.text = DateString; // show date send set to now
    //=====tbl_book_unit====
    mydb
        .getBookIdJob(
          widget.id_job,
          widget.sel_year,
        ) //.getBookIdJob(widget.id_job, yearNow.toString())
        .then((BookUnit? result) {
          if (result != null) {
            txtTitle.text = result.title;
            txtBookNo.text = result.doc_unit_no;

            // convert date from DB to thai date
            txtDateOriginal.text = dtClass.ConvertDateThaiNow(
              DateTime.parse(result.unit_date_no),
            );

            //=====timeline job====
            // if (result.date_start.toString() == "-0001-11-30 00:00:00.000")
            //   txtDateStart.text = "0000-00-00";
            // else
            //   txtDateStart.text = result.date_start.toString();

            // if (result.date_stop.toString() == "-0001-11-30 00:00:00.000")
            //   txtDateStop.text = "0000-00-00";
            // else
            //   txtDateStop.text = result.date_stop.toString();

            // txtDays.text = result.days.toString();

            txtAmout.text = FormatMoney.formatCurrencyfromDouble(
              double.parse(result.amout.toString()),
            );

            //txtUnitName.text = result.id_use_int.toString();

            //txtAcc.text = result.speed_class.toString();
            txtAcc.text = itemAcc[result.speed_class];

            //txtSecret.text = result.secret_class.toString();
            txtSecret.text = itemSecret[result.secret_class];
            txtTypeJob.text = result.type_job;

            txtResponseOriginal.text = result.response_person;

            setState(() {
              FileNameOriginal = result.doc_unit;
            });
          }
        });

    // _focus_ddl_status_detail.addListener(() {
    //   // Run calculation only when the field loses focus (focus out)
    //   if (!_focus_ddl_status_detail.hasFocus) {
    //     if (txtDateStart.text.isNotEmpty &&
    //         txtDays.text != '0' &&
    //         txtDateStart.text.isNotEmpty) //&& txtDateStart.text != "0000-00-00"
    //     {
    //       //=====get holiday in year======
    //       String day_end;

    //       holidayService
    //           .getAllHoliday(yearNow.toString())
    //           .then((holidayData) {
    //             day_end = dtClass.LastDate(
    //               dtClass.ConvertDateThaitoDB(txtDateStart.text),
    //               int.parse(txtDays.text),
    //               holidayData['dates'],
    //             );
    //             setState(() {
    //               txtDateStop.text = dtClass.ConvertDateThai(day_end);
    //             });
    //           })
    //           .catchError((error) {
    //             print('Failed to load holiday data: $error');
    //           });
    //     }
    //   }
    // });

    AllTextControllerinWidget = [
      txtListName,
      txtTitle,
      txtAmout,
      txtBookNo,
      txtDate,
      txtResponseOriginal,
      txtETC,
      txtDateOriginal,
      txtSender,
      txtDateStart,
      txtDateStop,
      txtDays,
    ];
  }

  @override
  void dispose() {
    _focus_ddl_status.dispose();
    _focus_ddl_status_detail.dispose();
    _focus_ddl_to_unit.dispose();

    // Clean up controllers
    for (var controller in AllTextControllerinWidget) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //_focus.requestFocus();
    //======define widget=======

    final txtlistname = TextField(
      style: styleHeadPurple4,
      //autofocus: true,
      //focusNode: _focus,
      readOnly: true,
      keyboardType: TextInputType.none,
      controller: txtListName,
      minLines: 1, // Display at least 5 lines
      maxLines: null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        filled: true,
        //filled : false,
        fillColor: lightyellow2,
        //hintText: "ชื่องบ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onSubmitted: (v) {
        //_fieldFocusChange(context, _focus, _nextFocus);
      },
    );

    final txttitle = TextField(
      readOnly: true,
      style: styleHeadPurple4,
      autofocus: true,
      // focusNode: _focus,
      //enabled: true,
      // minLines: 1, // Display at least 5 lines
      // maxLines: null,
      controller: txtTitle,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        filled: true,
        fillColor: lightyellow2,
        hintText: "ชื่อเรื่อง",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      // onSubmitted: (v) {
      //   //_fieldFocusChange(context, _focus, _nextFocus);
      // },
      // onTap: () {
      //   _focus.requestFocus();
      // },
    );

    final txt_unitname = TextField(
      style: styleHeadPurple4,
      controller: txtUnitName,
      readOnly: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        filled: true,
        fillColor: lightyellow2,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );

    final txtbookno = TextField(
      readOnly: true,
      style: styleHeadPurple4,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtBookNo,
      //keyboardType: TextInputType.number,
      // inputFormatters: [
      //   //FilteringTextInputFormatter.digitsOnly,
      //   //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
      //   currencyFormatter,
      // ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        filled: true,
        fillColor: lightyellow2,
        hintText: "ที่ของหนังสือ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onSubmitted: (v) {
        //_fieldFocusChange(context, _focus, _nextFocus);
      },
    );

    final txt_amout = TextField(
      readOnly: true,
      style: styleHeadPurple4,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtAmout,
      keyboardType: TextInputType.number,
      // inputFormatters: [
      //   currencyFormatter,
      // ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        filled: true,
        fillColor: lightyellow2,
        hintText: "จำนวนเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onChanged: (value) {
        String money = "";

        print(money);
      },
      // onSubmitted: (v) {
      //   //_fieldFocusChange(context, _focus, _nextFocus);
      // },
    );

    final txt_date_original = TextField(
      style: styleHeadPurple4,
      readOnly: true,
      controller: txtDateOriginal,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        filled: true,
        fillColor: lightyellow2,
        hintText: "วันที่ของหนังสือ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );

    final txtdate = TextField(
      style: styleHeadPurple4,
      readOnly: true,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focusDate,
      controller: txtDate,
      //keyboardType: TextInputType.number,
      // inputFormatters: [
      //   //FilteringTextInputFormatter.digitsOnly,
      //   //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
      //   currencyFormatter,
      // ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        filled: true,
        fillColor: lightyellow2,
        hintText: "วันที่ตั้งเรื่อง",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      // onTap: () {
      //   DateTime dt = DateTime.now();
      //   int dn = dt.year - 5;
      //   DateTime ystart = DateTime(dn);
      //   dn = dt.year + 10;
      //   DateTime yend = DateTime(dn);

      //   showDatePicker(
      //     context: context,
      //     initialDate: now.DateTimeNow(),
      //     firstDate: ystart,
      //     lastDate: yend,
      //   ).then((value) {
      //     if (value != null) {
      //       setState(() {
      //         DateString = now.ConvertDateThaiNow(value);
      //         //DateReal = now.ConvertDateDB(value);
      //       });

      //       txtDate.text = DateString;
      //       //txtHideDate.text = DateReal;
      //     }
      //   });
      // },
      // onSubmitted: (v) {
      //   //_fieldFocusChange(context, _focus, _nextFocus);
      // },
    );

    final txt_acc = TextField(
      style: styleHeadPurple4,
      controller: txtAcc,
      readOnly: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        filled: true,
        fillColor: lightyellow2,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );

    final txt_secret = TextField(
      style: styleHeadPurple4,
      controller: txtSecret,
      readOnly: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        filled: true,
        fillColor: lightyellow2,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );

    final txt_type_job = TextField(
      style: styleHeadPurple4,
      controller: txtTypeJob,
      readOnly: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        filled: true,
        fillColor: lightyellow2,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );

    final txt_response_original = TextField(
      style: styleHeadPurple4,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtResponseOriginal,
      readOnly: true,
      //keyboardType: TextInputType.none,
      //keyboardType: TextInputType.number,
      // inputFormatters: [
      //   //FilteringTextInputFormatter.digitsOnly,
      //   //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
      //   currencyFormatter,
      // ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        filled: true,
        fillColor: lightyellow2,
        //hintText: "ผู้รับผิดชอบ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onSubmitted: (v) {
        //_fieldFocusChange(context, _focus, _nextFocus);
      },
    );

    final txt_etc = TextField(
      style: styleHeadPurple4,
      controller: txtETC,
      //readOnly: true,
      minLines: 1, // Display at least 5 lines
      maxLines: null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        filled: true,
        fillColor: lightyellow2,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final txt_sender = TextField(
      style: styleHeadPurple4,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtSender,
      readOnly: true,
      //keyboardType: TextInputType.none,
      //keyboardType: TextInputType.number,
      // inputFormatters: [
      //   //FilteringTextInputFormatter.digitsOnly,
      //   //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
      //   currencyFormatter,
      // ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        filled: true,
        fillColor: lightyellow2,
        //hintText: "ผู้รับผิดชอบ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      onSubmitted: (v) {
        //_fieldFocusChange(context, _focus, _nextFocus);
      },
    );

    final txt_file = TextField(
      style: styleHeadPurple4,
      controller: txtFile,
      readOnly: true,
      minLines: 1, // Display at least 5 lines
      maxLines: null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        filled: true,
        fillColor: lightyellow2,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final txt_date_start = TextField(
      style: styleHeadPurple4,
      controller: txtDateStart,
      readOnly: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: lightyellow2,
        hintText: "วันที่เริ่ม",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      // onTap: () {
      //   DateTime dt = DateTime.now();
      //   int dn = dt.year - 5;
      //   DateTime ystart = DateTime(dn);
      //   dn = dt.year + 10;
      //   DateTime yend = DateTime(dn);

      //   showDatePicker(
      //     context: context,
      //     initialDate: dtClass.DateTimeNow(),
      //     firstDate: ystart,
      //     lastDate: yend,
      //   ).then((value) {
      //     if (value != null) {
      //       setState(() {
      //         txtDateStart.text = dtClass.ConvertDateThaiNow(value);
      //         if (_errorField == 'date_start') {
      //           _errorField = null;
      //         }
      //       });
      //     }
      //   });
      // },
    );

    final txt_date_stop = TextField(
      style: styleHeadPurple4,
      controller: txtDateStop,
      readOnly: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: lightyellow2,
        hintText: "วันที่สิ้นสุด",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      // onTap: () {
      //   DateTime dt = DateTime.now();
      //   int dn = dt.year - 5;
      //   DateTime ystart = DateTime(dn);
      //   dn = dt.year + 10;
      //   DateTime yend = DateTime(dn);

      //   showDatePicker(
      //     context: context,
      //     initialDate: dtClass.DateTimeNow(),
      //     firstDate: ystart,
      //     lastDate: yend,
      //   ).then((value) {
      //     if (value != null) {
      //       setState(() {
      //         txtDateStop.text = dtClass.ConvertDateThaiNow(value);
      //         if (_errorField == 'date_stop') {
      //           _errorField = null;
      //         }
      //       });
      //     }
      //   });
      // },
    );

    final txt_days = TextField(
      style: styleHeadPurple4,
      controller: txtDays,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: lightyellow2,
        hintText: "จำนวนวัน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );

    //==========DDL================================
    final ddlStatusJob = DropdownButton(
      focusNode: _focus_ddl_status,
      borderRadius: BorderRadius.circular(10),
      value: sel_status_job,
      //value: '0',
      items:
          itemStatusJob.map((item) {
            int index = itemStatusJob.indexOf(item);
            return DropdownMenuItem<String>(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('$item'),
              ),
              //value: item,
              value: index.toString(),
            );
          }).toList(),
      onChanged: (value) {
        setState(() {
          sel_status_job = value!;
          txt_status_job = itemStatusJob[int.parse(value)];
        });

        if (value != '0') {
          // get status detail in tbl_msg_status_detail
          mydb.getStatusMsg(value).then((json_value) {
            //print(json_value);
            //itemStatusJobDetail.add('test0');

            if (json_value != '') {
              final jsonRes = json.decode(json_value);
              if (jsonRes != null) {
                // loop value in json object
                //jsonRes["userid"];

                //===============================================
                itemStatusJobDetail.clear();
                itemStatusJobDetail.add('กรุณาเลือกรายละเอียดสถานะงาน');

                itemStatusJobDetailDay.clear();
                itemStatusJobDetailDay.add(0); // Placeholder for days

                for (var i = 0; i < jsonRes.length; i++) {
                  //print(jsonRes[i].name_msg_detail.toString() + "\n");
                  //print(jsonRes[i]['name_msg_detail'].toString() + "\n");
                  itemStatusJobDetail.add(
                    jsonRes[i]['name_msg_detail'].toString(),
                  );

                  itemStatusJobDetailDay.add(int.parse(jsonRes[i]['days']));
                }

                setState(() {
                  sel_status_job_detail = "0";
                  txt_status_job_detail = '';
                });
                //===============================================
              }
            }
          });
        }
      },
      //hint: Text("เลือกปีงบประมาณ"),
      disabledHint: Text("Disabled"),
      elevation: 3,
      style: TextStyle(
        color: Colors.green.shade900,
        fontSize: 13,
        //fontWeight: FontWeight.bold
      ),
      //style: styleLabel,
      dropdownColor: Colors.grey.shade200,
      icon: Icon(Icons.arrow_drop_down_circle),
      iconDisabledColor: Colors.red,
      iconEnabledColor: Colors.blue,
      iconSize: 30,
    );

    final ddlStatusJobDetail = DropdownButton(
      focusNode: _focus_ddl_status_detail,
      borderRadius: BorderRadius.circular(10),
      value: sel_status_job_detail,
      items:
          itemStatusJobDetail.map((item) {
            int index = itemStatusJobDetail.indexOf(item);
            return DropdownMenuItem<String>(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('$item'),
              ),
              //value: item,
              value: index.toString(),
            );
          }).toList(),
      onChanged: (value) {
        setState(() {
          sel_status_job_detail = value!;
          txt_status_job_detail = itemStatusJobDetail[int.parse(value)];
          txtDays.text = itemStatusJobDetailDay[int.parse(value)].toString();
          // calculate date_stop

          if (!_focus_ddl_status_detail.hasFocus) {
            if (txtDateStart.text.isNotEmpty &&
                txtDays.text != '0' &&
                txtDateStart
                    .text
                    .isNotEmpty) //&& txtDateStart.text != "0000-00-00"
            {
              //=====get holiday in year======
              String day_end;

              holidayService
                  .getAllHoliday(yearNow.toString())
                  .then((holidayData) {
                    day_end = dtClass.LastDate(
                      dtClass.ConvertDateThaitoDB(txtDateStart.text),
                      int.parse(txtDays.text),
                      holidayData['dates'],
                    );
                    setState(() {
                      txtDateStop.text = dtClass.ConvertDateThai(day_end);
                    });
                  })
                  .catchError((error) {
                    print('Failed to load holiday data: $error');
                  });
            }
          }
        });
      },
      //hint: Text("เลือกปีงบประมาณ"),
      disabledHint: Text("Disabled"),
      elevation: 3,
      style: TextStyle(
        color: Colors.green.shade900,
        fontSize: 13,
        //fontWeight: FontWeight.bold
      ),
      //style: styleLabel,
      dropdownColor: Colors.grey.shade200,
      icon: Icon(Icons.arrow_drop_down_circle),
      iconDisabledColor: Colors.red,
      iconEnabledColor: Colors.blue,
      iconSize: 30,
    );

    // final ddlStatusJobDetail = DropdownButton(
    //   focusNode: _focus_ddl_status_detail,
    //   borderRadius: BorderRadius.circular(10),
    //   value: sel_status_job_detail,
    //   items:
    //       itemStatusJobDetail.map((item) {
    //         int index = itemStatusJobDetail.indexOf(item);
    //         return DropdownMenuItem<String>(
    //           child: Padding(
    //             padding: const EdgeInsets.all(2.0),
    //             child: Text('$item'),
    //           ),
    //           //value: item,
    //           value: index.toString(),
    //         );
    //       }).toList(),
    //   onChanged: (value) {
    //     setState(() {
    //       sel_status_job_detail = value!;
    //       txt_status_job_detail = itemStatusJobDetail[int.parse(value)];
    //     });
    //   },
    //   //hint: Text("เลือกปีงบประมาณ"),
    //   disabledHint: Text("Disabled"),
    //   elevation: 3,
    //   style: TextStyle(
    //     color: Colors.green.shade900,
    //     fontSize: 13,
    //     //fontWeight: FontWeight.bold
    //   ),
    //   //style: styleLabel,
    //   dropdownColor: Colors.grey.shade200,
    //   icon: Icon(Icons.arrow_drop_down_circle),
    //   iconDisabledColor: Colors.red,
    //   iconEnabledColor: Colors.blue,
    //   iconSize: 30,
    // );

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
              focusNode: _focus_ddl_to_unit,
              //autofocus: true,
              //isExpanded: true,
              borderRadius: BorderRadius.circular(10),
              items:
                  snapshot.data
                      ?.map(
                        (item) => DropdownMenuItem<String>(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              item.uint_name,
                              style: TextStyle(
                                //backgroundColor: white,
                                //decoration: TextDecoration.underline,
                                color: Colors.green.shade900,
                                //backgroundColor: lightgreen
                              ),
                            ),
                          ),
                          value: item.uint,
                        ),
                      )
                      .toList(),
              value: sent_to,
              //value: "",
              //value: null,
              onChanged: (un) {
                setState(() {
                  sent_to = un.toString();

                  snapshot.data?.map((item) {
                    if (item.uint == un) {
                      txt_sent_to = item.uint_name;
                      print("txt_sent_to=" + txt_sent_to);
                    }
                  }).toList();
                });
                // ignore: unused_local_variable
                var msg = new ResponseMessage();
                //msg.Alert(context, "เลือกหน่วยงาน", unitNow.toString());
              },
              //isExpanded: true,
              hint: Text('กรุณาเลือกหน่วยที่ต้องการ'),
              disabledHint: Text("Disabled"),
              elevation: 3,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 13.0,
                //fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
              //style: Theme.of(context).textTheme.labelMedium,
              //style: Theme.of(context).textTheme.bodyText2,
              dropdownColor: Colors.grey.shade200,
              //dropdownColor: lightyellow2,
              //focusColor: Colors.yellow.shade100,
              icon: Icon(Icons.arrow_drop_down_circle),
              iconDisabledColor: Colors.red,
              iconEnabledColor: Colors.blue,
              iconSize: 30,
            );
        },
      );
    }

    //=======widget button===========
    final saveButton = Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.deepPurple,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        highlightColor: Colors.amber, //on press button change color
        onPressed: () {
          //validate data
          List<String> missing = [];
          if (sent_to == '0') missing.add('unit');
          if (sel_status_job == '0') missing.add('status_job');
          if (sel_status_job_detail == '0') missing.add('status_job_detail');

          if (missing.isNotEmpty) {
            final firstMissing = missing.first;
            switch (firstMissing) {
              case 'unit':
                msgStr = 'กรุณาเลือกหน่วยที่ต้องการส่ง';
                break;
              case 'status_job':
                msgStr = 'กรุณาเลือกสถานะงาน';
                break;
              case 'status_job_detail':
                msgStr = 'กรุณาเลือกรายละเอียดสถานะงาน';
                break;
              default:
                msgStr = 'กรุณากรอกข้อมูลให้ครบถ้วน !!!';
            }
            msg.Alert(context, 'Error', msgStr);
            return;
          }

          // All validations passed

          //=============================================================

          if (widget.id_job.isEmpty ||
              id_use_int == "0" ||
              sent_to == "0" ||
              txtDate.text.isEmpty ||
              sel_status_job == "0" ||
              itemStatusJobDetail[int.parse(sel_status_job_detail)] ==
                  'กรุณาเลือกรายละเอียดสถานะงาน' ||
              txtSender.text.isEmpty) // add years , id_exp_spen
          {
            // if (_file != null) {
            //   FileName = _file!.path;
            //   FileName = FileName.replaceAll(RegExp(r'.*/'), '');
            // } else {
            //   FileName = "";
            // }
            // print("file : " + FileName);

            msgStr = "กรุณากรอกข้อมูลให้ครบถ้วน !!!";
            msg.Alert(context, "Error", msgStr);
          } else {
            //=======================save===========================================
            txt_status_job_detail =
                itemStatusJobDetail[int.parse(sel_status_job_detail)];

            //txtDate.text = now.ConvDateThaiToDateDB(txtDate.text);
            String dateDB = dtClass.ConvDateThaiToDateDB(txtDate.text);
            print("date format db : " + dateDB);

            // cut only filename
            if (_file != null) {
              FileName = _file!.path;
              FileName = FileName.replaceAll(
                RegExp(r'.*/'),
                '',
              ); // แทนจุดด้วยช่องว่าง
            } else {
              FileName = "";
            }
            print("file : " + FileName);

            mydb.SendExpediteUser(
              txtYear.text,
              txtBookNo.text,
              txtListName.text,
              txtTitle.text,
              txtUnitName.text,
              widget.id_job,
              id_use_int,
              sent_to,
              txt_sent_to,
              dateDB, //txtDate.text,
              txt_status_job, //sel_status_job,
              txt_status_job_detail, //sel_status_job_detail,
              FileName,
              txtETC.text,
              // txtResponseOriginal.text it will reccord in rx
              txtSender.text,
              login.get('mobile'),
            )
            //txtResponse.text)
            .then((String result) {
              var ret = json.decode(result);

              //String msgstr = "";
              if (ret["result"] == "false") {
                msgStr = "ผิดพลาดในการบันทึก : ${ret["msg"]} ";
              } else if (ret["result"] == "true") {
                msgStr = "บันทึกเรียบร้อยแล้ว";
                print("Status Insert : $msgStr");

                if (_file != null) {
                  upc.UploadFileToServer(_file, "$Budget_Site").then((value) {
                    // if (value != "") {
                    //   print("Upload File Successful \n FileName : " + value);
                    // } else {
                    //   print("Error Upload File");
                    // }
                    //var ret = json.decode(value);
                    //print(ret["result"] + " | " + ret["msg"]);
                    Map<String, dynamic> ret = jsonDecode(
                      value.replaceAll("'", '"'),
                    );

                    if (ret['result'] == true) {
                      print("Success Upload File");
                    } else {
                      print('Error Upload File : $ret["msg"]');
                    }
                  });
                }
              }

              msg.Alert(context, "ผลการบันทึก", "ผลคือ : ${msgStr}");

              // GetExpUserSend.php for show last start 10 send
              // final oneSecond = Duration(seconds: 1);
              // Future.delayed(oneSecond * 2, () {
              //   Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => ShowStartBook(),
              //     ),
              //   );
              // });
            });
          }
        },
        child: Text(
          "เริ่มส่ง",
          textAlign: TextAlign.center,
          style: styleHeadPurple4.copyWith(
            color: lightyellow2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final selFileButton = Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(30.0),
      color: green,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width / 5,
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        highlightColor: Colors.amber, //on press button change color
        onPressed: () {
          upc.getFile().then((value) {
            if (value != null) {
              setState(() {
                _file = value;
                txtFile.text = value.path;
              });
            }
          });
        },
        child: Text(
          "เลือกแฟ้ม",
          textAlign: TextAlign.center,
          style: styleHeadPurple4.copyWith(
            color: lightyellow2,
            //fontWeight: FontWeight.bold
          ),
        ),
      ),
    );

    final backButton = Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.redAccent,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        highlightColor: Colors.amber, //on press button change color
        onPressed: () {
          //Navigator.of(context).pop();
          //ShowStartBook.routeName,
          Navigator.popAndPushNamed(context, ShowStartBook.routeName);
        },
        child: Text(
          "ย้อนกลับ",
          textAlign: TextAlign.center,
          style: styleHeadPurple4.copyWith(
            color: lightyellow2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final downloadButton = Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(30.0),
      color: blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width / 5,
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        highlightColor: Colors.amber, //on press button change color
        onPressed: () async {
          //Navigator.of(context).pop();
          //ShowStartBook.routeName,
          //Navigator.popAndPushNamed(context, ShowStartBook.routeName);

          String urlPath = 'http://$ipAddress/$Budget_Site/Follow/doc/';

          if (FileNameOriginal.isEmpty) {
            snackMsg.showSnackBarMsg('ไม่พบไฟล์แนบ', context);
            return;
          }

          //call launchURL(urlStr, fileName)
          //String fullUrl = urlStr + Uri.encodeComponent(fileName);
          //url = "http://$ipAddress/$Budget_Site/Follow/doc/$FileNameOriginal";
          try {
            await open.launchURL(urlPath, FileNameOriginal);
          } catch (e) {
            snackMsg.showSnackBarMsg(e.toString(), context);
          }
        },
        child: Text(
          "Download",
          textAlign: TextAlign.center,
          style: styleHeadPurple4.copyWith(
            color: lightyellow2,
            //fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );

    //======init data=======
    txtSender.text = fullname;

    //===tbl_exp_spen====
    mydb.getExpDetail(widget.id_exp_spen).then((Expedite? result) {
      if (result != null) {
        txtListName.text = result.list_exp_spen;
        //widget.id_exp_spen;
      }
      //txtMemo.text = result.memo_th;

      //txtBorder.text = result.mborder;
      //txtMalloc.text = result.malloc;

      //MoneyFormatterOutput fo = FlutterMoney(amount: double.parse(result.mborder)).output;
      //txtBorder.text = fo.nonSymbol;

      //fo = FlutterMoney(amount: double.parse(result.malloc)).output;
      //txtMalloc.text = fo.nonSymbol;
    });

    // //=====tbl_book_unit====
    //     mydb
    //         .getBookIdJob(widget.id_job, yearNow.toString())
    //         .then((BookUnit? result) {
    //       if (result != null) {
    //         txtTitle.text = result.title;
    //         txtBookNo.text = result.doc_unit_no;

    //         MoneyFormatterOutput fo = FlutterMoney(amount: result.amout).output;

    //         txtAmout.text = fo.nonSymbol;

    //         txtDateOriginal.text = result.unit_date_no;
    //         txtUnitName.text = result.id_use_int.toString();
    //         txtAcc.text = result.speed_class.toString();
    //         txtSecret.text = result.secret_class.toString();

    //         setState(() {
    //           FileNameOriginal = result.doc_unit;
    //         });
    //       }
    //     });

    //=====defined coding=====
    //txtAmout.text = "0";
    //txtResponse.text = fullname;

    //print(fullname);
    //print(unitStr);
    //_focus.requestFocus();
    //FocusScope.of(context).requestFocus(_focus);

    //========Scaffold======
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "หน่วยต้นเรื่องเริ่มบันทึก",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text('รายละเอียดงบที่บันทึก', style: styleHeadPurple4),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ประจำปีงบประมาณ',
                      style: styleHeadPurple4.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                      ),
                    ),
                    Text(
                      ' $yearNow',
                      style: styleHeadPurple4.copyWith(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      child: Text(
                        'ชื่อหน่วยงาน : ',
                        style: styleSmalless(black),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.7,
                      child: txt_unitname,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      child: Text(
                        'ชื่องบประมาณ : ',
                        style: styleSmalless(black),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.7,
                      child: txtlistname,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      child: Text('ชื่อเรื่อง : ', style: styleSmalless(black)),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.7,
                      child: txttitle,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      child: Text(
                        'ที่ของหนังสือ : ',
                        style: styleSmalless(black),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.7,
                      child: txtbookno,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      child: Text('จำนวนเงิน : ', style: styleSmalless(black)),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.7,
                      child: txt_amout,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      child: Text(
                        'วันที่ของหนังสือ : ',
                        style: styleSmalless(black),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.7,
                      child: txt_date_original,
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(2.0),
              //   child: Row(
              //     children: [
              //       Container(
              //         width: 85,
              //         child: Text(
              //           'วันที่ส่งเรื่อง : ',
              //           style: styleSmalless(black),
              //         ),
              //       ),
              //       Container(
              //         width: SizeConfig.screenWidth * 0.7,
              //         child: txtdate,
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      child: Text(
                        'ความเร่งด่วน : ',
                        style: styleSmalless(black),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.7,
                      child: txt_acc,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      child: Text(
                        'ชั้นความลับ : ',
                        style: styleSmalless(black),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.7,
                      child: txt_secret,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      child: Text('ประเภทงาน : ', style: styleSmalless(black)),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.7,
                      child: txt_type_job,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      child: Text('ผู้สร้าง : ', style: styleSmalless(black)),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.7,
                      child: txt_response_original,

                      //width: 350,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 85,
                      child: Text(
                        'เอกสารของต้นเรื่อง : ',
                        style: styleSmalless(black),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        //padding: const EdgeInsets.only(left: 0),
                        fixedSize: Size(SizeConfig.screenWidth * 0.7, 55),
                        alignment: Alignment.centerLeft,
                        foregroundColor: blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        backgroundColor: lightyellow2,
                      ),
                      onPressed: () async {
                        //print("Open Attached File: " + FileNameOriginal);

                        if (FileNameOriginal.isEmpty) {
                          snackMsg.showSnackBarMsg('ไม่พบไฟล์แนบ', context);
                          return;
                        }

                        if (!FileNameOriginal.toLowerCase().endsWith('.pdf')) {
                          const warning =
                              'not support view please download file';
                          print(warning);
                          snackMsg.showSnackBarMsg(warning, context);
                          return;
                        }

                        url =
                            "http://$ipAddress/$Budget_Site/Follow/doc/$FileNameOriginal";

                        //final uri = Uri.parse('https://www.google.co.th');

                        /*
                              http://10.130.230.64/index.htm
                              https://www.google.co.th
                        */

                        // openRemoteFile(url);

                        // Uri uri = Uri.parse(url);
                        // print("Url File: " + url);

                        // String encodedUrl = Uri.encodeQueryComponent(url);
                        // print("Encode Url File: " + encodedUrl);

                        // checck $FileNameOriginal if is pdf open pdf
                        // if is picture open new page
                        // if is other doc ppt xls confirm download? not view

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ViewPDF(url)),
                        );
                      },
                      child: Text(
                        FileNameOriginal,
                        style: styleSmalless(purple),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),

              //hidden TextField
              //Visibility(visible: false, child: txt_hide_bookdate),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      child: Text(
                        'วันที่เริ่ม : ',
                        style: styleSmalless(black),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.7,
                      child: txt_date_start,

                      //width: 350,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      child: Text(
                        'วันที่สิ้นสุด : ',
                        style: styleSmalless(black),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.7,
                      child: txt_date_stop,

                      //width: 350,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      child: Text('จำนวนวัน : ', style: styleSmalless(black)),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.7,
                      child: txt_days,

                      //width: 350,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'ดาวน์โหลดไฟล์ : ',
                        style: styleSmalless(black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        child: downloadButton,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          //color: blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('ส่งถึงหน่วย :', style: styleSmalless(black)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      child: ddlUnit(unitList),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('ประเภทงาน :', style: styleSmalless(black)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      child: ddlStatusJob,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Column(
                      children: [
                        Text('รายละเอียด : ', style: styleSmalless(black)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      child: ddlStatusJobDetail,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    Container(
                      width: 75,
                      child: Text('หมายเหตุ : ', style: styleSmalless(black)),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.7,
                      child: txt_etc,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      child: Text(
                        'ผู้รับผิดชอบ : ',
                        style: styleSmalless(black),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.7,
                      child: txt_sender,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      child: Text('เอกสารแนบ : ', style: styleSmalless(black)),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.74,
                      child: txt_file,
                    ),
                  ],
                ),
              ),
              Padding(padding: const EdgeInsets.all(2.0), child: selFileButton),
              Padding(padding: const EdgeInsets.all(2.0), child: saveButton),
              Padding(padding: const EdgeInsets.all(2.0), child: backButton),
            ],
          ),
        ),
      ),
    );
  }
}
