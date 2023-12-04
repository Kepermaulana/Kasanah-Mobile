import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';

Widget WForm_Default(
    String title, String hintText, TextEditingController controller,
    {dynamic context,
    int? maxLength,
    bool obscureText = false,
    bool isPassword = false,
    bool isErr = false,
    String? helperText,
    Widget? suffix,
    Widget? prefix,
    VoidCallback? onTap,
    List<TextInputFormatter>? inputFormatter,
    onSubmitted,
    onChanged,
    obscureTextOnTap,
    TextInputType? keyType,
    FocusNode? focusNode,
    bool readOnly = false}) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return TextField(
      controller: controller,
      readOnly: readOnly,
      maxLength: maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      keyboardType: (keyType != null) ? keyType : null,
      onChanged: (onChanged != null)
          ? (value) {
              onChanged(value);
            }
          : (value) {},
      onSubmitted: (onSubmitted != null)
          ? (value) {
              onSubmitted(value);
            }
          : (value) {},
      obscureText: obscureText,
      onTap: onTap,
      inputFormatters: inputFormatter,
      focusNode: (focusNode != null) ? focusNode : null,
      style: TextStyle(
          color: c.blackColor.withAlpha(225),
          fontSize: mediaW / 28,
          fontWeight: FontWeight.w500),
      cursorColor: c.greenColor,
      decoration: InputDecoration(
        label: Text(title),
        floatingLabelStyle: TextStyle(
          color: (isErr) ? c.redColor : c.greenColor,
        ),
        helperText: (helperText != null) ? helperText : null,
        helperStyle: TextStyle(color: (isErr) ? c.redColor : null),
        prefixIcon: (prefix) ?? prefix,
        suffix: (isPassword)
            ? GestureDetector(
                onTap: obscureTextOnTap,
                child: Icon(
                  (obscureText)
                      ? Icons.remove_red_eye_outlined
                      : Icons.remove_red_eye_rounded,
                  color: c.blackColor.withAlpha(225),
                ),
              )
            : suffix,
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: c.greenColor, width: 2)),
        hintText: hintText,
        hintStyle: TextStyle(
            letterSpacing: 1,
            fontWeight: FontWeight.w400,
            fontSize: mediaW / 28),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: (isErr) ? c.redColor : c.greyColor, width: 1.5)),
      ));
}

DropdownButtonFormField WForm_DropdownField(
  BuildContext context,
  String label,
  dynamic value,
  ValueChanged<dynamic> onChanged,
  List<dynamic> items, {
  String? helperText,
  dynamic categoryValue,
  bool isErr = false,
}) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return DropdownButtonFormField(
    focusColor: c.greenColor,
    icon: Icon(
      Icons.arrow_drop_down_rounded,
      color: (isErr) ? c.redColor : c.greyColor,
    ),
    decoration: InputDecoration(
        border: UnderlineInputBorder(
            borderSide: BorderSide(
                width: 2, color: (isErr) ? c.redColor : c.greenColor)),
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(width: 1.5, color: (isErr) ? c.redColor : c.greyColor),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(width: 1.5, color: (isErr) ? c.redColor : c.greyColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(width: 2, color: (isErr) ? c.redColor : c.greenColor),
        ),
        labelText: label,
        helperText: (helperText != null) ? helperText : null,
        helperStyle: TextStyle(color: (isErr) ? c.redColor : c.greyColor),
        labelStyle: TextStyle(
            color: (isErr) ? c.redColor : c.greenColor,
            fontFamily: 'Poppins',
            fontSize: mediaW / 28,
            fontWeight: FontWeight.w500)),
    value: value,
    onChanged: onChanged,
    items: items.map<DropdownMenuItem<String>>((dynamic val) {
      return DropdownMenuItem<String>(
        value: val,
        child: Text(
          val,
          style: TextStyle(
              color: c.blackColor.withAlpha(225),
              fontSize: mediaW / 28,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500),
        ),
      );
    }).toList(),
  );
}

Widget WForm_Checkbox(
  void Function(dynamic val) onChanged,
  BuildContext context, {
  bool value = false,
  double borderRadius = 4,
}) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return Checkbox(
    value: value,
    onChanged: ((val) {
      onChanged(val);
    }),
    activeColor: c.brownColor,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
  );
}
