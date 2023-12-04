import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/class/user_class.dart';
import 'package:kasanah_mobile/core/service/auth_service.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/screens/AuthStack/user_agreement_screen.dart';
import 'package:kasanah_mobile/screens/HomeStack/home_screen.dart';
import 'package:kasanah_mobile/screens/welcome_screen.dart';
import 'package:kasanah_mobile/widgets/WAlertDialog.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';
import 'package:kasanah_mobile/widgets/WForm.dart';
import 'package:kasanah_mobile/widgets/WGlobal.dart';
import 'package:kasanah_mobile/widgets/WNavigationBar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final TextEditingController _referralController = TextEditingController();
  TextEditingController _birthDate = TextEditingController();

  bool _isLoading = false;
  // bool _isAgree = false;

  bool _isPasswordObsecure = true;
  bool _isRepeatPasswordObsecure = true;

  final FocusNode _phoneNumberNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _nipNode = FocusNode();
  final FocusNode _birthDateNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _repeatPasswordNode = FocusNode();
  final FocusNode _referralNode = FocusNode();

  bool _isPhoneNumberErr = false;
  bool _isNameErr = false;
  bool _isNipErr = false;
  bool _isbirthDateErr = false;
  bool _isPasswordErr = false;
  bool _isRepeatPasswordErr = false;
  bool _isReferralErr = false;

  String _phoneNumberErrMsg = "";
  String _nameErrMsg = "";
  String _nipErrMsg = "";
  String _birthDateErrMsg = "";
  String _passwordErrMsg = "(Minimal 8 Karakter)";
  String _repeatPasswordErrMsg = "";
  String _referralErrMsg = "";

  final Uri _url = Uri.parse('https://kasanah.com/kebijakan-privasi');
  void _privacyPolicy({required String url}) async {
    (await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication));
  }

  bool validatePasswordLength(PUser u) {
    String p = u.password!;
    if (p.length < 8) {
      setState(() {
        _isPasswordErr = true;
        _passwordErrMsg = "Kata Sandi minimal memiliki 8 karakter";
      });
      return false;
    }
    return true;
  }

  bool validatePhoneNumberField(PUser u) {
    String n = u.phoneNumber!;
    bool isRegExp = RegExp("[0-9]").hasMatch(n);
    String idPhoneNumber = "08";
    bool validateRegion = ("${n[0]}${n[1]}" == idPhoneNumber);
    if (n.length < 8 ||
        isRegExp == false ||
        validateRegion == false ||
        n.length > 14) {
      setState(() {
        _isPhoneNumberErr = true;
        _phoneNumberErrMsg = "Mohon isi Nomor Telepon dengan benar";
      });
      return false;
    }
    return true;
  }

  bool validateEmptyField(PUser u) {
    String message = "tidak boleh kosong";
    if (u.phoneNumber == "") {
      setState(() {
        _isPhoneNumberErr = true;
        _phoneNumberErrMsg = "Nomor Telepon $message";
      });
      return false;
    }

    if (u.longName == "") {
      setState(() {
        _isNameErr = true;
        _nameErrMsg = "Nama $message";
      });
      return false;
    }
    if (u.password == "") {
      setState(() {
        _isPasswordErr = true;
        _passwordErrMsg = "Kata Sandi $message";
      });
      return false;
    }
    if (_repeatPasswordController.text == "") {
      setState(() {
        _isRepeatPasswordErr = true;
        _repeatPasswordErrMsg = "Ulangi Kata Sandi $message";
      });
      return false;
    }
    return true;
  }

  bool validatePassMatch() {
    String pass = _repeatPasswordController.text;
    String repPass = _passwordController.text;
    if (pass != repPass) {
      setState(() {
        _isPasswordErr = true;
        _isRepeatPasswordErr = true;
        _repeatPasswordErrMsg = "Password Tidak Sesuai";
        _passwordErrMsg = "Password Tidak Sesuai";
      });
      return false;
    }
    return true;
  }

  void resetValidation() {
    setState(() {
      _isPhoneNumberErr = false;
      _isNameErr = false;
      _isNipErr = false;
      _isPasswordErr = false;
      _isRepeatPasswordErr = false;
      _isReferralErr = false;
      _phoneNumberErrMsg = "";
      _nameErrMsg = "";
      _passwordErrMsg = "(Minimal 8 Karakter)";
      _repeatPasswordErrMsg = "";
      _referralErrMsg = "";
    });
  }

  DateTime? _selectedDate;
  String? _verificationDate;

  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(0),
      lastDate: DateTime.now(),
      builder: (context, picker) {
        return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.dark(
                primary: c.brownColor,
                surface: c.whiteColor,
                onPrimary: c.whiteColor,
                onSurface: c.brownColor,
              ),
            ),
            child: picker!);
      },
    );
    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _verificationDate = DateFormat.yMd("id_ID").format(_selectedDate!);
      _birthDate
        ..text = DateFormat.yMMMMEEEEd("id_ID").format(_selectedDate!)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _birthDate.text.length, affinity: TextAffinity.upstream));
    }
    // showDatePicker(
    //     context: context,
    //     initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
    //     firstDate: DateTime(2000),
    //     lastDate: DateTime(2040),
    //     builder: (BuildContext context, Widget child) {
    //       return Theme(
    //         data: ThemeData.dark().copyWith(
    //           colorScheme: ColorScheme.dark(
    //             primary: Colors.deepPurple,
    //             onPrimary: Colors.white,
    //             surface: Colors.blueGrey,
    //             onSurface: Colors.yellow,
    //           ),
    //           dialogBackgroundColor: Colors.blue[500],
    //         ),
    //         child: child,
    //       );
    //     });
    print(_verificationDate);
  }

  Future _proceed() async {
    setState(() {
      _isLoading = true;
    });

    String nP = _nipController.text;
    Map checkNp = await isNipExistService(nP);
    switch (checkNp["res"]) {
      case "is-exist":
        setState(() {
          _isLoading = false;
          _isNipErr = true;
          _nipErrMsg = "NIP Sudah Terdaftar";
        });
        // String thisUserId = checkNp["data"][0]["nip"];
        // if (mounted) {
        //   Navigator.push(
        //       context, MyRoute(builder: (context) => SignupScreen()));
        // }
        return;
    }
    PUser newUser = PUser(
      phoneNumber: _phoneNumberController.text,
      nip: _nipController.text,
      longName: _nameController.text,
      password: _passwordController.text,
      role: "authenticated",
    );

    resetValidation();
    bool isNextValidateEmptyField = validateEmptyField(newUser);
    if (isNextValidateEmptyField == false) {
      setState(() {
        _isLoading = false;
      });
      return null;
    }
    bool isNextValidatePhoneNumberField = validatePhoneNumberField(newUser);
    if (isNextValidatePhoneNumberField == false) {
      setState(() {
        _isLoading = false;
      });
      return null;
    }
    bool isValidatePasswordLength = validatePasswordLength(newUser);
    if (isValidatePasswordLength == false) {
      setState(() {
        _isLoading = false;
      });
      return null;
    }
    bool isNextValidatePassMatch = validatePassMatch();
    if (isNextValidatePassMatch == false) {
      setState(() {
        _isLoading = false;
      });
      return null;
    }
    Map isPhoneNumberExist =
        await isPhoneNumberExistService(newUser.phoneNumber!);
    if (await isPhoneNumberExist["res"] == "is-exist") {
      setState(() {
        _isPhoneNumberErr = true;
        _phoneNumberErrMsg = "Nomor Telepon sudah terdaftar";
        _isLoading = false;
      });
      return null;
    }
    register(newUser);
  }

  Future register(PUser newUser) async {
    String npP = _nipController.text;
    bool isVerified = false;
    Map checkNpP = await checkDataVerifiedMember(npP, _verificationDate ?? "");
    switch (checkNpP["res"]) {
      case "is-exist":
        setState(() {
          isVerified = true;
        });
    }
    Map signupUserRes =
        await signupService(newUser, isVerified, _selectedDate.toString());
    print(_selectedDate);
    setState(() {
      _isLoading = false;
    });
    print('ok 0');
    print(_selectedDate.toString());
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MyRoute(builder: (context) => WelcomeScreen()),
        (route) => false,
      );
      setState(() {
        showDialog(
          barrierColor: Colors.black26,
          context: context,
          builder: (context) {
            return WDialog_TextAlert(
                context, 'Register Berhasil', 'Silahkan Login');
          },
        );
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: WGlobal_AppBar_Stacked(
          context,
          "Daftar",
          fontSize: 14,
          isTransparent: true,
          leadButtonOnPressed: () {
            Navigator.pop(context);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(horizontal: mediaW / 22),
          child: WButton_Filled(
            () {
              _proceed();
            },
            _isLoading
                ? LoadingAnimationWidget.waveDots(
                    color: c.greenColor,
                    size: mediaW / 15,
                  )
                : Text("Daftar", style: TextStyle(color: c.whiteColor)),
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
                      child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mediaW / 18, vertical: mediaH / 26),
                child: SingleChildScrollView(
                  child: Column(children: [
                    WForm_Default("Nomor Telepon", "Ex: 08123456789",
                        _phoneNumberController,
                        readOnly: _isLoading,
                        isErr: _isPhoneNumberErr,
                        helperText: _phoneNumberErrMsg,
                        focusNode: _phoneNumberNode,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                        ],
                        prefix: Icon(
                          Icons.phone_android_rounded,
                          color: c.blackColor.withAlpha(185),
                        ),
                        context: context,
                        keyType: const TextInputType.numberWithOptions(),
                        onSubmitted: (val) {
                      FocusScope.of(context).requestFocus(_nameNode);
                    }),
                    WForm_Default("Nama", "John Doe", _nameController,
                        readOnly: _isLoading,
                        isErr: _isNameErr,
                        helperText: _nameErrMsg,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))
                        ],
                        focusNode: _nameNode,
                        keyType: TextInputType.name,
                        prefix: Icon(
                          Icons.person_outline_rounded,
                          color: c.blackColor.withAlpha(185),
                        ),
                        context: context, onSubmitted: (val) {
                      FocusScope.of(context).requestFocus(_nipNode);
                    }),
                    WForm_Default(
                        "Nomor Induk Pekerja", "1234567", _nipController,
                        readOnly: _isLoading,
                        isErr: _isNipErr,
                        helperText: _nipErrMsg,
                        keyType: TextInputType.number,
                        focusNode: _nipNode,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                        ],
                        prefix: Icon(
                          Icons.power_input_rounded,
                          color: c.blackColor.withAlpha(185),
                        ),
                        context: context, onSubmitted: (val) {
                      FocusScope.of(context).requestFocus(_birthDateNode);
                    }),
                    // WForm_Default('Tanggal Lahir', '2006-02-28', _birthDate),
                    WForm_Default(
                      "Tanggal Lahir",
                      "2006-02-28",
                      _birthDate,
                      readOnly: true,
                      isErr: _isbirthDateErr,
                      helperText: _birthDateErrMsg,
                      focusNode: _birthDateNode,
                      prefix: Icon(
                        Icons.date_range_outlined,
                        color: c.blackColor.withAlpha(185),
                      ),
                      context: context,
                      onTap: () {
                        _selectDate(context);
                      },
                    ),
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
                        FocusScope.of(context).requestFocus(_repeatPasswordNode);
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
                          FocusScope.of(context).requestFocus(_referralNode);
                        }),
                    // WForm_Default(
                    //     "Kode Referral", "Ex: KSN071122", _referralController,
                    //     // readOnly: _isLoading,
                    //     readOnly: true,
                    //     isErr: _isReferralErr,
                    //     helperText: _referralErrMsg,
                    //     focusNode: _referralNode,
                    //     prefix: Icon(
                    //       Icons.people_outline_rounded,
                    //       color: c.blackColor.withAlpha(185),
                    //     ),
                    //     context: context,
                    //     maxLength: 9, onSubmitted: (val) {
                    //   FocusScope.of(context).unfocus();
                    // }),
                    SizedBox(
                      width: mediaW,
                      child: Row(
                        children: [
                          // WForm_Checkbox(
                          //   (val) {
                          //     setState(() {
                          //       _isAgree = !_isAgree;
                          //     });
                          //   },
                          //   context,
                          //   value: _isAgree,
                          // ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dengan mendaftar di sini, kamu menyetujui",
                                style: TextStyle(
                                    color: c.greyColor, fontSize: mediaW / 28),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _privacyPolicy(url: "$_url");
                                    },
                                    child: Text(
                                      "Kebijakan Privasi",
                                      style: TextStyle(
                                          color: c.greenColor,
                                          fontSize: mediaW / 28,
                                          fontFamily: "Poppins",
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Text(
                                    " Kasanah.",
                                    style: TextStyle(
                                        color: c.greyColor,
                                        fontSize: mediaW / 28),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ), 
                  ]),
                )),
                    ),
            )));
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
