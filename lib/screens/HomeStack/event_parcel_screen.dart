import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/api/api.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/core/worker/StringWorker.dart';
import 'package:http/http.dart' as http;
import 'package:kasanah_mobile/widgets/WAlertDialog.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';
import 'package:kasanah_mobile/widgets/WNavigationBar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EventParcelScreen extends StatefulWidget {
  const EventParcelScreen({super.key});

  @override
  State<EventParcelScreen> createState() => _EventParcelScreenState();
}

class _EventParcelScreenState extends State<EventParcelScreen> {
  bool _isLoading = true;
  String? parcelCode;
  bool isTaked = false;

  Future takeParcel() async {
    try {
      String idParcel = StringWorker().genIdParcel();
      String _token = sessionManager.nToken!;
      Map takedParcel = await checkIsTaked();
      switch (takedParcel["res"]) {
        case "not-exist":
          var body = jsonEncode({
            "code": idParcel,
            "user": [sessionManager.nUserId]
          });
          Uri url = Uri.parse("$kMgApi/parcel");
          var res = await http.post(url,
              headers: {"Authorization": "Bearer $_token"}, body: body);
          print(res.body);
          setState(() {
            _isLoading = false;
            isTaked = true;
            Navigator.push(
                context, MyRoute(builder: (_) => const WNavigationBar()));
            showDialog(
              barrierColor: Colors.black26,
              context: context,
              builder: (context) {
                return WDialog_TextAlert(context, "Parcel Sukses Diambil",
                    'Silahkan Konfirmasi Dengan Admin');
              },
            );
          });
          if (res.statusCode < 300) return {"res": "ok"};
          break;
        case "is-exist":
          setState(() {
            _isLoading = false;
            Navigator.push(
                context, MyRoute(builder: (_) => const WNavigationBar()));
            showDialog(
              barrierColor: Colors.black26,
              context: context,
              builder: (context) {
                return WDialog_TextAlert(
                    context,
                    "Parcel Hanya Bisa Diambil Sekali",
                    'Silahkan Tunggu Event Parcel Berikutnya:)');
              },
            );
          });
      }
    } catch (e) {
      return {
        "res": "service-error",
        "error": {"error": e}
      };
    }
    return {"res": "api-error"};
  }

  //parcel?user=
  Future<Map> checkIsTaked() async {
    try {
      String userId = sessionManager.nUserId!;
      String url = "$kMgApi/parcel?user=$userId";
      var res = await http.get(Uri.parse(url));
      var c = jsonDecode(res.body);
      bool isExist = (c.length > 0) ? true : false;
      switch (isExist) {
        case true:
          return {"res": "is-exist", "data": c};
        case false:
          return {"res": "not-exist"};
      }
    } catch (e) {
      return {
        "res": "service-error",
        "data": {"error": e}
      };
    }
    return {"res": "api-error"};
  }

  Future getParcelCode() async {
    String cToken = sessionManager.nToken!;
    String cUserId = sessionManager.nUserId!;
    try {
      Uri url = Uri.parse(
        "$kMgApi/parcel?user=$cUserId",
      );
      var res = await http.get(
        url,
        headers: {"Authorization": "Bearer $cToken"},
      );
      var b = jsonDecode(res.body);
      setState(() {
        _isLoading = false;
        parcelCode = b[0]['code'];
      });
      if (b.isNotEmpty) {
        return {"res": "ok", "data": b};
      } else {
        return {
          "res": "empty",
        };
      }
    } catch (e) {
      return {
        "res": "service-error",
        "data": {"error": e}
      };
    }
  }

  @override
  void initState() {
    getParcelCode();
    // TODO: implement initState
    super.initState();
  }

  //parcel?user=64047a8b1f0e73c8ee9bf5c6&$select[0]=code

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
          'Parcel',
          style: TextStyle(color: c.blackColor),
        ),
      ),
      body: _isLoading
          ? Center(
              child: LoadingAnimationWidget.waveDots(
                size: mediaW / 15,
            color: c.greenColor,
          ))
          : Center(
              child: Column(
                children: [
                  Spacer(),
                  Column(
                    children: [
                      (parcelCode == null)
                          ? Container(
                              alignment: Alignment.center,
                              child: Column(children: [
                                Icon(
                                  Icons.card_giftcard_rounded,
                                  size: mediaW / 2,
                                  color: c.brownColor,
                                )
                              ]),
                            )
                          : Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                // color: c.brownColor,
                              ),
                              width: mediaW / 1,
                              height: mediaH / 4,
                              // child: QrImage(
                              //     version: 6,
                              //     size: mediaW / 2,
                              //     errorCorrectionLevel: QrErrorCorrectLevel.M,
                              //     data: "$parcelCode"),
                            ),
                      Text(
                        (parcelCode == null) ? "" : '$parcelCode',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ],
                  ),
                  (parcelCode != null)
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: mediaW / 28,
                              vertical: defaultPadding),
                          child: WButton_Filled(() {
                            takeParcel();
                          },
                              Text("Ambil Parcel",
                                  style: TextStyle(color: c.whiteColor)),
                              context,
                              height: 14,
                              color: c.brownColor),
                        ),
                  Spacer()
                ],
              ),
            ),
    );
  }
}
