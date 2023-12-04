import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/service/product_service.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/screens/TransactionStack/cart_screen.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';
import 'package:kasanah_mobile/widgets/WNotification.dart';
import 'package:kasanah_mobile/widgets/WSearchBar.dart';
import 'package:kasanah_mobile/widgets/WTopAuth.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _pressedType = "ALL";
  bool _isNotifyCart = false;
  int _cartCount = 0;
  Future handleUserCartCount() async {
    Map res = await countUserCartItems(
        sessionManager.nToken!, sessionManager.nUserId!);
    switch (res["res"]) {
      case "ok":
        if (mounted) {
          setState(
            () {
              _cartCount = res["count"] ?? 0;
              if (_cartCount == 0) {
                _isNotifyCart = false;
                return;
              } else {
                _isNotifyCart = true;
                return;
              }
            },
          );
        }

        break;
    }
  }

  @override
  void initState() {
    super.initState();
    (() async {
      await handleUserCartCount();
    })();
  }

  @override
  Widget build(BuildContext context) {
    (() async => await handleUserCartCount())();
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: c.whiteColor,
        automaticallyImplyLeading: false,
        elevation: 0.5,
        toolbarHeight: mediaH / 6.5,
        flexibleSpace: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: mediaW / defaultPadding * 0.6,
                    right: mediaW / defaultPadding * 0.6,
                    top: mediaH / defaultPadding / 3),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: c.blackColor,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Notifikasi',
                      style: TextStyle(
                          color: c.blackColor,
                          fontSize: 19,
                          fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    WActionButton(const Icon(Icons.shopping_cart_outlined),
                        c.greenColor, mediaW / 7, 50, context,
                        qty: _cartCount,
                        isNotify: _isNotifyCart, onPressed: () {
                      Navigator.push(context,
                          MyRoute(builder: (context) => const CartScreen()));
                    })
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() {
                        if (_pressedType == "P") {
                          _pressedType = "ALL";
                          return;
                        }
                        _pressedType = "P";
                      }),
                      child: Chip(
                        elevation: (_pressedType == "P") ? 10 : 2,
                        backgroundColor:
                            (_pressedType == "P") ? c.greenColor : c.whiteColor,
                        shadowColor:
                            (_pressedType == "P") ? c.whiteColor : c.blackColor,
                        label: Text(
                          'PENDANAAN',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: "Poppins",
                            color: (_pressedType == "P")
                                ? c.whiteColor
                                : c.blackColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: mediaW / 28,
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        if (_pressedType == "T") {
                          _pressedType = "ALL";
                          return;
                        }
                        _pressedType = "T";
                      }),
                      child: Chip(
                        elevation: (_pressedType == "T") ? 10 : 2,
                        backgroundColor:
                            (_pressedType == "T") ? c.greenColor : c.whiteColor,
                        shadowColor:
                            (_pressedType == "T") ? c.whiteColor : c.blackColor,
                        label: Text(
                          'TRANSAKSI',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: "Poppins",
                            color: (_pressedType == "T")
                                ? c.whiteColor
                                : c.blackColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(mediaW / 42),
        child: Column(
          children: [
            // WNotification_Default(
            //     context, "Title", "This is a loooooong body", "T", "12.11"),
            Center(child: const Text("notifikasi kosong"))
          ],
        ),
      )),
    );
  }
}
