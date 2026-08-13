import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:budget_mobile/budget/ReceiveExpedite.dart';
import 'package:budget_mobile/budget/ShowReceiveExpedite.dart';
//import 'package:budget_mobile/budget/ShowStartBook.dart';
import 'package:budget_mobile/models/BookUnit.dart';
import 'package:budget_mobile/models/TBStatusSearch.dart';
import 'package:flutter/material.dart';
//import '../MainPageAdmin.dart';
import '../global/GetHoliday.dart';
import '../global/MySQLService.dart';
import '../global/size_config.dart';
import '../models/Expedite.dart';
import '../global/globalVar.dart';
import '../global/ResponseMessage.dart';
//import '../global/GetYearBudget.dart';
import '../global/FormatMoney.dart';
import '../models/UnitName.dart';
import 'package:budget_mobile/styles/colors.dart';
import 'package:budget_mobile/styles/TextStyle.dart';
import 'package:intl/intl.dart';
import '../global/DateTimes.dart';
import '../global/ManageLogin.dart';
import '../upload/UploadFileBudget.dart';
import '../widget_share/SnackBarMsg.dart';

import '../widget_share/ViewPDF.dart';
import '../download/OpenUrlBrowser.dart';

var login;

class SendTbStatusBetweenUnit extends StatefulWidget {
  // get value from ShowStartBook
  final TBStatusSearch tbstatus;

  const SendTbStatusBetweenUnit({required this.tbstatus});

  @override
  _SendTbStatusBetweenUnitState createState() =>
      _SendTbStatusBetweenUnitState(tbstatus);
}

class _SendTbStatusBetweenUnitState extends State<SendTbStatusBetweenUnit> {
  String id_job = "0";
  String id_status = "0";
  String id_exp_spen = "0";
  String years = "";

  _SendTbStatusBetweenUnitState(TBStatusSearch tbstatus) {
    id_job = tbstatus.id_job.toString();
    years = tbstatus.years;
    id_status = tbstatus.id_status.toString();
    id_exp_spen = tbstatus.id_exp_spen;
  }

  late MySQLDB mydb;
  late ResponseMessage msg;
  late DateTimes dtClass = DateTimes();
  // String DateString = "";
  //String DateReal = "";
  String msgStr = "";

  // ddl unit data
  late Future<List<UnitName>?> unitList;
  late String sent_to;
  String txt_sent_to = "";
  String url = "";
  String uid = "0";

  File? _file;
  String FileNameOriginal = "";
  String FileName = "";
  UploadFileClass upc = UploadFileClass();

  // download file attach original
  late OpenUrlBrowser open;

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
  List<int> itemStatusJobDetailDay = [0];

  //String sel_status_job = "กรุณาเลือกสถานะงาน";
  String sel_status_job = "0";
  String txt_status_job = "";

  String sel_status_job_detail = "0";
  String txt_status_job_detail = "";

  String id_use_int = "0";
  //String send_to = "0";

  List<String> itemSecret = ['ปกติ', 'ลับ', 'ลับมาก', 'ลับที่สุด'];
  List<String> itemAcc = ['ปกติ', 'ด่วน', 'ด่วนมาก', 'ด่วนที่สุด'];

  //=======get Holiday data==========
  final GetHoliday holidayService = GetHoliday();
  //=====Controller Text===========
  // show only
  final txtListName = TextEditingController();
  final txtTitle = TextEditingController();
  final txtAmout = TextEditingController();
  final txtDateOriginal = TextEditingController();
  final txtSender = TextEditingController();
  final txtResponseOriginal = TextEditingController();
  final txtYear = TextEditingController();
  final txtBookNo = TextEditingController();
  final txtAcc = TextEditingController();
  final txtSecret = TextEditingController();
  final txtUnitName = TextEditingController();
  final txtTypeJob = TextEditingController();
  final txtFile = TextEditingController();

