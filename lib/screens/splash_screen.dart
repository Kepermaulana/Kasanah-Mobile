import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/screens/HomeStack/home_screen.dart';
import 'package:kasanah_mobile/screens/ProfileStack/profile_screen.dart';
import 'package:kasanah_mobile/screens/welcome_screen.dart';
import 'package:kasanah_mobile/widgets/WNavigationBar.dart';

import '../core/service/onesignal_service.dart';

class GlobalSplashScreen extends StatefulWidget {
  const GlobalSplashScreen({super.key});

  @override
  State<GlobalSplashScreen> createState() => GlobalSplashScreenState();
}

class GlobalSplashScreenState extends State<GlobalSplashScreen> {
  void onSession() async {
    Future.delayed(const Duration(seconds: 3), () {
      sessionManager.getPref().then((value) {
        if (value == null || value == false) {
          print("signin false");
          Navigator.pushAndRemoveUntil(context,
              MyRoute(builder: (_) => const WelcomeScreen()), (route) => false);
        } else if (value != null) {
          print("signin true");
          if (mounted) {
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(
            //         builder: (_) => WNavigationBar(
            //               userId: value,
            //             )),
            //     (route) => false);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => WNavigationBar()),
                (route) => false);
          }
        }
      });
    });
  }

  void initState() {
    super.initState();
    onSession();
  }

  @override
  Widget build(BuildContext context) {
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: mediaW,
        height: mediaH,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/kasanah.svg',
              width: 300,
            ),
          ],
        ),
      ),
    );
    ;
  }
}
