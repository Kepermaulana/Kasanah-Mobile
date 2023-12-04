import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/class/transactionHistory_class.dart';
import 'package:kasanah_mobile/core/service/transaction_service.dart';
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/widgets/WCard.dart';

class QRHistoryScreen extends StatefulWidget {
  const QRHistoryScreen({super.key});

  @override
  State<QRHistoryScreen> createState() => _QRHistoryScreenState();
}

class _QRHistoryScreenState extends State<QRHistoryScreen> {
  bool _isLoading = true;
  List<QRHistory> qrHistory = [];
  String? nKredit, nDebit;

  Future getHistoryQrPayment() async {
    Map res = await getQrHistory();
    String r = res["res"];
    if (r == "ok") {
      List datas = res["data"];
      datas.forEach((d) async {
        qrHistory.add(QRHistory(
            id: d["_id"],
            debit: d["debit"],
            kredit: d["kredit"],
            payer: d["user"][0]["firstName"],
            createdAt: d["createdAt"]));
      });
      setState(() {
        _isLoading = false;
      });
      return;
    }
  }

  @override
  void initState() {
    getHistoryQrPayment();
    initializeDateFormatting();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                reverse: true,
                itemCount: qrHistory.length,
                itemBuilder: (context, index) {
                  QRHistory tr = qrHistory[index];
                  nKredit = tr.kredit.toString();
                  nDebit = tr.debit.toString();
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: mediaH / 145, horizontal: mediaW / 50),
                    child: WHistoryQR(
                        context,
                        nKredit == "null"
                            ? "Pengirim: ${sessionManager.nLongName}"
                            : "Penerima: ${sessionManager.nLongName}",
                        DateFormat.yMMMMEEEEd('id_ID').format(
                            DateTime.parse(tr.createdAt ?? "").toLocal()),
                        DateFormat.Hm('id_ID').format(
                            DateTime.parse(tr.createdAt ?? "").toLocal()),
                        tr.debit == null ? "Rp$nKredit" : "Rp$nDebit",
                        tr.debit == null ? "+Rp$nKredit" : "-Rp$nDebit",
                        tr.type ?? "Direct"),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
