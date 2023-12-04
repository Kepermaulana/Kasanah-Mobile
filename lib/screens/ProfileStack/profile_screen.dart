import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:kasanah_mobile/core/api/api.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/class/product_class.dart';
import 'package:kasanah_mobile/core/service/sell_service.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:flutter_svg/svg.dart';
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/core/worker/CurrencyWorker.dart';
import 'package:kasanah_mobile/core/worker/MessageWorker.dart';
import 'package:kasanah_mobile/screens/FundStack/funding_render.dart';
import 'package:kasanah_mobile/screens/ProfileStack/OrderStatusStack/order_status_screen.dart';
import 'package:kasanah_mobile/screens/ProfileStack/ProfileChangeStack/change_profile_screen.dart';
import 'package:kasanah_mobile/screens/ProfileStack/ProfileChangeStack/user_address_screen.dart';
import 'package:kasanah_mobile/screens/ProfileStack/QrCodeStack/qr_code_screen.dart';
import 'package:kasanah_mobile/screens/ProfileStack/notification_screen.dart';
import 'package:kasanah_mobile/screens/TransactionStack/cart_screen.dart';
import 'package:kasanah_mobile/screens/welcome_screen.dart';
import 'package:kasanah_mobile/widgets/WAlertDialog.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';
import 'package:kasanah_mobile/widgets/WCard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import "package:package_info_plus/package_info_plus.dart";

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? idUser,
      token,
      phoneNumber,
      longName,
      appName,
      packageName,
      version,
      buildNumber;

  bool _isWithPieChart = false;

  // FOR PIECHART
  bool _isLoading = true;

  final Uri _url = Uri.parse('http://panenin.id/kebijakan-privasi/');
  void _privacyPolicy({required String url}) async {
    if (await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw AlertDialog(
        title: Text(
          "Gagal",
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 15, color: c.blackColor),
        ),
      );
    }
  }

  Future setVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
      _isLoading = false;
    });
  }

  String? walletUser;
  List<Wallet> userWallet = [];

  void getUserWallet() async {
    String wUserId = sessionManager.nUserId!;
    Uri url = Uri.parse('$kMgApi/SaldoPay?user=$wUserId');
    final respose = await http.get(url);
    var data = jsonDecode(respose.body);
    for (var e in data) {
      userWallet.add(Wallet(saldo: e["saldo"]));
    }
    Wallet wallet = userWallet.last;
    setState(() {
      walletUser = formatToRp(wallet.saldo!).toString();
    });
  }

  @override
  void initState() {
    getUserWallet();
    sessionManager.getPref().then((value) {
      setState(() {
        idUser = sessionManager.nUserId;
        longName = sessionManager.nLongName;
        token = sessionManager.nToken;
        phoneNumber = sessionManager.nPhoneNumber;
      });
    });
    (() async {
      setVersion();
    })();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            SvgPicture.asset('assets/images/top_auth.svg', width: mediaW),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: Center(
                        child: Text(
                          'Akun Saya',
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: c.whiteColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 24),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: Container(
                            height: mediaH / 7.5,
                            width: mediaW / 1.40,
                            decoration: BoxDecoration(
                              color: c.whiteColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: Row(
                                children: [
                                  (sessionManager.nIsVerified == "true")
                                      ? Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: mediaW / 3,
                                                    child: Text(
                                                      '${sessionManager.nLongName}',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: mediaH / 60,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: c.brownColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : Row(
                                          children: [
                                            SizedBox(
                                              width: mediaW / 3,
                                              child: Text(
                                                '${sessionManager.nLongName}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: mediaH / 60,
                                                  fontWeight: FontWeight.w600,
                                                  color: c.brownColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  const Spacer(),
                                  (sessionManager.nIsVerified == "true")
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const QrCodeScreen()),
                                                );
                                              },
                                              child: Icon(
                                                Icons.qr_code,
                                                size: 30,
                                                color: c.brownColor,
                                              ),
                                            ),
                                            const Spacer(),
                                            SizedBox(
                                                height: 20,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const ChangeProfileScreen()),
                                                    );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              c.brownColor),
                                                  child: const Text(
                                                    'Detail',
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ))
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const Spacer(),
                                            SizedBox(
                                                height: 20,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const ChangeProfileScreen()),
                                                    );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              c.brownColor),
                                                  child: const Text(
                                                    'Detail',
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                )),
                                          ],
                                        )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            WActionButton(
                              Icon(
                                Icons.notifications_none_outlined,
                                color: c.brownColor,
                              ),
                              c.whiteColor,
                              mediaW / 7,
                              50,
                              context,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MyRoute(
                                        builder: (_) =>
                                            const NotificationScreen()));
                              },
                            ),
                            SizedBox(
                              height: mediaH / 50,
                            ),
                            WActionButton(
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: c.brownColor,
                              ),
                              c.whiteColor,
                              mediaW / 7,
                              50,
                              context,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MyRoute(
                                        builder: (_) => const CartScreen()));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: Row(
                        children: [
                          const Text(
                            "Pesanan Saya",
                            style: TextStyle(
                                color: Color(0xFF855434),
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          GestureDetector(
                            child: Row(
                              children: [
                                const Text(
                                  " Riwayat Pesanan",
                                  style: TextStyle(
                                    color: Color(0xFF855434),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: c.brownColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: mediaH / 8,
                                child: ListView(
                                  addAutomaticKeepAlives: false,
                                  addRepaintBoundaries: false,
                                  padding: EdgeInsets.symmetric(
                                      vertical: mediaW / 28),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: false,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    Row(
                                      children: [
                                        WCard_MyOrder(
                                            context,
                                            'Belum Bayar',
                                            Icon(
                                              Icons.wallet,
                                              size: 40,
                                              color: c.brownColor,
                                            ), () {
                                          Navigator.push(
                                              context,
                                              MyRoute(
                                                builder: (_) =>
                                                    OrderStatusScreen(
                                                  orderIndex: 'P',
                                                ),
                                              ));
                                        }),
                                        WCard_MyOrder(
                                            context,
                                            'Dikemas',
                                            Icon(
                                              Icons.inventory,
                                              size: 40,
                                              color: c.brownColor,
                                            ), () {
                                          Navigator.push(
                                              context,
                                              MyRoute(
                                                builder: (_) =>
                                                    OrderStatusScreen(
                                                  orderIndex: 'T',
                                                ),
                                              ));
                                        }),
                                        WCard_MyOrder(
                                            context,
                                            'Dikirim',
                                            Icon(
                                              Icons.local_shipping,
                                              size: 40,
                                              color: c.brownColor,
                                            ), () {
                                          Navigator.push(
                                              context,
                                              MyRoute(
                                                builder: (_) =>
                                                    OrderStatusScreen(
                                                  orderIndex: 'A',
                                                ),
                                              ));
                                        }),
                                        WCard_MyOrder(
                                            context,
                                            'Beri Penilaian',
                                            Icon(
                                              Icons.star_outlined,
                                              size: 40,
                                              color: c.brownColor,
                                            ), () {
                                          Navigator.push(
                                              context,
                                              MyRoute(
                                                builder: (_) =>
                                                    OrderStatusScreen(
                                                  orderIndex: 'B',
                                                ),
                                              ));
                                        }),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: ListMenu(
                        icon: Icon(
                          Icons.location_on_outlined,
                          color: c.brownColor,
                          size: 30,
                        ),
                        onPress: () {
                          Navigator.push(
                              context,
                              MyRoute(
                                builder: (_) => const UserAddressScreen(),
                              ));
                        },
                        title: 'Alamat',
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: ListMenu(
                        icon: Icon(
                          Icons.logout_outlined,
                          color: c.brownColor,
                          size: 30,
                        ),
                        onPress: () => showDialog(
                            context: context,
                            builder: (BuildContext context) => WDialong_SignOut(
                                  context,
                                  'Apakah Anda Yakin Akan Keluar?',
                                  onConfirm: () async {
                                    await sessionManager.clearSession();
                                    // Restart.restartApp(); // for production
                                    setState(() {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const WelcomeScreen()),
                                          (route) => false);
                                    });
                                  },
                                )),
                        title: 'Keluar',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListMenu extends StatelessWidget {
  const ListMenu({
    Key? key,
    required this.icon,
    required this.onPress,
    required this.title,
  }) : super(key: key);

  final String title;
  final VoidCallback onPress;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Container(
        padding: const EdgeInsets.only(
            bottom: defaultPadding / 2, top: defaultPadding),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: c.greyColor.withOpacity(0.7)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                icon,
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: c.blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
