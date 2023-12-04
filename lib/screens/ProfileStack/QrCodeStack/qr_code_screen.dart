import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/screens/ProfileStack/QrCodeStack/qr_history_screen.dart';
import 'package:kasanah_mobile/screens/ProfileStack/QrCodeStack/scan_qr_screen.dart';
import 'package:kasanah_mobile/screens/ProfileStack/profile_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({super.key});

  @override
  State<QrCodeScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrCodeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: c.brownColor,
        title: Text(
          'Kode QR',
          style: TextStyle(
            color: c.whiteColor,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: c.whiteColor,
            )),
        bottom: TabBar(
            indicatorColor: c.whiteColor,
            indicatorWeight: 3,
            controller: _controller,
            tabs: const [
              Tab(
                text: "Kode Saya",
              ),
              Tab(
                text: "Pindai Kode",
              ),
              Tab(
                text: "History QR",
              )
            ]),
      ),
      body: TabBarView(
        controller: _controller,
        children: const [
          QrCode(),
          QRViewExample(),
          QRHistoryScreen()
        ],
      ),
    );
  }
}

class QrCode extends StatefulWidget {
  const QrCode({super.key});

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  @override
  Widget build(BuildContext context) {
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: mediaH / 4,
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                // color: c.brownColor,
              ),
              width: mediaW / 1,
              height: mediaH / 4,
              // child: QrImage(
              //     version: 6,
              //     size: mediaW / 2,
              //     errorCorrectionLevel: QrErrorCorrectLevel.M,
              //     data:
              //         "*Penjual: ${sessionManager.nStoreName}#\n~${sessionManager.nUserId}-"),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.all(35),
                  child: Text(
                    "Kode QR Anda bersifat privat. Jika anda membagikannya kepada orang lain, mereka dapat memindainya dengan kamera Scan ",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