  final txtDate = TextEditingController();
  final txtETC = TextEditingController();
  final txtDateStart = TextEditingController();
  final txtDateStop = TextEditingController();
  final txtDays = TextEditingController();

  // Keep a single list of all controllers for streamlined dispose
  late final List<TextEditingController> AllTextControllerinWidget;

  // define FocusNode
  final FocusNode _focus_title = FocusNode();
  final FocusNode _focus_bookno = FocusNode();
  final FocusNode _focus_amout = FocusNode();
  final FocusNode _focus_date = FocusNode();
  final FocusNode _focus_date_start = FocusNode();
  final FocusNode _focus_date_stop = FocusNode();
  final FocusNode _focus_days = FocusNode();
  final FocusNode _focus_status_job = FocusNode();
  final FocusNode _focus_status_detail = FocusNode();
  final FocusNode ddlNode = FocusNode(); // ddl unit / sent to

  // Track which field currently has a validation error for highlighting
  String? _errorField;

  void _focusErrorField() {
    if (_errorField == null) return;
    switch (_errorField) {
      case 'date_start':
        _focus_date_start.requestFocus();
        break;
      case 'date_stop':
        _focus_date_stop.requestFocus();
        break;
      case 'days':
        _focus_days.requestFocus();
        break;
      case 'status_job':
        _focus_status_job.requestFocus();
        break;
      case 'status_job_detail':
        _focus_status_detail.requestFocus();
        break;
      case 'sent_to':
        ddlNode.requestFocus();
        break;
    }
  }

  String _sanitizeFileName(String rawFileName) {
    if (rawFileName.isEmpty) return rawFileName;

    final trimmed = rawFileName.trim();
    final lastDotIndex = trimmed.lastIndexOf('.');

    String sanitizeName(String input) {
      String sanitized = input;
      sanitized = sanitized.replaceAll(RegExp(r'\s+'), '_');
      sanitized = sanitized.replaceAll('.', '');
      sanitized = sanitized.replaceAll(RegExp(r'[\\/?!\*]+'), '_');
      sanitized = sanitized.replaceAll(RegExp(r'_+'), '_');
      sanitized = sanitized.replaceAll(RegExp(r'^_+'), '');
      sanitized = sanitized.replaceAll(RegExp(r'_+$'), '');
      if (sanitized.isEmpty) {
        sanitized = 'file';
      }
      return sanitized;
    }

    if (lastDotIndex <= 0) {
      return sanitizeName(trimmed);
    }

    final namePart = trimmed.substring(0, lastDotIndex);
    final extension = trimmed.substring(lastDotIndex);
    final sanitizedName = sanitizeName(namePart);

    return '$sanitizedName$extension';
  }

