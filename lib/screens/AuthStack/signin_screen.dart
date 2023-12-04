import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kasanah_mobile/core/api/api.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/service/auth_service.dart';
import 'package:kasanah_mobile/core/service/onesignal_service.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/screens/AuthStack/ForgotPasswordStack/forgot_password_screen.dart';
import 'package:kasanah_mobile/screens/HomeStack/home_screen.dart';
import 'package:kasanah_mobile/screens/ProfileStack/profile_screen.dart';
import 'package:kasanah_mobile/screens/welcome_screen.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';
import 'package:kasanah_mobile/widgets/WForm.dart';
import 'package:kasanah_mobile/widgets/WGlobal.dart';
import 'package:kasanah_mobile/widgets/WNavigationBar.dart';
import 'package:kasanah_mobile/widgets/WTopAuth.dart';
import 'package:http/http.dart' as http;

import 'package:kasanah_mobile/core/class/user_class.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordObsecure = true;

  final FocusNode _phoneNumberNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  bool _isPhoneNumberErr = false;
  bool _isPasswordErr = false;

  String _phoneNumberErrMsg = "";
  String _passwordErrMsg = "";

  bool validateForm(String phoneNumber, String password) {
    resetValidation();
    if (phoneNumber == "" || phoneNumber.isEmpty) {
      setState(() {
        _isPhoneNumberErr = true;
        _phoneNumberErrMsg = "Nomor telepon tidak boleh kosong";
      });
      return false;
    }
    if (password == "" || password.isEmpty) {
      setState(() {
        _isPasswordErr = true;
        _passwordErrMsg = "Kata sandi tidak boleh kosong";
      });
      return false;
    }
    return true;
  }

  void resetValidation() {
    setState(() {
      _isPhoneNumberErr = false;
      _isPasswordErr = false;
      _phoneNumberErrMsg = "";
      _passwordErrMsg = "";
    });
  }

  Future _proceed() async {
    setState(() {
      _isLoading = true;
    });
    resetValidation();
    bool isNext =
        validateForm(_phoneNumberController.text, _passwordController.text);
    if (isNext == false) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    PUser newLogin = PUser(
      email: _phoneNumberController.text,
      phoneNumber: _phoneNumberController.text,
      password: _passwordController.text,
    );
    var signIn = await signinService(newLogin);
    String signInResponse = await signIn["res"];

    switch (signInResponse) {
      case "ok":
        var d = await signIn["data"];
        bool? isPhVerif = d["isPhoneNumberVerified"];
        if (isPhVerif == false || isPhVerif == null) {
          if (mounted) {
            Navigator.push(
                context, MyRoute(builder: (context) => WelcomeScreen()));
          }
        } else {
          String _userId = sessionManager.nUserId ?? "";
          String _token = sessionManager.nToken ?? "";
          DateTime lastLogin = DateTime.now().subtract(Duration(hours: 7));
          try {
            var body = jsonEncode({"lastLogin": lastLogin.toIso8601String()});
            var res = await http.patch(Uri.parse("$kMgApi/Users/$_userId"),
                body: body,
                headers: {
                  "Authorization": "Bearer $_token",
                  "content-type": "application/json"
                });
            int s = res.statusCode;
            print(res.body);
            print(res.statusCode);
            if (s < 300) {
              print("ok");
            }
            ;
          } catch (e) {
            print(e);
          }
          setState(() {
            sessionManager.savePref(
                d["token"],
                d["userId"],
                d["longName"],
                d["phoneNumber"],
                d["nip"].toString(),
                d["isPhoneNumberVerified"].toString(),
                d["role"][0],
                d["isVerified"].toString(),
                d["dateBirth"]);
            sessionManager.saveStoreName(d["storeName"]);
            Navigator.pushReplacement(
              context,
              MyRoute(builder: (context) => WNavigationBar()),
            );
          });
          // await subscribeUserAfterLogin(d["userId"]);
        }
        break;
      case "invalid login":
        setState(() {
          _isPhoneNumberErr = true;
          _isPasswordErr = true;
          _isLoading = false;
          _passwordErrMsg = "Nomor Telepon tidak ditemukan / Kata Sandi Salah";
        });
        break;
      case "signin-error":
        break;
      case "api-error":
        break;
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(horizontal: mediaW / 22),
          child: WButton_Filled(
            () {
              _proceed();
            },
            _isLoading
                ? LoadingAnimationWidget.waveDots(
                    size: mediaW / 15,
                    color: c.greenColor,
                  )
                : Text("Masuk", style: TextStyle(color: c.whiteColor)),
            context,
            isDisabled: _isLoading,
            color: c.brownColor,
            height: 14,
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Column(
              children: [
                const WTopAuth(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: mediaW / 18, vertical: mediaH / 26),
                  child: Column(children: [
                    SizedBox(
                      width: mediaW,
                      child: Text(
                        "Masuk",
                        style: TextStyle(
                            color: c.blackColor.withAlpha(200),
                            fontWeight: FontWeight.w600,
                            fontSize: mediaW / 18),
                      ),
                    ),
                    SizedBox(
                      height: mediaH / 40,
                    ),
                    SizedBox(
                      width: mediaW,
                      child: Text(
                        "Selamat Datang!",
                        style: TextStyle(
                            color: c.greyColor,
                            fontWeight: FontWeight.w500,
                            fontSize: mediaW / 26),
                      ),
                    ),
                    SizedBox(
                      height: mediaH / 42,
                    ),
                    WForm_Default("Nomor Telepon", "Ex: 08123456789",
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
                      resetValidation();
                      FocusScope.of(context).requestFocus(_passwordNode);
                    }),
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
                        resetValidation();
                        resetValidation();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    /* Hide (Lupa Kata Sandi) until OTP features ready! */
                    // SizedBox(
                    //     width: mediaW,
                    //     child: TextButton(
                    //         onPressed: () {
                    //           Navigator.push(
                    //               context,
                    //               MyRoute(
                    //                   builder: (_) => ForgotPasswordScreen(
                    //                         phoneNumber:
                    //                             _phoneNumberController.text,
                    //                       )));
                    //         },
                    //         child: Text(
                    //           "Lupa Kata Sandi?",
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //               color: c.greenColor,
                    //               fontSize: mediaW / 32,
                    //               fontFamily: "Poppins",
                    //               decoration: TextDecoration.underline,
                    //               fontWeight: FontWeight.w500),
                    //         ))),
                  ]),
                ),
              ],
            ),
          ),
        )));
  }
}
