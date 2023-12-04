import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;

// ignore: non_constant_identifier_names
Expanded WSearchBar(int flex, TextEditingController controller,
    VoidCallback onPressed, String hintText, BuildContext context) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return Expanded(
    flex: flex,
    child: Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(15),
      child: TextFormField(
        cursorColor: c.blackColor,
        controller: controller,
        autofocus: false,
        style: TextStyle(
          fontSize: mediaW / 32,
        ),
        decoration: InputDecoration(
          isDense: true,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.search,
              size: 20,
              color: c.blackColor,
            ),
          ),
          suffixIconConstraints:
              const BoxConstraints(maxHeight: 35, minWidth: 30),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    ),
  );
}
