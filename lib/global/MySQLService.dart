import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:budget_mobile/models/BookUnit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/Expedite.dart';
import '../models/TBStatusSearch.dart';
import '../screens/sign_in/sign_in_screen.dart';
import 'globalVar.dart';
import '../models/Account.dart';
import '../models/UnitName.dart';

class MySQLDB {
  //=========================================================
  Future<int> chkStatusNetwork() async {
    // Use the configured backend IP instead of a hardcoded address and
    // handle connection failures/timeouts gracefully.
    // Example path keeps your existing endpoint; adjust in globalVar.dart as needed.
    final url = "http://$ipAddress/budget69/index.htm";

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return 1;
      } else {
        debugPrint('chkStatusNetwork: HTTP ${response.statusCode} from $url');
        return 0;
      }
    } on TimeoutException catch (e) {
      debugPrint('chkStatusNetwork: timeout contacting $url -> $e');
      return 0;
    } catch (e) {
      // Covers _ClientSocketException and other IO errors
      debugPrint('chkStatusNetwork: connection error contacting $url -> $e');
      return 0;
    }
  }

  // Quick TCP reachability probe for diagnostics (not used by UI by default)
  Future<bool> tcpReachable(
    String host, {
    int port = 80,
    Duration timeout = const Duration(seconds: 2),
  }) async {
    try {
      final socket = await Socket.connect(host, port, timeout: timeout);
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  FocusChange(
    /* How to Use from current focus to next focus */
    BuildContext context,
    FocusNode currentFocus,
    FocusNode nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  //=========================================================
  Future<String> chkLogin(String uid, String pwd) async {
    String url = "http://$ipAddress/FlutterBudget/FlutterLogin.php/";
    String querystring = "?userid=$uid&password=$pwd";
    //  String qs = urlEncode(text: querystring);

    String uriStr = url + querystring;
    //print("uriStr : " + uriStr);

    //int ret;

    final response = await http.get(Uri.parse(uriStr));

    if (response.statusCode == 200) {
      return response.body.trim();
      //ret = int.parse(response.body);
      //print('Return Value : $ret');
    } else {
      return "";
      //print("error reponse : ${response.statusCode}");
    }
  }

  //=========================================================
  Future<int> chkLoginJson(String uid, String pwd) async {
    String url = "http://$ipAddress/FlutterBudget/FlutterLoginJson.php";

    var loginDat = <String, dynamic>{};
    loginDat['userid'] = uid;
    loginDat['password'] = pwd;

    var jsonLogin = json.encode(loginDat);

    final response = await http.post(
      Uri.parse(url),
      headers: {"Accept": "application/json"},
      body: jsonLogin,
    );

    print(
      "response.body : " + response.body.trim(),
    ); // check the status code for the result

    if (response.statusCode == 200) {
      var ret = json.decode(response.body.trim());

      // check data return
      //print("ret['result'] : " + ret["result"]);

      return ret["result"];
    } else {
      return 0;
    }
  }

  // ========random hex==================
  String generateRandomHex(int length) {
    final random = Random.secure(); // Use secure random for better randomness
    final values = List<int>.generate(
      length,
      (i) => random.nextInt(16),
    ); // 0-15 (0x0 - 0xF)

    return values.map((value) => value.toRadixString(16)).join();
  }

  //=========================================================
  Future<String> chkLoginToken(String uid, String pwd) async {
    String url = "http://$ipAddress/FlutterBudget/FlutterLogin.php";

    var loginDat = <String, dynamic>{};
    loginDat['userid'] = uid;
    loginDat['password'] = pwd;

    var jsonLogin = json.encode(loginDat);

    var ret;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Accept": "application/json"},
        body: jsonLogin,
      );

      print(
        "response.body : " + response.body.trim(),
      ); // check the status code for the result

      if (response.statusCode == 200) {
        String dat = response.body.trim();

        if (dat != "") {
          // check data return
          String aid;
          String userid;
          String status;
          String token = "";
          String firstname;
          String lastname;
          String uid;
          String mobile;
          String passwords;

          try {
            var acc = json.decode(dat);
            aid = acc["aid"];
            userid = acc["userid"];
            passwords = acc["passwords"];
            firstname = acc["firstname"]; // user , admin
            lastname = acc["lastname"];
            status = acc["status"];
            uid = acc["Uint"];
            mobile = acc["mobile"];
            //uid = acc["Uint"] ?? "";
            // token = "";
          } catch (e) {
            print("error :" + e.toString());

            return "";
          }

          //========Create Token==================
          // start php : php -S 10.130.230.21:80
          String url = "http://$ipAddress/FlutterBudget/token/create_token.php";

          var loginDat = <String, dynamic>{};
          loginDat['userid'] = userid;
          loginDat['passwords'] = passwords;
          SecretKey = generateRandomHex(10);
          loginDat['secretkey'] = SecretKey;

          var jsonLogin = json.encode(loginDat);

          try {
            final response = await http.post(Uri.parse(url), body: jsonLogin);

            print(
              "response.body : " + response.body.trim(),
            ); // check the status code for the result

            if (response.statusCode == 200) {
              if (response.body.trim() != "") {
                token = response.body.trim();
              }

              print("UserID : $userid ; Token : $token");
              //======================================
              ret = {
                "aid": aid,
                "userid": userid,
                "fullname": firstname + " " + lastname,
                "status": status,
                "token": token,
                "uid": uid,
                "mobile": mobile,
                "secretkey": SecretKey,
              };

              //return ret.toString();
              return json.encode(ret);
            } else
              //token = "";
              return "";
          } catch (e) {
            print("error :" + e.toString());
            //token = "";
            return "";
          }
        }
        if (response.statusCode != 200) {
          print("error :" + response.statusCode.toString());
          //token = "";
          return "";
        } else
          return "";
      } else {
        return "";
      }
    } catch (e) {
      print("error :" + e.toString());
      //token = "";

      //return "{errMsg : " + e.toString() + "}";

      ret = {"errMsg": e.toString()};

      return json.encode(ret);
    }
  }

  //=========================================================
  // start php : php -S 10.130.230.21:80

  Future<String> VerifyTokenExpireBearer(String token, String secretkey) async {
    String ret = "";
    //print("Token : " + token + " | Secretkey " + SecretKey);
    print("Token : " + token);

    var loginDat = <String, dynamic>{};
    loginDat['token'] = token;
    loginDat['secretkey'] = secretkey;

    var jsonDat = json.encode(loginDat);

    String url = "http://$ipAddress/FlutterBudget/token/verify_token.php";

    final response = await http.post(Uri.parse(url), body: jsonDat);

    if (response.statusCode == 200) {
      print("response : " + response.body.trim());

      if (response.body.trim() != "") {
        ret = response.body.trim();

        return ret;
      } else
        return ret;
    } else
      return ret;
  }

  //=========================================================
  Future<String> CheckTokenExpirePost(String token) async {
    String status = "";
    String url = "http://$url_node/check_token_expire/" + token;

    print("receive token : " + token);

    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        if (response.body != "") {
          print("response.body : " + response.body);
          //status = "true";
          status = response.body;
        } else
          status = "";
      } else {
        status = "";
      }
    } catch (e) {
      print("error :" + e.toString());
      status = "";
    }

    var ret = {"status": status, "token": token};

    return json.encode(ret);
  }

  //=========================================================
  FutureOr<String> CheckTokenExpireBearer(String token) async {
    //bool status;
    //String data = "";
    String ret = "";

    String url = "http://$url_node/check_token_expire_bearer";

    print("receive token : " + token);

    final response = await http.post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      print(response);

      ret = response.toString();
    }
    return ret;
  }

  //============Security J6==========================================
  Future<String> chkLoginTokenJ6(String uid, String pwd) async {
    String url = "http://$ipAddress/FlutterBudget/FlutterLogin.php";

    var loginDat = <String, dynamic>{};
    loginDat['userid'] = uid;
    loginDat['password'] = pwd;

    var jsonLogin = json.encode(loginDat);

    var ret;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Accept": "application/json"},
        body: jsonLogin,
      );

      print(
        "response.body : " + response.body.trim(),
      ); // check the status code for the result

      if (response.statusCode == 200) {
        String dat = response.body.trim();

        if (dat != "") {
          try {
            final acc = json.decode(dat);
            return json.encode(acc);
          } catch (e) {
            print("error :" + e.toString());

            ret = {"errMsg": e.toString()};
            return json.encode(ret);
          }
        } else {
          ret = {"errMsg": "Empty response from server"};
          return json.encode(ret);
        }
      } else {
        ret = {"errMsg": "HTTP error: ${response.statusCode}"};
        return json.encode(ret);
      }
    } catch (e) {
      print("error :" + e.toString());
      ret = {"errMsg": e.toString()};
      return json.encode(ret);
    }
  }

  //=========================================================
  // start php : php -S 10.130.230.21:80

  Future<String> VerifyTokenExpireJ6(String token) async {
    String ret = "";
    //print("Token : " + token + " | Secretkey " + SecretKey);
    print("Token : " + token);

    String url =
        "http://$ipAddress/FlutterBudget/token_rtarf/authen_rtarf_check.php";

    final response = await http.post(Uri.parse(url), body: {'token': token});

    if (response.statusCode == 200) {
      print("response : " + response.body.trim());

      if (response.body.trim() != "") {
        ret = response.body.trim();

        return ret;
      } else
        return ret;
    } else
      return ret;
  }

  //=========================================================
  Future<String> AddUserJson(
    String unitNow,
    String uid,
    String pwd,
    String firstname,
    String lastname,
    String mobile,
  ) async {
    String url = "http://$ipAddress/FlutterBudget/AddUser.php";

    var Dat = <String, dynamic>{};
    Dat['userid'] = uid;
    Dat['password'] = pwd;
    Dat['firstname'] = firstname;
    Dat['lastname'] = lastname;
    Dat['mobile'] = mobile;
    Dat['uid'] = unitNow;

    var datAdd = json.encode(Dat);

    final response = await http.post(
      Uri.parse(url),
      headers: {"Accept": "application/json"},
      body: datAdd,
    );

    //print("response.body : " + response.body); // check the status code for the result

    var ret;
    if (response.statusCode == 200) {
      print(
        "return response : " + response.body.trim().toString(),
      ); // check the status code for the result
      //int ret = int.parse(response.body.trim());
      ret = json.decode(response.body.trim());
      //print("return value : ${ret}");
      // check data return
      print(ret['result'] + " | " + ret["msg"]);

      return response.body.trim();

      //return 1;
      //return ret;
    } else {
      print("return statusCode Error");
      ret = {"result": "false", "msg": "No Response from Server"};

      return ret;
    }
  }

  //=========================================================
  Future<String> UpdateUser(Dat) async {
    String url = "http://$ipAddress/FlutterBudget/UpdateUser.php";

    // Dat = <String, dynamic>{};
    // Dat['userid'] = uid;
    // Dat['password'] = pwd;
    // Dat['firstname'] = firstname;
    // Dat['lastname'] = lastname;
    // Dat['mobile'] = mobile;

    var datUpdate = json.encode(Dat);

    final response = await http.post(
      Uri.parse(url),
      headers: {"Accept": "application/json"},
      body: datUpdate,
    );

    //print("response.body : " + response.body); // check the status code for the result

    var ret;
    if (response.statusCode == 200) {
      print(
        "return response : " + response.body.trim().toString(),
      ); // check the status code for the result

      ret = json.decode(response.body.trim());
      // check data return
      print(ret['result'] + " | " + ret["msg"].toString());

      return response.body.trim();

      //return 1;
      //return ret;
    } else {
      print("return statusCode Error");
      ret = {"result": "false", "msg": "No Response from Server"};

      return ret;
    }
  }

  //=========================================================
  Future<String> DeleteUser(Dat) async {
    String url = "http://$ipAddress/FlutterBudget/DeleteAccount.php";

    // Dat = <String, dynamic>{};
    // Dat['userid'] = uid;
    // Dat['password'] = pwd;
    // Dat['firstname'] = firstname;
    // Dat['lastname'] = lastname;
    // Dat['mobile'] = mobile;

    var datUpdate = json.encode(Dat);

    final response = await http.post(
      Uri.parse(url),
      headers: {"Accept": "application/json"},
      body: datUpdate,
    );

    //print("response.body : " + response.body); // check the status code for the result

    var ret;
    if (response.statusCode == 200) {
      print(
        "return response : " + response.body.trim().toString(),
      ); // check the status code for the result

      ret = json.decode(response.body.trim());
      // check data return
      print(ret['result'] + " | " + ret["msg"]);

      return response.body.trim();

      //return 1;
      //return ret;
    } else {
      print("return statusCode Error");
      ret = {"result": "false", "msg": "No Response from Server"};

      return ret;
    }
  }

  //=========================================================
  Future<List<Account>> getDataAccount() async {
    String url = "http://$ipAddress/FlutterBudget/FlutterGetAccount.php";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      //print(response.body);

      final items =
          json.decode(response.body.trim()).cast<Map<String, dynamic>>();

      List<Account> studentList =
          items.map<Account>((json) {
            return Account.fromJson(json);
          }).toList();

      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  //=======check Format Id_exp_spen , code_bud_rtarf============

  //==============Book Unit=====================================
  Future<String> AddBookUnit(
    String Years,
    String Id_exp_spen,
    String List_exp_spen,
    String TitleStr,
    String BookNo,
    String Doc_unit,
    String Money,
    String Dates,
    String Secret_class,
    String Speed_class,
    String Response,
    String Units,
    String UnitName,
    String TypeJob,
    String DateStart,
    String DateStop,
    String Days,
  ) async {
    String url = "http://$ipAddress/FlutterBudget/AddBookUnit.php";

    var Dat = <String, dynamic>{};
    Dat['years'] = Years;
    Dat['id_exp_spen'] = Id_exp_spen;
    Dat['list_exp_spen'] = List_exp_spen;
    Dat['title'] = TitleStr;
    Dat['doc_unit_no'] = BookNo;
    Dat['doc_unit'] = Doc_unit;
    Dat['amout'] = Money;
    Dat['unit_date_no'] = Dates;
    Dat['secret_class'] = Secret_class;
    Dat['speed_class'] = Speed_class;
    Dat['response_person'] = Response;
    Dat['type_job'] = TypeJob;
    Dat['uid'] = Units;
    Dat['unitname'] = UnitName;
    Dat['date_start'] = DateStart;
    Dat['date_stop'] = DateStop;
    Dat['days'] = Days;

    var datAdd = json.encode(Dat);

    final response = await http.post(
      Uri.parse(url),
      headers: {"Accept": "application/json"},
      body: datAdd,
    );

    //print("response.body : " + response.body); // check the status code for the result

    var ret;
    if (response.statusCode == 200) {
      print(
        "return response : " + response.body.trim().toString(),
      ); // check the status code for the result
      //int ret = int.parse(response.body.trim());
      ret = json.decode(response.body.trim());
      //print("return value : ${ret}");
      // check data return
      print(ret['result'] + " | " + ret["msg"]);

      return response.body.trim();

      //return 1;
      //return ret;
    } else {
      print("return statusCode Error");
      ret = {"result": "false", "msg": "No Response from Server"};

      return ret;
    }
  }

  //==============table Status=====================================
  /* txtYear.text,
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
             txtResponseOriginal.text,
             txtSender.text,
             login.get('mobile'),
*/
  Future<String> SendExpediteUser(
    //send first from original to other unit
    String years,
    String doc_unit_no,
    String list_exp_spen,
    String title,
    String unitname_str,
    String id_job,
    String id_use_int,
    String sent_to,
    String sent_to_name,
    String date_sent_to,
    String status,
    String status_detail,
    String fileName,
    String etc,
    //String Response_Original,
    String sender,
    String mobile,
  ) async {
    String url = "http://$ipAddress/FlutterBudget/SendExpediteUser.php";

    var Dat = <String, dynamic>{};
    Dat['years'] = years;
    Dat['list_exp_spen'] = list_exp_spen;
    Dat['title'] = title;
    Dat['unitname'] = unitname_str;
    Dat['doc_unit_no'] = doc_unit_no;
    Dat['id_job'] = id_job;
    Dat['id_use_int'] = id_use_int;
    Dat['sent_to'] = sent_to;
    Dat['sent_to_name'] = sent_to_name;
    Dat['date_sent_to'] = date_sent_to;
    Dat['status'] = status;
    Dat['status_detail'] = status_detail;
    Dat['doc_unit'] = fileName;
    Dat['etc'] = etc;
    // Dat['response_person_original'] = Response_Original; it will reccord to rx
    Dat['sender'] = sender;
    Dat['mobile'] = mobile;

    var datAdd = json.encode(Dat);

    final response = await http.post(
      Uri.parse(url),
      headers: {"Accept": "application/json"},
      body: datAdd,
    );

    //print("response.body : " + response.body); // check the status code for the result

    var ret;
    if (response.statusCode == 200) {
      print(
        "return response : " + response.body.trim().toString(),
      ); // check the status code for the result
      //int ret = int.parse(response.body.trim());
      ret = json.decode(response.body.trim());
      //print("return value : ${ret}");
      // check data return
      print(ret['result'] + " | " + ret["msg"]);

      return response.body.trim();

      //return 1;
      //return ret;
    } else {
      print("return statusCode Error");
      ret = {"result": "false", "msg": "No Response from Server"};

      return ret;
    }
  }

  //============Update Status BeforSent .php====================
  Future<String> UpdateStatusBeforSent(String id_status) async {
    String url = "http://$ipAddress/FlutterBudget/UpdateStatusBeforSent.php";

    final response = await http.post(
      Uri.parse(url),
      //headers: {"Accept": "application/json"},
      body: {"id_status": id_status},
    );

    var ret;
    if (response.statusCode == 200) {
      print(
        "return response : " + response.body.trim().toString(),
      ); // check the status code for the result
      //int ret = int.parse(response.body.trim());
      ret = json.decode(response.body.trim());
      //print("return value : ${ret}");
      // check data return
      print(ret['result'] + " | " + ret["msg"]);

      return response.body.trim();
    } else {
      print("return statusCode Error");
      ret = {"result": "false", "msg": "No Response from Server"};

      return ret;
    }
  }

  //===================SendTbStatusBetweenUnit===============
  Future<String> SendTbStatusBetweenUnit(
    //send first from original to other unit
    String years,
    String doc_unit_no,
    String list_exp_spen,
    String title,
    String unitname_str,
    String id_job,
    String id_use_int,
    String sent_to,
    String sent_to_name,
    String date_sent_to,
    String status,
    String status_detail,
    String date_start,
    String date_stop,
    String days,
    String etc,
    String Response_Original,
    String fileName,
    String sender,
    String mobile,
  ) async {
    String url = "http://$ipAddress/FlutterBudget/SendTbStatusBetweenUnit.php";

    var Dat = <String, dynamic>{};

    Dat['years'] = years;
    Dat['list_exp_spen'] = list_exp_spen;
    Dat['title'] = title;
    Dat['unitname'] = unitname_str;
    Dat['doc_unit_no'] = doc_unit_no;
    Dat['id_job'] = id_job;
    Dat['id_use_int'] = id_use_int;
    Dat['sent_to'] = sent_to;
    Dat['sent_to_name'] = sent_to_name;
    Dat['date_sent_to'] = date_sent_to;
    Dat['date_start'] = date_start;
    Dat['date_stop'] = date_stop;
    Dat['days'] = days;
    Dat['status'] = status;
    Dat['status_detail'] = status_detail;
    Dat['doc_unit'] = fileName;
    Dat['etc'] = etc;
    Dat['response_person_original'] = Response_Original;
    Dat['sender'] = sender;
    Dat['mobile'] = mobile;

    var datAdd = json.encode(Dat);

    final response = await http.post(
      Uri.parse(url),
      headers: {"Accept": "application/json"},
      body: datAdd,
    );

    //print("response.body : " + response.body); // check the status code for the result

    var ret;
    if (response.statusCode == 200) {
      print(
        "return response : " + response.body.trim().toString(),
      ); // check the status code for the result
      //int ret = int.parse(response.body.trim());
      ret = json.decode(response.body.trim());
      //print("return value : ${ret}");
      // check data return
      print(ret['result'] + " | " + ret["msg"]);

      return response.body.trim();

      //return 1;
      //return ret;
    } else {
      print("return statusCode Error");
      ret = {"result": "false", "msg": "No Response from Server"};

      return ret;
    }
  }

  //=========================================================
  Future<List<Expedite>?> getDataExpedite() async {
    String url = "http://$ipAddress/FlutterBudget/FlutterGetExpedite.php";

    final response = await http.get(Uri.parse(url));
    final items =
        json.decode(response.body.trim()).cast<Map<String, dynamic>>();
    List<Expedite>? expList;

    if (response.statusCode == 200) {
      //print(response.body);
      if (response.body.isEmpty) {
        print("ไม่พบงบประมาณใดๆ!!!");
        expList = null;
      } else {
        expList =
            items.map<Expedite>((json) {
              return Expedite.fromJson(json);
            }).toList();
      }
      return expList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  //=========================================================
  Future<List<Expedite>?> getExpSearch(String cond, String years) async {
    String url = "http://$ipAddress/FlutterBudget/GetExpSearch.php";

    final response = await http.post(
      Uri.parse(url),
      body: {"cond": cond, "years": years},
    );
    if (response.statusCode == 200) {
      if (response.body.trim() != "") {
        final items =
            json.decode(response.body.trim()).cast<Map<String, dynamic>>();

        List<Expedite> expList =
            items.map<Expedite>((json) {
              return Expedite.fromJson(json);
            }).toList();

        return expList;
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  //=========================================================
  Future<List<Expedite>?> getExpSearchUnit(
    String cond,
    String years,
    String uid,
  ) async {
    String url = "http://$ipAddress/FlutterBudget/GetExpSearchUnit.php";

    final response = await http.post(
      Uri.parse(url),
      body: {"cond": cond, "years": years, "uid": uid},
    );
    if (response.statusCode == 200) {
      //print(response.body);

      if (response.body.trim() != "") {
        final items =
            json.decode(response.body.trim()).cast<Map<String, dynamic>>();

        List<Expedite> expList =
            items.map<Expedite>((json) {
              return Expedite.fromJson(json);
            }).toList();

        return expList;
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  //=========================================================
  Future<Expedite?> getExpDetail(String idExpSpen) async {
    Expedite exp;
    String url = "http://$ipAddress/FlutterBudget/GetExpDetail.php";
    //String querystring = "?id_exp_spen=$idExpSpen";
    //String qs = urlEncode(text: querystring);
    //print(urlSecret);
    Uri uriObj = Uri.parse(url);

    final response = await http.post(uriObj, body: {"id_exp_spen": idExpSpen});
    if (response.statusCode == 200) {
      if (response.body.trim() != "") {
        //final items = Expedite.fromJson(json.decode(response.body.trim())); error
        //Map items = json.decode(response.body.trim());
        final jsonRes = json.decode(response.body.trim());
        //Expedite exp = new Expedite.fromJson(jsonRes);
        if (jsonRes != null) {
          //var listExpSpen = jsonRes[0]['list_exp_spen'];
          int idlist = int.parse(jsonRes[0]["idlist"]);
          String idExpSpen = jsonRes[0]["id_exp_spen"];
          String listExpSpen = jsonRes[0]["list_exp_spen"];
          String memoTh = jsonRes[0]["memo_th"];
          double mBorder =
              double.tryParse(jsonRes[0]["mborder"]?.toString() ?? '0.0') ??
              0.0;
          double mAlloc =
              double.tryParse(jsonRes[0]["malloc"]?.toString() ?? '0.0') ?? 0.0;
          int status = int.parse(jsonRes[0]["status"]);
          String daystart = jsonRes[0]["daystart"];
          String daystop = jsonRes[0]["daystop"];
          String code_bud_rtarf =
              (jsonRes[0]["code_bud_rtarf"] == null)
                  ? ''
                  : jsonRes[0]["code_bud_rtarf"];
          int field_work =
              (jsonRes[0]["field_work"] == null)
                  ? 0
                  : int.parse(jsonRes[0]["field_work"]);
          int exp_type =
              (jsonRes[0]["exp_type"] == null)
                  ? 0
                  : int.parse(jsonRes[0]["exp_type"]);
          int int_group =
              (jsonRes[0]["int_group"] == null)
                  ? 0
                  : int.parse(jsonRes[0]["int_group"]);
          int unit_use =
              (jsonRes[0]["unit_use"] == null)
                  ? 0
                  : int.parse(jsonRes[0]["unit_use"]);
          int unit_oper =
              (jsonRes[0]["unit_oper"] == null)
                  ? 0
                  : int.parse(jsonRes[0]["unit_oper"]);
          int bud_type =
              (jsonRes[0]["bud_type"] == null)
                  ? 0
                  : int.parse(jsonRes[0]["bud_type"]);
          double mpay =
              double.tryParse(jsonRes[0]["mpay"]?.toString() ?? '0.0') ?? 0.0;
          double bpay_n =
              double.tryParse(jsonRes[0]["bpay_n"]?.toString() ?? '0.0') ?? 0.0;
          double bpay =
              double.tryParse(jsonRes[0]["bpay"]?.toString() ?? '0.0') ?? 0.0;
          double cpay =
              double.tryParse(jsonRes[0]["cpay"]?.toString() ?? '0.0') ?? 0.0;
          double dpay =
              double.tryParse(jsonRes[0]["dpay"]?.toString() ?? '0.0') ?? 0.0;
          double spay =
              double.tryParse(jsonRes[0]["spay"]?.toString() ?? '0.0') ?? 0.0;
          double spay_n =
              double.tryParse(jsonRes[0]["spay_n"]?.toString() ?? '0.0') ?? 0.0;
          double opay =
              double.tryParse(jsonRes[0]["opay"]?.toString() ?? '0.0') ?? 0.0;
          double tpay =
              double.tryParse(jsonRes[0]["tpay"]?.toString() ?? '0.0') ?? 0.0;
          double tlpay =
              double.tryParse(jsonRes[0]["tlpay"]?.toString() ?? '0.0') ?? 0.0;
          double stpay =
              double.tryParse(jsonRes[0]["stpay"]?.toString() ?? '0.0') ?? 0.0;
          double balan =
              double.tryParse(jsonRes[0]["balan"]?.toString() ?? '0.0') ?? 0.0;
          int years = int.parse(jsonRes[0]["years"]);
          double m10 =
              double.tryParse(jsonRes[0]["m10"]?.toString() ?? '0.0') ?? 0.0;
          double m11 =
              double.tryParse(jsonRes[0]["m11"]?.toString() ?? '0.0') ?? 0.0;
          double m12 =
              double.tryParse(jsonRes[0]["m12"]?.toString() ?? '0.0') ?? 0.0;
          double sum1 =
              double.tryParse(jsonRes[0]["sum1"]?.toString() ?? '0.0') ?? 0.0;
          double m01 =
              double.tryParse(jsonRes[0]["m01"]?.toString() ?? '0.0') ?? 0.0;
          double m02 =
              double.tryParse(jsonRes[0]["m02"]?.toString() ?? '0.0') ?? 0.0;
          double m03 =
              double.tryParse(jsonRes[0]["m03"]?.toString() ?? '0.0') ?? 0.0;
          double sum2 =
              double.tryParse(jsonRes[0]["sum2"]?.toString() ?? '0.0') ?? 0.0;
          double m04 =
              double.tryParse(jsonRes[0]["m04"]?.toString() ?? '0.0') ?? 0.0;
          double m05 =
              double.tryParse(jsonRes[0]["m05"]?.toString() ?? '0.0') ?? 0.0;
          double m06 =
              double.tryParse(jsonRes[0]["m06"]?.toString() ?? '0.0') ?? 0.0;
          double sum3 =
              double.tryParse(jsonRes[0]["sum3"]?.toString() ?? '0.0') ?? 0.0;
          double m07 =
              double.tryParse(jsonRes[0]["m07"]?.toString() ?? '0.0') ?? 0.0;
          double m08 =
              double.tryParse(jsonRes[0]["m08"]?.toString() ?? '0.0') ?? 0.0;
          double m09 =
              double.tryParse(jsonRes[0]["m09"]?.toString() ?? '0.0') ?? 0.0;
          double sum4 =
              double.tryParse(jsonRes[0]["sum4"]?.toString() ?? '0.0') ?? 0.0;
          String stwork = jsonRes[0]["stwork"];
          int whocreate =
              (jsonRes[0]["whocreate"] == null)
                  ? 0
                  : int.parse(jsonRes[0]["whocreate"]);
          String createtime =
              (jsonRes[0]["createtime"] == null)
                  ? ''
                  : jsonRes[0]["createtime"];
          int whouse =
              (jsonRes[0]["whouse"] == null)
                  ? 0
                  : int.parse(jsonRes[0]["whouse"]);
          String lastaccess =
              (jsonRes[0]["lastaccess"] == null)
                  ? ''
                  : jsonRes[0]["lastaccess"];
          String unit_chk =
              (jsonRes[0]["unit_chk"] == null) ? '' : jsonRes[0]["unit_chk"];
          String st_rx =
              (jsonRes[0]["st_rx"] == null) ? '' : jsonRes[0]["st_rx"];
          double st_malloc =
              double.tryParse(jsonRes[0]["st_malloc"]?.toString() ?? '0.0') ??
              0.0;

          exp = Expedite(
            idlist: idlist,
            id_exp_spen: idExpSpen,
            list_exp_spen: listExpSpen,
            memo_th: memoTh,
            mborder: mBorder,
            malloc: mAlloc,
            status: status,
            daystart: daystart,
            daystop: daystop,
            code_bud_rtarf: code_bud_rtarf,
            field_work: field_work,
            exp_type: exp_type,
            int_group: int_group,
            unit_use: unit_use,
            unit_oper: unit_oper,
            bud_type: bud_type,
            mpay: mpay,
            bpay_n: bpay_n,
            bpay: bpay,
            cpay: cpay,
            dpay: dpay,
            spay: spay,
            spay_n: spay_n,
            opay: opay,
            tpay: tpay,
            tlpay: tlpay,
            stpay: stpay,
            balan: balan,
            years: years,
            m10: m10,
            m11: m11,
            m12: m12,
            sum1: sum1,
            m01: m01,
            m02: m02,
            m03: m03,
            sum2: sum2,
            m04: m04,
            m05: m05,
            m06: m06,
            sum3: sum3,
            m07: m07,
            m08: m08,
            m09: m09,
            sum4: sum4,
            stwork: stwork,
            whocreate: whocreate,
            createtime: createtime,
            whouse: whouse,
            lastaccess: lastaccess,
            unit_chk: unit_chk,
            st_rx: st_rx,
            st_malloc: st_malloc,
          );

          return exp;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } else {
      throw Exception('Response Error : ${response.statusCode}');
      //return null;
      //print("error reponse : ${response.statusCode}");
    }
  }

  //==============================================

  Future<List<UnitName>?> getDataUnit() async {
    String url = "http://$ipAddress/FlutterBudget/GetUnitName.php";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      //print(response.body.trim());

      if (response.body.trim() != "") {
        final items =
            json.decode(response.body.trim()).cast<Map<String, dynamic>>();

        List<UnitName> unitList =
            items.map<UnitName>((json) {
              return UnitName.fromJson(json);
            }).toList();

        //print(unitList.toString());
        UnitName un = new UnitName(uint: "0", uint_name: "เลือกหน่วยงาน");
        unitList.add(un);

        return unitList;
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  //=========================================================
  Future<List<UnitName>?> getUnitList() {
    Future<List<UnitName>?> tmplist;
    tmplist = getDataUnit();
    return tmplist;
  }

  //=========================================================
  Future<Object?> fetchData(String query) async {
    String url = "http://$ipAddress/FlutterBudget/FlutterGetData.php";

    var queryCom = <String, dynamic>{};
    queryCom['userid'] = query;

    var jsonQuery = json.encode(queryCom);

    final response = await http.post(
      Uri.parse(url),
      headers: {"Accept": "application/json"},
      body: jsonQuery,
    );

    if (response.statusCode == 200) {
      var ret = json.decode(response.body.trim());
      print(ret);
      return ret;
    } else {
      print("error reponse : ${response.statusCode}");
      return null;
    }
  }

  //=========================================================
  Future<Account?> getAccDetail(String aid) async {
    Account acc;
    String url = "http://$ipAddress/FlutterBudget/GetAccDetail.php";
    //String querystring = "?id_exp_spen=$idExpSpen";
    //String qs = urlEncode(text: querystring);
    //print(urlSecret);

    final response = await http.post(Uri.parse(url), body: {"aid": aid});
    if (response.statusCode == 200) {
      if (response.body.trim() != "") {
        //final items = Expedite.fromJson(json.decode(response.body.trim())); error
        //Map items = json.decode(response.body.trim());
        final jsonRes = json.decode(response.body.trim());
        //Expedite exp = new Expedite.fromJson(jsonRes);
        if (jsonRes != null) {
          //var listExpSpen = jsonRes[0]['list_exp_spen'];
          String userid = jsonRes["userid"];
          String password = jsonRes["passwords"];
          String firstname = jsonRes["firstname"];
          String lastname = jsonRes["lastname"];
          String mobile = jsonRes["mobile"] ?? '';
          int uid = int.parse(jsonRes["Uint"]);
          String pic = jsonRes["pic"] ?? '';
          int uses = int.parse(jsonRes["uses"]);
          int login =
              (jsonRes["login"] == null) ? 0 : int.parse(jsonRes["login"]);

          acc = new Account(
            aid: aid,
            userid: userid,
            passwords: password,
            firstname: firstname,
            lastname: lastname,
            mobile: mobile,
            uid: uid,
            pic: pic,
            login: login,
            uses: uses,
          );

          return acc;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } else {
      throw Exception('Response Error : ${response.statusCode}');
      //return null;
      //print("error reponse : ${response.statusCode}");
    }
  }

  //=========================================================

  Future<List<Account>?> getAccSearch(String cond, String uid) async {
    if (uid == "0") {
      return null;
    }

    String url = "http://$ipAddress/FlutterBudget/GetAccSearch.php";

    final response = await http.post(
      Uri.parse(url),
      body: {"cond": cond, "uid": uid},
    );
    if (response.statusCode == 200) {
      //print(response.body.trim());

      if (response.body.trim() != "") {
        final items =
            json.decode(response.body.trim()).cast<Map<String, dynamic>>();

        List<Account> accList =
            items.map<Account>((json) {
              return Account.fromJson(json);
            }).toList();

        print(accList.toString());

        return accList;
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  //=========================================================
  Future<List<BookUnit>?> getBookStartSearch(String cond, String years) async {
    String url = "http://$ipAddress/FlutterBudget/GetBookStartSearch.php";

    final response = await http.post(
      Uri.parse(url),
      body: {"cond": cond, "years": years},
    );
    if (response.statusCode == 200) {
      //print(response.body);

      if (response.body.trim() != "") {
        final items =
            json.decode(response.body.trim()).cast<Map<String, dynamic>>();

        List<BookUnit> bookList =
            items.map<BookUnit>((json) {
              return BookUnit.fromJson(json);
            }).toList();

        return bookList;
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  //=========================================================
  Future<List<BookUnit>?> getBookStartSearchUnit(
    String cond,
    String years,
    String uid,
  ) async {
    String url = "http://$ipAddress/FlutterBudget/GetBookStartSearchUnit.php";

    final response = await http.post(
      Uri.parse(url),
      body: {"cond": cond, "years": years, "uid": uid},
    );
    if (response.statusCode == 200) {
      //print(response.body);

      if (response.body.trim() != "") {
        final items =
            json.decode(response.body.trim()).cast<Map<String, dynamic>>();

        List<BookUnit> bookList =
            items.map<BookUnit>((json) {
              return BookUnit.fromJson(json);
            }).toList();

        return bookList;
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  //=========================================================
  Future<BookUnit?> getBookIdJob(String id_job, String years) async {
    String url = "http://$ipAddress/FlutterBudget/getBookIdJob.php";

    final response = await http.post(
      Uri.parse(url),
      body: {"id_job": id_job, "years": years},
    );
    if (response.statusCode == 200) {
      //print(response.body);

      if (response.body.trim() != "") {
        BookUnit book = BookUnit.fromJson(json.decode(response.body.trim()));

        return book;
      } else {
        return null;
      }
    } else {
      return null;
      //throw Exception('Failed to load data from Server.');
    }
  }

  //=====================Chk Income Job in ChkIncomeJob.php =======================
  Future<String> getStatusInCome(String uid, String years) async {
    String url = "http://$ipAddress/FlutterBudget/ChkIncomeJob.php";

    final response = await http.post(
      Uri.parse(url),
      body: {"uid": uid, "years": years},
    );
    if (response.statusCode == 200) {
      print("return response : " + response.body.trim());

      if (response.body.trim() != "0") {
        return response.body.trim();
      } else {
        return "0";
      }

      //return 1;
      //return ret;
    } else {
      print("return Error Get Income Job Count");
      return "0";
    }
  }

  //=====================Chk Income Job in ChkIncomeJob.php =======================
  Future<String> getStatusSend(String uid, String years) async {
    String url = "http://$ipAddress/FlutterBudget/ChkStatusSend.php";

    final response = await http.post(
      Uri.parse(url),
      body: {"uid": uid, "years": years},
    );
    if (response.statusCode == 200) {
      print("return response : " + response.body.trim());

      if (response.body.trim() != "0") {
        return response.body.trim();
      } else {
        return "0";
      }

      //return 1;
      //return ret;
    } else {
      print("return Error Get Status Send Job Count");
      return "0";
    }
  }

  //=====================tbl_status=======================
  Future<String> getStatusMsg(id_msg) async {
    String url = "http://$ipAddress/FlutterBudget/get_msg_status_detail.php";

    final response = await http.post(Uri.parse(url), body: {"id_msg": id_msg});
    if (response.statusCode == 200) {
      //print(response.body);

      if (response.body.trim() != "") {
        return response.body.trim();
      } else {
        return "";
      }
    } else {
      return "";
      //throw Exception('Failed to load data from Server.');
    }
  }

  //=========================================================
  Future<String> getFieldWork(String id_field_work) async {
    String url = "http://$ipAddress/FlutterBudget/getFieldWork.php";

    final response = await http.post(
      Uri.parse(url),
      body: {"id_field_work": id_field_work},
    );
    if (response.statusCode == 200) {
      //print(response.body);

      if (response.body.trim() != "") {
        return response.body.trim();
      } else {
        return "";
      }
    } else {
      return "";
      //throw Exception('Failed to load data from Server.');
    }
  }

  //===========get budget type name========================
  Future<String> getBudType(String id_bud_type) async {
    String url = "http://$ipAddress/FlutterBudget/getBudType.php";

    final response = await http.post(
      Uri.parse(url),
      body: {"id_bud_type": id_bud_type},
    );
    if (response.statusCode == 200) {
      //print(response.body);

      if (response.body.trim() != "") {
        return response.body.trim();
      } else {
        return "";
      }
    } else {
      return "";
      //throw Exception('Failed to load data from Server.');
    }
  }

  //====================GetUnitName==========================
  Future<String> getUnitName(String uid) async {
    String url = "http://$ipAddress/FlutterBudget/GetUnitNameID.php";

    final response = await http.post(Uri.parse(url), body: {"uid": uid});
    if (response.statusCode == 200) {
      //print(response.body);

      if (response.body.trim() != "") {
        return response.body.trim();
      } else {
        return "";
      }
    } else {
      return "";
      //throw Exception('Failed to load data from Server.');
    }
  }

  //======================Get Acc Name=========================
  Future<String> getAccName(String aid) async {
    String url = "http://$ipAddress/FlutterBudget/GetAccName.php";

    final response = await http.post(Uri.parse(url), body: {"aid": aid});
    if (response.statusCode == 200) {
      //print(response.body);

      if (response.body.trim() != "") {
        return response.body.trim();
      } else {
        return "";
      }
    } else {
      return "";
      //throw Exception('Failed to load data from Server.');
    }
  }

  //=======================Get int group name=========================
  Future<String> getIntGroupName(String id_int_group) async {
    String url = "http://$ipAddress/FlutterBudget/GetIntGroup.php";

    final response = await http.post(
      Uri.parse(url),
      body: {"id_int_group": id_int_group},
    );
    if (response.statusCode == 200) {
      //print(response.body);

      if (response.body.trim() != "") {
        return response.body.trim();
      } else {
        return "";
      }
    } else {
      return "";
      //throw Exception('Failed to load data from Server.');
    }
  }

  //======================get getExpType=============================
  Future<String> getExpType(String id_expen_type) async {
    String url = "http://$ipAddress/FlutterBudget/GetExpType.php";

    final response = await http.post(
      Uri.parse(url),
      body: {"id_expen_type": id_expen_type},
    );
    if (response.statusCode == 200) {
      //print(response.body);

      if (response.body.trim() != "") {
        return response.body.trim();
      } else {
        return "";
      }
    } else {
      return "";
      //throw Exception('Failed to load data from Server.');
    }
  }
  //====================== Table Status ================================

  Future<List<TBStatusSearch>?> GetTBStatusSearch(
    String cond,
    String years,
    String sent_to,
  ) async {
    String url = "http://$ipAddress/FlutterBudget/GetTBStatusSearch.php";

    final response = await http.post(
      Uri.parse(url),
      body: {"cond": cond, "years": years, "sent_to": sent_to},
    );
    if (response.statusCode == 200) {
      //print(response.body);

      if (response.body.trim() != "") {
        final items =
            json.decode(response.body.trim()).cast<Map<String, dynamic>>();

        List<TBStatusSearch> statusList =
            items.map<TBStatusSearch>((json) {
              return TBStatusSearch.fromJson(json);
            }).toList();

        return statusList;
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  //===============receive from sender in tbs_status=============================
  // ReceiveExpediteUser(
  // txtNoDocRx.text,
  // txtStatus.text,
  // widget.tbstatus.id_exp_spen,
  // widget.tbstatus.id_job,
  // widget.tbstatus.id_status)

  Future<String> ReceiveExpediteUser(
    String no_doc_rx,
    String status_detail,
    String id_exp_spen,
    String id_job,
    String id_status,
    String etc,
    String fullname,
  ) async {
    String url = "http://$ipAddress/FlutterBudget/ReceiveExpedite.php";

    var Dat = <String, dynamic>{};
    Dat['id_exp_spen'] = id_exp_spen;
    Dat['id_job'] = id_job;
    Dat['id_status'] = id_status;
    Dat['no_doc_rx'] = no_doc_rx;
    Dat['status_detail'] = status_detail;
    Dat['fullname'] = fullname;
    Dat['etc'] = etc;

    var datAdd = json.encode(Dat);

    final response = await http.post(
      Uri.parse(url),
      headers: {"Accept": "application/json"},
      body: datAdd,
    );

    //print("response.body : " + response.body); // check the status code for the result

    var ret;
    if (response.statusCode == 200) {
      print(
        "return response : " + response.body.trim().toString(),
      ); // check the status code for the result
      //int ret = int.parse(response.body.trim());
      ret = json.decode(response.body.trim());
      //print("return value : ${ret}");
      // check data return
      print(ret['result'] + " | " + ret["msg"]);

      return response.body.trim();

      //return 1;
      //return ret;
    } else {
      print("return statusCode Error");
      ret = {"result": "false", "msg": "No Response from Server"};

      return ret;
    }
  }

  //============get Date Rec Rx==========================
  Future<String> getDateRecRx(String id_status) async {
    String url = "http://$ipAddress/FlutterBudget/GetDateRecRx.php";

    final response = await http.post(
      Uri.parse(url),
      body: {"id_status": id_status},
    );
    if (response.statusCode == 200) {
      //print(response.body);

      if (response.body.trim() != "") {
        return response.body.trim();
      } else {
        return "";
      }
    } else {
      return "";
      //throw Exception('Failed to load data from Server.');
    }
  }

  //======================================================
  static Future<String> createTable(String tb) async {
    String url = "http://$ipAddress/FlutterBudget/CreateTable.php";

    Uri uriObj = Uri.parse(url);

    try {
      var map = <String, dynamic>{};
      map['tbName'] = tb;

      final response = await http.post(uriObj, body: map);
      print('Create Table Response : ${response.body.trim()}');
      return response.body;
    } catch (e) {
      return "error";
    }
  }

  //==============Send to Create QRCODE =====================================
  Future<String> SentURLQRCODE(String id_exp_spen, String site) async {
    String url =
        "http://$ipAddress/$site/qrcode/getURLFromFlutter.php"; // it is in qrcode in website target

    var Dat = <String, dynamic>{};
    Dat['id_exp_spen'] = id_exp_spen;

    final response = await http.post(
      Uri.parse(url),
      headers: {"Accept": "application/json"},
      body: json.encode(Dat),
    );

    if (response.statusCode == 200) {
      print(
        "return response : " + response.body.trim(),
      ); // check the status code for the result

      return response.body.trim();
    } else {
      return "";
    }
  }

  //=============Function Delay  ============================================

  void delay(int sec, Function() function1) {
    Future.delayed(Duration(seconds: sec), () {
      function1(); // Call the provided function after the delay
    });
  }

  //==============Redirect SignIn======================================
  void redirectSignIn(BuildContext context) {
    // Use the global navigatorKey so this can be called from async/delayed
    // callbacks without depending on a BuildContext that may be deactivated.
    try {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        SignInScreen.routeName,
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      // As a fallback, attempt to use the provided context.
      Navigator.of(context).pushNamedAndRemoveUntil(
        SignInScreen.routeName,
        (Route<dynamic> route) => false,
      );
    }
  }
}  //=======end class MySQLService=======================

