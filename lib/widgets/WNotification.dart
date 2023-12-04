import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';

Widget WNotification_Default(BuildContext context, String title, String body,
    String type, String formatedTime,
    {bool isWithData = false, Map<String, dynamic>? data}) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  String _notifTitle = "-";
  dynamic? _notifIcon;
  switch (type) {
    case "T":
      _notifTitle = "Transaksi";
      _notifIcon = Icons.shopping_bag_rounded;
      break;
    case "P":
      _notifTitle = "Pendanaan";
      _notifIcon = Icons.credit_card_rounded;
      break;
    case "A":
      _notifTitle = "Pengumuman";
      _notifIcon = Icons.announcement_rounded;
      break;
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mediaW / 48, vertical: mediaH / 72),
            child: Icon(
              _notifIcon,
              color: c.greenColor,
            ),
          ),
          Text(
            _notifTitle,
            style: GreenStyle(),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(right: mediaW / 48),
            child: Text(
              formatedTime,
              style: GreenStyle(),
            ),
          )
        ],
      ),
      Padding(
        padding: EdgeInsets.only(left: mediaW / 10),
        child: Text(title,
            style: TextStyle(
              color: c.blackColor,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 12,
            )),
      ),
      Padding(
        padding: EdgeInsets.only(left: mediaW / 10, bottom: mediaH / 72),
        child: Text(
          body,
          style: NormalStyle(),
        ),
      ),
      isWithData
          ? Container(
              padding: EdgeInsets.only(right: 8, bottom: mediaH / 72),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text(
                      data?["info"].toString() ?? "",
                      style: NormalStyle(),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Detail',
                      style: TextStyle(
                          color: c.greenColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          fontFamily: 'Poppins'),
                    ),
                  ),
                ],
              ),
            )
          : Container(),
      Divider(
        color: c.greyColor,
      ),
    ],
  );
}

TextStyle NormalStyle() {
  return TextStyle(
    color: c.blackColor,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    fontSize: 12,
  );
}

TextStyle GreenStyle() {
  return TextStyle(
    color: c.greenColor,
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}
