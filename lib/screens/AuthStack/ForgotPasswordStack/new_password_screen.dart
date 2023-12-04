import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/service/auth_service.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/screens/welcome_screen.dart';
import 'package:kasanah_mobile/widgets/WAlertDialog.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';
import 'package:kasanah_mobile/widgets/WForm.dart';
import 'package:kasanah_mobile/widgets/WTopAuth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class NewPasswordScreen extends StatefulWidget {
  NewPasswordScreen({super.key, required this.userId});
  String? userId;

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  bool _isLoading = false;

  bool _isPasswordObsecure = true;
  bool _isRepeatPasswordObsecure = true;

  final FocusNode _passwordNode = FocusNode();
  final FocusNode _repeatPasswordNode = FocusNode();

  bool _isPasswordErr = false;
  bool _isRepeatPasswordErr = false;

  String _passwordErrMsg = "(1 Huruf Besar, 1 Simbol, 8 Karakter)";
  String _repeatPasswordErrMsg = "";

  Future proceed() async {
    setState(() {
      _isLoading = true;
    });
    bool isValidatePasswordLength =
        validatePasswordLength(_passwordController.text);
    if (isValidatePasswordLength == false) {
      setState(() {
        _isLoading = false;
      });
      return null;
    }
    bool isValidated = validatePassMatch();
    if (isValidated == false) {
      setState(() {
        _isLoading = false;
      });
      return null;
    }
    bool passwordChanged = await changePwWithUserId(
        userId: widget.userId!, newPassword: _passwordController.text);
    if (passwordChanged) {
      showDialog(
        context: context,
        builder: (context) {
          return WDialog_TextAlert(context, "Aksi Berhasil",
              "Kata Sandi berhasil diganti, silakan lakukan login ulang");
        },
      ).then((value) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
          (route) => false));
      return null;
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return WDialog_TextAlert(context, "Aksi Gagal",
              "Kata Sandi gagal diganti, silakan lakukan kembali");
        },
      ).then((value) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
          (route) => false));
      return null;
    }
  }

  void disposalSystem() {
    setState(() {
      _isLoading = false;
      _isPasswordErr = false;
      _isRepeatPasswordErr = false;
      _passwordErrMsg = "(1 Huruf Besar, 1 Simbol, 8 Karakter)";
      _repeatPasswordErrMsg = "";
    });
  }

  bool validatePassMatch() {
    String pass = _repeatPasswordController.text;
    String repPass = _passwordController.text;
    if (pass != repPass) {
      setState(() {
        _isPasswordErr = true;
        _isRepeatPasswordErr = true;
        _passwordErrMsg = "Kata Sandi Tidak Sesuai";
        _repeatPasswordErrMsg = "Kata Sandi Tidak Sesuai";
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
        _isPasswordErr = true;
        _passwordErrMsg = "Kata Sandi minimal memiliki 8 karakter";
      });
      return false;
    }
    return true;
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
            proceed();
          },
          _isLoading
              ? LoadingAnimationWidget.waveDots(
                size: mediaW / 15,
                  color: c.greenColor,
                )
              : Text("Ganti", style: TextStyle(color: c.whiteColor)),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: mediaH / 30,
                    ),
                    Center(
                      child: Text(
                        'Kata Sandi Baru',
                        style: TextStyle(
                          color: c.blackColor,
                          fontWeight: FontWeight.w500,
                          fontSize: mediaW / 14,
                        ),
                      ),
                    ),
                    SizedBox(height: mediaW / 14),
                    WForm_Default(
                      "Kata Sandi",
                      "********",
                      _passwordController,
                      readOnly: _isLoading,
                      isErr: _isPasswordErr,
                      helperText: _passwordErrMsg,
                      focusNode: _passwordNode,
                      prefix: Icon(
                        Icons.lock_outline_rounded,
                        color: c.blackColor.withAlpha(185),
                      ),
                      isPassword: true,
                      obscureText: _isLoading ? true : _isPasswordObsecure,
                      obscureTextOnTap: () {
                        setState(() {
                          _isPasswordObsecure = !_isPasswordObsecure;
                        });
                      },
                      context: context,
                      onSubmitted: (val) {
                        disposalSystem();
                        FocusScope.of(context)
                            .requestFocus(_repeatPasswordNode);
                      },
                    ),
                    WForm_Default("Ulangi Kata Sandi", "********",
                        _repeatPasswordController,
                        readOnly: _isLoading,
                        isErr: _isRepeatPasswordErr,
                        helperText: _repeatPasswordErrMsg,
                        focusNode: _repeatPasswordNode,
                        prefix: Icon(
                          Icons.lock_outline_rounded,
                          color: c.blackColor.withAlpha(185),
                        ),
                        isPassword: true,
                        obscureText:
                            _isLoading ? true : _isRepeatPasswordObsecure,
                        obscureTextOnTap: () {
                          setState(() {
                            _isRepeatPasswordObsecure =
                                !_isRepeatPasswordObsecure;
                          });
                        },
                        context: context,
                        onSubmitted: (val) {
                          disposalSystem();
                          FocusScope.of(context).unfocus();
                        }),
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
