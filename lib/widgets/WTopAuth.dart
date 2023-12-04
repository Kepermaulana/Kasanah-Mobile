import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';

class WTopAuth extends StatelessWidget {
  const WTopAuth({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double mediaW = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        SvgPicture.asset('assets/images/top_auth.svg', width: mediaW),
        Positioned(
          top: 120,
          left: 7,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: c.greenColor,
                elevation: 0,
                padding: const EdgeInsets.all(defaultPadding)),
            child: const Icon(
              Icons.arrow_back_outlined,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
