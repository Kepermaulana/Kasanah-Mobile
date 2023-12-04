import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/class/user_class.dart';
import 'package:kasanah_mobile/core/service/auth_service.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/screens/welcome_screen.dart';
import 'package:kasanah_mobile/widgets/WAlertDialog.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';
import 'package:kasanah_mobile/widgets/WForm.dart';
import 'package:kasanah_mobile/widgets/WGlobal.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newRepeatPasswordController =
      TextEditingController();

  void disposalSystem() {
    setState(() {
      _isLoading = false;
      _isOldPasswordErr = false;
      _isNewPasswordErr = false;
      _isNewRepeatPasswordErr = false;
      _oldPasswordErrMsg = "";
      _newPasswordErrMsg = "(1 Huruf Besar, 1 Simbol, 8 Karakter)";
      _newRepeatPasswordErrMsg = "";
    });
  }

  bool _isLoading = false;
  bool _isOldPasswordObsecure = true;
  bool _isNewPasswordObsecure = true;
  bool _isNewRepeatPasswordObsecure = true;
  final FocusNode _oldPasswordNode = FocusNode();
  final FocusNode _newPasswordNode = FocusNode();
  final FocusNode _newRepeatPasswordNode = FocusNode();
  bool _isOldPasswordErr = false;
  bool _isNewPasswordErr = false;
  bool _isNewRepeatPasswordErr = false;
  String _oldPasswordErrMsg = "";
  String _newPasswordErrMsg = "(1 Huruf Besar, 1 Simbol, 8 Karakter)";
  String _newRepeatPasswordErrMsg = "";

  Future proceed() async {
    setState(() {
      _isLoading = true;
    });
    bool isValidated = validatePassMatch();
    if (isValidated == false) {
      setState(() {
        _isLoading = false;
      });
      return null;
    }
    bool isValidatePasswordLength =
        validatePasswordLength(_newPasswordController.text);
    if (isValidatePasswordLength == false) {
      setState(() {
        _isLoading = false;
      });
      return null;
    }
    setState(() {
      _isLoading = false;
    });
    String? getNewToken = await checkOldPassword(PUser(
        phoneNumber: sessionManager.nPhoneNumber,
        password: _oldPasswordController.text));
    if (getNewToken == null) {
      setState(() {
        _isLoading = false;
      });
      return null;
    }
    print(getNewToken);
    bool passwordChanged = await changePwWithOldPW(
        token: getNewToken,
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text);
    if (passwordChanged) {
      showDialog(
        context: context,
        builder: (context) {
          return WDialog_TextAlert(context, "Aksi Berhasil",
              "Kata Sandi berhasil diganti, silakan lakukan login ulang");
        },
      ).then((value) {
        sessionManager
            .clearSession()
            .then((value) => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const WelcomeScreen(),
                ),
                (route) => false));
      });
      return null;
    }
    showDialog(
      context: context,
      builder: (context) {
        return WDialog_TextAlert(context, "Aksi Gagal",
            "Kata Sandi gagal diganti, silakan lakukan kembali");
      },
    ).then((value) => Navigator.pop(context));

    return null;
  }

  bool validatePassMatch() {
    String pass = _newRepeatPasswordController.text;
    String repPass = _newPasswordController.text;
    if (pass != repPass && pass != "") {
      setState(() {
        _isNewPasswordErr = true;
        _isNewRepeatPasswordErr = true;
        _newPasswordErrMsg = "Kata Sandi tidak sesuai";
        _newRepeatPasswordErrMsg = "Kata Sandi tidak sesuai";
      });
      return false;
    }
    if (pass == repPass) {
      disposalSystem();
      return true;
    }
    return false;
  }

  bool validatePasswordLength(String p) {
    if (p.length < 8) {
      setState(() {
        _isNewPasswordErr = true;
        _newPasswordErrMsg = "Kata Sandi minimal memiliki 8 karakter";
      });
      return false;
    }
    return true;
  }

  Future<String?> checkOldPassword(PUser user) async {
    Map res = await signinService(user);
    if (res["res"] == "ok") return res["data"]["token"];
    setState(() {
      _isOldPasswordErr = true;
      _oldPasswordErrMsg = "Kata Sandi Lama tidak sesuai";
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: WGlobal_AppBar_Stacked(
        context,
        "Kata Sandi Baru",
        leadButtonOnPressed: () {
          Navigator.pop(context);
        },
      ),
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
              : Text("Lanjut", style: TextStyle(color: c.whiteColor)),
          context,
          isDisabled: _isLoading,
          height: 14,
          color: c.brownColor
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.transparent,
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Form(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WForm_Default(
                      "Kata Sandi Lama",
                      "********",
                      _oldPasswordController,
                      readOnly: _isLoading,
                      isErr: _isOldPasswordErr,
                      helperText: _oldPasswordErrMsg,
                      focusNode: _oldPasswordNode,
                      prefix: Icon(
                        Icons.lock_outline_rounded,
                        color: c.blackColor.withAlpha(185),
                      ),
                      // isPassword: false,
                      isPassword: true,
                      // obscureText: true,
                      obscureText: _isLoading ? true : _isOldPasswordObsecure,
                      obscureTextOnTap: () {
                        setState(() {
                          _isOldPasswordObsecure = !_isOldPasswordObsecure;
                        });
                      },
                      context: context,
                      onSubmitted: (val) {
                        disposalSystem();
                        FocusScope.of(context).requestFocus(_oldPasswordNode);
                      },
                    ),
                    WForm_Default(
                      "Kata Sandi Baru",
                      "********",
                      _newPasswordController,
                      readOnly: _isLoading,
                      isErr: _isNewPasswordErr,
                      helperText: _newPasswordErrMsg,
                      focusNode: _newPasswordNode,
                      prefix: Icon(
                        Icons.lock_outline_rounded,
                        color: c.blackColor.withAlpha(185),
                      ),
                      isPassword: true,
                      obscureText: _isLoading ? true : _isNewPasswordObsecure,
                      obscureTextOnTap: () {
                        setState(() {
                          _isNewPasswordObsecure = !_isNewPasswordObsecure;
                        });
                      },
                      context: context,
                      onSubmitted: (val) {
                        disposalSystem();
                        FocusScope.of(context)
                            .requestFocus(_newRepeatPasswordNode);
                      },
                    ),
                    WForm_Default(
                      "Ulangi Kata Sandi Baru",
                      "********",
                      _newRepeatPasswordController,
                      readOnly: _isLoading,
                      isErr: _isNewRepeatPasswordErr,
                      helperText: _newRepeatPasswordErrMsg,
                      focusNode: _newRepeatPasswordNode,
                      prefix: Icon(
                        Icons.lock_outline_rounded,
                        color: c.blackColor.withAlpha(185),
                      ),
                      isPassword: true,
                      obscureText:
                          _isLoading ? true : _isNewRepeatPasswordObsecure,
                      obscureTextOnTap: () {
                        setState(() {
                          _isNewRepeatPasswordObsecure =
                              !_isNewRepeatPasswordObsecure;
                        });
                      },
                      context: context,
                      onSubmitted: (val) {
                        disposalSystem();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
