import 'dart:convert';

import 'package:kasanah_mobile/core/api/network.dart';
import "package:nanoid/nanoid.dart" as nanoid;
import 'package:kasanah_mobile/core/api/api.dart';
import 'package:kasanah_mobile/core/worker/StringWorker.dart';

import 'package:kasanah_mobile/core/class/user_class.dart';

import 'package:http/http.dart' as http;

Future<Map> signinService(PUser user) async {
  try {
    var res = await http.post(Uri.parse(kMgAuthLoginWallet),
        body: jsonEncode({
          "email": "${user.email ?? user.phoneNumber}@notvierra.ied",
          "password": "${user.password}"
        }),
        headers: {"Content-Type": "application/json"});
    switch (res.statusCode) {
      // res => invalid login || wrong password || wrong phonenumber
      case 401:
        return {"res": "invalid login"};
      case 400:
        return {"res": "invalid login"};
      // login success, token acquired
      case 200:
        var b = jsonDecode(res.body);

        return {
          "res": "ok",
          "data": {
            "token": b["token"],
            "userId": b["user"]["_id"],
            "longName": b["user"]["longName"],
            "phoneNumber": b["user"]["phoneNumber"],
            "isPhoneNumberVerified": b["user"]["isPhoneNumberVerified"],
            "role": b["user"]["role"],
            "nip": b["user"]["nip"],
            "isVerified": b["user"]["isVerified"],
            "storeName": b["user"]["storeName"],
            "dateBirth": b["user"]["dateBirth"]
          }
        };
    }
  } catch (e) {
    return {
      "res": "service-error",
      "data": {"error": e}
    };
  }

  return {"res": "api-error"};
}

Future<Map> signupService(
    PUser newUser, bool isVerified, String birthDate) async {
  try {
    String longName = newUser.longName!.toTitleCase();
    String firstName = longName.split(' ')[0].toTitleCase();
    String nip = newUser.nip.toString();
    String email = "${newUser.phoneNumber}@notvierra.ied";
    String id = nanoid.customAlphabet("1234567890", 7);
    String refId = "KSN$id";

    var body = jsonEncode({
      "firstName": firstName,
      "longName": longName,
      "nip": nip,
      "password": newUser.password,
      "email": email,
      "isVerified": isVerified,
      "phoneNumber": newUser.phoneNumber,
      "isPhoneNumberVerified": true,
      "dateBirth": birthDate,
      "refId": refId,
      "foreignRefId":
          (newUser.foreignRefId == "") ? null : newUser.foreignRefId,
    });
    var res = await http.post(Uri.parse(kMgAuthRegister), body: body);
    int s = res.statusCode;
    switch (s) {
      case 200:
        var b = jsonDecode(res.body);
        // bool isPatchDone = await _signupPatchToDefault(b["user"]["_id"]);
        if (b) {
          return {
            "res": "ok",
          };
        }
        return {
          "res": "api-err",
        };
      case 400:
        return {
          "res": "signup-err",
        };
      case 409:
        return {
          "res": "email-registered",
        };
    }
  } catch (e) {
    return {
      "res": "service-error",
      "data": {"error": e}
    };
  }
  return {"res": "api-error"};
}

Future<bool> _signupPatchToDefault(String userId) async {
  try {
    var body = jsonEncode({
      "isEmailVerified": false,
      "role": ["authenticated"],
    });
    var res = await http.patch(Uri.parse("$kMgApi/Users/$userId"), body: body);
    int s = res.statusCode;
    if (s < 300) return true;
  } catch (e) {
    return false;
  }
  return false;
}

Future<Map> isPhoneNumberExistService(String phoneNumber) async {
  try {
    String p = phoneNumber;
    String url = "$kMgApi/Users?\$lookup=*&phoneNumber=$p";
    var res = await http.get(Uri.parse(url));
    var b = jsonDecode(res.body);
    bool isExist = (b.length > 0) ? true : false;
    switch (isExist) {
      case true:
        return {"res": "is-exist", "data": b};
      case false:
        return {
          "res": "not-exist",
        };
    }
  } catch (e) {
    return {
      "res": "service-error",
      "data": {"error": e}
    };
  }
  return {"res": "api-error"};
}

Future<Map> isNipExistService(String nip) async {
  try {
    String n = nip;
    String url = "$kMgApi/Users?\$lookup=*&nip=$n";
    var res = await http.get(Uri.parse(url));
    var b = jsonDecode(res.body);
    bool isExist = (b.length > 0) ? true : false;
    switch (isExist) {
      case true:
        return {"res": "is-exist", "data": b};
      case false:
        return {
          "res": "not-exist",
        };
    }
  } catch (e) {
    return {
      "res": "service-error",
      "data": {"error": e}
    };
  }
  return {"res": "api-error"};
}

Future<Map> checkDataVerifiedMember(String nip, String birthDateVerif) async {
  try {
    String naip = nip;
    String url =
        "$kMgApi/verifiedMember?nip=$naip&tanggalLahir=$birthDateVerif";
    var res = await http.get(Uri.parse(url));
    var c = jsonDecode(res.body);
    bool isExist = (c.length > 0) ? true : false;
    switch (isExist) {
      case true:
        return {"res": "is-exist", "data": c};
      case false:
        return {"res": "not-exist"};
    }
  } catch (e) {
    return {
      "res": "service-error",
      "data": {"error": e}
    };
  }
  return {"res": "api-error"};
}

Future<bool> patchToPhoneVerified(String userId) async {
  try {
    var body = jsonEncode({
      "isPhoneNumberVerified": true,
      "role": ["farmer"]
    });
    var res = await http.patch(Uri.parse("$kMgApi/Users/$userId"), body: body);
    int s = res.statusCode;
    if (s < 300) return true;
  } catch (e) {
    return false;
  }
  return false;
}

Future<bool> changePwWithOldPW(
    {required String oldPassword,
    required String newPassword,
    required String token}) async {
  try {
    // auth/change-password
    var body =
        jsonEncode({"oldPassword": oldPassword, "newPassword": newPassword});
    Uri url = Uri.parse("$kMgAuth/change-password");
    var res = await http.post(url, body: body, headers: {
      "Authorization": "Bearer $token",
      "content-type": "application/json"
    });
    int s = res.statusCode;
    if (s < 300) return true;
  } catch (e) {
    return false;
  }
  return false;
}

Future<bool> changePwWithUserId(
    {required String userId, required String newPassword}) async {
  try {
    var body = jsonEncode({"password": newPassword});
    Uri url = Uri.parse("$kMgApi/Users/$userId");
    var res = await http
        .patch(url, body: body, headers: {"content-type": "application/json"});
    int s = res.statusCode;
    if (s < 300) return true;
  } catch (e) {
    return false;
  }

  return false;
}

Future<Map> postAddress(String address, String nUserId) async {
  try {
    String cToken = sessionManager.nToken!;
    var body = ({"address": address, "user": nUserId});
    var res = await http.post(
      Uri.parse('$kMgApi/address'),
      body: body,
      headers: {
        'Authorization': 'Bearer $cToken',
      },
    );
    int s = res.statusCode;
    switch (s) {
      case 200:
        var b = jsonDecode(res.body);
        // bool isPatchDone = await _signupPatchToDefault(b["user"]["_id"]);
        if (b) {
          return {
            "res": "ok",
          };
        }
        return {
          "res": "api-err",
        };
      case 400:
        return {
          "res": "signup-err",
        };
    }
  } catch (e) {
    return {
      "res": "service-error",
      "data": {"error": e}
    };
  }

  return {"res": "api-error"};
}
