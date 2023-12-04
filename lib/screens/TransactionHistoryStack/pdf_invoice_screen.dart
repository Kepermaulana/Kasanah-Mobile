// import 'dart:io';

// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:kasanah_mobile/core/class/transactionHistory_class.dart';
// import 'package:kasanah_mobile/core/service/transaction_service.dart';
// import 'package:kasanah_mobile/core/worker/CurrencyWorker.dart';
// import 'package:kasanah_mobile/core/worker/StringWorker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart';

// import '../../core/style/Constants.dart';

// class PdfInvoice {
//   PdfInvoice({
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
//   Future<File> generate() async {
//     PdfColor flatten({PdfColor background = const PdfColor(1, 1, 1)}) {
//       var a = 0.45;
//       var r = 0.255;
//       var g = 0.5;
//       var b = 0.5;
//       return PdfColor(
//         a * r + (1 - a) * background.red,
//         a * g + (1 - a) * background.green,
//         a * b + (1 - a) * background.blue,
//         background.alpha,
//       );
//     }

//     // String? method(String? method) {
//     //   if (method == "MANUAL") {
//     //     return "Pembayaran Via Transfer Bank";
//     //   }
//     // }

//     Widget? isUserLunas(String? status) {
//       if (status == "NEED_PAYMENT" ||
//           status == "IN_REVIEW" ||
//           status == "CANCELLED") {
//         return null;
//       }
//       return Container(
//         decoration: BoxDecoration(
//             border: Border.all(color: PdfColors.green100, width: 5),
//             borderRadius: BorderRadius.circular(12)),
//         child: SizedBox(
//             child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
//           child: Text(
//             "LUNAS",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 color: PdfColors.green100,
//                 fontSize: 100,
//                 fontWeight: FontWeight.bold,
//                 decoration: TextDecoration.none),
//           ),
//         )),
//       );
//     }

