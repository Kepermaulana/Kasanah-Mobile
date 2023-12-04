import 'package:flutter/material.dart';

const defaultPadding = 18.0;
const defaultDuration = Duration(seconds: 1);

class MyRoute extends MaterialPageRoute {
  MyRoute({builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 600);
}
