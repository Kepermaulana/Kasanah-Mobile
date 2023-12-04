//import OneSignal
import 'package:flutter/cupertino.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:kasanah_mobile/core/api/network.dart';

import '../api.dart';
import 'mg_os_service.dart';

Dio dio = Dio();
MgOSignal mgos = MgOSignal();

class OSignal {
  Future<void> sendNotifByPhoneNumber(
      String phoneNumber, String title, String body, String sessionToken,
      {Map<String, dynamic>? data}) async {
    var res = await http.post(
        Uri(
          scheme: "https",
          host: Host,
          path: "graphql",
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $sessionToken"
        },
        body: jsonEncode({
          "query":
              "query{oneSignalPlayers(where:{user:{phoneNumber:\"$phoneNumber\"}}), {oSUserId}}"
        }));

    var resdata = jsonDecode(res.body);

    resdata = resdata["data"]["oneSignalPlayers"][0]["oSUserId"];

    await sendNotif(["$resdata"], title, body, data: data);
  }

  Future<void> sendNotif(List<String> playerIds, String title, String body,
      {Map<String, dynamic>? data}) async {
    OSCreateNotification createNotif = OSCreateNotification(
      playerIds: playerIds,
      heading: title,
      content: body,
      additionalData: data,
      androidSmallIcon: "@drawable/notif_image_lg",
    );
    OneSignal.shared.postNotification(createNotif);
    await mgos.switchPlayerReadNotif(
        false, sessionManager.nPhoneNumber!, sessionManager.nToken!);
  }

  Future<String> getPlayerId() async {
    final status = await OneSignal.shared.getDeviceState();
    return status!.userId!;
  }

  Future<dynamic> loginSubscribe(String userId) async {
    String playerId = await getPlayerId();
    bool isDeviceExist = await isThisDeviceOnDb(playerId);
    if (isDeviceExist == false) {
      Response res = await dio.post("$Api/oneSignalPlayers",
          options: Options(contentType: "application/json"),
          data: {"userId": userId, "oSUserId": playerId});

      if (res.statusCode! < 300) {
        String osSignalPostId = res.data["id"];
        return osSignalPostId;
      }
      return "FAILED";
    }
    if (isDeviceExist = true) {
      Response resGetOsId =
          await dio.get("$Api/oneSignalPlayers?where[oSUserId]=$playerId");
      if (resGetOsId.statusCode! < 300) {
        String osId = resGetOsId.data[0]["id"];
        Response resDel = await dio.delete("$Api/oneSignalPlayer/$osId");

        if (resDel.statusCode! < 300) {
          Response resCreate = await dio.post("$Api/oneSignalPlayers",
              options: Options(contentType: "application/json"),
              data: {"userId": userId, "oSUserId": playerId});
          String osSignalPostId = resCreate.data["id"];
          return osSignalPostId;
        }
      }
    }
  }

  Future<bool> isThisDeviceOnDb(String playerId) async {
    try {
      Response res = await dio.get(
          "$Api/oneSignalPlayers?where[oSUserId]=$playerId",
          options: Options(contentType: "application/json"));
      List data = res.data;
      if (data[0]["oSUserId"] != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<void> checkHasNotifAndRelog(
      String userId, String userToken, BuildContext context) async {
    try {
      Response res = await dio.get("$Api/user/$userId?select=oSUsers",
          options: Options(
              headers: {"Authorization": "Bearer $userToken"},
              contentType: "application/json"));

      if (res.statusCode! < 300) {
        dynamic oSUsers =
            (res.data["oSUsers"]?.length > 0) ? res.data["oSUsers"][0] : null;
        if (oSUsers != null) {
          // if exist
          debugPrint("OS Local Service: User a Player");
        }
        if (oSUsers == null) {
          // if not exist
          debugPrint("OS Local Service: User not a Player");

          sessionManager.clearSession();
        }
      }
    } catch (e) {
      debugPrint("err: $e");
    }
  }
}
