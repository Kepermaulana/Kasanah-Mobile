// ignore_for_file: avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_count_down/date_count_down.dart';
import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/style/Colors.dart';
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:intl/intl.dart';
import 'package:kasanah_mobile/core/worker/CurrencyWorker.dart';
import 'package:kasanah_mobile/core/worker/StringWorker.dart';
import 'package:kasanah_mobile/screens/TransactionHistoryStack/transaction_detail_screen.dart';
import 'package:kasanah_mobile/screens/TransactionStack/ProceedStack/manual_payment_screen.dart';
import 'package:kasanah_mobile/screens/TransactionStack/product_detail_screen.dart';

Widget WCard_Financial(
    {required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    double? width}) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      height: mediaH / 12,
      child: Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(mediaW / 32),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Card(
                  elevation: 1.5,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(mediaW / 100),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF855434),
                    size: mediaW / 12,
                  )),
              SizedBox(
                width: mediaW / 68,
              ),
              Text(
                title,
                style: TextStyle(
                    fontSize: mediaW / 24, fontWeight: FontWeight.w300),
              )
            ]),
          )),
    ),
  );
}

GestureDetector WCard_ProductScrolled(VoidCallback onTap, BuildContext context,
    String title, int price, String imageNetworkUrl) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;

  String _price = formatToRp(price);
  return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Container(
            width: mediaW / 2.5,
            height: mediaH / 3.7,
            decoration: BoxDecoration(
              color: c.whiteColor,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(40, 0, 0, 0),
                  blurRadius: 3.0,
                  spreadRadius: 2.0,
                  offset: Offset(0.0, 1.0),
                )
              ],
            ),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shadowColor: c.blackColor,
              elevation: 0,
              color: c.whiteColor,
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(defaultPadding / 2.5)),
              ),
              // elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6)),
                      child: CachedNetworkImage(
                        imageUrl: imageNetworkUrl,
                        fit: BoxFit.cover,
                        height: mediaH / 6.5,
                        placeholder: (context, url) => SizedBox(
                          height: mediaH / 2,
                          child: Center(
                              child: CircularProgressIndicator(
                            color: c.greenColor,
                          )),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    const Spacer(),
                    Text(_price,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: mediaW / 33),
                    )
                  ],
                ),
              ),
            )),
      ));
}

GestureDetector WCard_Product(VoidCallback onTap, BuildContext context,
    String title, int price, String imageNetworkUrl) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  String _price = formatToRp(price);
  return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Container(
            width: mediaW / 2.3,
            height: mediaH / 3.6,
            decoration: BoxDecoration(
              color: c.whiteColor,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(40, 0, 0, 0),
                  blurRadius: 3.0,
                  spreadRadius: 2.0,
                  offset: Offset(0.0, 1.0),
                )
              ],
            ),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shadowColor: c.blackColor,
              elevation: 0,
              color: c.whiteColor,
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(defaultPadding / 2.5)),
              ),
              // elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                child: Column(
                  children: [
                    imageNetworkUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6)),
                            child: CachedNetworkImage(
                              imageUrl: imageNetworkUrl,
                              fit: BoxFit.cover,
                              height: mediaH / 6.5,
                              placeholder: (context, url) => SizedBox(
                                height: mediaH / 2,
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: c.greenColor,
                                )),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          )
                        : SizedBox(
                            width: mediaW,
                            height: mediaH / 5.5,
                          ),
                    const Spacer(),
                    Text(_price,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: mediaW / 33),
                    )
                  ],
                ),
              ),
            )),
      ));
}