  //==========set==fullname=====
  String fullname = ""; // for response person
  late String mobile;
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
      //txtResponse.text = fullname + " " + login.get("unitname");
      txtSender.text = fullname;
      txtUnitName.text = login.get("unitname");
      mobile = login.get("mobile");
      uid = login.get("uid");
    });

    msg = ResponseMessage();
    mydb = MySQLDB();

    //=====init Data=================
    // GetYearBudget yb = new GetYearBudget();
    // yearNow = yb.getYearBudget();
    // txtYear.text = yearNow.toString();
    txtYear.text = years;

    //=====init UNIT Name==============
    sent_to = "0";
    unitList = mydb.getUnitList();

    //======init Date to TextField========

    // txtDateStart.text = "0000-00-00";
    txtDateStart.text = dtClass.ConvertDateThai(
      DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    // txtDateStop.text = "0000-00-00";
    txtDateStop.text = "0000-00-00";
    txtDays.text = "0";

    // Register controllers for easier cleanup
    AllTextControllerinWidget = [
      txtListName,
      txtTitle,
      txtAmout,
      txtDateOriginal,
      txtSender,
      txtResponseOriginal,
      txtYear,
      txtBookNo,
      txtAcc,
      txtSecret,
      txtUnitName,
      txtTypeJob,
      txtFile,
      txtDate,
      txtETC,
      txtDateStart,
      txtDateStop,
      txtDays,
    ];

    //=====tbl_book_unit====
    mydb
        .getBookIdJob(
          id_job,
          years,
        ) //.getBookIdJob(widget.id_job, yearNow.toString())
        .then((BookUnit? result) {
          if (result != null) {
            txtTitle.text = result.title;
            txtBookNo.text = result.doc_unit_no;

            // convert date from DB to thai date
            txtDateOriginal.text = dtClass.ConvertDateThaiNow(
              DateTime.parse(result.unit_date_no),
            );

            txtAmout.text = FormatMoney.formatCurrencyfromDouble(
              double.parse(widget.tbstatus.amout),
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

    open = OpenUrlBrowser();
  }

  @override
  void dispose() {
    _focus_title.dispose();
    _focus_bookno.dispose();
    _focus_amout.dispose();
    _focus_date.dispose();
    _focus_date_start.dispose();
    _focus_date_stop.dispose();
    _focus_days.dispose();
    _focus_status_job.dispose();
    _focus_status_detail.dispose();
    ddlNode.dispose();

    for (final controller in AllTextControllerinWidget) {
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
      style: styleHeadPurple4,
      //autofocus: true,
      readOnly: true,
      focusNode: _focus_title,
      controller: txtTitle,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        filled: true,
        fillColor: _errorField == 'title' ? Colors.red.shade100 : lightyellow2,
        hintText: "ชื่อเรื่อง",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onChanged: (value) {
        if (_errorField == 'title' && value.trim().isNotEmpty) {
          setState(() => _errorField = null);
        }
      },
    );

    final txt_amout = TextField(
      style: styleHeadPurple4,
      focusNode: _focus_amout,
      controller: txtAmout,
      readOnly: true,
      //keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        filled: true,
        //fillColor: _errorField == 'amout' ? Colors.red.shade100 : lightyellow2,
        fillColor: lightyellow2,
        hintText: "จำนวนเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      // onChanged: (value) {
      //   final cleaned = value.replaceAll(RegExp(r'[,\s]'), '');
      //   final parsed = double.tryParse(cleaned);
      //   final invalid = parsed == null || parsed <= 0;
      //   if (invalid) {
      //     if (_errorField != 'amout') setState(() => _errorField = 'amout');
      //   } else if (_errorField == 'amout') {
      //     setState(() => _errorField = null);
      //   }
      // },
    );

    final txtbookno = TextField(
      readOnly: true,
      style: styleHeadPurple4,
      focusNode: _focus_bookno,
      controller: txtBookNo,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        filled: true,
        fillColor: _errorField == 'bookno' ? Colors.red.shade100 : lightyellow2,
        hintText: "ที่ของหนังสือ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onChanged: (value) {
        if (_errorField == 'bookno' && value.trim().isNotEmpty) {
          setState(() => _errorField = null);
        }
      },
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

    // final txtdate = TextField(
    //   readOnly: true,
    //   style: styleHeadPurple4,
    //   focusNode: _focus_date,
    //   controller: txtDate,
    //   decoration: InputDecoration(
    //     contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
    //     filled: true,
    //     fillColor: _errorField == 'date' ? Colors.red.shade100 : lightyellow2,
    //     hintText: "วันที่เริ่มส่งเรื่อง",
    //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
    //   ),
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
    //         DateString = dtClass.ConvertDateThaiNow(value);
    //         //DateReal = now.ConvertDateDB(value);
    //       });

    //       txtDate.text = DateString;

    //       if (_errorField == 'date') {
    //         setState(() => _errorField = null);
    //       }
    //       //txtHideDate.text = DateReal;
    //     }
    //   });
    // },
    //onSubmitted: (v) {
    //_fieldFocusChange(context, _focus, _nextFocus);
    //},
    // );

    final txt_date_start = TextField(
      style: styleHeadPurple4,
      focusNode: _focus_date_start,
      controller: txtDateStart,
      readOnly: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        filled: true,
        fillColor:
            _errorField == 'date_start' ? Colors.red.shade100 : lightyellow2,
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
      //         if (_errorField == 'date_start') _errorField = null;
      //       });
      //     }
      //   });
      // },
    );

    final txt_days = TextField(
      readOnly: true,
      style: styleHeadPurple4,
      focusNode: _focus_days,
      controller: txtDays,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        filled: true,
        fillColor: _errorField == 'days' ? Colors.red.shade100 : lightyellow2,
        hintText: "จำนวนวัน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onChanged: (value) {
        if (_errorField == 'days' && value.isNotEmpty && value != '0') {
          setState(() => _errorField = null);
        }
      },
    );

    final txt_date_stop = TextField(
      style: styleHeadPurple4,
      focusNode: _focus_date_stop,
      controller: txtDateStop,
      readOnly: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        filled: true,
        fillColor:
            _errorField == 'date_stop' ? Colors.red.shade100 : lightyellow2,
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
      //         if (_errorField == 'date_stop') _errorField = null;
      //       });
      //     }
      //   });
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

    //==========DDL================================
    final ddlStatusJob = DropdownButton(
      focusNode: _focus_status_job,
      borderRadius: BorderRadius.circular(10),
      value: sel_status_job,
      items:
          itemStatusJob.map((item) {
            int index = itemStatusJob.indexOf(item);
            return DropdownMenuItem<String>(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('$item'),
              ),
              value: index.toString(),
            );
          }).toList(),
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          sel_status_job = value;
          txt_status_job = itemStatusJob[int.parse(value)];
          if (_errorField == 'status_job' && value != '0') {
            _errorField = null;
          }
        });

        if (value != '0') {
          mydb.getStatusMsg(value).then((json_value) {
            if (json_value != '') {
              final jsonRes = json.decode(json_value);
              if (jsonRes != null) {
                itemStatusJobDetail.clear();
                itemStatusJobDetail.add('กรุณาเลือกรายละเอียดสถานะงาน');

                itemStatusJobDetailDay.clear();
                itemStatusJobDetailDay.add(0); // Placeholder for days

                for (var i = 0; i < jsonRes.length; i++) {
                  itemStatusJobDetail.add(
                    jsonRes[i]['name_msg_detail'].toString(),
                  );

                  itemStatusJobDetailDay.add(int.parse(jsonRes[i]['days']));
                }
                setState(() {
                  sel_status_job_detail = '0';
                  txt_status_job_detail = '';
                });
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
      focusNode: _focus_status_detail,
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
              value: index.toString(),
            );
          }).toList(),
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          sel_status_job_detail = value;
          txt_status_job_detail = itemStatusJobDetail[int.parse(value)];

          txtDays.text = itemStatusJobDetailDay[int.parse(value)].toString();

          if (_errorField == 'status_job_detail' && value != '0') {
            _errorField = null;
          }
        });

        //msg.Alert(context, "days", txtDays.text);
        //=======  get Last Date Stop ==============
        if (txtDays.text != '0') {
          holidayService
              .getAllHoliday(years)
              .then((holidayData) {
                //print('Loaded holiday data: $holidayData');
                // print(
                //   "Holiday Count : " + holidayData['dates'].length.toString(),
                // );
                // for (int i = 0; i < holidayData['dates'].length; i++) {
                //   print(holidayData['dates'][i]);
                // }

                String day_end = dtClass.LastDate(
                  dtClass.ConvertDateThaitoDB(txtDateStart.text),
                  int.parse(txtDays.text),
                  holidayData['dates'],
                );
                setState(() {
                  txtDateStop.text = dtClass.ConvertDateThai(day_end);
                });

                // msg.Alert(
                //   context,
                //   "test convert thai date to yyyy-mm-dd",
                //   txtDateStop.text,
                // );
              })
              .catchError((error) {
                print('Failed to load holiday data: $error');
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
              borderRadius: BorderRadius.circular(10),
              items:
                  snapshot.data
                      ?.map(
                        (item) => DropdownMenuItem<String>(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              item.uint_name,
                              style: TextStyle(color: Colors.green.shade900),
                            ),
                          ),
                          value: item.uint,
                        ),
                      )
                      .toList(),
              value: sent_to,
              onChanged: (un) {
                if (un == null) return;
                setState(() {
                  sent_to = un.toString();
                  snapshot.data?.forEach((item) {
                    if (item.uint == un) {
                      txt_sent_to = item.uint_name;
                    }
                  });
                  if (_errorField == 'sent_to' && sent_to != '0') {
                    _errorField = null;
                  }
                });
              },
              hint: Text('กรุณาเลือกหน่วยที่ต้องการ'),
              disabledHint: Text("Disabled"),
              elevation: 3,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 13.0,
                color: Colors.brown,
              ),
              dropdownColor: Colors.grey.shade200,
              icon: Icon(Icons.arrow_drop_down_circle),
              iconDisabledColor: Colors.red,
              iconEnabledColor: Colors.blue,
              iconSize: 30,
            );
        },
      );
    }

    //=======widget button===========
    final sentButton = Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.deepPurple,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        highlightColor: Colors.amber, //on press button change color
        onPressed: () {
          List<String> missing = [];

          if (txtTitle.text.trim().isEmpty) missing.add('title');
          if (txtBookNo.text.trim().isEmpty) missing.add('bookno');
          if (txtAmout.text.trim().isEmpty) missing.add('amout');
          if (txtDate.text.trim().isEmpty) missing.add('date');
          if (sent_to == "0") missing.add('sent_to');
          if (sel_status_job == "0") missing.add('status_job');
          if (sel_status_job_detail == "0") missing.add('status_job_detail');

          if (missing.isNotEmpty) {
            const focusOrder = [
              'title',
              'bookno',
              'amout',
              'date',
              'sent_to',
              'status_job',
              'status_job_detail',
            ];

            final target = focusOrder.firstWhere(
              (field) => missing.contains(field),
              orElse: () => '',
            );

            if (target.isNotEmpty) {
              setState(() => _errorField = target);
              _focusErrorField();
            }

            if (missing.contains('sent_to')) {
              msgStr = "กรุณาเลือกหน่วยที่จะส่ง !!!";
            } else if (missing.contains('status_job_detail')) {
              msgStr = "กรุณาเลือกรายละเอียดสถานะงาน !!!";
            } else if (missing.contains('status_job')) {
              msgStr = "กรุณาเลือกประเภทงาน !!!";
            } else {
              msgStr = "กรุณากรอกข้อมูลให้ครบถ้วน !!!";
            }

            msg.Alert(context, "Error", msgStr);
            return;
          }

          final cleanedAmount = txtAmout.text.replaceAll(RegExp(r'[\,\s]'), '');
          final parsedAmount = double.tryParse(cleanedAmount);
          if (parsedAmount == null || parsedAmount <= 0) {
            setState(() => _errorField = 'amout');
            _focusErrorField();
            msg.Alert(context, "Error", "จำนวนเงินต้องเป็นตัวเลขมากกว่า 0");
            return;
          }

          final bool hasStart =
              txtDateStart.text.isNotEmpty && txtDateStart.text != "0000-00-00";
          final bool hasStop =
              txtDateStop.text.isNotEmpty && txtDateStop.text != "0000-00-00";
          final String daysText = txtDays.text.trim();
          final bool hasDays = daysText.isNotEmpty && daysText != '0';

          if (hasStart != hasStop) {
            setState(() => _errorField = hasStart ? 'date_stop' : 'date_start');
            _focusErrorField();
            msg.Alert(
              context,
              "Error",
              "กรุณากรอกวันที่เริ่มและวันที่สิ้นสุดให้ครบ",
            );
            return;
          }

          if ((hasStart || hasStop) && !hasDays) {
            setState(() => _errorField = 'days');
            _focusErrorField();
            msg.Alert(context, "Error", "กรุณากรอกจำนวนวัน");
            return;
          }

          if (hasDays) {
            final daysInt = int.tryParse(daysText);
            if (daysInt == null || daysInt <= 0) {
              setState(() => _errorField = 'days');
              _focusErrorField();
              msg.Alert(context, "Error", "จำนวนวันต้องเป็นตัวเลขมากกว่า 0");
              return;
            }
          }

          if (hasStart && hasStop) {
            DateTime startDate = DateTime.parse(
              dtClass.ConvDateThaiToDateDB(txtDateStart.text),
            );
            DateTime stopDate = DateTime.parse(
              dtClass.ConvDateThaiToDateDB(txtDateStop.text),
            );
            if (!stopDate.isAfter(startDate)) {
              setState(() => _errorField = 'date_stop');
              _focusErrorField();
              msg.Alert(
                context,
                "Error",
                "วันที่สิ้นสุดต้องมากกว่าวันที่เริ่มต้น",
              );
              return;
            }
          }

          //=======================save===========================================
          txt_status_job_detail =
              itemStatusJobDetail[int.parse(sel_status_job_detail)];

          String dateDB = dtClass.ConvDateThaiToDateDB(txtDate.text);
          print("date format db : " + dateDB);

          String dateStartDB =
              hasStart
                  ? dtClass.ConvDateThaiToDateDB(txtDateStart.text)
                  : '0000-00-00';
          String dateStopDB =
              hasStop
                  ? dtClass.ConvDateThaiToDateDB(txtDateStop.text)
                  : '0000-00-00';
          String daysDB = hasDays ? daysText : '0';

          if (_file != null) {
            FileName = _file!.path;
            FileName = FileName.split(RegExp(r'[\\/]+')).last;
            FileName = _sanitizeFileName(FileName);
          } else {
            FileName = "";
          }
          print("file : " + FileName);

          setState(() => _errorField = null);

          mydb.UpdateStatusBeforSent(id_status).then((json_value) {
            if (json_value != '') {
              final jsonRes = json.decode(json_value);
              if (jsonRes != null) {
                print(jsonRes['result'] + " | " + jsonRes["msg"]);
              }
            }
          });

          mydb.SendTbStatusBetweenUnit(
            txtYear.text,
            txtBookNo.text,
            txtListName.text,
            txtTitle.text,
            txtUnitName.text,
            id_job,
            id_use_int,
            sent_to,
            txt_sent_to,
            dateDB,
            txt_status_job,
            txt_status_job_detail,
            dateStartDB,
            dateStopDB,
            daysDB,
            txtETC.text,
            txtResponseOriginal.text,
            FileName,
            txtSender.text,
            mobile,
          ).then((String result) {
            var ret = json.decode(result);

            if (ret["result"] == "false") {
              msgStr = "ผิดพลาดในการบันทึก : ${ret["msg"]} ";
            } else if (ret["result"] == "true") {
              msgStr = "บันทึกเรียบร้อยแล้ว";
              print("Status Insert : $msgStr");

              if (_file != null) {
                upc.UploadFileToServer(_file, Budget_Site).then((value) {
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

            final oneSecond = Duration(seconds: 1);
            Future.delayed(oneSecond * 2, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowReceiveExpedite(uid),
                ),
              );
            });
          });
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
          // if (uid == '30') {
          //   //  Navigator.pushReplacement(context, MainPageAdmin.routeName as Route<Object?>);
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => MainPageAdmin(),
          //     ),
          //   );
          // } else
          //   Navigator.popAndPushNamed(context, ShowStartBook.routeName);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReceiveExpedite(tbstatus: widget.tbstatus),
            ),
          );
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

          //call launchURL(urlStr, fileName)
          //String fullUrl = urlStr + Uri.encodeComponent(fileName);
          //url = "http://$ipAddress/$Budget_Site/Follow/doc/$FileNameOriginal";
          if (FileNameOriginal.isEmpty) {
            snackMsg.showSnackBarMsg('ไม่พบไฟล์แนบ', context);
            return;
          }

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
    mydb.getExpDetail(id_exp_spen).then((Expedite? result) {
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
          "หน่วยเตรียมส่งเรื่อง",
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
                child: Text(
                  'รายละเอียดงบที่บันทึก',
                  style: styleHeadPurple4.copyWith(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
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
                        fontSize: 12.0,
                      ),
                    ),

                    //Text(' $yearNow',
                    Text(
                      ' ${years}',
                      style: styleHeadPurple4.copyWith(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
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
              //           'วันที่เริ่มส่ง : ',
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
                        foregroundColor: blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        backgroundColor: lightyellow2,
                      ),
                      onPressed: () async {
                        if (FileNameOriginal.isEmpty) {
                          snackMsg.showSnackBarMsg('ไม่พบไฟล์แนบ', context);
                          return;
                        }

                        final urlPath =
                            'http://$ipAddress/$Budget_Site/Follow/doc/';
                        final fileUrl = '$urlPath$FileNameOriginal';
                        final ext =
                            FileNameOriginal.split('.').last.toLowerCase();

                        const imageExt = {
                          'png',
                          'jpg',
                          'jpeg',
                          'gif',
                          'bmp',
                          'webp',
                          'svg',
                        };

                        try {
                          if (ext == 'pdf') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewPDF(fileUrl),
                              ),
                            );
                          } else if (imageExt.contains(ext)) {
                            // Let the browser render supported images
                            await open.launchURL(urlPath, FileNameOriginal);
                          } else {
                            // Other docs: trigger browser download
                            await open.launchURL(urlPath, FileNameOriginal);
                          }
                        } catch (e) {
                          snackMsg.showSnackBarMsg(e.toString(), context);
                        }
                      },
                      child: Text(
                        FileNameOriginal,
                        style: styleSmalless(purple),
                      ),
                    ),
                  ],
                ),
              ),

              //hidden TextField
              //Visibility(visible: false, child: txt_hide_bookdate),
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
                        color:
                            _errorField == 'sent_to'
                                ? Colors.red.shade100
                                : Colors.grey.shade200,
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
                        color:
                            _errorField == 'status_job'
                                ? Colors.red.shade100
                                : Colors.grey.shade200,
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
                        color:
                            _errorField == 'status_job_detail'
                                ? Colors.red.shade100
                                : Colors.grey.shade200,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 90,
                      child: Text(
                        'วันที่เริ่ม : ',
                        style: styleSmalless(black),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.7,
                      child: txt_date_start,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 90,
                      child: Text(
                        'วันที่สิ้นสุด : ',
                        style: styleSmalless(black),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.7,
                      child: txt_date_stop,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 90,
                      child: Text('จำนวนวัน : ', style: styleSmalless(black)),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.7,
                      child: txt_days,
                    ),
                  ],
                ),
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
              Text(
                'เฉพาะ doc,docx,xls,xlsx,ppt,pptx,pdf,jpeg,jpg,png !!!',
                textAlign: TextAlign.end,
                style: styleSmalless(yellow),
              ),
              Padding(padding: const EdgeInsets.all(2.0), child: selFileButton),
              Padding(padding: const EdgeInsets.all(2.0), child: sentButton),
              Padding(padding: const EdgeInsets.all(2.0), child: backButton),
            ],
          ),
        ),
      ),
    );
  }
}
