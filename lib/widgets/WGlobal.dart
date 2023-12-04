import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';

import 'WButton.dart';

PreferredSizeWidget WGlobal_AppBar_Stacked(BuildContext context, String title,
    {double fontSize = 18,
    bool isTransparent = true,
    void Function()? leadButtonOnPressed}) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return AppBar(
    toolbarHeight: mediaH / 10,
    elevation: isTransparent ? 0 : null,
    backgroundColor:
        (isTransparent) ? c.greenColor.withOpacity(0) : c.greenColor,
    leadingWidth: mediaW / 4.5,
    leading: (isTransparent == true)
        ? SizedBox(
            width: mediaW,
            child: Row(children: [
              SizedBox(
                width: mediaW / 18,
              ),
              WButton_BackArrowCircle(
                leadButtonOnPressed ?? () {},
                context,
              ),
            ]),
          )
        : null,
    title: SizedBox(
        child: Text(
      title,
      textAlign: TextAlign.center,
    )),
    titleTextStyle: TextStyle(
      color: isTransparent ? c.blackColor.withAlpha(220) : c.whiteColor,
      fontWeight: FontWeight.w500,
      fontSize: mediaW / fontSize,
      fontFamily: "Poppins",
    ),
  );
}
