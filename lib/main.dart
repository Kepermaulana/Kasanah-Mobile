import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:kasanah_mobile/core/api/api.dart';
import 'package:kasanah_mobile/core/style/My_Theme.dart';
import 'package:kasanah_mobile/core/style/Theme_Manager.dart';
import 'package:flutter/material.dart';
import 'package:kasanah_mobile/screens/splash_screen.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/widgets/WNavigationBar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // OneSignal.shared.setAppId(oneSignalAppId);

  // OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
  //   print("Accepted permission: $accepted");
  // });
  runApp(const MyApp());
}

ThemeManager _themeManager = ThemeManager();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    _themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: c.whiteColor, statusBarBrightness: Brightness.dark));
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/home": (context) => WNavigationBar(),
        "/splash": (context) => GlobalSplashScreen()
      },
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeManager.themeMode,
      home: const GlobalSplashScreen(),
    );
  }
}
