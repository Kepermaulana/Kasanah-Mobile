// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:kasanah_mobile/core/api/network.dart';
// import 'package:kasanah_mobile/core/style/Colors.dart' as c;
// import 'package:kasanah_mobile/core/style/Constants.dart';
// import 'package:kasanah_mobile/core/worker/CurrencyWorker.dart';
// import 'package:kasanah_mobile/core/worker/StringWorker.dart';
// import 'package:kasanah_mobile/screens/TransactionHistoryStack/pdf_invoice_screen.dart';

// class InvoiceScreen extends StatefulWidget {
//   InvoiceScreen({
//     super.key,
//     required this.noInvoice,
//     required this.namaPenerima,
//     required this.phoneNumber,
//     required this.tanggalPembelian,
//     required this.jamPembelian,
//     required this.paymentStatus,
//     required this.orderPickStatus,
//     required this.total,
//     required this.overallQuantity,
//     required this.detailList,
//   });

//   String noInvoice;
//   String namaPenerima;
//   String phoneNumber;
//   String tanggalPembelian;
//   String jamPembelian;
//   String paymentStatus;
//   String orderPickStatus;
//   int total;
//   int overallQuantity;
//   List<dynamic> detailList;

//   @override
//   State<InvoiceScreen> createState() => _InvoiceScreenState();
// }

// class _InvoiceScreenState extends State<InvoiceScreen> {
//   String? idUser, token, phoneNumber, longName;

//   Widget? isUserLunas(String? status) {
//     if (status == "NEED_PAYMENT" ||
//         status == "IN_REVIEW" ||
//         status == "CANCELLED") {
//       return null;
//     }
//     return Transform.rotate(
//       angle: 3.14 / -5,
//       child: Container(
//         decoration: BoxDecoration(
//             border: Border.all(color: Colors.green.withAlpha(100), width: 5),
//             borderRadius: BorderRadius.circular(12)),
//         child: SizedBox(
//             child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
//           child: Text(
//             "LUNAS",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 color: Colors.green.withAlpha(100),
//                 fontSize: 80,
//                 fontWeight: FontWeight.bold,
//                 decoration: TextDecoration.none),
//           ),
//         )),
//       ),
//     );
//   }

