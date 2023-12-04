import 'package:shared_preferences/shared_preferences.dart';

class NetworkHandler {
  String? nToken,
      nUserId,
      nLongName,
      nStoreName,
      nPhoneNumber,
      nNip,
      nIsPhoneNumberVerified,
      nRole,
      nIsVerified,
      nAddress,
      nAddressId,
      nDateBirth;

  void savePref(
    String? nToken,
    String? nUserId,
    String? nLongName,
    String? nPhoneNumber,
    String? nNip,
    String? nIsPhoneNumberVerified,
    String? nRole,
    String? nIsVerified,
    String? nDateBirth,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("token", nToken ?? "");
    pref.setString("userId", nUserId ?? "");
    pref.setString("longName", nLongName ?? "");
    pref.setString("phoneNumber", nPhoneNumber ?? "");
    pref.setString("nip", nNip ?? "");
    pref.setString("isPhoneNumberVerified", nIsPhoneNumberVerified ?? "");
    pref.setString("role", nRole ?? "");
    pref.setString("isVerified", nIsVerified ?? "");
        pref.setString("dateBirth", nDateBirth ?? "");
  }

  void saveAddress(String? nAddress, nAddressId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("address", nAddress ?? "");
    prefs.setString("addressId", nAddressId ?? "");
  }

  void saveStoreName(String? nStoreName) async {
    SharedPreferences prefst = await SharedPreferences.getInstance();
    prefst.setString("storeName", nStoreName ?? "");
  }

  Future getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    nToken = pref.getString("token");
    nUserId = pref.getString("userId");
    nLongName = pref.getString("longName");
    nStoreName = pref.getString("storeName");
    nPhoneNumber = pref.getString("phoneNumber");
    nNip = pref.getString("nip");
    nIsPhoneNumberVerified = pref.getString("isPhoneNumberVerified");
    nRole = pref.getString("role");
    nIsVerified = pref.getString("isVerified");
    nAddress = pref.getString("address");
    nAddressId = pref.getString("addressId");
    nDateBirth = pref.getString("dateBirth");
    return nUserId;
  }

  Future clearSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}

final sessionManager = NetworkHandler();
