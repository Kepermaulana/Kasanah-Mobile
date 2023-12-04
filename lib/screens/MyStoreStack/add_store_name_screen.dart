import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/api/api.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/screens/ProfileStack/profile_screen.dart';
import 'package:kasanah_mobile/widgets/WAlertDialog.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';
import 'package:kasanah_mobile/widgets/WForm.dart';
import 'package:http/http.dart' as http;
import 'package:kasanah_mobile/widgets/WNavigationBar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AddStoreNameScreen extends StatefulWidget {
  const AddStoreNameScreen({super.key});

  @override
  State<AddStoreNameScreen> createState() => _AddStoreNameScreenState();
}

class _AddStoreNameScreenState extends State<AddStoreNameScreen> {
  TextEditingController cStore = TextEditingController();
  bool _isLoading = false;

  Future<Map> _proceed() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String cToken = sessionManager.nToken!;
      String cUserId = sessionManager.nUserId!;
      var body = jsonEncode({
        "storeName": cStore.text,
      });
      var res = await http.patch(
        Uri.parse('$kMgApi/Users/$cUserId'),
        body: body,
        headers: {
          'Authorization': 'Bearer $cToken',
        },
      );
      int s = res.statusCode;
      print(s);
      switch (s) {
        case 200:
          var b = jsonDecode(res.body);
          print(b);
          setState(() {
            _isLoading = false;
          });
          setState(() {
            Navigator.push(
                context,
                MyRoute(
                  builder: (_) => WNavigationBar(),
                ));
            sessionManager.saveStoreName(b["storeName"]);
            print(sessionManager.nStoreName);
            showDialog(
              context: context,
              builder: (context) {
                return WDialog_TextAlert(context,
                    "Menambahkan Nama Toko Berhasil", "Selamat Berjualan");
              },
            );
          });
          // bool isPatchDone = await _signupPatchToDefault(b["user"]["_id"]);
          if (b) {
            return {
              "res": "ok",
            };
          }
          return {
            "res": "api-err",
          };
        case 400:
          return {
            "res": "signup-err",
          };
      }
    } catch (e) {
      return {
        "res": "service-error",
        "data": {"error": e}
      };
    }

    return {"res": "api-error"};
  }

  @override
  Widget build(BuildContext context) {
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
          'Nama Toko',
          style: TextStyle(color: c.blackColor),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: WForm_Default('Nama Toko', 'Masukkan Nama Toko', cStore,
                    context: context),
              ),
              WButton_Filled(
                () {
                  _proceed();
                },
                _isLoading
                    ? LoadingAnimationWidget.waveDots(
                      size: MediaQuery.of(context).size.width / 15,
                        color: c.greenColor,
                      )
                    : Text("Simpan", style: TextStyle(color: c.whiteColor)),
                context,
                isDisabled: _isLoading,
                color: c.brownColor,
                height: 14,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: Text("*Nama Toko Hanya Dapat Didaftarkan 1 Kali dan Tidak Bisa Diedit", style: TextStyle(
                  color: c.redColor
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
