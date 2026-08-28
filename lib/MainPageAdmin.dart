import 'package:budget_mobile/widget_share/SideMenuLeftAdmin.dart';
import 'package:flutter/material.dart';
import 'package:budget_mobile/global/globalVar.dart';

import 'styles/TextStyle.dart';
import 'styles/colors.dart';
import 'screens/theme/theme_provider.dart'; // เพิ่มการ import ThemeProvider

class MainPageAdmin extends StatelessWidget {
  static String routeName = "/mainpageadmin";
  const MainPageAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print("MediaQuery size: $size");

    return ListenableBuilder(
      listenable: ThemeProvider.instance,
      builder: (context, child) {
        return Scaffold(
          drawer: SideMenuLeftAdmin(),
          appBar: AppBar(
            title: Text(titleApp, style: TextStyle(color: Colors.white)),
            backgroundColor:
                ThemeProvider.activeBgcolorApp, // อัปเดตสีพื้นหลังของ AppBar
          ),
          backgroundColor:
              ThemeProvider
                  .activeBgcolorTitlebar, // อัปเดตสีพื้นหลังของ Scaffold
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 100,
                  width:
                      double.infinity, // ensure the container takes full width
                  child: Image.asset(
                    "assets/images/budget-banner.jpg",
                    width:
                        MediaQuery.of(
                          context,
                        ).size.width, // force the image width
                    height: 100, // force the image height to match container
                    fit:
                        BoxFit
                            .fill, // fill the container completely (might distort aspect ratio)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    "assets/images/icon_win42.jpg",
                    width: MediaQuery.of(context).size.width * 0.4,
                    //fit: BoxFit.cover,
                    //fit: BoxFit.fitWidth,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'หน้าบริหารระบบ สำหรับแอดมิน !!!',
                      style: styleCustom('', 18.0, purple, true),
                    ),
                  ),
                ),
                const Text(
                  ownerApp,
                  style: TextStyle(color: Colors.brown, fontSize: 13),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
