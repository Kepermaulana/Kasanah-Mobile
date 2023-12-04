import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/class/transactionHistory_class.dart';
import 'package:kasanah_mobile/core/service/product_service.dart';
import 'package:kasanah_mobile/core/service/transaction_service.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/screens/TransactionStack/cart_screen.dart';
import 'package:kasanah_mobile/widgets/WAlertDialog.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';
import 'package:kasanah_mobile/widgets/WCard.dart';
import 'package:kasanah_mobile/widgets/WSearchBar.dart';
import 'package:kasanah_mobile/widgets/WSkeleton.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  TextEditingController cariTransaksi = TextEditingController();
  bool _isLoading = true;
  bool _isNotifyCart = false;
  bool isSearch = true;
  int _cartCount = 0;
  String dateDone = "";

  List<TransactionHistory> transactions = [];
  List<TransactionHistory> _dataFilter = [];

  Future handleUserCartCount() async {
    if (sessionManager.nToken != null && sessionManager.nUserId != null) {
      Map res = await countUserCartItems(
          sessionManager.nToken!, sessionManager.nUserId!);
      switch (res["res"]) {
        case "ok":
          setState(() {
            _cartCount = res["count"] ?? 0;
            if (_cartCount == 0) {
              _isNotifyCart = false;
              return;
            } else {
              _isNotifyCart = true;
              return;
            }
          });
          break;
      }
    } else {
      setState(() {
        _isNotifyCart = false;
      });
    }
  }

  Future getHistoryTransaction() async {
    Map res = await getUserHistoryTransaction();
    String r = res["res"];
    if (r == "ok") {
      List datas = res["data"];
      datas.forEach((d) async {
        String longName = sessionManager.nLongName ?? "";
        transactions.add(TransactionHistory(
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
    super.initState();
    (() async {
      // await handleUserCartCount();
      initializeDateFormatting();
      await getHistoryTransaction();
      _isLoading = false;
    })();
  }

  @override
  void initStates() {
    super.initState();
    getHistoryTransaction().then((value) {
      setState(() {
        transactions.addAll(value);
        _dataFilter = transactions;
      });
    });
  }

  _ListHistoryState(String value) {
    cariTransaksi.addListener(() {
      if (cariTransaksi.text.isEmpty) {
        setState(() {
          isSearch = true;
        });
      } else {
        setState(() {
          isSearch = false;
        });
      }
    });
  }

  Widget filterData(String value) {
    _dataFilter = [];
    for (int i = 0; i < transactions.length; i++) {
      var data = transactions[i];
      if (data.status!
          .toLowerCase()
          .contains(cariTransaksi.text.toLowerCase())) {
        _dataFilter.add(data);
      }
      cariTransaksi.addListener(() {
        if (cariTransaksi.text.isEmpty) {
          setState(() {
            isSearch = true;
          });
        } else {
          setState(() {
            isSearch = false;
          });
        }
      });
    }
    return showFilterList();
  }

  Widget showFilterList() {
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return (_dataFilter.isNotEmpty)
        ? ListView.builder(
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            reverse: true,
            itemCount: _dataFilter.length,
            itemBuilder: (context, index) {
              TransactionHistory tr = _dataFilter[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: mediaH / 148),
                child: WHistoryCard(
                    context,
                    tr.orderUser ?? "-",
                    "-",
                    tr.id ?? "",
                    tr.idTransaction ?? "-",
                    DateFormat.yMMMMEEEEd('id_ID')
                        .format(DateTime.parse(tr.createdAt ?? "").toLocal()),
                    DateFormat.Hm('id_ID')
                        .format(DateTime.parse(tr.createdAt ?? "").toLocal()),
                    tr.totalQuantity ?? 0,
                    tr.totalPayment ?? 0,
                    tr.status ?? "-",
                    tr.methodPayment ?? "",
                    tr.createdAt ?? "",
                    []),
              );
            },
          )
        : Center(
            child: SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  children: const [
                    Spacer(),
                    Text("Transaksi Yang Anda Cari Tidak Ada"),
                    Spacer()
                  ],
                )));
  }

  @override
  Widget build(BuildContext context) {
    // (() async => await handleUserCartCount())();
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: c.whiteColor,
          automaticallyImplyLeading: false,
          toolbarHeight: mediaH / 10,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: mediaW / defaultPadding * 0.6,
                  vertical: mediaH / defaultPadding / 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    // flex: 8,
                    child: Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(15),
                      child: TextFormField(
                        controller: cariTransaksi,
                        onChanged: (value) => filterData(value),
                        cursorColor: c.blackColor,
                        autofocus: false,
                        style: TextStyle(
                          fontSize: mediaW / 32,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.search,
                              size: 20,
                              color: c.blackColor,
                            ),
                          ),
                          suffixIconConstraints:
                              const BoxConstraints(maxHeight: 35, minWidth: 30),
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Cari Transaksi Di Sini....",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                  // WSearchBar(8, cariTransaksi, () {}, () {},
                  //     'Cari Transaksi ...', context),
                  SizedBox(
                    width: mediaW / 52,
                  ),
                  WActionButton(
                    const Icon(Icons.shopping_cart_outlined),
                    c.greenColor,
                    mediaW / 7,
                    50,
                    context,
                    qty: _cartCount,
                    isNotify: _isNotifyCart,
                    onPressed: () {
                      Navigator.push(context,
                          MyRoute(builder: (context) => const CartScreen()));
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        body: _isLoading
            ? WSkeletonLoadings(context)
            : (transactions.isEmpty)
                ? const Center(
                    child: Text("Kamu Belum Melakukan Transaksi"),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding,
                    ),
                    child: SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: isSearch
                          ? ListView.builder(
                              addAutomaticKeepAlives: false,
                              addRepaintBoundaries: false,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              reverse: true,
                              itemCount: transactions.length,
                              itemBuilder: (context, index) {
                                TransactionHistory tr = transactions[index];
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
                          : showFilterList(),
                    ),
                  ));
  }
}
