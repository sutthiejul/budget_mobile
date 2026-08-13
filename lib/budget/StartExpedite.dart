// ignore_for_file: prefer_const_constructors, file_names
import 'dart:convert';
// import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import '../global/FirstCharOnly.dart';
import '../global/GetHoliday.dart';
import '../global/MySQLService.dart';
import '../models/Expedite.dart';
import '../global/globalVar.dart';
import '../global/ResponseMessage.dart';
import '../global/GetYearBudget.dart';
import '../models/UnitName.dart';
import 'package:budget_mobile/styles/colors.dart';
import 'package:budget_mobile/styles/TextStyle.dart';
import '../global/DateTimes.dart';
import '../global/ManageLogin.dart';
import '../upload/UploadFileBudget.dart';
import 'ShowStartBook.dart';
import '../widget_share/SnackBarMsg.dart';
//import 'ShowExpUserStart.dart.bak';

var login;

class StartExpedite extends StatefulWidget {
  final String id_exp_spen;

  const StartExpedite({super.key, required this.id_exp_spen});

  @override
  _ShowBudgetDetailState createState() => _ShowBudgetDetailState();
}

class _ShowBudgetDetailState extends State<StartExpedite> {
  late MySQLDB mydb;
  late ResponseMessage msg;
  late DateTimes dtClass = DateTimes();
  String DateString = "";
  //String DateReal = "";
  String msgStr = "";
  late Future<List<UnitName>?> unitList;

  File? _file;
  String FileName = "";
  UploadFileClass upc = UploadFileClass();

  SnackBarMsg snackMsg = SnackBarMsg();
  //=========data ddl==============
  List<String> itemSecret = ['ปกติ', 'ลับ', 'ลับมาก', 'ลับที่สุด'];
  List<String> itemAcc = ['ปกติ', 'ด่วน', 'ด่วนมาก', 'ด่วนที่สุด'];
  List<String> itemTypeJob = [
    'กรุณาเลือกประเภทงาน',
    'MA',
    'ครุภัณฑ์',
    'งานจัดหารายบรรทัด',
    'งานซ่อมรถ',
    'งานโครงการ',
    'งานก่อสร้าง',
    'งานอื่นๆ',
  ];

  final GetHoliday holidayService = GetHoliday();

  int sel_acc = 0;
  int sel_secret = 0;
  double amout = 0.00;
  String sel_type_job = "กรุณาเลือกประเภทงาน";
  String txt_unit = "";
  String unitName = "";
  //String uid = "";

  //late String? unitNow;
  //String? unitNow = null;
  //=====Controller Text===========
  final txtListName = TextEditingController();
  final txtTitle = TextEditingController();
  final txtAmout = TextEditingController();
  final txtBookNo = TextEditingController();
  final txtDate = TextEditingController();
  //final txtHideDate = TextEditingController(); // Date Format DB
  //final txtMoney = TextEditingController();
  final txtResponse = TextEditingController();
  final txtYear = TextEditingController();
  final txtIdExpSpen = TextEditingController();
  final txtUnit = TextEditingController();
  final txtLastAccess = TextEditingController();
  final txtDateStart = TextEditingController();
  final txtDateStop = TextEditingController();
  final txtDays = TextEditingController();

  // Keep a single list of all controllers on this page for easy disposal
  late final List<TextEditingController> AllTextControllerinWidget;

  // file
  // ddl urgent
  // ddl secret
  // ddl type_job

  // define FocusNode
  final FocusNode _focus_title = FocusNode();
  final FocusNode _focus_addr_book = FocusNode();
  final FocusNode _focus_amout = FocusNode();
  final FocusNode _focus_date = FocusNode();
  final FocusNode _focus_date_start = FocusNode();
  final FocusNode _focus_date_stop = FocusNode();
  final FocusNode _focus_days = FocusNode();

  // Track which field currently has a validation error for highlighting
  String?
  _errorField; // values: title, bookno, amout, date, date_start, date_stop, days

