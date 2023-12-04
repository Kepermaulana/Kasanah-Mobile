// LINKV2

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/screens/FundStack/funding_component.dart';
import 'package:kasanah_mobile/screens/FundStack/funding_empty_component.dart';
import '../../core/style/Constants.dart';
import '../../core/v2/api.dart';
import '../../core/v2/token.dart';

class FundingRendererScreen extends StatefulWidget {
  const FundingRendererScreen({super.key});

  @override
  State<FundingRendererScreen> createState() => _FundingRendererScreenState();
}

class _FundingRendererScreenState extends State<FundingRendererScreen> {
  Dio dio = Dio();

  bool _isPetaniOnKur = false;
  bool _isLoading = true;

  // data
  var _data;

  // proses
  bool berhasil = false;
  bool pengajuan = false;
  bool sesuai = false;
  bool verifikasi = false;

  Future<void> checkPetaniOnKur() async {
    var res = await http.post(
        Uri(
          scheme: "https",
          host: Host,
          path: "graphql",
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "query":
              "query{kurs(where:{noTlp:\"${sessionManager.nPhoneNumber}\"}),{name,status,noKur,updatedAt,penyerahanBank{cabang,namePetugas,statusPenyerahan,kurApprove{nominal,start,end,tenor,paidOffNominal,interestPercent,approved,note}}}}"
        }));
    if (res.statusCode < 300) {
      var kurs = jsonDecode(res.body)["data"]["kurs"];
      var kur = (kurs.length == 0) ? null : kurs[0];
      if (kur != null) {
        setState(() {
          _data = kur;
          verifikasi = true;
          _isPetaniOnKur = true;
        });
      } else {
        setState(() {
          _isPetaniOnKur = false;
        });
      }
    } else {
      setState(() {
        _isPetaniOnKur = false;
      });
    }
  }

  @override
  void initState() {
    (() async {
      await checkPetaniOnKur();
      _isLoading = false;
    })();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: defaultPadding * 3.3,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Image.asset(
                'assets/images/logo.png',
                height: MediaQuery.of(context).size.height / defaultPadding,
                width: MediaQuery.of(context).size.width / defaultPadding * 7,
                fit: BoxFit.contain,
              ),
            )
          ],
        ),
        body: _isLoading
            ? null
            : (_isPetaniOnKur)
                ? FundingComponent(
                    berhasil: berhasil,
                    pengajuan: pengajuan,
                    sesuai: sesuai,
                    verifikasi: verifikasi,
                    data: _data,
                  )
                : const FundingEmptyComponent());
  }
}
