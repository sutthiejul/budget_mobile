import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:intl/intl.dart';

class DateTimes {
  List<String> MonthTh = [
    "ม.ค.",
    "ก.พ.",
    "มี.ค.",
    "เม.ย.",
    "พ.ค.",
    "มิ.ย.",
    "ก.ค.",
    "ส.ค.",
    "ก.ย.",
    "ต.ค.",
    "พ.ย.",
    "ธ.ค.",
  ];

  List<String> MonthThFull = [
    "มกราคม",
    "กุมภาพันธ์",
    "มีนาคม",
    "เมษายน",
    "พฤษภาคม",
    "มิถุนายน",
    "กรกฎาคม",
    "สิงหาคม",
    "กันยายน",
    "ตุลาคม",
    "พฤศจิกายน",
    "ธันวาคม",
  ];

  String selyear = "";
  String dateRet = "";
  int dayn = 0, monthn = 0, yearn = 0;

  //=========================================================

  String getThaiDay(int dayInt) {
    // Define array of Thai day names indexed by their standard DayOfWeek numeric value
    List<String> thaiDays = [
      "อาทิตย์", // Sunday = 0
      "จันทร์", // Monday = 1
      "อังคาร", // Tuesday = 2
      "พุธ", // Wednesday = 3
      "พฤหัสบดี", // Thursday = 4
      "ศุกร์", // Friday = 5
      "เสาร์", // Saturday = 6
    ];

    dayInt -= 1;

    // Validate input range
    if (dayInt >= 0 && dayInt <= 6) {
      return thaiDays[dayInt];
    } else {
      return ''; // Return empty string for invalid input
    }
  }

  String getEngDay(int dayInt) {
    // Define array of English day names indexed by their standard DayOfWeek numeric value
    List<String> engDays = [
      "Sunday", // Sunday = 0
      "Monday", // Monday = 1
      "Tuesday", // Tuesday = 2
      "Wednesday", // Wednesday = 3
      "Thursday", // Thursday = 4
      "Friday", // Friday = 5
      "Saturday", // Saturday = 6
    ];

    // Validate input range
    if (dayInt >= 0 && dayInt <= 6) {
      return engDays[dayInt];
    } else {
      return ''; // Return empty string for invalid input
    }
  }

  bool isWeekend(DateTime date) {
    int dayOfWeek = date.weekday;
    return (dayOfWeek == DateTime.saturday) || (dayOfWeek == DateTime.sunday);
  }

  DateTime DateTimeNow() {
    DateTime now = DateTime.now();
    return now;
  }

  String DateNowYMDTime() {
    DateTime now = DateTime.now();
    //2024-11-01 15:40:44.129783

    List<String> tmp = now.toString().split(".");

    dayn = now.day;
    monthn = now.month;
    yearn = now.year;

    String dateRet =
        yearn.toString() +
        "-" +
        monthn.toString() +
        "-" +
        dayn.toString() +
        " " +
        tmp[0].split(" ")[1];

    return dateRet;
  }

  String DateNowYMD() {
    DateTime now = DateTime.now();

    dayn = now.day;
    monthn = now.month;
    yearn = now.year;

    String dateRet =
        yearn.toString() + "-" + monthn.toString() + "-" + dayn.toString();

    return dateRet;
  }

  String DateNowDDMMYY() {
    DateTime now = DateTime.now();
    //DateFormat thaiDateFormat = DateFormat('dd MMMM yyyy');
    DateFormat DateFormat1 = DateFormat('dd-MM-yyyy');
    dateRet = DateFormat1.format(now);

    return dateRet;
  }

  String DateLongNow() {
    DateTime now = DateTime.now();
    DateFormat DateFormat1 = DateFormat('dd MMMM yyyy');
    //DateFormat DateFormat1 = DateFormat('dd-MM-yyyy');
    dateRet = DateFormat1.format(now);

    return dateRet;
  }

  String DateThaiNow() {
    DateTime now = DateTime.now();

    dayn = now.day;
    monthn = now.month;
    yearn = now.year + 543;

    dateRet =
        dayn.toString() +
        " " +
        MonthTh[monthn - 1].toString() +
        " " +
        yearn.toString();

    return dateRet;
  }

