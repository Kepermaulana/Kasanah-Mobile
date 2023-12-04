import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/service/onesignal_service.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/screens/FundStack/funding_component.dart';
import 'package:kasanah_mobile/screens/FundStack/funding_render.dart';
import 'package:kasanah_mobile/screens/HomeStack/home_screen.dart';
import 'package:kasanah_mobile/screens/MyStoreStack/store_screen.dart';
import 'package:kasanah_mobile/screens/ProfileStack/profile_screen.dart';
import 'package:kasanah_mobile/screens/TransactionHistoryStack/transaction_history_screen.dart';
import 'package:kasanah_mobile/screens/welcome_screen.dart';
import 'package:kasanah_mobile/widgets/WAlertDialog.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class WNavigationBar extends StatefulWidget {
  const WNavigationBar({super.key});

  @override
  State<WNavigationBar> createState() => _WNavigationBarState();
}

class _WNavigationBarState extends State<WNavigationBar> {
  int _selectedIndex = 0;
  PageController? _pageController;
  String? isVerified;

  final List _listPage = [
    const HomeScreen(),
    const TransactionHistoryPage(),
    // const FundingRendererScreen(), // LINKV2
    const StoreScreen(),
    const ProfileScreen(),
  ];

  final List _listPageFalse = [
    const HomeScreen(),
    const TransactionHistoryPage(),
    // const FundingRendererScreen(), // LINKV2
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    sessionManager.getPref().then((value) {
      setState(() {
        isVerified = sessionManager.nIsVerified;
      });
    });
    (() async {
      // await validateOneSignalPlayer();
      // validatePhoneNumberVerification();
    })();
  }

  @override
  Widget build(BuildContext context) {
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return (isVerified == "true")
        ? Scaffold(
            body: Center(
              child: _listPage[_selectedIndex],
            ),
            // SizedBox.expand(
            //   child: PageView(
            //     controller: _pageController,
            //     onPageChanged: (index) {
            //       _selectedIndex = index;
            //     },
            //     children: [_listPage[_selectedIndex]],
            //   ),
            // ),
            bottomNavigationBar: StyleProvider(
              style: Style(),
              child: ConvexAppBar(
                  style: TabStyle.reactCircle,
                  backgroundColor: c.brownColor,
                  height: mediaH / 14,
                  color: c.whiteColor,
                  initialActiveIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  items: [
                    TabItem(
                        icon: SvgPicture.asset(
                          'assets/images/home_active.svg',
                          color: c.whiteColor,
                        ),
                        activeIcon: Padding(
                          padding: EdgeInsets.all(mediaW / 30),
                          child: SvgPicture.asset(
                            'assets/images/home_active.svg',
                            color: c.brownColor,
                          ),
                        ),
                        title: 'Home'),
                    TabItem(
                        icon: SvgPicture.asset('assets/images/transaksi.svg',
                            color: c.whiteColor),
                        activeIcon: Padding(
                          padding: EdgeInsets.all(mediaW / 23),
                          child: SvgPicture.asset('assets/images/transaksi.svg',
                              color: c.brownColor),
                        ),
                        title: 'Transaksi'),
                    TabItem(
                        icon: SvgPicture.asset('assets/images/market.svg',
                            color: c.whiteColor),
                        activeIcon: Padding(
                          padding: EdgeInsets.all(mediaW / 21),
                          child: SvgPicture.asset('assets/images/market.svg',
                              color: c.brownColor),
                        ),
                        title: 'Toko Saya'),
                    TabItem(
                        icon: SvgPicture.asset('assets/images/akun_active.svg',
                            color: c.whiteColor),
                        activeIcon: Padding(
                          padding: EdgeInsets.all(mediaW / 30),
                          child: SvgPicture.asset(
                              'assets/images/akun_active.svg',
                              color: c.brownColor),
                        ),
                        title: 'Akun'),
                  ]),
            ),
          )
        : Scaffold(
            body: SizedBox.expand(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  _selectedIndex = index;
                },
                children: <Widget>[_listPageFalse[_selectedIndex]],
              ),
            ),
            bottomNavigationBar: StyleProvider(
              style: Style(),
              child: ConvexAppBar(
                  style: TabStyle.reactCircle,
                  backgroundColor: c.brownColor,
                  height: mediaH / 14,
                  color: c.whiteColor,
                  initialActiveIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  items: [
                    TabItem(
                        icon: SvgPicture.asset(
                          'assets/images/home_active.svg',
                          color: c.whiteColor,
                        ),
                        activeIcon: Padding(
                          padding: EdgeInsets.all(mediaW / 30),
                          child: SvgPicture.asset(
                            'assets/images/home_active.svg',
                            color: c.brownColor,
                          ),
                        ),
                        title: 'Home'),
                    TabItem(
                        icon: SvgPicture.asset('assets/images/transaksi.svg',
                            color: c.whiteColor),
                        activeIcon: Padding(
                          padding: EdgeInsets.all(mediaW / 23),
                          child: SvgPicture.asset('assets/images/transaksi.svg',
                              color: c.brownColor),
                        ),
                        title: 'Transaksi'),
                    TabItem(
                        icon: SvgPicture.asset('assets/images/akun_active.svg',
                            color: c.whiteColor),
                        activeIcon: Padding(
                          padding: EdgeInsets.all(mediaW / 30),
                          child: SvgPicture.asset(
                              'assets/images/akun_active.svg',
                              color: c.brownColor),
                        ),
                        title: 'Akun'),
                  ]),
            ),
          );
  }
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 40;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 24;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(fontSize: 12, color: color, fontFamily: 'Poppins');
  }
}

BottomAppBar WCartBottomBar(BuildContext context, String totalHarga,
    String title, VoidCallback onPressed,
    {bool btnIsDisabled = true}) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return BottomAppBar(
    child: Container(
      padding: const EdgeInsets.all(25.0),
      height: mediaH / 7.5,
      decoration: BoxDecoration(
        color: c.whiteColor,
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  const Text(
                    'Total Harga',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                  Text(
                    // mark2
                    totalHarga,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  )
                ],
              ),
              SizedBox(
                  height: mediaH / defaultPadding,
                  child: WButton_Filled(
                      onPressed, const Text("Lanjut"), context,
                      color: c.greenColor,
                      width: 3.5,
                      isDisabled: btnIsDisabled)),
            ],
          ),
        ),
      ]),
    ),
  );
}
