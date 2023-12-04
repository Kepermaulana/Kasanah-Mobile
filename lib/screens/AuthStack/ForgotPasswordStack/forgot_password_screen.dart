import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/service/auth_service.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/screens/AuthStack/ForgotPasswordStack/new_password_screen.dart';
import 'package:kasanah_mobile/screens/welcome_screen.dart';
import 'package:kasanah_mobile/widgets/WAlertDialog.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';
import 'package:kasanah_mobile/widgets/WForm.dart';
import 'package:kasanah_mobile/widgets/WTopAuth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({super.key, this.phoneNumber});
  String? phoneNumber;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  bool _isLoading = false;
  final FocusNode _phoneNumberNode = FocusNode();
  bool _isPhoneNumberErr = false;
  String _phoneNumberErrMsg = "";

  void disposalSystem() {
    _isPhoneNumberErr = false;
    _phoneNumberErrMsg = "";
    _isLoading = false;
  }

  void validateField(String pH) {
    bool isRegExp = RegExp("[0-9]").hasMatch(pH);
    String idPhoneNumber = "08";

    if (pH.isEmpty) {
      setState(() {
        _isLoading = false;
        _isPhoneNumberErr = true;
        _phoneNumberErrMsg = "Nomor Handphone tidak boleh kosong";
      });
      return;
    }
    bool validateRegion = ("${pH[0]}${pH[1]}" == idPhoneNumber);
    if (pH.length < 8 ||
        isRegExp == false ||
        validateRegion == false ||
        pH.length > 14) {
      setState(() {
        _isLoading = false;
        _isPhoneNumberErr = true;
        _phoneNumberErrMsg = "Mohon isi Nomor Telepon dengan benar";
      });
      return;
    }
  }

  Future proceed() async {
    setState(() {
      _isLoading = true;
    });
    String pH = _phoneNumberController.text;
    validateField(pH);
    Map checkPh = await isPhoneNumberExistService(pH);
    switch (checkPh["res"]) {
      case "is-exist":
        String thisUserId = checkPh["data"][0]["_id"];
        if (mounted) {
          Navigator.push(
              context,
              MyRoute(
                  builder: (context) => NewPasswordScreen(userId: thisUserId)));
        }
        return;
      case "not-exist":
        setState(() {
          _isLoading = false;
          _isPhoneNumberErr = true;
          _phoneNumberErrMsg = "Nomor Telepon tidak ditemukan";
        });
        return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return WDialog_TextAlert(context, "Aksi Gagal",
            "Sedang terjadi kesalahan, silakan lakukan kembali");
      },
    ).then((value) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
        (route) => false));
  }

  @override
  void initState() {
    super.initState();
    _phoneNumberController.text = widget.phoneNumber ?? "";
  }

  @override
  Widget build(BuildContext context) {
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: mediaW / 22),
        child: WButton_Filled(
          () async {
            await proceed();
          },
          _isLoading
              ? LoadingAnimationWidget.waveDots(
                size: mediaW / 15,
                  color: c.greenColor,
                )
              : Text("Selanjutnya", style: TextStyle(color: c.whiteColor)),
          context,
          isDisabled: _isLoading,
          height: 14,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Container(
          color: Colors.transparent,
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const WTopAuth(),
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 45),
                    child: Text(
                      'Lupa Kata Sandi?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 28),
                    child: Text(
                      'Masukkan nomor Handphone yang anda gunakan saat mendaftar',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(height: mediaW / 14),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: WForm_Default("Nomor Telepon", "Ex: 08123456789",
                        _phoneNumberController,
                        readOnly: _isLoading,
                        isErr: _isPhoneNumberErr,
                        helperText: _phoneNumberErrMsg,
                        focusNode: _phoneNumberNode,
                        prefix: Icon(
                          Icons.phone_android_rounded,
                          color: c.blackColor.withAlpha(185),
                        ),
                        context: context,
                        keyType: const TextInputType.numberWithOptions(),
                        onSubmitted: (val) {
                      disposalSystem();
                      FocusScope.of(context).unfocus();
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
