import 'package:flutter/material.dart';
import 'Colors.dart' as c;

ThemeData lightTheme = ThemeData(
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColorLight: c.greenColor,
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: c.greenColor.withAlpha(300),
      selectionHandleColor: c.greenColor,
    ),
    hoverColor: c.blackColor,
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: c.greenColor)),
    scaffoldBackgroundColor: c.whiteColor,
    primaryColor: c.greenColor,
    appBarTheme: AppBarTheme(
      backgroundColor: c.greenColor,
    ),
    snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.whiteColor,
        actionTextColor: c.greenColor,
        contentTextStyle: TextStyle(
          color: c.blackColor,
          fontFamily: "Poppins",
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    }),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: c.greenColor));

ThemeData darkTheme = ThemeData(brightness: Brightness.dark);

class ZoomSlideUpTransitionsBuilder extends PageTransitionsBuilder {
  const ZoomSlideUpTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _ZoomSlideUpTransitionsBuilder(
        routeAnimation: animation, child: child);
  }
}

class _ZoomSlideUpTransitionsBuilder extends StatelessWidget {
  _ZoomSlideUpTransitionsBuilder({
    Key? key,
    required Animation<double> routeAnimation,
    required this.child,
  })  : _scaleAnimation = CurvedAnimation(
          parent: routeAnimation,
          curve: Curves.easeIn,
        ),
        super(key: key);

  final Animation<double> _scaleAnimation;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _scaleAnimation, child: child);
  }
}
