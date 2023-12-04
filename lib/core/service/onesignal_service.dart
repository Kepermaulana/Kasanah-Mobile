import 'dart:convert';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:kasanah_mobile/core/api/api.dart';

Future<String> getPlayerId() async {
  final status = await OneSignal.shared.getDeviceState();
  return status!.userId!;
}

Future<bool> subscribeUserAfterLogin(String userId) async {
  try {
    var body = jsonEncode({"oneSignalPlayerId": await getPlayerId()});
    var res = await http.patch(Uri.parse("$mgApi/Users/$userId"), body: body);
    int s = res.statusCode;
    if (s < 300) return true;
  } catch (e) {
    return false;
  }
  return false;
}

Future<bool> isPlayerIdMatchWithDb(String userId) async {
  try {
    var res = await http.get(Uri.parse("$mgApi/Users/$userId"));
    if (res.statusCode < 300) {
      var b = jsonDecode(res.body);
      String thisPlayerId = await getPlayerId();
      if (b["oneSignalPlayerId"] == thisPlayerId) return true;
    }
  } catch (e) {
    return false;
  }
  return false;
}
