import 'package:budget_mobile/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
//import 'ResponseMessage.dart';
import '../../global/globalVar.dart';
import '../../styles/TextStyle.dart';
import '../global/ManageLogin.dart';

var login;

class ChatPerson extends StatefulWidget {
  static String routeName = "/chatperson";
  const ChatPerson({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ChatPerson> createState() => _ChatPersonState();
}

class _ChatPersonState extends State<ChatPerson> {
  late IO.Socket socket;
  List<String>? msgList = [];

  // login.get('token')

  _ChatPersonState() {
    // initHive Box Name : LoginData
    ManageLogin _login = ManageLogin();
    _login.DefineBox().then((box) {
      login = box;
    });
  }

  //=================set Hive for Global Data===================
  // await Hive.initFlutter();
  // box = await Hive.openBox('LoginData');
  // box.put('aid', dat["aid"]);
  // box.put('userid', dat['userid']);
  // box.put('uid', dat['Uint']);
  // box.put('fullname', dat['fullname']);
  // box.put('mobile', dat["mobile"]);
  // box.put('email', dat['email']);
  // box.put('status', dat["status"]);
  // box.put('token', dat["token"]);

  //=====define TextEditingController======
  final txtMsg = TextEditingController();
  String labelGreeting = "";
  String labelBroadcast = "";

  bool _visible_state = true;

  final FocusNode _focus = FocusNode();
  ScrollController listviewcontroller = new ScrollController();

  @override
  void initState() {
    super.initState();
    //msgList.add("");
    initialSocketIO();
  }

  void initialSocketIO() {
    socket = IO.io(
      url_node,
      IO.OptionBuilder()
          .setTransports(["websocket"])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.on(
      "connect",
      (data) => print("Connection : " + socket.connected.toString()),
    );
    // socket.onConnect(
    //     (data) => print("Connection : " + socket.connected.toString()));
    socket.onConnectError((data) => print("Connected Error : $data"));
    socket.onDisconnect((data) => print("DisConnected Server"));

    //socket.on("greeting", (data) => print(data["txt"]));
    socket.on("greeting", (data) {
      print(data["txt"]);

      setState(() {
        //txtMsg.text = data["txt"];
        labelGreeting = data["txt"];
      });

      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          _visible_state = false;
        });
      });
    });

    //socket.on("greeting", (data) => print(data["txt"]));
    socket.on("broadcast", (data) {
      print(data["txt"]);

      setState(() {
        labelBroadcast = data["txt"];
      });
    });

    socket.on("msg", (data) {
      //print("UserName : " + data["username"] + " Message : " + data["msg"]);
      //print("UserName : " + data.username + " Message : " + data.msg);

      setState(() {
        // if (UserName != data["username"]) {
        //   _txtChatAlign = TextAlign.left;
        //   _styleTextChat = styleChatOther;
        // } else {
        //   _txtChatAlign = TextAlign.right;
        //   _styleTextChat = styleChatOur;
        // }
        CurrentUName = data["username"];
        msgList?.add(data["msg"]);
      });

      if (listviewcontroller.hasClients)
        listviewcontroller.jumpTo(listviewcontroller.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextMsg = TextField(
      style: styleMedium(black),
      autofocus: true,
      //focusNode: focusNode,
      focusNode: _focus,

      //keyboardType: TextInputType.text,
      //keyboardType: TextInputType.none,
      controller: txtMsg,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        filled: true,
        fillColor: Colors.green.shade200,
        hintText: "กรอกข้อความที่นี่",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSubmitted: (v) {
        if (txtMsg.text.trim() != "") {
          setState(() {
            //msgList?.add(txtMsg.text);
            socket.emit("msg", {
              "username": login.get('userid'),
              "msg": txtMsg.text,
            });
            txtMsg.clear();

            //FocusScope.of(context).previousFocus();
            //FocusScope.of(context).requestFocus();
            //FocusScope.of(context).requestFocus(_focus);
            _focus.requestFocus();
          });

          // if (listviewcontroller.hasClients)
          //   listviewcontroller
          //       .jumpTo(listviewcontroller.position.maxScrollExtent);
        }

        //var msg = new ResponseMessage();
        //msg.Alert(context, "ข้อความ", '${txtMsg.text}');

        // setState(() {
        //   msgList?.add(txtMsg.text);
        // });

        // txtMsg.text = '';
      },
    );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.lightBlueAccent,
        appBar: AppBar(title: Text('Chat User : ${login.get('userid')}')),
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Visibility(
                    child: Text(labelGreeting, style: styleMedium(black)),
                    visible: _visible_state,
                  ),
                  //Text(labelGreeting,textAlign: TextAlign.center, style: styleLabelMedium),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(labelBroadcast, style: styleMedium(black))],
            ),
            // Row(
            //   children: [
            //     (msgList != null && msgList?.length != 0) ? CardChat() : Text('')
            //   ],
            // ),
            SingleChildScrollView(
              child: Column(
                children: List.from(
                  msgList!.map(
                    (msg) => Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(3),
                      child:
                          (login.get('userid') != CurrentUName)
                              ? Text(msg)
                              : Align(
                                alignment: Alignment.centerRight,
                                child: Text(msg),
                              ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(2.0), child: TextMsg),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: FloatingActionButton(
                //hoverColor: Colors.redAccent.shade400,
                onPressed: () {
                  //var msg = new ResponseMessage();
                  //msg.Alert(context, "ข้อความ", '${txtMsg.text}');

                  if (txtMsg.text.trim() != "") {
                    setState(() {
                      //msgList?.add(txtMsg.text);

                      socket.emit("msg", {
                        "username": login.get('userid'),
                        "msg": txtMsg.text,
                      });
                      txtMsg.clear();
                      //txtMsg.text = '';
                    });
                  }
                },
                tooltip: 'Send',
                child: Icon(Icons.chat_sharp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget CardChat() {
    return Column(
      children: List.from(
        msgList!.map(
          (msg) => Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(3),
            child: Text(
              msg,
              textAlign:
                  (login.get('userid') != CurrentUName)
                      ? TextAlign.left
                      : TextAlign.right,
            ),
          ),
        ),
      ),
    );
  }
}