  //=======Convert yyyy-mm-dd to thai date ===================================
  String ConvertDateThai(String dates) // format dates yyyy-mm-dd
  {
    DateTime date_tmp = DateTime.parse(dates);

    dayn = date_tmp.day;
    monthn = date_tmp.month;
    yearn = date_tmp.year + 543;

    dateRet =
        dayn.toString() +
        " " +
        MonthTh[monthn - 1].toString() +
        " " +
        yearn.toString();

    return dateRet;
  }

  //-----------Convert thai date to yyyy-mm-dd---------------------------------
  String ConvertDateThaitoDB(String dates) // format dates yyyy-mm-dd
  {
    List<String> date_tmp = dates.split(" ");

    String day_str = date_tmp[0].padLeft(2, '0');
    ;
    String month_str = date_tmp[1];
    String month_str_num = "";

    int yearn = int.parse(date_tmp[2]) - 543;

    // int monthn = 0;

    switch (month_str) {
      case "ม.ค.":
        month_str_num = "01";
        break;
      case "ก.พ.":
        month_str_num = "02";
        break;
      case "มี.ค.":
        month_str_num = "03";
        break;
      case "เม.ย.":
        month_str_num = "04";
        break;
      case "พ.ค.":
        month_str_num = "05";
        break;
      case "มิ.ย.":
        month_str_num = "06";
        break;
      case "ก.ค.":
        month_str_num = "07";
        break;
      case "ส.ค.":
        month_str_num = "08";
        break;
      case "ก.ย.":
        month_str_num = "09";
        break;
      case "ต.ค.":
        month_str_num = "10";
        break;
      case "พ.ย.":
        month_str_num = "11";
        break;
      case "ธ.ค.":
        month_str_num = "12";
        break;
    }
    //==============================

    String dateRet = yearn.toString() + "-" + month_str_num + "-" + day_str;

    return dateRet;
  }

  //============================================

  String DateThaiNowFull() {
    DateTime now = DateTime.now();

    dayn = now.day;
    monthn = now.month;
    yearn = now.year + 543;

    dateRet =
        dayn.toString() +
        " " +
        MonthThFull[monthn - 1].toString() +
        " " +
        yearn.toString();

    return dateRet;
  }

  String ConvertDateDB(DateTime dt) {
    dayn = dt.day;
    monthn = dt.month;
    yearn = dt.year;

    dateRet =
        yearn.toString() +
        " " +
        MonthTh[monthn].toString() +
        " " +
        dayn.toString();

    return dateRet;
  }

  String ConvertDateThaiNow(DateTime now) {
    dayn = now.day;
    monthn = now.month - 1;
    yearn = now.year + 543;

    dateRet =
        dayn.toString() +
        " " +
        MonthTh[monthn].toString() +
        " " +
        yearn.toString();

    return dateRet;
  }

  String ConvDateThaiToDateDB(String dt) {
    List<String> dtemp = dt.split(" ");

    String dayn = dtemp[0];
    dayn = dayn.padLeft(2, '0');

    //===========month==============
    String monthn = "";
    switch (dtemp[1]) {
      case "ม.ค.":
        monthn = "01";
        break;
      case "ก.พ.":
        monthn = "02";
        break;
      case "มี.ค.":
        monthn = "03";
        break;
      case "เม.ย.":
        monthn = "04";
        break;
      case "พ.ค.":
        monthn = "05";
        break;
      case "มิ.ย.":
        monthn = "06";
        break;
      case "ก.ค.":
        monthn = "07";
        break;
      case "ส.ค.":
        monthn = "08";
        break;
      case "ก.ย.":
        monthn = "09";
        break;
      case "ต.ค.":
        monthn = "10";
        break;
      case "พ.ย.":
        monthn = "11";
        break;
      case "ธ.ค.":
        monthn = "12";
        break;
    }
    //==============================
    int yearn = int.parse(dtemp[2]) - 543;

    dateRet = yearn.toString() + "-" + monthn + "-" + dayn;

    return dateRet;
  }

  String getMonthThai() {
    String mth = "";
    int iMonth = DateTime.now().month;

    mth = MonthTh[iMonth];

    return mth;
  }

