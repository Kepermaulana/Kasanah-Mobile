import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/api/api.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/class/product_class.dart';
import 'package:kasanah_mobile/core/service/transaction_service.dart';
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/worker/CurrencyWorker.dart';
import 'package:kasanah_mobile/screens/ProfileStack/QrCodeStack/qr_code_screen.dart';
import 'package:kasanah_mobile/widgets/WAlertDialog.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';
import 'package:kasanah_mobile/widgets/WForm.dart';
import 'package:http/http.dart' as http;
import 'package:kasanah_mobile/widgets/WNavigationBar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class DataQrScreen extends StatefulWidget {
  DataQrScreen({super.key, required this.resultCode});
  String? resultCode;

  @override
  State<DataQrScreen> createState() => _DataQrScreenState();
}

class _DataQrScreenState extends State<DataQrScreen> {
  bool _isLoading = false;
  QRViewController? controller;
  bool _isDisableLanjutBtn = true;

  TextEditingController nominal = TextEditingController();

  String nStoreName = "";
  String nStoreId = "";
  String nUserId = "";
  String nQrTypeId = "";
  String? payLaterType;
  String? value;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  getStoreName(String nStoreName) {
    var str = widget.resultCode;
    const start = "*";
    const end = "#";

    final startIndex = str!.indexOf(start);
    final endIndex = str.indexOf(end, startIndex + start.length);

    String nStoreName = str.substring(startIndex + start.length, endIndex);

    return nStoreName; // brown fox jumps
  }

  getStoreId(String nStoreId) {
    var str = widget.resultCode;
    const start = "~";
    const end = "-";

    final startIndex = str!.indexOf(start);
    final endIndex = str.indexOf(end, startIndex + start.length);

    String nStoreId = str.substring(startIndex + start.length, endIndex);

    return nStoreId; // brown fox jumps
  }

