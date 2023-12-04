import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/screens/MyStoreStack/my_product_screen.dart';

Widget WButton_BackArrowCircle(
    void Function() onPressed, BuildContext context) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return CircleAvatar(
    radius: (context != null) ? mediaH / 32 : 25,
    backgroundColor: c.greenColor,
    child: IconButton(
      onPressed: onPressed,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      icon: Icon(
        Icons.arrow_back,
        size: (context != null) ? mediaH / 32 : 25,
        color: c.whiteColor,
      ),
    ),
  );
}

// Panenin: Button Filled
Widget WButton_Filled(void Function() onPressed, child, BuildContext context,
    {double width = 1,
    double height = 12,
    double fontSize = 16,
    Color color = const Color(0xffffffff),
    bool isDisabled = false}) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;

  return ElevatedButton(
    child: child,
    onPressed: isDisabled ? () {} : onPressed,
    style: ButtonStyle(
      visualDensity: VisualDensity.comfortable,
      elevation: MaterialStateProperty.all<double>(5),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(mediaW / (defaultPadding + 26)),
      )),
      textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: c.whiteColor,
          fontFamily: 'Poppins')),
      foregroundColor: MaterialStateProperty.all<Color>(c.whiteColor),
      backgroundColor:
          MaterialStateProperty.all<Color>(isDisabled ? c.greyColor : color),
      fixedSize: MaterialStateProperty.all<Size?>(
          Size(mediaW / width, mediaH / height)),
    ),
  );
}

// Panenin: Button Outlined
Widget WButton_Outlined(void Function() onPressed, child, BuildContext context,
    {double width = 1,
    double height = 12,
    Color bgColor = const Color(0xFF855434),
    Color borderColor = const Color(0xffffffff),
    double fontSize = 16,
    bool isDisabled = false}) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return OutlinedButton(
      child: child,
      onPressed: isDisabled ? () {} : onPressed,
      style: OutlinedButton.styleFrom(
        elevation: 5,
        backgroundColor: bgColor,
        foregroundColor: borderColor,
        textStyle: TextStyle(
          fontSize: fontSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        side: BorderSide(color: borderColor, width: 2),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(mediaW / (defaultPadding + 26))),
        fixedSize: Size(mediaW / width, mediaH / height),
      ));
}

// ignore: non_constant_identifier_names
Stack WActionButton(
    Icon icon, Color color, double width, double height, BuildContext context,
    {int? qty, bool isNotify = false, VoidCallback? onPressed}) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return Stack(children: [
    SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16))),
          onPressed: onPressed ?? () {},
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                0, defaultPadding / 2.2, 0, defaultPadding / 2.2),
            child: icon,
          )),
    ),
    Positioned(
        right: 10,
        top: 1,
        child: () {
          if (!isNotify) {
            return Container();
          } else {
            String _text = qty.toString();
            if (qty == null) {
              _text = "";
            } else if (qty >= 1000) {
              _text = "999+";
            }
            return Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Text(
                _text,
                style: TextStyle(
                    color: c.whiteColor,
                    fontSize: mediaW / 48,
                    fontWeight: FontWeight.bold),
              ),
            );
          }
        }())
  ]);
}

SizedBox WFilterButton(BuildContext context) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return SizedBox(
    width: mediaW / 5,
    height: 20,
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: c.whiteColor,
            foregroundColor: c.greyColor.withAlpha(500),
            elevation: 0,
            side: BorderSide(width: 0.3, color: c.greyColor)),
        onPressed: () {},
        child: Row(
          children: [
            Icon(
              Icons.filter_list_rounded,
              size: 13,
              color: c.greyColor,
            ),
            const Spacer(),
            Text(
              'Filter',
              style: TextStyle(fontSize: 12, color: c.greyColor),
            )
          ],
        )),
  );
}

Container WButton_Store(
    BuildContext context, String url, String title, VoidCallback onPressed) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return Container(
    height: mediaH / 10,
    width: mediaW / 3.5,
    child: Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Colors.transparent,
              ),
              backgroundColor: c.whiteColor),
          onPressed: onPressed,
          child: SvgPicture.asset(
            url,
            color: c.brown2Color,
            width: 40,
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 11, color: c.brown2Color),
        )
      ],
    ),
  );
}