GestureDetector WCard_CategoryScrolled(
    BuildContext context, String title, String imageNetworkUrl,
    {VoidCallback? onTap}) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;

  return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Container(
            width: mediaW / 2.5,
            height: mediaH / 3.7,
            decoration: BoxDecoration(
              color: c.whiteColor,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(40, 0, 0, 0),
                  blurRadius: 3.0,
                  spreadRadius: 2.0,
                  offset: Offset(0.0, 1.0),
                )
              ],
            ),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shadowColor: c.blackColor,
              elevation: 0,
              color: c.whiteColor,
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(defaultPadding / 2.5)),
              ),
              // elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                child: Column(
                  children: [
                    ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6)),
                        child: Image.network(
                          fit: BoxFit.cover,
                          imageNetworkUrl,
                          height: mediaH / 6.5,
                        )),
                    const Spacer(),
                    const Spacer(),
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: mediaW / 33),
                    )
                  ],
                ),
              ),
            )),
      ));
}

GestureDetector WCard_ProductCategory(
    BuildContext context, String title, String imageNetworkUrl,
    {VoidCallback? onTap}) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Container(
            width: mediaW / 2.5,
            height: mediaH / 6,
            decoration: BoxDecoration(
              color: c.whiteColor,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: c.greyColor.withOpacity(0.5),
                  blurRadius: 3.0,
                  spreadRadius: 2.0,
                  offset: const Offset(0.0, 1.0),
                )
              ],
            ),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shadowColor: c.blackColor,
              elevation: 0,
              color: c.whiteColor,
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(defaultPadding / 2.5)),
              ),
              // elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6)),
                      child: CachedNetworkImage(
                        imageUrl: imageNetworkUrl,
                        fit: BoxFit.cover,
                        height: mediaH / 8,
                        placeholder: (context, url) => SizedBox(
                          height: mediaH / 2,
                          child: Center(
                              child: CircularProgressIndicator(
                            color: c.greenColor,
                          )),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      overflow: TextOverflow.clip,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: mediaW / 26, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            )),
      ));
}

Widget WCard_Cart(BuildContext context, bool isTersedia, String productName,
    int quantity, int price, String imageUrl,
    {VoidCallback? onMinus,
    VoidCallback? onAdd,
    VoidCallback? onRemove,
    bool? isChecked,
    required VoidCallback onChanged}) {
  return Column(children: [
    Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              checkColor: Colors.white,
              activeColor: c.brownColor,
              value: isTersedia ? isChecked ?? false : false,
              onChanged: (bool? value) {
                onChanged();
              },
            ),
            Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0.5,
              margin: const EdgeInsets.all(10),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width / defaultPadding * 4,
                height:
                    MediaQuery.of(context).size.height / defaultPadding * 1.9,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 180,
                    child: Text(
                      productName,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 12 * 1.2,
                          fontFamily: 'Poppins',
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    formatToRp(price * quantity),
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                      fontSize: 12 * 1.1,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: defaultPadding * 1.7),
          child: Row(
            children: [
              IconButton(
                  onPressed: onRemove,
                  icon: Icon(
                    Icons.delete,
                    color: isTersedia
                        ? const Color.fromARGB(255, 151, 151, 151)
                        : const Color.fromARGB(255, 186, 74, 59),
                  )),
              isTersedia
                  ? Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(
                            color: const Color.fromARGB(255, 151, 151, 151),
                            width: 0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      height: MediaQuery.of(context).size.height /
                          defaultPadding /
                          1.3,
                      width: MediaQuery.of(context).size.width /
                          defaultPadding *
                          5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: onMinus ?? () {},
                            child: Icon(
                              Icons.remove,
                              color: greenColor,
                            ),
                          ),
                          Text(quantity.toString()),
                          GestureDetector(
                            onTap: onAdd ?? () {},
                            child: Icon(
                              Icons.add,
                              color: greenColor,
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 12),
                      decoration: BoxDecoration(
                          color: blackColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Text(
                        "TIDAK TERSEDIA",
                        style: TextStyle(
                            fontFamily: 'Poppin',
                            color: Color.fromARGB(255, 186, 74, 59),
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                    )
            ],
          ),
        ),
      ],
    ),
    Divider(
      color: greenColor,
      height: defaultPadding,
      thickness: 1,
      endIndent: 0,
    )
  ]);
}

