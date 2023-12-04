import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Colors.dart';
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/screens/ProfileStack/ProfileChangeStack/change_password_screen.dart';
import 'package:kasanah_mobile/screens/ProfileStack/profile_screen.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';

class ProductDetailTransactionScreen extends StatefulWidget {
  ProductDetailTransactionScreen({
    super.key,
    this.transactionId,
    this.createdAt,
    this.total,
    this.paymentStatus,
    this.noInvoice,
    this.tanggalPembelian,
    this.jamPembelian,
    this.namaPenerima,
  });

  String? transactionId;
  String? createdAt;
  String? paymentStatus;
  String? noInvoice;
  String? tanggalPembelian;
  String? jamPembelian;
  String? namaPenerima;
  int? total;

  @override
  State<ProductDetailTransactionScreen> createState() =>
      ProductDetailTransactionScreenState();
}

class ProductDetailTransactionScreenState
    extends State<ProductDetailTransactionScreen> {
  File? image;

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
            title: const Text('Pilih Media Untuk Mengubah Foto Profil'),
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
                        context,
                        height: 14),
                    const SizedBox(
                      height: 10,
                    ),
                    WButton_Filled(() {
                      getImageCamera();
                      Navigator.pop(context);
                    },
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

  @override
  void initState() {
    initializeDateFormatting();
    print(sessionManager.nDateBirth);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: c.whiteColor,
          title: Text(
            ' Transaksi',
            style: TextStyle(
              color: c.blackColor,
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: c.blackColor,
              )),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'DETAIL TRANSAKSI',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                      width: mediaW / 2.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text('Status'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text('Nama Pembeli'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text('Tanggal Pembelian'),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(vertical: 15),
                          //   child: Text('NO INVOICE'),
                          // ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: mediaW / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              children: [
                                Text('${widget.paymentStatus}',
                                    overflow: TextOverflow.ellipsis),
                                Divider(
                                  thickness: 1,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              children: [
                                // Text('${sessionManager.nDateBirth}'),
                                Text('${widget.namaPenerima}',
                                    overflow: TextOverflow.ellipsis),
                                // Text(DateFormat.yMMMMd('id_ID').format(
                                //     DateTime.parse(
                                //             sessionManager.nDateBirth ?? "")
                                //         .toLocal()))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              children: [
                                Text(
                                  '${widget.tanggalPembelian},',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  '${widget.jamPembelian} WIB',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 15),
                          //   child: Row(
                          //     children: [
                          //       Text('${widget.noInvoice}'),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // ListMenu(
              //     icon: const Icon(Icons.lock),
              //     onPress: () {
              //       Navigator.push(
              //           context,
              //           MyRoute(
              //               builder: (context) =>
              //                   const ChangePasswordScreen()));
              //     },
              //     title: 'Ubah Password'),
            ]),
          ),
        ));
  }
}
