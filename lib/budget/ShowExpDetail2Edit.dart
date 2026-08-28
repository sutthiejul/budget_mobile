// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../global/MySQLService.dart';
import '../models/Expedite.dart';
import '../global/globalVar.dart';
import '../global/GetYearBudget.dart';

class ShowExpDetail extends StatefulWidget {
  const ShowExpDetail({Key? key}) : super(key: key);

  @override
  _ShowBudgetDetailState createState() => _ShowBudgetDetailState();
}

class _ShowBudgetDetailState extends State<ShowExpDetail> {
  //=====Controller Text===========
  final txtListName = TextEditingController();
  final txtBorder = TextEditingController();
  final txtMemo = TextEditingController();
  final txtMalloc = TextEditingController();
  final txtIdList = TextEditingController();
  final txtStatus = TextEditingController();
  final txtDaystart = TextEditingController();
  final txtDaystop = TextEditingController();
  final txtIdExpSpen = TextEditingController();
  final txtCodeBudRtarf = TextEditingController();
  final txtFieldWork = TextEditingController();
  final txtExpType = TextEditingController();
  final txtIntGroup = TextEditingController();
  final txtUnitUse = TextEditingController();
  final txtUnitOper = TextEditingController();
  final txtBudType = TextEditingController();
  final txtMpay = TextEditingController();
  final txtBpay_n = TextEditingController();
  final txtBpay = TextEditingController();
  final txtCpay = TextEditingController();
  final txtDpay = TextEditingController();
  final txtSpay = TextEditingController();
  final txtSpay_n = TextEditingController();
  final txtOpay = TextEditingController();
  final txtTpay = TextEditingController();
  final txtTlpay = TextEditingController();
  final txtStpay = TextEditingController();
  final txtBalan = TextEditingController();
  final txtYears = TextEditingController();
  final txtM10 = TextEditingController();
  final txtM11 = TextEditingController();
  final txtM12 = TextEditingController();
  final txtSum1 = TextEditingController();
  final txtM01 = TextEditingController();
  final txtM02 = TextEditingController();
  final txtM03 = TextEditingController();
  final txtSum2 = TextEditingController();
  final txtM04 = TextEditingController();
  final txtM05 = TextEditingController();
  final txtM06 = TextEditingController();
  final txtSum3 = TextEditingController();
  final txtM07 = TextEditingController();
  final txtM08 = TextEditingController();
  final txtM09 = TextEditingController();
  final txtSum4 = TextEditingController();
  final txtStwork = TextEditingController();
  final txtWhocreate = TextEditingController();
  final txtCreatetime = TextEditingController();
  final txtWhouse = TextEditingController();
  final txtLastaccess = TextEditingController();
  final txtUnit_chk = TextEditingController();
  final txtStRx = TextEditingController();
  final txtStMalloc = TextEditingController();

  //const currencyRegExp = r'^(\d+)?\.?\d{0,2}$';
  static const currencyRegExp = r'^(\d+)(?:\.|\,)\d{0,2}$';
  final currencyFormatter = FilteringTextInputFormatter.allow(
    RegExp(currencyRegExp),
  );

  // ==== set caption to Text====
  int yearNow = 0;

  @override
  void initState() {
    super.initState();

    //=====init Data=================
    yearNow = GetYearBudget.getYearBudget();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //====TextStyle========
    TextStyle styleHead = const TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.purple,
    );

