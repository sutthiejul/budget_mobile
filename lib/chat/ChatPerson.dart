import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../global/globalVar.dart';
import '../global/ManageLogin.dart';
import 'package:budget_mobile/helper/DatabaseHelper.dart';
import 'package:budget_mobile/screens/theme/theme_provider.dart'; // เพิ่มการ import ThemeProvider

var login;

class ChatPerson extends StatefulWidget {
  static String routeName = "/chatperson";
  const ChatPerson({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ChatPerson> createState() => _ChatPersonState();
}

class _ChatPersonState extends State<ChatPerson> {
  IO.Socket? socket;
  List<Map<String, dynamic>> msgList = [];
  bool isDbLoading = true;
  bool isConnected = false;
  String connectionError = "";
  int groupUserCount = 0;

  final txtMsg = TextEditingController();
  final FocusNode _focus = FocusNode();
  final ScrollController listviewcontroller = ScrollController();

  @override
  void initState() {
    super.initState();
    loadLocalData();
  }

  void loadLocalData() async {
    ManageLogin manageLogin = ManageLogin();
    final box = await manageLogin.DefineBox();
    final localChats = await DatabaseHelper.instance.getAllMessages();

    if (mounted) {
      setState(() {
        login = box;
        msgList = localChats;
        isDbLoading = false;
      });
      scrollToBottom();
      initialSocketIO();
    }
  }

  void initialSocketIO() {
    String connectUrl = url_node.trim();
    if (!connectUrl.startsWith("http://") &&
        !connectUrl.startsWith("https://")) {
      connectUrl = "http://" + connectUrl;
    }

    dev.log(
      "==> [Socket Client] Connecting to: $connectUrl",
      name: "CHAT_SOCKET",
    );

    try {
      socket = IO.io(
        connectUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(10)
            .setReconnectionDelay(2000)
            .build(),
      );

      socket!.onConnect((_) {
        dev.log(
          "==> [Socket Client] Connected successfully!",
          name: "CHAT_SOCKET",
        );
        if (mounted) {
          setState(() {
            isConnected = true;
            connectionError = "";
          });
        }
        final myUserid =
            login?.get('userid') ??
            'User_${DateTime.now().millisecondsSinceEpoch % 1000}';
        socket!.emit("join_group", {"userid": myUserid});
      });

      socket!.onConnectError((err) {
        dev.log(
          "==> [Socket Client Error] ConnectError: $err",
          name: "CHAT_SOCKET",
        );
        if (mounted) {
          setState(() {
            isConnected = false;
            connectionError = "ConnectError: $err";
          });
        }
      });

      socket!.onError((err) {
        dev.log(
          "==> [Socket Client Error] General Error: $err",
          name: "CHAT_SOCKET",
        );
        if (mounted) {
          setState(() {
            isConnected = false;
            connectionError = "Error: $err";
          });
        }
      });

      // ใช้ .on('connect_timeout', ...) แทน onConnectTimeout เพื่อรองรับ socket_io_client 3.x
      socket!.on('connect_timeout', (data) {
        dev.log(
          "==> [Socket Client Error] Connect Timeout",
          name: "CHAT_SOCKET",
        );
        if (mounted) {
          setState(() {
            isConnected = false;
            connectionError = "Connection Timeout";
          });
        }
      });

      socket!.onDisconnect((reason) {
        dev.log(
          "==> [Socket Client] Disconnected: $reason",
          name: "CHAT_SOCKET",
        );
        // ถ้าเป็นการหลุดชั่วคราวแล้วกำลังต่อใหม่ ให้รอ 1 วินาทีก่อนแสดงแถบแดง
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted && !(socket?.connected ?? false)) {
            setState(() {
              isConnected = false;
              connectionError = "Disconnected: $reason";
            });
          }
        });
      });

      socket!.on("group_info", (data) {
        dev.log(
          "==> [Socket Client] Received group_info: $data",
          name: "CHAT_SOCKET",
        );
        if (mounted) {
          setState(() {
            groupUserCount = data["count"] ?? 0;
          });
        }
      });

      socket!.on("history", (data) async {
        dev.log(
          "==> [Socket Client] Received history count: ${(data as List).length}",
          name: "CHAT_SOCKET",
        );
        final historyList = List<dynamic>.from(data);
        await DatabaseHelper.instance.syncHistory(historyList);
        final localChats = await DatabaseHelper.instance.getAllMessages();
        if (mounted) {
          setState(() {
            msgList = localChats;
          });
          scrollToBottom();
        }
      });

      socket!.on("msg", (data) async {
        dev.log(
          "==> [Socket Client] Received message: $data",
          name: "CHAT_SOCKET",
        );
        final username = data["username"] ?? '';
        final msg = data["msg"] ?? '';
        final timestamp =
            data["timestamp"] ?? DateTime.now().millisecondsSinceEpoch;

        await DatabaseHelper.instance.insertMessage(
          username,
          msg,
          timestamp: timestamp,
        );
        final localChats = await DatabaseHelper.instance.getAllMessages();
        if (mounted) {
          setState(() {
            msgList = localChats;
          });
          scrollToBottom();
        }
      });
    } catch (e, stack) {
      dev.log(
        "==> [Socket Client Exception] $e",
        error: e,
        stackTrace: stack,
        name: "CHAT_SOCKET",
      );
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (listviewcontroller.hasClients) {
        listviewcontroller.jumpTo(listviewcontroller.position.maxScrollExtent);
      }
    });
  }

  void sendMessage() {
    if (txtMsg.text.trim().isNotEmpty && login != null && socket != null) {
      final myUserid = login?.get('userid') ?? 'User';
      socket!.emit("msg", {"username": myUserid, "msg": txtMsg.text.trim()});
      txtMsg.clear();
      _focus.requestFocus();
    }
  }

  String formatTimestamp(int? timestamp) {
    if (timestamp == null) return "";
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return "$hour.$minute น.";
  }

  Widget buildAvatar(String username) {
    final firstLetter =
        username.isNotEmpty ? username.substring(0, 1).toUpperCase() : '?';
    final colors = [
      Colors.blueGrey.shade600,
      Colors.teal.shade700,
      Colors.indigo.shade600,
      Colors.brown.shade600,
      Colors.deepPurple.shade600,
      Colors.cyan.shade800,
    ];
    final avatarColor = colors[username.hashCode.abs() % colors.length];

    return CircleAvatar(
      backgroundColor: avatarColor,
      radius: 18,
      child: Text(
        firstLetter,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget buildMessageItem(Map<String, dynamic> item) {
    final sender = item['username'] ?? '';
    final msgText = item['msg'] ?? '';
    final timestamp = item['timestamp'] as int?;
    final myUserid = login?.get('userid') ?? '';
    final isMe = myUserid == sender;
    final timeStr = formatTimestamp(timestamp);

    if (isMe) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (timeStr.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 6, bottom: 2),
                child: Text(
                  timeStr,
                  style: const TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ),
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.72,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF4A4A4A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.zero,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 14,
                ),
                child: Text(
                  msgText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAvatar(sender),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sender,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.65,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFF2E2E2E),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.zero,
                              topRight: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 14,
                          ),
                          child: Text(
                            msgText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                      if (timeStr.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 6, bottom: 2),
                          child: Text(
                            timeStr,
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    socket?.disconnect();
    socket?.dispose();
    txtMsg.dispose();
    _focus.dispose();
    listviewcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // นำ ListenableBuilder มาครอบในส่วนของการ build เพื่อให้ UI อัปเดตตาม Theme
    return ListenableBuilder(
      listenable: ThemeProvider.instance,
      builder: (context, child) {
        if (isDbLoading || login == null) {
          return Scaffold(
            backgroundColor:
                ThemeProvider
                    .activeBgcolorTitlebar, // อัปเดตสีพื้นหลังตอนโหลดข้อมูล
            body: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        final myUserid = login?.get('userid') ?? 'Guest';

        return SafeArea(
          child: Scaffold(
            backgroundColor:
                ThemeProvider
                    .activeBgcolorTitlebar, // อัปเดตสีพื้นหลัง Scaffold
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'กลุ่มเร่งรัดงบประมาณ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'ผู้ใช้: $myUserid (ออนไลน์ในกลุ่ม: $groupUserCount คน)',
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                ],
              ),
              backgroundColor:
                  ThemeProvider.activeBgcolorApp, // อัปเดตสีพื้นหลัง AppBar
              elevation: 1,
            ),
            body: Column(
              children: [
                if (!isConnected)
                  GestureDetector(
                    onTap: () {
                      dev.log(
                        "==> Manual Reconnect Triggered",
                        name: "CHAT_SOCKET",
                      );
                      socket?.connect();
                    },
                    child: Container(
                      color: Colors.red.shade900,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 16,
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้ (แตะเพื่อเชื่อมต่อใหม่)",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (connectionError.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                connectionError,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    controller: listviewcontroller,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    itemCount: msgList.length,
                    itemBuilder: (context, index) {
                      return buildMessageItem(msgList[index]);
                    },
                  ),
                ),
                Container(
                  color: const Color(
                    0xFF151515,
                  ), // สามารถพิจารณาเปลี่ยนสี Container ตรงส่วนพิมพ์ข้อความเพิ่มเติมได้หากต้องการ
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          focusNode: _focus,
                          controller: txtMsg,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 10.0,
                            ),
                            filled: true,
                            fillColor: const Color(0xFF2E2E2E),
                            hintText: "พิมพ์ข้อความ...",
                            hintStyle: const TextStyle(color: Colors.white38),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (_) => sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade700,
                        radius: 20,
                        child: IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 16,
                          ),
                          onPressed: sendMessage,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
