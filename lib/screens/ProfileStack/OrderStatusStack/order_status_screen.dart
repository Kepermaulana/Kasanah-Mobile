import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/class/transactionHistory_class.dart';
import 'package:kasanah_mobile/core/service/sell_service.dart';
import 'package:kasanah_mobile/core/service/transaction_service.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;

import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/screens/MyStoreStack/add_product_screen.dart';
import 'package:kasanah_mobile/screens/MyStoreStack/edit_product_screen.dart';
import 'package:kasanah_mobile/widgets/WAlertDialog.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';
import 'package:kasanah_mobile/widgets/WCard.dart';
import 'package:kasanah_mobile/widgets/WNavigationBar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/class/product_class.dart';

class OrderStatusScreen extends StatefulWidget {
  OrderStatusScreen({super.key, required this.orderIndex});
  String? orderIndex;

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreen();
}

class _OrderStatusScreen extends State<OrderStatusScreen> {
  bool _isLoading = false;
  String userId = sessionManager.nUserId!;
  List<TransactionHistory> _listNotyetPayed = [];
  List<TransactionHistory> _listOnPacked = [];
  List<TransactionHistory> _listOnDelivery = [];
  List<TransactionHistory> _listRating = [];
  String? _pressedType;

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
      setState(() {
        _isLoading = false;
      });
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
      setState(() {
        _isLoading = false;
      });
      return;
    }
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
      setState(() {
        _isLoading = false;
      });
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
      setState(() {
        _isLoading = false;
      });
      return;
    }
  }

  @override
  void initState() {
    // await handleUserCartCount();
    (() async {
      await getNotyetPayed();
      await getOnPacked();
      await getOnDelivery();
      await getDone();
    })();
    initializeDateFormatting();
    setState(() {
      _isLoading = false;
      _pressedType = widget.orderIndex;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: c.whiteColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: c.blackColor,
            )),
        title: Text(
          'Pesanan Saya',
          style: TextStyle(color: c.blackColor),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: mediaW,
          height: mediaH,
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: mediaW,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() {
                            _pressedType = "P";
                          }),
                          child: Container(
                            child: Chip(
                              padding:
                                  EdgeInsets.symmetric(horizontal: mediaW / 40),
                              elevation: (_pressedType == "P") ? 10 : 2,
                              backgroundColor: (_pressedType == "P")
                                  ? c.greenColor
                                  : c.whiteColor,
                              shadowColor: (_pressedType == "P")
                                  ? c.whiteColor
                                  : c.blackColor,
                              label: Text(
                                'Belum Bayar',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "Poppins",
                                  color: (_pressedType == "P")
                                      ? c.whiteColor
                                      : c.blackColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: mediaW / 30,
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            _pressedType = "T";
                          }),
                          child: Chip(
                            padding:
                                EdgeInsets.symmetric(horizontal: mediaW / 20),
                            elevation: (_pressedType == "T") ? 10 : 2,
                            backgroundColor: (_pressedType == "T")
                                ? c.greenColor
                                : c.whiteColor,
                            shadowColor: (_pressedType == "T")
                                ? c.whiteColor
                                : c.blackColor,
                            label: Text(
                              'Dikemas',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Poppins",
                                color: (_pressedType == "T")
                                    ? c.whiteColor
                                    : c.blackColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: mediaW / 30,
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            _pressedType = "A";
                          }),
                          child: Chip(
                            padding:
                                EdgeInsets.symmetric(horizontal: mediaW / 20),
                            elevation: (_pressedType == "A") ? 10 : 2,
                            backgroundColor: (_pressedType == "A")
                                ? c.greenColor
                                : c.whiteColor,
                            shadowColor: (_pressedType == "A")
                                ? c.whiteColor
                                : c.blackColor,
                            label: Text(
                              'Dikirim',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Poppins",
                                color: (_pressedType == "A")
                                    ? c.whiteColor
                                    : c.blackColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: mediaW / 30,
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            _pressedType = "B";
                          }),
                          child: Chip(
                            padding:
                                EdgeInsets.symmetric(horizontal: mediaW / 20),
                            elevation: (_pressedType == "B") ? 10 : 2,
                            backgroundColor: (_pressedType == "B")
                                ? c.greenColor
                                : c.whiteColor,
                            shadowColor: (_pressedType == "B")
                                ? c.whiteColor
                                : c.blackColor,
                            label: Text(
                              'Beri Penilaian',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Poppins",
                                color: (_pressedType == "B")
                                    ? c.whiteColor
                                    : c.blackColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                _isLoading
                    ? SizedBox(
                        height: mediaH / 2,
                        child: Center(
                            child: LoadingAnimationWidget.waveDots(
                              size: mediaW / 15,
                          color: c.greenColor,
                        )),
                      )
                    : _pressedType == "P"
                        ? (_listNotyetPayed.isEmpty)
                            ? const Text('Belum Ada Pesanan')
                            : ListView.builder(
                                addAutomaticKeepAlives: false,
                                addRepaintBoundaries: false,
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                reverse: true,
                                itemCount: _listNotyetPayed.length,
                                itemBuilder: (context, index) {
                                  TransactionHistory tr =
                                      _listNotyetPayed[index];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: mediaH / 148),
                                    child: WHistoryCard(
                                        context,
                                        tr.orderUser ?? "-",
                                        "-",
                                        tr.id ?? "",
                                        tr.idTransaction ?? "-",
                                        DateFormat.yMMMMEEEEd('id_ID').format(
                                            DateTime.parse(tr.createdAt ?? "")
                                                .toLocal()),
                                        DateFormat.Hm('id_ID').format(
                                            DateTime.parse(tr.createdAt ?? "")
                                                .toLocal()),
                                        tr.totalQuantity ?? 0,
                                        tr.totalPayment ?? 0,
                                        tr.status ?? "-",
                                        tr.methodPayment ?? "",
                                        tr.createdAt ?? "",
                                        []),
                                  );
                                },
                              )
                        : _pressedType == "T"
                            ? (_listOnPacked.isEmpty)
                                ? const Text('Belum Ada Pesanan')
                                : ListView.builder(
                                    addAutomaticKeepAlives: false,
                                    addRepaintBoundaries: false,
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    reverse: true,
                                    itemCount: _listOnPacked.length,
                                    itemBuilder: (context, index) {
                                      TransactionHistory tr =
                                          _listOnPacked[index];
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: mediaH / 148),
                                        child: WHistoryCard(
                                            context,
                                            tr.orderUser ?? "-",
                                            "-",
                                            tr.id ?? "",
                                            tr.idTransaction ?? "-",
                                            DateFormat.yMMMMEEEEd('id_ID')
                                                .format(DateTime.parse(
                                                        tr.createdAt ?? "")
                                                    .toLocal()),
                                            DateFormat.Hm('id_ID').format(
                                                DateTime.parse(
                                                        tr.createdAt ?? "")
                                                    .toLocal()),
                                            tr.totalQuantity ?? 0,
                                            tr.totalPayment ?? 0,
                                            tr.status ?? "-",
                                            tr.methodPayment ?? "",
                                            tr.createdAt ?? "",
                                            []),
                                      );
                                    },
                                  )
                            : _pressedType == "A"
                                ? (_listOnDelivery.isEmpty)
                                    ? const Text('Belum Ada Pesanan')
                                    : ListView.builder(
                                        addAutomaticKeepAlives: false,
                                        addRepaintBoundaries: false,
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        reverse: true,
                                        itemCount: _listOnDelivery.length,
                                        itemBuilder: (context, index) {
                                          TransactionHistory tr =
                                              _listOnDelivery[index];
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: mediaH / 148),
                                            child: WHistoryCard(
                                                context,
                                                tr.orderUser ?? "-",
                                                "-",
                                                tr.id ?? "",
                                                tr.idTransaction ?? "-",
                                                DateFormat.yMMMMEEEEd('id_ID')
                                                    .format(DateTime.parse(
                                                            tr.createdAt ?? "")
                                                        .toLocal()),
                                                DateFormat.Hm('id_ID').format(
                                                    DateTime.parse(
                                                            tr.createdAt ?? "")
                                                        .toLocal()),
                                                tr.totalQuantity ?? 0,
                                                tr.totalPayment ?? 0,
                                                tr.status ?? "-",
                                                tr.methodPayment ?? "",
                                                tr.createdAt ?? "",
                                                []),
                                          );
                                        },
                                      )
                                : _pressedType == "B"
                                    ? (_listRating.isEmpty)
                                        ? const Text('Belum Ada Pesanan')
                                        : ListView.builder(
                                            addAutomaticKeepAlives: false,
                                            addRepaintBoundaries: false,
                                            shrinkWrap: true,
                                            physics: const ScrollPhysics(),
                                            reverse: true,
                                            itemCount: _listRating.length,
                                            itemBuilder: (context, index) {
                                              TransactionHistory tr =
                                                  _listRating[index];
                                                  print(tr.status);
                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: mediaH / 148),
                                                child: WHistoryCard(
                                                    context,
                                                    tr.orderUser ?? "-",
                                                    "-",
                                                    tr.id ?? "",
                                                    tr.idTransaction ?? "-",
                                                    DateFormat.yMMMMEEEEd(
                                                            'id_ID')
                                                        .format(DateTime.parse(
                                                                tr.createdAt ??
                                                                    "")
                                                            .toLocal()),
                                                    DateFormat.Hm('id_ID')
                                                        .format(DateTime.parse(
                                                                tr.createdAt ??
                                                                    "")
                                                            .toLocal()),
                                                    tr.totalQuantity ?? 0,
                                                    tr.totalPayment ?? 0,
                                                    tr.status ?? "-",
                                                    tr.methodPayment ?? "",
                                                    tr.createdAt ?? "",
                                                    []),
                                              );
                                            },
                                          )
                                    : Container(),
                SizedBox(
                  height: mediaH / 2.20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