    TextStyle styleInput = const TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16.0,
      color: Colors.black,
    );

    //======define widget=======
    final txtlistname = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtListName,
      minLines: 1, // Display at least 5 lines
      maxLines: null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        //filled : false,
        fillColor: Colors.white,
        //hintText: "ชื่องบ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onSubmitted: (v) {
        //_fieldFocusChange(context, _focus, _nextFocus);
      },
    );

    final txtmemo = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtMemo,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        //hintText: "ชื่องบ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onSubmitted: (v) {
        //_fieldFocusChange(context, _focus, _nextFocus);
      },
    );

    final txtborder = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtBorder,
      keyboardType: TextInputType.number,
      inputFormatters: [currencyFormatter],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "กรอบวงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onSubmitted: (v) {
        //_fieldFocusChange(context, _focus, _nextFocus);
      },
    );

    final txtmalloc = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtMalloc,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onSubmitted: (v) {
        //_fieldFocusChange(context, _focus, _nextFocus);
      },
    );

    final txt_idlist = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      onSubmitted: (v) {
        //_fieldFocusChange(context, _focus, _nextFocus);
      },
    );

    final txt_memo_th = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_list_exp_spen = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_status = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_daystart = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_daystop = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_id_exp_spen = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_code_bud_rtarf = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_field_work = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_exp_type = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_int_group = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_unit_use = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_unit_oper = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_mborder = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_bud_type = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_malloc = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_mpay = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_bpay_n = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_bpay = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_cpay = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_dpay = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_spay = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_spay_n = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_opay = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_tpay = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_tlpay = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_stpay = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_balan = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_years = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_m10 = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_m11 = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_m12 = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_sum1 = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_m01 = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_m02 = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_m03 = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_sum2 = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_m04 = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_m05 = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_m06 = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_sum3 = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_m07 = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_m08 = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_m09 = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_sum4 = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_stwork = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_whocreate = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_createtime = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_whouse = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_lastaccess = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_unit_chk = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_st_rx = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    final txt_st_malloc = TextField(
      style: styleInput,
      //autofocus: true,
      //focusNode: focusNode,
      //focusNode: _focus,
      controller: txtIdList,
      keyboardType: TextInputType.number,
      inputFormatters: [
        //FilteringTextInputFormatter.digitsOnly,
        //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
        currencyFormatter,
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "วงเงิน",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );

    final backButon = Material(
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
    MySQLDB mydb = MySQLDB();
    mydb.getExpDetail(idExpSpen).then((Expedite? result) {
      if (result != null) {
        txtListName.text = result.list_exp_spen;
        txtMemo.text = result.memo_th;
        txtBorder.text = result.mborder.toString();
        txtMalloc.text = result.malloc.toString();
        txtIdList.text = result.idlist.toString();
        txtStatus.text = result.status.toString();
        txtDaystart.text = result.daystart;
        txtDaystop.text = result.daystop;
        txtIdExpSpen.text = result.id_exp_spen;
        txtCodeBudRtarf.text = result.code_bud_rtarf;
        txtFieldWork.text = result.field_work.toString();
        txtExpType.text = result.exp_type.toString();
        txtIntGroup.text = result.int_group.toString();
        txtUnitUse.text = result.unit_use.toString();
        txtUnitOper.text = result.unit_oper.toString();
        txtBudType.text = result.bud_type.toString();
        txtMpay.text = result.mpay.toString();
        txtBpay_n.text = result.bpay_n.toString();
        txtBpay.text = result.bpay.toString();
        txtCpay.text = result.cpay.toString();
        txtDpay.text = result.dpay.toString();
        txtSpay.text = result.spay.toString();
        txtSpay_n.text = result.spay_n.toString();
        txtOpay.text = result.opay.toString();
        txtTpay.text = result.tpay.toString();
        txtTlpay.text = result.tlpay.toString();
        txtStpay.text = result.stpay.toString();
        txtBalan.text = result.balan.toString();
        txtYears.text = result.years.toString();
        txtM10.text = result.m10.toString();
        txtM11.text = result.m11.toString();
        txtM12.text = result.m12.toString();
        txtSum1.text = result.sum1.toString();
        txtM01.text = result.m01.toString();
        txtM02.text = result.m02.toString();
        txtM03.text = result.m03.toString();
        txtSum2.text = result.sum2.toString();
        txtM04.text = result.m04.toString();
        txtM05.text = result.m05.toString();
        txtM06.text = result.m06.toString();
        txtSum3.text = result.sum3.toString();
        txtM07.text = result.m07.toString();
        txtM08.text = result.m08.toString();
        txtM09.text = result.m09.toString();
        txtSum4.text = result.sum4.toString();
        txtStwork.text = result.stwork;
        txtWhocreate.text = result.whocreate.toString();
        txtCreatetime.text = result.createtime;
        txtWhouse.text = result.whouse.toString();
        txtLastaccess.text = result.lastaccess;
        txtUnit_chk.text = result.unit_chk;
        txtStRx.text = result.st_rx;
        txtStMalloc.text = result.st_malloc.toString();
      }
    });

    //========Scaffold======
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "รายละเอียดงบประมาณ",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text('รายละเอียดงบประมาณ', style: styleHead),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ประจำปี',
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
          Padding(padding: const EdgeInsets.all(2.0), child: txtmemo),
          Padding(padding: const EdgeInsets.all(2.0), child: txtborder),
          Padding(padding: const EdgeInsets.all(2.0), child: txtmalloc),
          const SizedBox(height: 4.0),
          backButon,
        ],
      ),
    );
  }
}

/* Future<void> msgBox(context, msg) async {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('แสดงค่าที่เลือก'),
      content: Text("ผลคือ : $msg"),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  ); // end show dialog
} */
