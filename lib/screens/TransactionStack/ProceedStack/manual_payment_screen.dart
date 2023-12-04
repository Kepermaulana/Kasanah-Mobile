import 'dart:io';
import 'dart:async';

import 'package:date_count_down/date_count_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/class/product_class.dart';
import 'package:kasanah_mobile/core/service/transaction_service.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/core/worker/CurrencyWorker.dart';
import 'package:kasanah_mobile/screens/HomeStack/home_screen.dart';
import 'package:kasanah_mobile/widgets/WAlertDialog.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';
import 'package:kasanah_mobile/widgets/WNavigationBar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ManualPaymentScreen extends StatefulWidget {
  ManualPaymentScreen(
      {super.key,
      required this.transactionId,
      required this.createdAt,
      required this.total});
  String? transactionId;
  String? createdAt;
  int? total;

  @override
  State<ManualPaymentScreen> createState() => _ManualPaymentScreenState();
}

class _ManualPaymentScreenState extends State<ManualPaymentScreen> {
  File? image;
  bool _isLoading = false;
  bool _isOnWillPop = false;
  String namaRekening = "Kantin Kasanah";
  String nomorRekening = "7777772982";
  int total = 1;

  // Future getTotal() async {
  //   print(widget.transactionId);
  //   await getManualTransactionTotalPayment(widget.transactionId!).then(
  //     (value) {
  //       total = value;
  //     },
  //   ).then((value) => setState(() {
  //         _isLoading = false;
  //       }));
  // }

  Future getImageCamera() async {
    var takeImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (takeImage != null) {
      setState(() {
        image = File(takeImage.path);
      });
    }
  }

  Future getImageGallery() async {
    var takeImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (takeImage != null) {
      setState(() {
        image = File(takeImage.path);
      });
    }
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // scrollable: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Pilih Media Untuk Upload Bukti Transfer'),
            content: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 5,
                child: Column(
                  children: [
                    const Spacer(),
                    WButton_Filled(() {
                      getImageGallery();
                      Navigator.pop(context);
                    },
                        Text(
                          'Galeri',
                          style: TextStyle(color: c.whiteColor),
                        ),
                        color: c.brownColor,
                        context,
                        height: 14),
                    const SizedBox(
                      height: 10,
                    ),
                    WButton_Filled(() {
                      getImageCamera();
                      Navigator.pop(context);
                    },
                        color: c.brownColor,
                        Text(
                          'Kamera',
                          style: TextStyle(color: c.whiteColor),
                        ),
                        context,
                        height: 14),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future _uploadTransferProof() async {
    setState(() {
      _isLoading = true;
    });
    String fileName = image!.path.split("/").last;
    Map res = await sendTransferProofImage(
        widget.transactionId!, image!.path, fileName);
    if (res["res"] == "ok") {
      if (mounted) {
        WDialog_TextAlert(context, "Transaksi berhasil",
            "Pembayaran kamu akan segera kami verifikasi");
      }
      onWillPop();
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return WDialog_TextAlert(context, "Terjadi Kesalahan",
                "mohon coba lagi untuk melanjutkan transaksi");
          }).then((value) => onWillPop());
    }
  }

  Future onWillPop() async {
    await Navigator.pushNamedAndRemoveUntil(
      context,
      "/home",
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    (() async {
      // await getTotal();
    })();
  }

  @override
  Widget build(BuildContext context) {
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => await onWillPop(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: c.whiteColor,
          leading: IconButton(
              onPressed: () async {
                await onWillPop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: c.blackColor,
              )),
          title: Text(
            'Pembayaran Manual',
            style: TextStyle(color: c.blackColor),
          ),
        ),
        body: _isLoading
            ? Center(
                child: LoadingAnimationWidget.waveDots(
                  size: mediaW / 15,
                color: c.greenColor,
              ))
            : SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding, vertical: defaultPadding),
                    child: Center(
                        child: Column(children: [
                      SizedBox(
                        width: mediaW,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "*Mohon untuk bayar sesuai nominal dan rekening yang tertera dibawah ini!",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Total Pembayaran:",
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              formatToRp(widget.total ?? total),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "BSI",
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              "Nama Rekening: $namaRekening",
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "No. Rekening: ",
                                  style: TextStyle(fontSize: 13),
                                ),
                                SelectableText(
                                  nomorRekening,
                                  style: TextStyle(
                                      color: c.blackColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                    onTap: () {
                                      // ignore: prefer_const_constructors
                                      final data =
                                          ClipboardData(text: nomorRekening);
                                      Clipboard.setData(data);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text("Copied"),
                                      ));
                                    },
                                    child: const Icon(
                                      Icons.copy,
                                      size: 18,
                                    )),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  "Copy",
                                  style: TextStyle(
                                      color: c.blackColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            // CountDownText(
                            //   due: (DateTime.parse(widget.createdAt ?? "")
                            //       .add(const Duration(days: 1))),
                            //   finishedText: "",
                            //   showLabel: true,
                            //   longDateName: true,
                            //   daysTextLong: 'hari',
                            //   hoursTextLong: " jam ",
                            //   minutesTextLong: " menit ",
                            //   secondsTextLong: " detik ",
                            //   style: const TextStyle(
                            //       fontWeight: FontWeight.w600,
                            //       fontFamily: "Poppins",
                            //       fontSize: 10,
                            //       color: Colors.red),
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      image != null
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(image!.path),
                                      fit: BoxFit.cover,
                                      width: mediaW,
                                      height: 300,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                WButton_Filled(() {
                                  myAlert();
                                },
                                    Text(
                                      'Upload Bukti Transfer',
                                      style: TextStyle(color: c.whiteColor),
                                    ),
                                    context,
                                    color: c.brownColor,
                                    height: 14),
                                const SizedBox(
                                  height: 10,
                                ),
                                WButton_Filled(() async {
                                  await _uploadTransferProof();
                                },
                                    Text('Kirim Bukti Transfer',
                                        style: TextStyle(color: c.whiteColor)),
                                    context,
                                    height: 14,
                                    color: c.orangeColor),
                              ],
                            )
                          : Column(
                              children: [
                                Container(
                                    height: 300,
                                    width: mediaW,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all()),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "No Image",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: c.blackColor,
                                          ),
                                        ),
                                      ],
                                    )),
                                SizedBox(height: mediaH / 30),
                                WButton_Filled(() {
                                  myAlert();
                                },
                                    color: c.brownColor,
                                    Text(
                                      'Upload Bukti Transfer',
                                      style: TextStyle(color: c.whiteColor),
                                    ),
                                    context,
                                    height: 14),
                              ],
                            ),
                    ])),
                  ),
                ),
              ),
      ),
    );
  }
}