//   Widget? isCanDownload(String? status) {
//     if (status == "NEED_PAYMENT" ||
//         status == "IN_REVIEW" ||
//         status == "CANCELLED") {
//       return null;
//     }
//     return Transform.rotate(
//       angle: 3.14 / -5,
//       child: Container(
//         decoration: BoxDecoration(
//             border: Border.all(color: Colors.green.withAlpha(100), width: 5),
//             borderRadius: BorderRadius.circular(12)),
//         child: SizedBox(
//             child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
//           child: Text(
//             "LUNAS",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 color: Colors.green.withAlpha(100),
//                 fontSize: 80,
//                 fontWeight: FontWeight.bold,
//                 decoration: TextDecoration.none),
//           ),
//         )),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     sessionManager.getPref().then((value) {
//       setState(() {
//         idUser = sessionManager.nUserId;
//         longName = sessionManager.nLongName;
//         token = sessionManager.nToken;
//         phoneNumber = sessionManager.nPhoneNumber;
//       });
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double mediaW = MediaQuery.of(context).size.width;
//     double mediaH = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 1,
//         backgroundColor: c.whiteColor,
//         title: Text(
//           'Invoice Panenin',
//           style: TextStyle(
//             color: c.blackColor,
//           ),
//         ),
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(
//               Icons.arrow_back,
//               color: c.blackColor,
//             )),
//         actions: [
//           (widget.paymentStatus == "VERIFIED")
//               ? IconButton(
//                   onPressed: () async {
//                     final pdfFile = await PdfInvoice(
//                       noInvoice: widget.noInvoice,
//                       namaPenerima: widget.namaPenerima,
//                       phoneNumber: widget.phoneNumber,
//                       tanggalPembelian: widget.tanggalPembelian,
//                       jamPembelian: widget.jamPembelian,
//                       paymentStatus: widget.paymentStatus,
//                       orderPickStatus: widget.orderPickStatus,
//                       total: widget.total,
//                       overallQuantity: widget.overallQuantity,
//                       detailList: widget.detailList,
//                     ).generate();
//                     PdfInvoice.openFile(pdfFile);
//                     print(pdfFile);
//                   },
//                   icon: Icon(
//                     Icons.file_download_outlined,
//                     color: c.blackColor,
//                   ))
//               : Container()
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             Positioned(
//               top: mediaH / 3,
//               left: mediaW / 8,
//               child: Center(
//                 child: BackdropFilter(
//                     filter: ImageFilter.blur(
//                       sigmaX: 0,
//                       sigmaY: 0,
//                     ),
//                     child: isUserLunas(widget.paymentStatus)),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: const [
//                       Spacer(),
//                       Text('Invoice',
//                           style: TextStyle(
//                             fontSize: 21,
//                           )),
//                     ],
//                   ),
//                   Image.asset(
//                     'assets/images/logo.png',
//                     width: mediaW / 4,
//                   ),
//                   Text(
//                     widget.noInvoice,
//                     style: TextStyle(fontSize: 10, color: c.greenColor),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: mediaW / 2,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("DITERBITKAN OLEH",
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     color: c.blackColor,
//                                     fontWeight: FontWeight.w600)),
//                             Text("PT. AGRI GAIN NUSANTARA",
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     color: c.blackColor,
//                                     fontWeight: FontWeight.w600))
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         child: SizedBox(
//                           height: mediaH / 9,
//                           child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Untuk',
//                                     style: TextStyle(
//                                         fontSize: 12,
//                                         color: c.blackColor,
//                                         fontWeight: FontWeight.w600)),
//                                 Text('Nama: ${widget.namaPenerima}',
//                                     style: TextStyle(
//                                       fontSize: 9,
//                                       color: c.blackColor,
//                                     )),
//                                 Text('No. Telepon: $phoneNumber',
//                                     style: TextStyle(
//                                       fontSize: 9,
//                                       color: c.blackColor,
//                                     )),
//                                 Text(
//                                     'Tanggal Pembelian: ${widget.tanggalPembelian}',
//                                     maxLines: 3,
//                                     style: TextStyle(
//                                       fontSize: 9,
//                                       color: c.blackColor,
//                                     )),
//                                 Text(
//                                     'Status Pembayaran: ${StringWorker().genHistoryPaymentStatus(widget.paymentStatus)}',
//                                     style: TextStyle(
//                                       fontSize: 9,
//                                       color: c.blackColor,
//                                     ))
//                               ]),
//                         ),
//                       )
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   Container(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Divider(thickness: 1),
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: mediaW / 4.5,
//                               child: const Text(
//                                 'Info Produk',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w600, fontSize: 12),
//                               ),
//                             ),
//                             SizedBox(
//                               width: mediaW / 6.3,
//                               child: const Text(
//                                 'Jumlah',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w600, fontSize: 12),
//                               ),
//                             ),
//                             SizedBox(
//                               width: mediaW / 4,
//                               child: const Text(
//                                 'Harga Satuan',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w600, fontSize: 12),
//                               ),
//                             ),
//                             SizedBox(
//                               width: mediaW / 5,
//                               child: const Text(
//                                 'Total Harga',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w600, fontSize: 12),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const Divider(
//                           thickness: 1,
//                         ),
//                         ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: widget.detailList.length,
//                           itemBuilder: (context, index) {
//                             var detail = widget.detailList[index];
//                             return ProductListInvoice(
//                                 mediaW,
//                                 detail["productName"],
//                                 detail["quantity"],
//                                 detail["price"]);
//                           },
//                         ),
//                         const Divider(
//                           thickness: 1,
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Row(
//                           children: [
//                             const Spacer(),
//                             const SizedBox(
//                               width: 30,
//                             ),
//                             Row(
//                               children: [
//                                 const Text("TOTAL HARGA",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 12)),
//                                 SizedBox(
//                                   width: mediaW / 14,
//                                 ),
//                                 Text(formatToRp(widget.total),
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.w400,
//                                         fontSize: 12)),
//                               ],
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: mediaH / 20,
//                         ),
//                         Text('Update *${widget.tanggalPembelian}',
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 12,
//                                 fontStyle: FontStyle.italic)),
//                         const SizedBox(
//                           height: 17,
//                         ),
//                         const Text("No Rekening: ",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w500, fontSize: 12)),
//                         const Text('1283558855',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w400, fontSize: 12)),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         const Text("Metode Pembayaran: ",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w500, fontSize: 12)),
//                         const Text('Pembayaran Via Transfer Bank',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w400, fontSize: 12)),
//                         const SizedBox(
//                           height: 45,
//                         ),
//                         Text(
//                           "Invoice ini sah dan diproses oleh Aplikasi Panenin",
//                           style: TextStyle(
//                               color: c.greenColor,
//                               fontStyle: FontStyle.italic,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400),
//                         ),
//                         Text(
//                           "Silahkan hubungi Panenin apabila membutuhkan bantuan",
//                           style: TextStyle(
//                               color: c.greenColor,
//                               fontStyle: FontStyle.italic,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400),
//                         ),
//                         const Divider(
//                           thickness: 2,
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget ProductListInvoice(
//       double mediaW, String productName, int qty, int price) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: mediaW / 98),
//       child: Row(
//         children: [
//           SizedBox(
//             width: mediaW / 4.5,
//             child: Text(
//               productName,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 9),
//               maxLines: 3,
//             ),
//           ),
//           SizedBox(
//             width: mediaW / 7.5,
//             child: Text(
//               qty.toString(),
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 9),
//             ),
//           ),
//           SizedBox(
//             width: mediaW / 4,
//             child: Text(
//               formatToRp(price),
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 9),
//             ),
//           ),
//           SizedBox(
//             width: mediaW / 4.5,
//             child: Text(
//               formatToRp(price * qty),
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 9),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
