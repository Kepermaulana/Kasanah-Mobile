import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:shimmer/shimmer.dart';
import '../core/style/Colors.dart' as c;

GridView WSkeletonLoadings(BuildContext context) {
  int timer = 800, offset = 0;
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: mediaW, childAspectRatio: 3),
      itemCount: 8,
      itemBuilder: (BuildContext ctx, index) {
        offset += 50;
        timer = 800 + offset;
        print(timer);
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: mediaH / 100),
          child: Shimmer.fromColors(
            baseColor: c.greyColor,
            highlightColor: Colors.white,
            period: Duration(milliseconds: timer),
            child: box(context),
          ),
        );
      });
}

Widget box(BuildContext context) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return Container(
    decoration: BoxDecoration(
        color: c.greyColor.withAlpha(300),
        borderRadius: BorderRadius.circular(6)),
    height: 100,
    width: mediaW,
  );
}