Container WCheckedProductList(BuildContext context, String imageUrl,
    String productName, int qty, int subtotal, int price) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0.5,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width / defaultPadding * 4,
            height: MediaQuery.of(context).size.height / defaultPadding * 1.9,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 220,
                child: Text(
                  productName,
                  style: const TextStyle(
                      fontSize: 14, overflow: TextOverflow.ellipsis),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                '${qty.toString()} Barang x ${formatToRp(price)}',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                formatToRp(subtotal),
                style: const TextStyle(fontSize: 13),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Card WHistoryCard(
    BuildContext context,
    String namaPenerima,
    String phoneNumber,
    String transactionId,
    String noInvoice,
    String tanggalPembelian,
    String jamPembelian,
    int overallQuantity,
    int total,
    String paymentStatus,
    String orderPickStatus,
    String createdAt,
    List<dynamic> detailList) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  DateTime countDown =
      DateTime.parse(createdAt).add(const Duration(days: 1)); // -1
  return Card(
    elevation: 3,
    child: Container(
      padding: EdgeInsets.symmetric(
          horizontal: defaultPadding / 2, vertical: mediaH / 100),
      width: mediaW,
      height: mediaH / 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: c.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 15,
                    ),
                  ),
                  Text(
                    '$tanggalPembelian $jamPembelian WIB',
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 8,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    paymentStatus,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 8,
                      color: Color.fromRGBO(132, 142, 13, 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      noInvoice,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  paymentStatus == "NEED_PAYMENT"
                      ? CountDownText(
                          due: countDown,
                          finishedText: "",
                          showLabel: true,
                          longDateName: true,
                          daysTextLong: 'hari',
                          hoursTextLong: " jam ",
                          minutesTextLong: " menit ",
                          secondsTextLong: " detik ",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: "Poppins",
                              fontSize: 10,
                              color: c.redColor),
                        )
                      : const Text('')
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${overallQuantity.toString()} Barang',
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 8,
                  ),
                ),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Belanja',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 8,
                        ),
                      ),
                      Text(
                        formatToRp(total),
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  (paymentStatus == 'PENDING')
                      ? SizedBox(
                          width: 90,
                          height: 26,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: c.brownColor,
                            ),
                            child: const Text(
                              'Bayar',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 8,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MyRoute(
                                      builder: (_) => ManualPaymentScreen(
                                            transactionId: transactionId,
                                            createdAt: createdAt,
                                            total: total,
                                          )));
                            },
                          ),
                        )
                      : Container(),
                  SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: 90,
                    height: 26,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: c.brownColor,
                      ),
                      child: const Text(
                        'Detail',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 8,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MyRoute(
                                builder: (_) => ProductDetailTransactionScreen(
                                      transactionId: transactionId,
                                      createdAt: createdAt,
                                      paymentStatus: paymentStatus,
                                      tanggalPembelian: tanggalPembelian,
                                      jamPembelian: jamPembelian,
                                      noInvoice: noInvoice,
                                      namaPenerima: namaPenerima,
                                    )));
                      },
                    ),
                  )

                  //     : paymentStatus == 'NEED_PAYMENT' &&
                  //             (countDown.compareTo(DateTime.now()) > 0)
                  //         ? SizedBox(
                  //             width: 86,
                  //             height: 24,
                  //             child: ElevatedButton(
                  //               style: ElevatedButton.styleFrom(
                  //                 backgroundColor: greenColor,
                  //               ),
                  //               child: const Text(
                  //                 'Bayar',
                  //                 style: TextStyle(
                  //                   fontWeight: FontWeight.w500,
                  //                   fontSize: 8,
                  //                 ),
                  //               ),
                  //               onPressed: () {
                  //                 // _launchPayment(data.linkId);
                  //               },
                  //             ),
                  //           )
                  //         : paymentStatus == 'CANCELLED'
                  //             ? Container()
                  //             : SizedBox(
                  //                 width: 86,
                  //                 height: 24,
                  //                 child: ElevatedButton(
                  //                   style: ElevatedButton.styleFrom(
                  //                     backgroundColor: greenColor,
                  //                   ),
                  //                   child: const Text(
                  //                     'Detail',
                  //                     style: TextStyle(
                  //                       fontWeight: FontWeight.w500,
                  //                       fontSize: 8,
                  //                     ),
                  //                   ),
                  //                   onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MyRoute(
                  //         builder: (_) =>
                  //             TransactionDetailScreen(
                  //               namaPenerima: namaPenerima,
                  //               phoneNumber: phoneNumber,
                  //               total: total,
                  //               overallQuantity:
                  //                   overallQuantity,
                  //               noInvoice: noInvoice,
                  //               tanggalPembelian:
                  //                   tanggalPembelian,
                  //               jamPembelian: jamPembelian,
                  //               paymentStatus:
                  //                   paymentStatus,
                  //               orderPickStatus:
                  //                   orderPickStatus,
                  //               detailList: detailList,
                  //             )));
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Card WHistoryQR(
    BuildContext context,
    String namaPenjual,
    String tanggalPembelian,
    String jamPembelian,
    String nominal,
    String pembayaran,
    String tipePembayaran) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  // DateTime countDown =
  //     DateTime.parse(createdAt).add(const Duration(days: 1)); // -1
  return Card(
    elevation: 3,
    child: Container(
      padding: EdgeInsets.symmetric(
          horizontal: defaultPadding / 2, vertical: mediaH / 100),
      width: mediaW,
      height: mediaH / 9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: c.whiteColor,
      ),
      child: Row(
        children: [
          Icon(
            Icons.qr_code,
            size: mediaH / 11,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: mediaW / 1.5,
                child: Row(
                  children: [
                    Text(
                      "$tanggalPembelian $jamPembelian WIB",
                      style: TextStyle(fontSize: mediaW / 40),
                    ),
                    Spacer(),
                    Text(
                      "$pembayaran",
                      style: TextStyle(fontSize: mediaW / 40),
                    ),
                  ],
                ),
              ),
              Text(
                "$namaPenjual",
                style: TextStyle(fontSize: mediaW / 33),
              ),
              Text(
                "Tipe Pembayaran: $tipePembayaran",
                style: TextStyle(fontSize: mediaW / 33),
              ),
              Text(
                "Nominal: $nominal",
                style: TextStyle(fontSize: mediaW / 33),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget WCard_OrderStatus(
  BuildContext context,
  int overallQuantity,
  String title,
) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Container(
      padding: const EdgeInsets.only(bottom: 6),
      height: mediaH / 10,
      width: mediaW / 4.6,
      decoration: BoxDecoration(
        color: c.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(105, 158, 158, 158),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${overallQuantity.toString()}',
              style: TextStyle(
                  fontSize: 25,
                  color: c.brownColor,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 10, color: c.brownColor),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget WCard_MyOrder(
    BuildContext context, String title, Icon icon, VoidCallback onTap) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        padding: const EdgeInsets.only(bottom: 6),
        height: mediaH / 10,
        width: mediaW / 4.6,
        decoration: BoxDecoration(
          color: c.whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(105, 158, 158, 158),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              // Text(
              //   total,
              //   style: TextStyle(fontSize: 25, color: c.brownColor, fontWeight: FontWeight.w500),
              // ),
              Text(
                title,
                style: TextStyle(fontSize: 10, color: c.brownColor),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget WCard_MyProduct(
    BuildContext context,
    String imageUrl,
    String title,
    String price,
    String stock,
    VoidCallback editOnPress,
    VoidCallback archiveOnPress) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return Card(
    elevation: 0,
    child: Container(
      width: mediaW,
      child: Column(
        children: [
          Row(
            children: [
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 0.5,
                margin: const EdgeInsets.all(10),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width / defaultPadding * 4,
                  height:
                      MediaQuery.of(context).size.height / defaultPadding * 1.9,
                ),
              ),
              SizedBox(
                width: mediaW / 18,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Rp $price',
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 15),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Stock"),
                          SizedBox(
                            width: 30,
                          ),
                          // Text("Terjual"),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            stock,
                            style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                          // Text(sold),
                        ],
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    height: 30,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c.whiteColor,
                        ),
                        child: Text(
                          'Arsipkan',
                          style: TextStyle(color: c.brownColor),
                        ),
                        onPressed: archiveOnPress),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    height: 30,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c.whiteColor,
                        ),
                        child: Text(
                          'Edit',
                          style: TextStyle(color: c.brownColor),
                        ),
                        onPressed: editOnPress),
                  ),
                ),
              ),
              // Container(
              //   alignment: Alignment.center,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: SizedBox(
              //       width: 100,
              //       height: 30,
              //       child: ElevatedButton(
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: c.whiteColor,
              //           ),
              //           child: Text(
              //             'Ubah',
              //             style: TextStyle(color: c.brownColor),
              //           ),
              //           onPressed: () {}),
              //     ),
              //   ),
              // ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          const Divider(
            thickness: 2,
          ),
        ],
      ),
    ),
  );
}