  List<Wallet> userWallet = [];
  String? walletUser;
  int? plainWallet;

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
      plainWallet = wallet.saldo;
      print(walletUser);
    });
  }

  getUserId(String nUserId) {
    var str1 = widget.resultCode;
    const start1 = "~";
    const end1 = "-";

    final start1Index = str1!.indexOf(start1);
    final end1Index = str1.indexOf(end1, start1Index + start1.length);

    String nUserId = (str1.substring(start1Index + start1.length, end1Index));

    return nUserId;
  }

  Widget buildResult() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: c.whiteColor),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(widget.resultCode != null
                  ? '${widget.resultCode}'
                  : 'Hasil Scan QR'),
            ),
          ],
        ),
      );

  Future<Map> _proceed() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String? qToken = sessionManager.nToken;
      String? qUserId = sessionManager.nUserId;
      List<Wallet> qrList = [];
      String? qrPaymentId;
      List<Wallet> storeWallet = [];
      int? plainStoreWallet;
      print('a');
      var body = jsonEncode({
        "nominal": int.parse(nominal.text),
        "seller": [getUserId(nUserId)],
        "type": [categoryValue]
      });
      var res = await http.post(
        Uri.parse('$kMgApi/QR Payment'),
        body: body,
        headers: {
          'Authorization': 'Bearer $qToken',
        },
      );
      int s = res.statusCode;
      switch (s) {
        case 201:
          FocusScope.of(context).unfocus();
          var b = jsonDecode(res.body);
          //gettransactionId
          Uri url = Uri.parse('$kMgApi/QR Payment?payer=$qUserId');
          var qrRes = await http.get(url);
          var qrData = jsonDecode(qrRes.body);
          for (var e in qrData) {
            qrList.add(Wallet(type: e["_id"]));
          }
          Wallet qrLastData = qrList.last;
          setState(() {
            qrPaymentId = qrLastData.type;
          });
          //debit
          var _debit = plainWallet! - int.parse(nominal.text); //err
          Map postPayer =
              await postSaldo(_debit, int.parse(nominal.text), qrPaymentId!);
          //get store wallet
          Uri urlStore =
              Uri.parse('$kMgApi/SaldoPay?user=${getStoreId(nStoreId)}');
          final setor = await http.get(urlStore);
          var dataSetor = jsonDecode(setor.body);
          print(dataSetor);
          for (var e in dataSetor) {
            storeWallet.add(Wallet(saldo: e["saldo"]));
          }
          Wallet wallets = storeWallet.last;
          setState(() {
            plainStoreWallet = wallets.saldo;
          });
          //kredit
          var _kredit = plainStoreWallet! + int.parse(nominal.text);
          Map postSeller = await postSaldoStore(_kredit,
              int.parse(nominal.text), qrPaymentId!, getStoreId(nStoreId));
          setState(() {
            _isLoading = false;
          });
          setState(() {
            Navigator.push(
                context,
                MyRoute(
                  builder: (_) => const WNavigationBar(),
                ));
            showDialog(
              context: context,
              builder: (context) {
                return WDialog_TextAlert(context, "Pembayaran Berhasil", "");
              },
            );
          });
          // bool isPatchDone = await _signupPatchToDefault(b["user"]["_id"]);
          if (b) {
            return {
              "res": "ok",
            };
          }
          return {
            "res": "api-err",
          };
        case 400:
          return {
            "res": "signup-err",
          };
      }
    } catch (e) {
      return {
        "res": "service-error",
        "data": {"error": e}
      };
    }

    return {"res": "api-error"};
  }

  // Future getQRTransactionType() async {
  //   try {
  //     String cToken = sessionManager.nToken!;
  //     Uri url = Uri.parse(
  //       "$kMgApi/QRTransactionType/?\$select[0]=_id&\$select[1]=type",
  //     );
  //     var res = await http.get(
  //       url,
  //       headers: {"Authorization": 'Bearer $cToken'},
  //     );
  //     var b = jsonDecode(res.body);
  //     print(b);
  //     // if (b.isNotEmpty) {
  //     //   return {"res": "ok", "data": b};
  //     // } else {
  //     //   return {
  //     //     "res": "empty",
  //     //   };
  //     // }
  //     // ;
  //   } catch (e) {
  //     return {
  //       "res": "service-error",
  //       "data": {"error": e}
  //     };
  //   }
  // }

  List<dynamic> _dataProvince = [];
  var categoryValue;

  void getProvince() async {
    Uri url = Uri.parse(
        '$kMgApi/QRTransactionType/?\$select[0]=_id&\$select[1]=type');
    final respose = await http.get(url);
    var listData = jsonDecode(respose.body);
    setState(() {
      _dataProvince = listData;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProvince();
    getUserWallet();
  }

  @override
  Widget build(BuildContext context) {
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: c.whiteColor,
        title: Text(
          'Pembayaran',
          style: TextStyle(
            color: c.blackColor,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MyRoute(
                    builder: (_) => const WNavigationBar(),
                  ));
            },
            icon: Icon(
              Icons.arrow_back,
              color: c.blackColor,
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${getStoreName(nStoreName)}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: mediaH / 40,
              ),
              (walletUser == null)
                  ? Text(
                      'Saldo Kasanah Pay = Rp0',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: c.brownColor),
                    )
                  : Text(
                      'Saldo Kasanah Pay = $walletUser',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: c.brownColor),
                    ),
              WForm_Default('Nominal', 'Masukkan Nominal', nominal,
                  context: context, keyType: TextInputType.number),
              SizedBox(
                height: mediaH / 30,
              ),
              const Text(
                "Tipe Pembayaran",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              DropdownButton(
                hint: Text("Pilih Tipe Pembayaran"),
                value: categoryValue,
                items: _dataProvince.map((item) {
                  return DropdownMenuItem(
                    child: Text(item['type']),
                    value: item['_id'],
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    categoryValue = value;
                  });
                },
              ),
              SizedBox(height: mediaH / 20),
              (walletUser == null)
                  ? Container(
                      child: Text(
                        '*Saldo Anda Kosong, Tidak Dapat Melakukan Transaksi',
                        style: TextStyle(color: c.redColor),
                      ),
                    )
                  : WButton_Filled(
                      () {
                        _proceed();
                      },
                      _isLoading
                          ? LoadingAnimationWidget.waveDots(
                            size: mediaW / 15,
                              color: c.greenColor,
                            )
                          : Text("Bayar",
                              style: TextStyle(color: c.whiteColor)),
                      context,
                      isDisabled: _isLoading,
                      color: c.brownColor,
                      height: 14,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
