import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:flutter_svg/svg.dart';
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/core/worker/MessageWorker.dart';
import 'package:kasanah_mobile/screens/FundStack/funding_render.dart';
import 'package:kasanah_mobile/screens/MyStoreStack/add_store_name_screen.dart';
import 'package:kasanah_mobile/screens/MyStoreStack/my_product_screen.dart';
// import 'package:kasanah_mobile/screens/MyStoreStack/store_screen_dashboard.dart';
import 'package:kasanah_mobile/screens/ProfileStack/notification_screen.dart';
import 'package:kasanah_mobile/screens/ProfileStack/privacy_policy_screen.dart';
import 'package:kasanah_mobile/screens/welcome_screen.dart';
import 'package:kasanah_mobile/widgets/WAlertDialog.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';
import 'package:kasanah_mobile/widgets/WCard.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import "package:package_info_plus/package_info_plus.dart";

import '../../core/api/api.dart';
import '../../core/class/transactionHistory_class.dart';
import '../../core/service/transaction_service.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<StoreScreen> {
  String? idUser,
      token,
      phoneNumber,
      longName,
      appName,
      packageName,
      version,
      buildNumber;

  bool _isWithPieChart = false;
  bool _isNotifyCart = false;
  bool _isNotifyNotif = false;
  int _cartCount = 0;

  List<TransactionHistory> _listOnDelivery = [];
  List<TransactionHistory> _listRating = [];
  List<TransactionHistory> _listNotyetPayed = [];
  List<TransactionHistory> _listOnPacked = [];
  List<TransactionHistory> _listCancel = [];

  // FOR PIECHART
  bool _isLoading = true;
  Map<String, double> dataMap = {
    "Pupuk": 0,
    "Alat Tani": 0,
    "Sewa Alat": 0,
  };

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

  Future getOnDelivery() async {
    Map res = await getHistoryTransactionOnDelivery();
    String r = res["res"];
    if (r == "ok") {
      List datas = res["data"];
      datas.forEach((d) async {
        String longName = sessionManager.nLongName ?? "";
        _listOnDelivery.add(TransactionHistory(
          id: d["_id"],
          idTransaction: d["IDTransaction"],
          orderUser: longName,
          deliveryService: d["deliveryService"],
          methodPayment: d["methodPayment"],
          createdAt: d["createdAt"],
          status: d["status"],
          totalPayment: d["totalPayment"],
          totalQuantity: d["totalQuantity"],
        ));
      });
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }
  }

  Future getOnPacked() async {
    Map res = await getHistoryTransactionOnPacked();
    String r = res["res"];
    if (r == "ok") {
      List datas = res["data"];
      datas.forEach((d) async {
        String longName = sessionManager.nLongName ?? "";
        _listOnPacked.add(TransactionHistory(
          id: d["_id"],
          idTransaction: d["IDTransaction"],
          orderUser: longName,
          deliveryService: d["deliveryService"],
          methodPayment: d["methodPayment"],
          createdAt: d["createdAt"],
          status: d["status"],
          totalPayment: d["totalPayment"],
          totalQuantity: d["totalQuantity"],
        ));
      });
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }
  }

  Future getNotyetPayed() async {
    Map res = await getHistoryTransactionNotPayed();
    String r = res["res"];
    if (r == "ok") {
      List datas = res["data"];
      datas.forEach((d) async {
        String longName = sessionManager.nLongName ?? "";
        _listNotyetPayed.add(TransactionHistory(
          id: d["_id"],
          idTransaction: d["IDTransaction"],
          orderUser: longName,
          deliveryService: d["deliveryService"],
          methodPayment: d["methodPayment"],
          createdAt: d["createdAt"],
          status: d["status"],
          totalPayment: d["totalPayment"],
          totalQuantity: d["totalQuantity"],
        ));
      });
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }
  }

  Future getCancel() async {
    Map res = await getHistoryTransactionCancel();
    String r = res["res"];
    if (r == "ok") {
      List datas = res["data"];
      datas.forEach((d) async {
        String longName = sessionManager.nLongName ?? "";
        _listCancel.add(TransactionHistory(
          id: d["_id"],
          idTransaction: d["IDTransaction"],
          orderUser: longName,
          deliveryService: d["deliveryService"],
          methodPayment: d["methodPayment"],
          createdAt: d["createdAt"],
          status: d["status"],
          totalPayment: d["totalPayment"],
          totalQuantity: d["totalQuantity"],
        ));
      });
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }
  }

  Future getDone() async {
    Map res = await getHistoryTransactionDone();
    String r = res["res"];
    if (r == "ok") {
      List datas = res["data"];
      datas.forEach((d) async {
        String longName = sessionManager.nLongName ?? "";
        _listRating.add(TransactionHistory(
          id: d["_id"],
          idTransaction: d["IDTransaction"],
          orderUser: longName,
          deliveryService: d["deliveryService"],
          methodPayment: d["methodPayment"],
          createdAt: d["createdAt"],
          status: d["status"],
          totalPayment: d["totalPayment"],
          totalQuantity: d["totalQuantity"],
        ));
      });
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }
  }

  @override
  void initState() {
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
      await getOnDelivery();
      await getOnPacked();
      await getNotyetPayed();
      await getCancel();
      await getDone();
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
                          'Toko Saya',
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
                            height: mediaH / 9.5,
                            width: mediaW / 1.4,
                            decoration: BoxDecoration(
                              color: c.whiteColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(114, 202, 202, 202),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Align(
                                    alignment: const Alignment(5, -0.7),
                                    child: Icon(
                                      Icons.storefront_outlined,
                                      size: 35,
                                      color: c.brownColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        (sessionManager.nStoreName == "")
                                            ? InkWell(
                                                splashColor: c.brownColor,
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MyRoute(
                                                        builder: (_) =>
                                                            AddStoreNameScreen(),
                                                      ));
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Daftar Nama Toko',
                                                      style: TextStyle(
                                                          color: c.brownColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 13),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(
                                                      Icons.edit,
                                                      size: 16,
                                                      color: c.brownColor,
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Text(
                                                '${sessionManager.nStoreName}',
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: mediaW / 30,
                                                  fontWeight: FontWeight.w600,
                                                  color: c.brownColor,
                                                ),
                                              ),
                                        const Text(
                                          "Rp.0",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            'Isi Saldo',
                                            style: TextStyle(
                                                color: c.brownColor,
                                                fontSize: 12),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: mediaW / 52,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        height: 100,
                        width: mediaW,
                        decoration: BoxDecoration(
                          color: c.whiteColor,
                          border: Border.all(
                              color: c.brown2Color,
                              width: 10,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Pengumuman Penjual",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: c.brownColor,
                            ),
                          ),
                        ),
                      ),
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
                            "Status Pesanan ",
                            style: TextStyle(
                                color: Color(0xFF855434),
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              {
                                showComingSoonFeatureMsg(context: context);
                              }
                            },
                            child: Row(
                              children: [
                                const Text(
                                  " Riwayat Penjualan",
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              _isLoading
                                  ? SizedBox(
                                      height: mediaH / 10,
                                      child: Center(
                                          child:
                                              LoadingAnimationWidget.waveDots(
                                        size: mediaW / 15,
                                        color: c.greenColor,
                                      )),
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        (_listOnDelivery.isEmpty)
                                            ? WCard_OrderStatus(
                                                context,
                                                0,
                                                "Dikirim",
                                              )
                                            : SizedBox(
                                                height: mediaH / 10,
                                                child: ListView.builder(
                                                  addAutomaticKeepAlives: false,
                                                  addRepaintBoundaries: false,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const AlwaysScrollableScrollPhysics(),
                                                  reverse: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      _listOnDelivery.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    TransactionHistory tr =
                                                        _listOnDelivery[index];
                                                    return WCard_OrderStatus(
                                                      context,
                                                      tr.totalQuantity ?? 0,
                                                      tr.title ?? "Dikirim",
                                                    );
                                                  },
                                                ),
                                                //   addAutomaticKeepAlives: false,
                                                //   addRepaintBoundaries: false,
                                                //   padding: EdgeInsets.symmetric(
                                                //       vertical: mediaW / 28),
                                                //   scrollDirection: Axis.horizontal,
                                                //   shrinkWrap: false,
                                                //   physics:
                                                //       const AlwaysScrollableScrollPhysics(),
                                                //   children: [
                                                //     Row(
                                                //       children: [
                                                //         WCard_OrderStatus(
                                                //             context, 'Perlu Dikirim', '0'),
                                                //         WCard_OrderStatus(
                                                //             context, 'Pembatalan', '0'),
                                                //         WCard_OrderStatus(
                                                //             context, 'Pengembalian', '0'),
                                                //         WCard_OrderStatus(
                                                //             context, 'Penilaian', '0'),
                                                //       ],
                                                //     )
                                                //   ],
                                                // ),
                                              ),
                                        (_listOnPacked.isEmpty)
                                            ? WCard_OrderStatus(
                                                context,
                                                0,
                                                "Perlu Dikirim",
                                              )
                                            : SizedBox(
                                                height: mediaH / 10,
                                                child: ListView.builder(
                                                  addAutomaticKeepAlives: false,
                                                  addRepaintBoundaries: false,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const AlwaysScrollableScrollPhysics(),
                                                  reverse: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      _listOnPacked.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    TransactionHistory tr =
                                                        _listOnPacked[index];
                                                    return WCard_OrderStatus(
                                                      context,
                                                      tr.totalQuantity ?? 0,
                                                      tr.title ??
                                                          "Perlu Dikirim",
                                                    );
                                                  },
                                                ),
                                              ),
                                        (_listCancel.isEmpty)
                                            ? WCard_OrderStatus(
                                                context,
                                                0,
                                                "Pembatalan",
                                              )
                                            : SizedBox(
                                                height: mediaH / 10,
                                                child: ListView.builder(
                                                  addAutomaticKeepAlives: false,
                                                  addRepaintBoundaries: false,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const AlwaysScrollableScrollPhysics(),
                                                  reverse: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: _listCancel.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    TransactionHistory tr =
                                                        _listCancel[index];
                                                    return WCard_OrderStatus(
                                                      context,
                                                      tr.totalQuantity ?? 0,
                                                      tr.title ?? "Dibatalkan",
                                                    );
                                                  },
                                                ),
                                              ),
                                        (_listRating.isEmpty)
                                            ? WCard_OrderStatus(
                                                context,
                                                0,
                                                " Penilaian",
                                              )
                                            : SizedBox(
                                                height: mediaH / 10,
                                                child: ListView.builder(
                                                  addAutomaticKeepAlives: false,
                                                  addRepaintBoundaries: false,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const AlwaysScrollableScrollPhysics(),
                                                  reverse: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: _listRating.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    TransactionHistory tr =
                                                        _listRating[index];
                                                    return WCard_OrderStatus(
                                                      context,
                                                      tr.totalQuantity ?? 0,
                                                      tr.title ?? " Penilaian",
                                                    );
                                                  },
                                                ),
                                              ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    (sessionManager.nStoreName!.isNotEmpty)
                        ? Column(
                            children: [
                              SizedBox(
                                width: mediaW,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    WButton_Store(
                                        context,
                                        'assets/icons/product.svg',
                                        'Produk', () {
                                      Navigator.push(
                                          context,
                                          MyRoute(
                                              builder: (_) =>
                                                  const MyProductScreen()));
                                    }),
                                    const Spacer(),
                                    WButton_Store(
                                        context,
                                        'assets/icons/finance.svg',
                                        'Keuangan', () {
                                      showComingSoonFeatureMsg(
                                          context: context);
                                    }),
                                    const Spacer(),
                                    WButton_Store(
                                        context,
                                        'assets/icons/store_performance.svg',
                                        'Performa Toko', () {
                                      showComingSoonFeatureMsg(
                                          context: context);
                                    }),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  WButton_Store(
                                      context,
                                      'assets/icons/store_promotions.svg',
                                      'Promosi Toko', () {
                                    showComingSoonFeatureMsg(context: context);
                                  }),
                                  const Spacer(),
                                  WButton_Store(
                                      context,
                                      'assets/icons/seller_program.svg',
                                      'Program Penjual', () {
                                    showComingSoonFeatureMsg(context: context);
                                  }),
                                  const Spacer(),
                                  WButton_Store(
                                      context,
                                      'assets/icons/help_center.svg',
                                      'Pusat Bantuan', () {
                                    showComingSoonFeatureMsg(context: context);
                                  }),
                                ],
                              ),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding),
                            child: Center(
                              child: SizedBox(
                                  width: mediaW / 1.5,
                                  child: Text(
                                    'Daftarkan Nama Toko Anda Untuk Mengupload Produk dan Membuka Menu Toko Lainnya',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: c.brownColor),
                                  )),
                            ),
                          )
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