  void _focusErrorField() {
    if (_errorField == null) return;
    switch (_errorField) {
      case 'title':
        _focus_title.requestFocus();
        break;
      case 'bookno':
        _focus_addr_book.requestFocus();
        break;
      case 'amout':
        _focus_amout.requestFocus();
        break;
      case 'date':
        _focus_date.requestFocus();
        break;
      case 'date_start':
        _focus_date_start.requestFocus();
        break;
      case 'date_stop':
        _focus_date_stop.requestFocus();
        break;
      case 'days':
        _focus_days.requestFocus();
        break;
    }
  }

  // (removed helper) amount validation is handled inline in onChanged/onPressed

  //final FocusNode _focus_ddlSecret = FocusNode();

  //const currencyRegExp = r'^(\d+)?\.?\d{0,2}$';
  // static const currencyRegExp = r'^(\d+)(?:\.|\,)\d{0,2}$';
  // final currencyFormatter = FilteringTextInputFormatter.allow(
  //   RegExp(currencyRegExp),
  // );

  //==========set==fullname=====
  String fullname = "";

  // ==== set year====
  int yearNow = 0;

  _ShowBudgetDetailState() {}

  @override
  void initState() {
    super.initState();

    // initHive Box Name : LoginData
    ManageLogin _login = ManageLogin();

    _login.DefineBox().then((box) {
      login = box;
      fullname = login.get('fullname');
      txt_unit = login.get("uid");
      txtResponse.text = fullname + " " + login.get("unitname");
      unitName = login.get("unitname");
    });

    msg = ResponseMessage();
    mydb = MySQLDB();

    //=====init Data=================
    yearNow = GetYearBudget.getYearBudget();
    txtYear.text = yearNow.toString();

    //=====init UNIT Name==============
    //unitNow = null;
    unitList = mydb.getUnitList();

    //======init Date to TextField========
    DateString = dtClass.DateThaiNow();
    txtDate.text = DateString; // show date now

    txtDateStart.text = "0000-00-00";
    txtDateStop.text = "0000-00-00";
    txtDays.text = "0";

    //txtHideDate.text = now.DateNowYMD(); // real record date

    // =====init Amout===================
    // setState(() {
    //   txtAmout.text = amout.toString();
    // });
    //txtAmout.text = "0";

    //_focus.requestFocus();
    //FocusScope.of(context).requestFocus(_focus);

    // _focus.addListener(() {
    //   print("Focus Node Status: ${_focus.hasFocus}");
    // });

    _focus_days.addListener(() {
      // Run calculation only when the field loses focus (focus out)
      if (!_focus_days.hasFocus) {
        if (txtDays.text.isNotEmpty &&
            txtDays.text != '0' &&
            txtDateStart.text.isNotEmpty) //&& txtDateStart.text != "0000-00-00"
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

    // Register all controllers here so we can dispose them in one place
    AllTextControllerinWidget = [
      txtListName,
      txtTitle,
      txtAmout,
      txtBookNo,
      txtDate,
      txtResponse,
      txtYear,
      txtIdExpSpen,
      txtUnit,
      txtLastAccess,
      txtDateStart,
      txtDateStop,
      txtDays,
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Request focus after the context is fully available.
    //_focus.requestFocus();
    //FocusScope.of(context).requestFocus(_focus);
    //FocusScope.of(context).unfocus();
    //SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void dispose() {
    // _focus.removeListener(() {
    //   print("Focus Node Listener Removed");
    // });

    // dispose focus
    _focus_title.dispose();
    _focus_addr_book.dispose();
    _focus_amout.dispose();
    _focus_date.dispose();
    _focus_date_start.dispose();
    _focus_date_stop.dispose();
    _focus_days.dispose();
    //_focus_ddlSecret.dispose();

    // Clean up controllers
    for (var controller in AllTextControllerinWidget) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //_focus.requestFocus();
    //var widthTextFiled = MediaQuery.of(context).size.width * 0.6;
    //====TextStyle========
    TextStyle styleHead = const TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.purple,
    );

    TextStyle styleLabel = const TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 18.0,
      color: Colors.yellow,
    );

    TextStyle styleInput = const TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16.0,
      color: Colors.black,
    );

    //======define widget=======

    final txtlistname = TextField(
      style: styleLabel,
      //autofocus: true,
      //focusNode: _focus,
      readOnly: true,
      keyboardType: TextInputType.none,
      controller: txtListName,
      minLines: 1, // Display at least 5 lines
      maxLines: null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        //filled : false,
        fillColor: Colors.green.shade800,
        //hintText: "ชื่องบ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onSubmitted: (v) {
        //_fieldFocusChange(context, _focus, _nextFocus);
      },
    );

    final txttitle = TextField(
      //key: ValueKey("my_text_field"),
      // inputFormatters: [], // Can help stabilize input connection
      // keyboardType: TextInputType.text,
      // autocorrect: false,
      // enableSuggestions: false,
      style: styleInput,
      autofocus: true,
      focusNode: _focus_title,
      //enabled: true,
      // minLines: 1, // Display at least 5 lines
      // maxLines: null,
      controller: txtTitle,
      inputFormatters: [FirstCharNotDigitFormatter()],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
        filled: true,
        fillColor: _errorField == 'title' ? Colors.red.shade100 : Colors.white,
        hintText: "ชื่อเรื่อง",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onSubmitted: (v) {
        //_fieldFocusChange(context, _focus, _nextFocus);
        _focus_addr_book.requestFocus();
      },
      onChanged: (v) {
        if (_errorField == 'title' && v.isNotEmpty) {
          setState(() => _errorField = null);
        }
      },
      // onTap: () {
      //   //_focus.requestFocus();
      //   FocusScope.of(context).requestFocus(_focus);
      //   SystemChannels.textInput.invokeMethod('TextInput.show');
      // },
      // onTapOutside: (event) {
      //   // ปิด Focus เมื่อแตะนอก TextField
      //   _focus.unfocus();
      // },
      // onEditingComplete: () {
      //   // จัดการเมื่อแก้ไขเสร็จ
      //   _focus.unfocus();
      // },
    );

    final txt_addr_book = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      focusNode: _focus_addr_book,
      controller: txtBookNo,
      //keyboardType: TextInputType.number,
      inputFormatters: [FirstCharNotDigitFormatter()],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: _errorField == 'bookno' ? Colors.red.shade100 : Colors.white,
        hintText: "ที่ของหนังสือ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onSubmitted: (v) {
        //_fieldFocusChange(context, _focus, _nextFocus);
        _focus_amout.requestFocus();
      },
      onChanged: (v) {
        if (_errorField == 'bookno' && v.isNotEmpty) {
          setState(() => _errorField = null);
        }
      },
    );

    final txt_amout = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      focusNode: _focus_amout,
      controller: txtAmout,
      keyboardType: keyBoardTypeDecimal,
      inputFormatters: [currencyFormatter],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: _errorField == 'amout' ? Colors.red.shade100 : Colors.white,
        hintText: "รับค่าจำนวนเงินเท่านั้น !!!",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onChanged: (value) {
        // Live validate amount; highlight red when invalid or <= 0
        final cleaned = value.replaceAll(RegExp(r'[,\s]'), '');
        final parsed = double.tryParse(cleaned);
        final invalid = parsed == null || parsed <= 0;
        if (invalid) {
          if (_errorField != 'amout') {
            setState(() => _errorField = 'amout');
          }
        } else if (_errorField == 'amout') {
          setState(() => _errorField = null);
        }
      },
      onSubmitted: (v) {
        _focus_date.requestFocus();
      },
    );

    final txtdate = TextField(
      readOnly: true,
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      focusNode: _focus_date,
      controller: txtDate,
      //keyboardType: TextInputType.number,
      // inputFormatters: [
      //   //FilteringTextInputFormatter.digitsOnly,
      //   //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
      //   currencyFormatter,
      // ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: _errorField == 'date' ? Colors.red.shade100 : Colors.white,
        hintText: "วันที่ตั้งเรื่อง",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onTap: () {
        DateTime dt = DateTime.now();
        int dn = dt.year - 5;
        DateTime ystart = DateTime(dn);
        dn = dt.year + 10;
        DateTime yend = DateTime(dn);

        showDatePicker(
          context: context,
          initialDate: dtClass.DateTimeNow(),
          firstDate: ystart,
          lastDate: yend,
        ).then((value) {
          if (value != null) {
            setState(() {
              DateString = dtClass.ConvertDateThaiNow(value);
              //DateReal = now.ConvertDateDB(value);
            });

            txtDate.text = DateString;
            //txtHideDate.text = DateReal;
            if (_errorField == 'date') {
              setState(() => _errorField = null);
            }
          }
        });
      },
      // onSubmitted: (v) {
      //   //_focus_ddlSecret.requestFocus();
      // },
    );

    final txt_date_start = TextField(
      style: styleInput,
      focusNode: _focus_date_start,
      controller: txtDateStart,
      readOnly: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor:
            _errorField == 'date_start' ? Colors.red.shade100 : Colors.white,
        hintText: "วันที่เริ่ม",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onTap: () {
        DateTime dt = DateTime.now();
        int dn = dt.year - 5;
        DateTime ystart = DateTime(dn);
        dn = dt.year + 10;
        DateTime yend = DateTime(dn);

        showDatePicker(
          context: context,
          initialDate: dtClass.DateTimeNow(),
          firstDate: ystart,
          lastDate: yend,
        ).then((value) {
          if (value != null) {
            setState(() {
              txtDateStart.text = dtClass.ConvertDateThaiNow(value);
              if (_errorField == 'date_start') {
                _errorField = null;
              }
            });
          }
        });
      },
    );

    final txt_date_stop = TextField(
      style: styleInput,
      focusNode: _focus_date_stop,
      controller: txtDateStop,
      readOnly: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor:
            _errorField == 'date_stop' ? Colors.red.shade100 : Colors.white,
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
      style: styleInput,
      focusNode: _focus_days,
      controller: txtDays,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: _errorField == 'days' ? Colors.red.shade100 : Colors.white,
        hintText: "จำนวนวัน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onChanged: (v) {
        if (_errorField == 'days' && v.isNotEmpty && v != '0') {
          setState(() => _errorField = null);

          // alert value in txt_days
          msg.Alert(context, "Status Text Changed", "Value : " + v + " วัน");
        }
      },
    );

    final txt_response_person = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtResponse,
      readOnly: true,
      //keyboardType: TextInputType.none,
      //keyboardType: TextInputType.number,
      // inputFormatters: [
      //   //FilteringTextInputFormatter.digitsOnly,
      //   //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
      //   currencyFormatter,
      // ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: lightyellow2,
        hintText: "ผู้รับผิดชอบ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onSubmitted: (v) {
        //_fieldFocusChange(context, _focus, _nextFocus);
      },
    );

    //======widget ddl=================
    final ddlSecret = DropdownButton(
      //focusNode: _focus_ddlSecret,
      borderRadius: BorderRadius.circular(10),
      value: sel_secret,
      items:
          itemSecret.map((item) {
            int index = itemSecret.indexOf(item);
            return DropdownMenuItem<int>(child: Text('$item'), value: index);
          }).toList(),
      onChanged: (value) {
        setState(() {
          sel_secret = value!;
        });
      },
      //hint: Text("เลือกปีงบประมาณ"),
      disabledHint: Text("Disabled"),
      elevation: 8,
      style: TextStyle(
        color: Colors.blue,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      //style: styleLabel,
      dropdownColor: Colors.yellow.shade100,
      icon: Icon(Icons.arrow_drop_down_circle),
      iconDisabledColor: Colors.red,
      iconEnabledColor: Colors.blue,
      iconSize: 35,
    );

    final ddlAcc = DropdownButton(
      borderRadius: BorderRadius.circular(10),
      value: sel_acc,
      items:
          itemAcc.map((item) {
            int index = itemAcc.indexOf(item);
            return DropdownMenuItem<int>(child: Text('$item'), value: index);
          }).toList(),
      onChanged: (value) {
        setState(() {
          sel_acc = value!;
        });
      },
      //hint: Text("เลือกปีงบประมาณ"),
      disabledHint: Text("Disabled"),
      elevation: 8,
      style: TextStyle(
        color: Colors.red,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      //style: styleLabel,
      dropdownColor: Colors.grey.shade200,
      icon: Icon(Icons.arrow_drop_down_circle),
      iconDisabledColor: Colors.red,
      iconEnabledColor: Colors.blue,
      iconSize: 35,
    );

    final ddlTypeJob = DropdownButton(
      borderRadius: BorderRadius.circular(10),
      value: sel_type_job,
      items:
          itemTypeJob.map((item) {
            //int index = itemTypeJob.indexOf(item);
            return DropdownMenuItem<String>(
              child: Text('$item'),
              value: item,
              //value: index,
            );
          }).toList(),
      onChanged: (value) {
        setState(() {
          sel_type_job = value!;
          if (_errorField == 'typejob' &&
              sel_type_job != 'กรุณาเลือกประเภทงาน') {
            _errorField = null;
          }
        });
      },
      //hint: Text("เลือกปีงบประมาณ"),
      disabledHint: Text("Disabled"),
      elevation: 8,
      style: TextStyle(
        color: Colors.green.shade900,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      //style: styleLabel,
      dropdownColor: Colors.grey.shade200,
      icon: Icon(Icons.arrow_drop_down_circle),
      iconDisabledColor: Colors.red,
      iconEnabledColor: Colors.blue,
      iconSize: 35,
    );
    //=======widget button===========
    final saveButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.deepPurple,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        highlightColor: Colors.amber, //on press button change color
        onPressed: () {
          // Build a list of missing/invalid fields
          List<String> missing = [];
          if (txtTitle.text.isEmpty) missing.add('title');
          if (txtBookNo.text.isEmpty) missing.add('bookno');
          if (txtAmout.text.isEmpty || txtAmout.text == '0')
            missing.add('amout');
          if (txtDate.text.isEmpty) missing.add('date');
          if (txtResponse.text.isEmpty)
            missing.add('response'); // not a focusable error field
          if (txt_unit == '')
            missing.add('unit'); // not a focusable error field
          if (sel_type_job == 'กรุณาเลือกประเภทงาน')
            missing.add('typejob'); // dropdown
          if (txtYear.text.isEmpty) missing.add('year');
          if (txtIdExpSpen.text.isEmpty) missing.add('idexpspen');

          // Validate date range only if both provided in Thai format and not default placeholders
          if (txtDateStart.text != '0000-00-00' &&
              txtDateStop.text != '0000-00-00' &&
              txtDateStart.text.isNotEmpty &&
              txtDateStop.text.isNotEmpty) {
            DateTime startDate = DateTime.parse(
              dtClass.ConvDateThaiToDateDB(txtDateStart.text),
            );
            DateTime stopDate = DateTime.parse(
              dtClass.ConvDateThaiToDateDB(txtDateStop.text),
            );
            if (stopDate.isBefore(startDate) ||
                stopDate.isAtSameMomentAs(startDate)) {
              setState(() => _errorField = 'date_stop');
              _focusErrorField();
              msgStr = 'วันที่สิ้นสุดต้องมากกว่าวันที่เริ่มต้น !!!';
              msg.Alert(context, 'Error', msgStr);
              return;
            }
          }

          // Validate amount must be numeric > 0
          if (txtAmout.text.isNotEmpty) {
            final cleanedAmt = txtAmout.text.replaceAll(RegExp(r'[,\s]'), '');
            final parsedAmt = double.tryParse(cleanedAmt);
            if (parsedAmt == null || parsedAmt <= 0) {
              setState(() => _errorField = 'amout');
              _focusErrorField();
              msgStr = 'จำนวนเงินต้องเป็นตัวเลขมากกว่า 0';
              msg.Alert(context, 'Error', msgStr);
              return;
            }
          }

          if (missing.isNotEmpty) {
            // choose first focusable error field if any; otherwise just alert
            const focusable = [
              'title',
              'bookno',
              'amout',
              'date',
              'date_start',
              'date_stop',
              'days',
            ];
            String firstFocusable = missing.firstWhere(
              (m) => focusable.contains(m),
              orElse: () => '',
            );

            // Highlight dropdown 'typejob' container if that's the only missing
            if (firstFocusable.isEmpty && missing.contains('typejob')) {
              setState(() => _errorField = 'typejob');
            } else if (firstFocusable.isNotEmpty) {
              setState(() => _errorField = firstFocusable);
              _focusErrorField();
            }

            msgStr =
                missing.contains('typejob')
                    ? 'กรุณาเลือกประเภทงาน'
                    : 'กรุณากรอกข้อมูลให้ครบถ้วน !!!';
            msg.Alert(context, 'Error', msgStr);
            return;
          }

          // All validations passed
          setState(() => _errorField = null);
          //=======================save===========================================

          //txtDate.text = dtClass.ConvDateThaiToDateDB(txtDate.text);
          String dateDB = dtClass.ConvDateThaiToDateDB(txtDate.text);
          print("date format db : " + dateDB);

          String dateStartDB = txtDateStart.text;
          if (txtDateStart.text != "0000-00-00") {
            dateStartDB = dtClass.ConvDateThaiToDateDB(txtDateStart.text);
          } else {
            dateStartDB = "0000-00-00";
          }

          String dateStopDB = txtDateStop.text;
          if (txtDateStop.text != "0000-00-00") {
            dateStopDB = dtClass.ConvDateThaiToDateDB(txtDateStop.text);
          } else {
            dateStopDB = "0000-00-00";
          }

          // remove comma in amout
          String fmtCommaStr = "r'[\,]";
          RegExp fmtCommaRegExp = RegExp(fmtCommaStr);
          //const fmtMoneyDisp = "r'^(\d+)(?:\.|\,)\d{0,2}";

          //String fmt = txtAmout.text.replaceAll(RegExp(r'[\,]+'), '');
          String fmtAmout = txtAmout.text.replaceAll(fmtCommaRegExp, '');

          // cut only filename
          if (_file != null) {
            FileName = _file!.path;
            FileName = FileName.replaceAll(RegExp(r'.*/'), '');
          } else {
            FileName = "";
          }
          print("file : " + FileName);

          mydb.AddBookUnit(
            txtYear.text,
            txtIdExpSpen.text,
            txtListName.text,
            txtTitle.text,
            txtBookNo.text,
            //txtAmout.text,
            FileName,
            fmtAmout,
            dateDB,
            //txtDate.text,
            ddlSecret.value.toString(),
            ddlAcc.value.toString(),
            txtResponse.text,
            txt_unit,
            unitName,
            //unitNow.toString(), // send to other unit
            sel_type_job,
            dateStartDB,
            dateStopDB,
            txtDays.text,
          ).then((String result) {
            var ret = json.decode(result);

            //String msgstr = "";
            if (ret["result"] == "false") {
              msgStr = "ผิดพลาดในการบันทึก : ${ret["msg"]} ";
            } else if (ret["result"] == "true") {
              msgStr = "บันทึกเรียบร้อยแล้ว";
              print("Status Insert : $msgStr");

              //create QR CODE by PHP in budget1 send url from ret["msg"]
              String id_exp_spen = ret["msg"];
              // create QRCODE in website budget
              mydb.SentURLQRCODE(id_exp_spen, Budget_Site).then((value) {
                int ret = int.parse(value);
                if (ret == 0) {
                  print('Error Create QR Code !!!');
                } else {
                  print("Create QRCode OK=>id_exp_spen : " + id_exp_spen);
                }
              });

              if (_file != null) {
                //upc.UploadFileToServer(_file, "budget1").then((value) {
                upc.UploadFToSrvAddProp(
                  _file,
                  Budget_Site,
                  txtIdExpSpen.text,
                ).then((value) {
                  print("return upload msg : \n" + value);

                  if (value != "") {
                    var ret = json.decode(value);

                    if (ret["result"] == true) {
                      print(
                        "Upload File Successful \n FileName : " + ret["msg"],
                      );
                    } else {
                      print("Error Upload File \n FileName : " + ret["msg"]);
                    }
                  } else {
                    print("Error Upload File");
                  }
                });
              }
            }

            msg.Alert(context, "ผลการบันทึก", "ผลคือ : ${msgStr}");

            // GetExpUserSend.php for show last start 10 send
            final oneSecond = Duration(seconds: 1);
            Future.delayed(oneSecond * 5, () {
              // If this widget was disposed during the delay, do nothing.
              if (!mounted) return;
              final nav = navigatorKey.currentState;
              if (nav != null) {
                nav.pushReplacement(
                  MaterialPageRoute(builder: (_) => ShowStartBook()),
                );
              } else {
                // Fallback to the local context
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => ShowStartBook()),
                );
              }
            });
          });
        },
        child: Text(
          "บันทึก",
          textAlign: TextAlign.center,
          style: styleInput.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final selFileButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width / 5,
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        highlightColor: Colors.amber, //on press button change color
        onPressed: () {
          upc.getFile().then((value) {
            setState(() {
              _file = value;
            });
          });
        },
        child: Text(
          "เลือกแฟ้ม",
          textAlign: TextAlign.center,
          style: styleInput.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final backButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.redAccent,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        highlightColor: Colors.amber, //on press button change color
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          "ย้อนกลับ",
          textAlign: TextAlign.center,
          style: styleInput.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    //======init data=======

    mydb.getExpDetail(widget.id_exp_spen).then((Expedite? result) {
      if (result != null) {
        txtListName.text = result.list_exp_spen;
        txtIdExpSpen.text = widget.id_exp_spen;
      }
      //txtMemo.text = result.memo_th;

      //txtBorder.text = result.mborder;
      //txtMalloc.text = result.malloc;

      //MoneyFormatterOutput fo = FlutterMoney(amount: double.parse(result.mborder)).output;
      //txtBorder.text = fo.nonSymbol;

      //fo = FlutterMoney(amount: double.parse(result.malloc)).output;
      //txtMalloc.text = fo.nonSymbol;
    });

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
        child: Form(
          //key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text('รายละเอียดงบที่บันทึก', style: styleHead),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ประจำปีงบประมาณ',
                      style: styleHead.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      ' $yearNow',
                      style: styleHead.copyWith(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(padding: const EdgeInsets.all(2.0), child: txtlistname),
              Padding(padding: const EdgeInsets.all(2.0), child: txttitle),
              Padding(padding: const EdgeInsets.all(2.0), child: txt_addr_book),
              Padding(padding: const EdgeInsets.all(2.0), child: txt_amout),

              Padding(padding: const EdgeInsets.all(2.0), child: txtdate),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: txt_date_start,
              ),
              Padding(padding: const EdgeInsets.all(2.0), child: txt_days),
              Padding(padding: const EdgeInsets.all(2.0), child: txt_date_stop),

              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(_file?.path ?? '', style: styleHeadWhite3),
              ),
              Padding(padding: const EdgeInsets.all(2.0), child: selFileButton),

              //hidden TextField
              //Visibility(visible: false, child: txt_hide_bookdate),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text('เลือกชั้นความลับ', style: styleHead),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.yellow.shade100,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ddlSecret,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text('เลือกความเร่งด่วน', style: styleHead),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ddlAcc,
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
                    child: Text('เลือกประเภทงาน', style: styleHead),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      child: ddlTypeJob,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            _errorField == 'typejob'
                                ? Colors.red.shade100
                                : Colors.grey.shade200,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: txt_response_person,
              ),
              Padding(padding: const EdgeInsets.all(4.0), child: saveButton),
              Padding(padding: const EdgeInsets.all(4.0), child: backButton),
            ],
          ),
        ),
      ),
    );
  }
}
