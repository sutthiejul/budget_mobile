import 'package:flutter/material.dart';
import '../styles/TextStyle.dart';
import '../styles/colors.dart';

class WebViewClass extends StatefulWidget {
  //const ShowAccountDetail({Key? key}) : super(key: key);
  final String url;

  WebViewClass(this.url) {
    print("url : " + this.url);
  }

  @override
  _WebViewClassState createState() => _WebViewClassState();
}

class _WebViewClassState extends State<WebViewClass> {
  _WebViewClassState() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileField = TextField(
      //obscureText: true,
      // controller: txtFirstName,
      // focusNode: _nextFocus2,
      //enabled: false,
      style: styleNormal(red),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        filled: true,
        fillColor: Colors.white,
        hintText: "FirstName",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      onTap: () {
        //FocusScope.of(context).requestFocus(_focus);
        // _nextFocus2.requestFocus();
      },
      onSubmitted: (v) {},
      /*   onChanged: (txt) {
        setState(() {
          log(txt);
        }); 
      },*/
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
          //ShowStartBook.routeName,
          //Navigator.popAndPushNamed(context, ShowStartBook.routeName);
        },
        child: Text(
          "ย้อนกลับ",
          textAlign: TextAlign.center,
          style: styleHeadPurple2.copyWith(
            color: lightyellow2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      // help protect bottom  overflow display
      resizeToAvoidBottomInset: false,
      backgroundColor: lightpurple,
      appBar: AppBar(
        //title: Text(widget.title),
        title: Text("แสดงแฟ้มข้อมูล", style: styleHeadWhite4),
      ),
      body: SafeArea(child: Text('')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.refresh),
      ),
    );
  }
}
