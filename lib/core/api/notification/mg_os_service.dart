// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/cupertino.dart';
// import 'package:panenin/core/api.dart';
// import 'package:panenin/core/network.dart';
// import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;

// Dio dio = Dio();

// class MgOSignal {
//   Future<String> getUserIdByPhoneNumber(
//       String phoneNumber, String userToken) async {
//     try {
//       Response res = await dio.get(
//           "$Api/users?where[phoneNumber]=$phoneNumber&select=id",
//           options: Options(
//               headers: {"Authorization": "Bearer $userToken"},
//               contentType: "application/json"));
//       return "${res.data[0]["id"]}";
//     } catch (e) {
//       debugPrint("Err trow: $e");
//       return "error";
//     }
//   }

//   Future<dynamic> getUserNotification(String id, String userToken) async {
//     var res = await http.post(
//         Uri(
//           scheme: "https",
//           host: Host,
//           path: "graphql",
//         ),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $userToken"
//         },
//         body: jsonEncode({
//           "query":
//               "query{notifications(where:{user:{id:\"$id\"}}), {id,title,type,body,isWithData,additionalData,createdAt}}"
//         }));
//     var resdata = jsonDecode(res.body);
//     return resdata;
//   }

//   Future<dynamic> switchPlayerReadNotif(
//       bool setIsRead, String phoneNumber, String userToken) async {
//     var resPlayerOSignalId = await http.post(
//         Uri(
//           scheme: "https",
//           host: Host,
//           path: "graphql",
//         ),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $userToken"
//         },
//         body: jsonEncode({
//           "query":
//               "query{oneSignalPlayers(where:{user:{phoneNumber:\"$phoneNumber\"}}),{id}}"
//         }));
//     var resPlayerOSignalIdData = jsonDecode(resPlayerOSignalId.body);
//     String _id = resPlayerOSignalIdData["data"]["oneSignalPlayers"][0]["id"];
//     Response resPatch = await dio.patch("$Api/oneSignalPlayer/$_id",
//         options: Options(
//             headers: {"Authorization": "Bearer $userToken"},
//             contentType: "application/json"),
//         data: {"isRead": setIsRead});
//   }

//   Future<bool> checkPlayerIsReadNotif(
//       String phoneNumber, String userToken) async {
//     var res = await http.post(
//         Uri(
//           scheme: "https",
//           host: Host,
//           path: "graphql",
//         ),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $userToken"
//         },
//         body: jsonEncode({
//           "query":
//               "query{oneSignalPlayers(where:{user:{phoneNumber:\"$phoneNumber\"}}),{isRead}}"
//         }));
//     var resdata = jsonDecode(res.body);
//     bool? _isRead = resdata["data"]["oneSignalPlayers"][0]["isRead"];
//     return _isRead ?? false;
//   }
// }