  TextStyle styleLabel = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16.0,
    color: Colors.blue,
    fontWeight: FontWeight.bold,
    //decorationColor: Colors.yellowAccent.shade100,
    backgroundColor: Colors.white,
  );

  Widget ddlYearNew() {
    // init year now
    int yearNow = DateTime.now().year.toInt() + 543;
    List<int> listyear = [for (var i = yearNow - 5; i <= yearNow + 5; i++) i];
    return DropdownButton(
      value: yearNow,
      items:
          listyear.map((int item) {
            return DropdownMenuItem<int>(child: Text(' $item '), value: item);
          }).toList(),
      onChanged: (value) {
        selyear = value.toString();
        log(value.toString());
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
  }

  //============Cal Last Date==================================
  // day_end = dtClass.LastDate(
  // txtDate.text,
  // int.parse(txtDays.text),
  //holidayData['dates'],
  // );

  DateTime? _parseFlexibleDate(String raw) {
    if (raw.trim().isEmpty) return null;

    final candidates = [raw.trim()];

    // If Thai month text is present, try converting via existing helper.
    if (MonthTh.any((m) => raw.contains(m)) ||
        MonthThFull.any((m) => raw.contains(m))) {
      try {
        final iso = ConvDateThaiToDateDB(raw);
        candidates.add(iso);
      } catch (_) {}
    }

    for (final c in candidates) {
      // 1) Native ISO parser
      try {
        return DateTime.parse(c);
      } catch (_) {}

      // 2) Common numeric formats (including single-digit day/month variants)
      for (final pattern in [
        'dd-MM-yyyy',
        'dd/MM/yyyy',
        'd-M-yyyy',
        'd/M/yyyy',
        'd-MM-yyyy',
        'd/MM/yyyy',
        'yyyy-MM-dd',
        'yyyy/MM/dd',
        'yyyy-M-d',
        'yyyy/M/d',
        'yyyy-MM-d',
        'yyyy-M-dd',
      ]) {
        try {
          return DateFormat(pattern).parseStrict(c);
        } catch (_) {}
      }
    }

    return null;
  }

  String LastDate(
    String dstart,
    int workingDaysNeeded,
    List<dynamic> holidayArrStr,
  ) {
    workingDaysNeeded += 1;

    // if (workingDaysNeeded <= 0) return "Error";

    // final parsedDate = _parseFlexibleDate(dstart);
    // if (parsedDate == null) {
    //   return "Error: Invalid Date";
    // }

    // DateTime currentDate = parsedDate;

    if (workingDaysNeeded <= 0) return "Error";

    DateTime currentDate;
    try {
      currentDate = DateTime.parse(dstart);
    } catch (e) {
      return "Error: Invalid Date";
    }

    Set<String> holidaySet = holidayArrStr.map((e) => e.toString()).toSet();
    int daysCounted = 0;

    for (int i = 0; i < 1000; i++) {
      // Safety break
      int dayOfWeek = currentDate.weekday; // 1 = Mon, 7 = Sun

      if (dayOfWeek != DateTime.sunday && dayOfWeek != DateTime.saturday) {
        // แปลงเป็น "yyyy-mm-dd" เพื่อตรวจสอบ
        String isoDateString = fmtDatetoYMD(currentDate);

        // ตรวจสอบว่าไม่ใช่วันหยุดที่ระบุ
        if (!holidaySet.contains(isoDateString)) {
          daysCounted++;
        }
      }

      // เมื่อนับครบตามที่ต้องการ ให้หยุด
      if (daysCounted == workingDaysNeeded) {
        break;
      }

      // เลื่อนไปวันถัดไป
      currentDate = currentDate.add(Duration(days: 1));
    }

    return fmtDatetoYMD(currentDate);
  }

  fmtDatetoYMD(DateTime date) {
    int dayn = date.day;
    int monthn = date.month;
    int yearn = date.year;

    String day_str = dayn.toString().padLeft(2, '0');
    String month_str = monthn.toString().padLeft(2, '0');

    String dateRet = yearn.toString() + "-" + month_str + "-" + day_str;

    return dateRet;
  }
} //=======end class DateTimes ============================
