import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kasanah_mobile/screens/AuthStack/signin_screen.dart';
import 'package:kasanah_mobile/screens/AuthStack/signup_screen.dart';
import 'package:kasanah_mobile/widgets/WNavigationBar.dart';

import '../core/style/Constants.dart';
import '../core/style/Colors.dart' as c;
import 'package:kasanah_mobile/widgets/WButton.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: mediaW,
        height: mediaH,
        color: c.whiteColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 70),
              SizedBox(
                width: mediaW / 1.5,
                child: SvgPicture.asset('assets/images/kasanah-logo.svg')),
              SizedBox(
                height: mediaH / 3.5,
                child: SvgPicture.asset(
                  'assets/images/kasanah-maskot.svg',
                  height: mediaH / 4,
                ),
              ),
              SizedBox(
                height: mediaH / 19,
              ),
              Column(
                children: <Widget>[
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: Column(children: [
                      Text(
                        "Selamat Datang di KASANAH",
                        style: TextStyle(
                            fontSize: mediaW / 20,
                            fontWeight: FontWeight.w700,
                            color: c.greenColor),
                      ),
                      SizedBox(
                        width: mediaW * 0.8,
                        child: Text(
                          "Jual Beli Amanah Tanpa Masalah",
                          style: TextStyle(
                            wordSpacing: 1,
                            fontWeight: FontWeight.w400,
                            color: c.greenColor,
                            fontSize: mediaW / 26,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: mediaH / 12,
                  ),
                  // Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: mediaW / 28),
                  //     child: TextButton(
                  //       onPressed: (() {
                  //         Navigator.push(context,
                  //             MyRoute(builder: (_) => const WNavigationBar()));
                  //       }),
                  //       child: const Icon(Icons.fingerprint),
                  //     )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: mediaW / 28),
                    child: WButton_Filled(
                      () {
                        Navigator.push(context,
                            MyRoute(builder: (_) => const SigninScreen()));
                      },
                      Text("Masuk", style: TextStyle(color: c.whiteColor)),
                      context,
                      height: 14,
                      color: c.brownColor
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: mediaW / 28, vertical: mediaH / 90),
                    child: WButton_Outlined(() {
                      Navigator.push(context,
                          MyRoute(builder: (_) => const SignupScreen()));
                    }, Text("Belum Punya Akun? Daftar Dulu",style: TextStyle(color: c.brownColor),), context,
                    bgColor: c.whiteColor,
                    borderColor: c.brownColor,
                        height: 14),
                  ),
                  SizedBox(
                    height: mediaH / 120,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