//     final Inter =
//         await rootBundle.load("assets/fonts/inter/Inter-SemiBold.ttf");
//     final Font myFont = Font.ttf(Inter);
//     Document pdf = Document();
//     final imageLogo =
//         (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List();
//     pdf.addPage(
//       MultiPage(
//           build: (context) => [
//                 Stack(children: <Widget>[
//                   Positioned(
//                       top: 200,
//                       left: 40,
//                       child: Transform.rotate(
//                           angle: 3.14 / 5, child: isUserLunas(paymentStatus))),
//                   Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Spacer(),
//                             Text('Invoice',
//                                 style: const TextStyle(
//                                   fontSize: 21,
//                                 )),
//                           ],
//                         ),
//                         Image(MemoryImage(imageLogo), width: 100),
//                         SizedBox(height: 10),
//                         Text(
//                           noInvoice,
//                           style: const TextStyle(
//                               fontSize: 10, color: PdfColors.green),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               width: 200,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("DITERBITKAN OLEH",
//                                       style: TextStyle(
//                                           fontSize: 12,
//                                           color: PdfColors.black,
//                                           fontWeight: FontWeight.bold)),
//                                   Text("PT. AGRI GAIN NUSANTARA",
//                                       style: TextStyle(
//                                           fontSize: 12,
//                                           color: PdfColors.black,
//                                           fontWeight: FontWeight.bold))
//                                 ],
//                               ),
//                             ),
//                             Spacer(),
//                             Expanded(
//                               child: SizedBox(
//                                 height: 90,
//                                 child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text('Untuk',
//                                           style: TextStyle(
//                                               fontSize: 12,
//                                               color: PdfColors.black,
//                                               fontWeight: FontWeight.bold)),
//                                       Text('Nama: $namaPenerima',
//                                           style: const TextStyle(
//                                             fontSize: 9,
//                                             color: PdfColors.black,
//                                           )),
//                                       Text('No. Telepon: $phoneNumber',
//                                           style: const TextStyle(
//                                             fontSize: 9,
//                                             color: PdfColors.black,
//                                           )),
//                                       Text(
//                                           'Tanggal Pembelian: $tanggalPembelian',
//                                           maxLines: 3,
//                                           style: const TextStyle(
//                                             fontSize: 9,
//                                             color: PdfColors.black,
//                                           )),
//                                       Text(
//                                           'Status Pembayaran: ${StringWorker().genHistoryPaymentStatus(paymentStatus)}',
//                                           style: const TextStyle(
//                                             fontSize: 9,
//                                             color: PdfColors.black,
//                                           ))
//                                     ]),
//                               ),
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Divider(thickness: 1),
//                             Row(
//                               children: [
//                                 SizedBox(
//                                   width: 140,
//                                   child: Text(
//                                     'Info Produk',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 12),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 110,
//                                   child: Text(
//                                     'Jumlah',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 12),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 140,
//                                   child: Text(
//                                     'Harga Satuan',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 12),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 140,
//                                   child: Text(
//                                     'Total Harga',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 12),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Divider(
//                               thickness: 1,
//                             ),
//                             ListView.builder(
//                               itemCount: detailList.length,
//                               itemBuilder: (context, index) {
//                                 var detail = detailList[index];
//                                 return ProductListInvoice(
//                                     300,
//                                     detail["productName"],
//                                     detail["quantity"],
//                                     detail["price"]);
//                               },
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Divider(
//                               thickness: 1,
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Row(
//                               children: [
//                                 Spacer(),
//                                 SizedBox(
//                                   width: 30,
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text("TOTAL HARGA",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 12)),
//                                     SizedBox(
//                                       width: 250 / 14,
//                                     ),
//                                     Text(formatToRp(total),
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.normal,
//                                             fontSize: 12)),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 700 / 20,
//                             ),
//                             Text('Update *$tanggalPembelian',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 12,
//                                     fontStyle: FontStyle.italic)),
//                             SizedBox(
//                               height: 17,
//                             ),
//                             Text("No Rekening: ",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 12)),
//                             Text('1283558855',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 12)),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Text("Metode Pembayaran: ",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 12)),
//                             Text('Pembayaran Via Transfer Bank',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 12)),
//                             SizedBox(
//                               height: 45,
//                             ),
//                             Text(
//                               "Invoice ini sah dan diproses oleh Aplikasi Panenin",
//                               style: TextStyle(
//                                   color: PdfColors.green,
//                                   fontStyle: FontStyle.italic,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                             Text(
//                               "Silahkan hubungi Panenin apabila membutuhkan bantuan",
//                               style: TextStyle(
//                                   color: PdfColors.green,
//                                   fontStyle: FontStyle.italic,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                             Divider(
//                               thickness: 1,
//                             )
//                           ],
//                         ),
//                       ]),
//                 ]),
//               ]),
//     );
//     return saveDocument(name: 'invoice.pdf', pdf: pdf);
//   }

//   static Future<File> saveDocument({
//     required String name,
//     required Document pdf,
//   }) async {
//     final bytes = await pdf.save();

//     final dir = await getApplicationDocumentsDirectory();
//     final file = File('${dir.path}/$name');
//     await file.writeAsBytes(bytes);
//     return file;
//   }

//   static Future openFile(File file) async {
//     final url = file.path;
//     print('assf, $url');
//     await OpenFilex.open(url);
//   }

//   Widget ProductListInvoice(
//       double mediaW, String productName, int qty, int price) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: mediaW / 98),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 95,
//             child: Text(
//               productName,
//               overflow: TextOverflow.clip,
//               style: TextStyle(fontWeight: FontWeight.normal, fontSize: 9),
//               maxLines: 3,
//             ),
//           ),
//           SizedBox(
//             width: 135,
//             child: Text(
//               qty.toString(),
//               textAlign: TextAlign.center,
//               style: TextStyle(fontWeight: FontWeight.normal, fontSize: 9),
//             ),
//           ),
//           SizedBox(
//             width: 130,
//             child: Text(
//               formatToRp(price),
//               textAlign: TextAlign.center,
//               style: TextStyle(fontWeight: FontWeight.normal, fontSize: 9),
//             ),
//           ),
//           SizedBox(
//             width: 125,
//             child: Text(
//               formatToRp(price * qty),
//               textAlign: TextAlign.center,
//               style: TextStyle(fontWeight: FontWeight.normal, fontSize: 9),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