Widget WCard_MyProductArchived(
    BuildContext context,
    String imageUrl,
    String title,
    String price,
    String stock,
    VoidCallback editOnPress,
    VoidCallback publishOnPress) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return Card(
    elevation: 0,
    child: Container(
      width: mediaW,
      child: Column(
        children: [
          Row(
            children: [
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 0.5,
                margin: const EdgeInsets.all(10),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width / defaultPadding * 4,
                  height:
                      MediaQuery.of(context).size.height / defaultPadding * 1.9,
                ),
              ),
              SizedBox(
                width: mediaW / 18,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Rp $price',
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 15),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Stock"),
                          SizedBox(
                            width: 30,
                          ),
                          // Text("Terjual"),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            stock,
                            style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                          // Text(sold),
                        ],
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    height: 30,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c.whiteColor,
                        ),
                        child: Text(
                          'Publish',
                          style: TextStyle(color: c.brownColor),
                        ),
                        onPressed: publishOnPress),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    height: 30,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c.whiteColor,
                        ),
                        child: Text(
                          'Edit',
                          style: TextStyle(color: c.brownColor),
                        ),
                        onPressed: editOnPress),
                  ),
                ),
              ),
              // Container(
              //   alignment: Alignment.center,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: SizedBox(
              //       width: 100,
              //       height: 30,
              //       child: ElevatedButton(
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: c.whiteColor,
              //           ),
              //           child: Text(
              //             'Ubah',
              //             style: TextStyle(color: c.brownColor),
              //           ),
              //           onPressed: () {}),
              //     ),
              //   ),
              // ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          const Divider(
            thickness: 2,
          ),
        ],
      ),
    ),
  );
}

