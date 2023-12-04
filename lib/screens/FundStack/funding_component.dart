import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasanah_mobile/core/v2/components/currency_format.dart';
import 'package:kasanah_mobile/screens/FundStack/funding_empty_component.dart';
import 'package:intl/date_symbol_data_local.dart';
import "package:kasanah_mobile/core/v2/constanst.dart";

class FundingComponent extends StatefulWidget {
  // const FundingComponent({super.key});
  const FundingComponent(
      {Key? key,
      required this.berhasil,
      required this.pengajuan,
      required this.sesuai,
      required this.verifikasi,
      this.data})
      : super(key: key);

  final bool berhasil;
  final bool pengajuan;
  final bool sesuai;
  final bool verifikasi;
  final dynamic data;

  @override
  State<FundingComponent> createState() => _FundingComponentState();
}

class _FundingComponentState extends State<FundingComponent> {
  var kur;
  var kurApprove;

  String? _nominal;
  String? _start;
  String? _end;
  String? _tenor;
  String? _bunga;
  String? _totalPelunasan;

  String? _noKur;
  String? _statusKur;
  bool _statusIsGagal = false;

  String _tglProses = "-";
  String _jamProses = "-";

  bool _sesuaiProses = false;
  bool _pengajuanProses = false;
  bool _berhasilProses = false;
  bool _verifikasiProses = false;

  formatStatus(String status) {
    print(status);
    switch (status) {
      case "true":
        return "BERHASIL";
      case "false":
        return "DITOLAK";
      case "KUR_GAGAL":
        return "DITOLAK";
    }
    return status;
  }

  formatDate(String? date) {
    List? splittedDate = (date != null) ? date.split(" ") : null;
    String stringDate = (splittedDate != null)
        ? "${splittedDate[1]} ${splittedDate[2]} ${splittedDate[3]}"
        : "-";
    return stringDate;
  }

  isGagal(String status) {
    if (status == "BERHASIL" || status == "BERJALAN" || status == "DISERAHKAN")
      return false;
    return true;
  }