GestureDetector WCard_Product_Dashboard(
  VoidCallback onTap,
  BuildContext context,
  String title,
  int price,
  String imageNetworkUrl,
  String sellerName,
) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  String _price = formatToRp(price);
  return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Container(
            width: mediaW / 2.3,
            height: mediaH / 3.6,
            decoration: BoxDecoration(
              color: c.whiteColor,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(40, 0, 0, 0),
                  blurRadius: 3.0,
                  spreadRadius: 2.0,
                  offset: Offset(0.0, 1.0),
                )
              ],
            ),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shadowColor: c.blackColor,
              elevation: 0,
              color: c.whiteColor,
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(defaultPadding / 2.5)),
              ),
              // elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                child: Column(
                  children: [
                    imageNetworkUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6)),
                            child: CachedNetworkImage(
                              imageUrl: imageNetworkUrl,
                              fit: BoxFit.cover,
                              height: mediaH / 6.5,
                              placeholder: (context, url) => SizedBox(
                                height: mediaH / 2,
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: c.greenColor,
                                )),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          )
                        : SizedBox(
                            width: mediaW,
                            height: mediaH / 5.5,
                          ),
                    const Spacer(),
                    Text(_price,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: mediaW / 33),
                    ),
                    Text(
                      sellerName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: mediaW / 33),
                    )
                  ],
                ),
              ),
            )),
      ));
}