  Widget noKurWidget(String noKur, String status, {bool isMerah = false}) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context, MyRoute(builder: (_) => DetailPengajuan()));
      },
      child: Row(
        children: [
          Text(noKur),
          const Spacer(),
          Text(
            '$status',
            style: TextStyle(color: isMerah ? Colors.red[600] : Colors.green),
          ),
          IconButton(
            onPressed: () {
              // Navigator.push(
              //     context, MyRoute(builder: (_) => DetailPengajuan()));
            },
            icon: const Icon(Icons.arrow_forward_ios_rounded),
            iconSize: 15,
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    kur = widget.data;
    initializeDateFormatting();
    _verifikasiProses = true;
    String kurDate = kur["updatedAt"];
    _tglProses = DateFormat.yMMMMEEEEd('id_ID')
        .format(DateTime.parse(kurDate).add(const Duration(hours: 7)));
    _jamProses = DateFormat.Hm('id_ID')
        .format(DateTime.parse(kurDate).add(const Duration(hours: 7)));
    print("1");
    if (kur["penyerahanBank"] != null) {
      print("2");
      _pengajuanProses = true;
      _sesuaiProses = false;
      _verifikasiProses = false;
      if (kur["penyerahanBank"]["kurApprove"] != null) {
        print("3");
        kurApprove = kur["penyerahanBank"]["kurApprove"];
        // is
        _nominal = kurApprove["nominal"].toString();
        _start = formatDate(kurApprove["start"]) ?? "-";
        _end = formatDate(kurApprove["end"]) ?? "-";
        _tenor = kurApprove["tenor"].toString();
        _bunga = kurApprove["interestPercent"].toString();
        _totalPelunasan = kurApprove["paidOffNominal"].toString();
        // is
        _statusKur = formatStatus(kurApprove["approved"].toString()) ?? "-";
        _statusIsGagal = isGagal(_statusKur ?? "DITOLAK") ?? "-";
        _berhasilProses = true;
        _pengajuanProses = false;
        _sesuaiProses = false;
        _verifikasiProses = false;
      } else {
        print("4");
        _statusKur = formatStatus(
            kur["penyerahanBank"]["statusPenyerahan"] ?? "DISERAHKAN");
        _statusIsGagal = isGagal(_statusKur ?? "DITOLAK");
      }
      print("5");
    } else {
      _statusKur = formatStatus("BERJALAN");
      print("6");
    }
    if (kur["status"] == "DATA_VALID" && kur["penyerahanBank"] == null) {
      print("7");
      _sesuaiProses = true;
      _verifikasiProses = false;
    }
    print("8");
    if (isGagal(_statusKur ?? "DITOLAK") == true) _statusKur = "DITOLAK";
    _noKur = kur["noKur"];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            child: Container(
              child: const Text(
                'Status Pendanaan',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: greenColor),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 30,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Infromasi KUR:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text(
                    'Nominal',
                    style: TextStyle(),
                  ),
                  const Spacer(),
                  Text((_nominal != null &&
                          _nominal != "-" &&
                          _nominal != "null")
                      ? CurrencyFormat.convertToIdr(int.parse(_nominal!), 0)
                      : "-")
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text(
                    'Tanggal Kontrak',
                    style: TextStyle(),
                  ),
                  const Spacer(),
                  Text((_start != null) ? _start! : "-")
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text(
                    'Tenor',
                    style: TextStyle(),
                  ),
                  const Spacer(),
                  Text((_tenor != null && _tenor != "null")
                      ? "${_tenor!.toString()} Bulan"
                      : "-")
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text(
                    'Jatuh Tempo Pembayaran',
                    style: TextStyle(),
                  ),
                  const Spacer(),
                  Text((_end != null) ? _end! : "-")
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text(
                    'Bunga',
                    style: TextStyle(),
                  ),
                  const Spacer(),
                  Text((_bunga != null && _bunga != "null")
                      ? "${_bunga.toString()}%"
                      : "-")
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text(
                    'Total Pelunasan',
                    style: TextStyle(),
                  ),
                  const Spacer(),
                  Text((_totalPelunasan != null &&
                          _totalPelunasan != "-" &&
                          _totalPelunasan != "null")
                      ? CurrencyFormat.convertToIdr(
                          int.parse(_totalPelunasan!), 0)
                      : "-")
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 25,
              ),
              ExpandablePanel(
                  header: const Text(
                    'Proses Pengajuan',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  collapsed: const Text(' '),
                  expanded: Container(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: defaultPadding),
                    child: Column(
                      children: [
                        Column(
                          //berhasil
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: defaultPadding),
                              child: Center(
                                  child:
                                      Text('Nomor Pengajuan ${_noKur ?? "-"}')),
                            ),
                            Container(
                              child: (_berhasilProses)
                                  // true berhasil
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          //kondisi data
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 8, right: 12, top: 3),
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                color: (isGagal(_statusKur ??
                                                            "DITOLAK") ==
                                                        true)
                                                    ? Colors.red
                                                    : greenColor,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Text(
                                              (isGagal(_statusKur ??
                                                          "DITOLAK") ==
                                                      true)
                                                  ? "Pendanaan Gagal"
                                                  : 'Pendanaan Berhasil',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Container(
                                            margin: const EdgeInsets.only(
                                              left: 17.5,
                                            ),
                                            padding: const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 5,
                                                bottom: 25),
                                            decoration: const BoxDecoration(
                                                border: Border(
                                                    left: BorderSide(
                                              color: greenColor,
                                            ))),
                                            child: Text(
                                                "$_tglProses - $_jamProses",
                                                style: const TextStyle(
                                                    fontSize: 9))),
                                      ],
                                    )
                                  // false berhasil
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          //kondisi data
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 8, right: 12, top: 3),
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: blackColor,
                                                      width: 0.5)),
                                            ),
                                            const Text("Pendanaan Berhasil",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                            left: 17.5,
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 5,
                                              bottom: 25),
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  left: BorderSide(
                                            color: greyColor,
                                          ))),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                        Column(
                          //pengajuan bank
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: (_pengajuanProses)
                                  // true pengajuan
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                left: 8,
                                                right: 12,
                                              ),
                                              height: 20,
                                              width: 20,
                                              decoration: const BoxDecoration(
                                                color: greenColor,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Text("Pengajuan Bank",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                            left: 17.5,
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 5,
                                              bottom: 25),
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  left: BorderSide(
                                            color: greenColor,
                                          ))),
                                          child: Text(
                                            '$_tglProses - $_jamProses',
                                            style: TextStyle(fontSize: 9),
                                          ),
                                        ),
                                      ],
                                    )
                                  // false pengajuan
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                left: 8,
                                                right: 12,
                                              ),
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: blackColor,
                                                      width: 0.5)),
                                            ),
                                            const Text("Pengajuan Bank",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                            left: 17.5,
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 5,
                                              bottom: 25),
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  left: BorderSide(
                                            color: greyColor,
                                          ))),
                                        ),
                                      ],
                                    ),
                            )
                          ],
                        ),
                        Column(
                          // data sesuai
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: (_sesuaiProses)
                                  // true sesuai
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                left: 8,
                                                right: 12,
                                              ),
                                              height: 20,
                                              width: 20,
                                              decoration: const BoxDecoration(
                                                color: greenColor,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Text("Data Sesuai",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                            left: 17.5,
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 5,
                                              bottom: 25),
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  left: BorderSide(
                                            color: greenColor,
                                          ))),
                                          child: Text(
                                            '$_tglProses - $_jamProses',
                                            style: TextStyle(fontSize: 9),
                                          ),
                                        ),
                                      ],
                                    )
                                  // false sesuai
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                left: 8,
                                                right: 12,
                                              ),
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: blackColor,
                                                      width: 0.5)),
                                            ),
                                            const Text("Data Sesuai",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                            left: 17.5,
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 5,
                                              bottom: 25),
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  left: BorderSide(
                                            color: greyColor,
                                          ))),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                        Column(
                          // verifikasi data
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: (_verifikasiProses)
                                  // true verif
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                left: 8,
                                                right: 12,
                                              ),
                                              height: 20,
                                              width: 20,
                                              decoration: const BoxDecoration(
                                                color: greenColor,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const Text("Verifikasi Data",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                            left: 17.5,
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 5,
                                              bottom: 25),
                                          child: Text(
                                            '$_tglProses - $_jamProses',
                                            style: TextStyle(fontSize: 9),
                                          ),
                                        ),
                                      ],
                                    )
                                  // false verif
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                left: 8,
                                                right: 12,
                                              ),
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: blackColor,
                                                      width: 0.5)),
                                            ),
                                            const Text("Verifikasi Data",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                            left: 17.5,
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 5,
                                              bottom: 25),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ExpandablePanel(
                    header: const Text(
                      'Riwayat Pengajuan',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    collapsed: const Text(' '),
                    expanded: Container(
                      child: Column(children: [
                        noKurWidget(
                            _noKur ?? "Loading...", _statusKur ?? "Loading...",
                            isMerah: _statusIsGagal)
                      ]),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ]),
          )
        ],
      ),
    );
  }
}
