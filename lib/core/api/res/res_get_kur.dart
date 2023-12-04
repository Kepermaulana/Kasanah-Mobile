// To parse this JSON data, do
//
//     final resGetKur = resGetKurFromJson(jsonString);

import 'dart:convert';

ResGetKur resGetKurFromJson(String str) => ResGetKur.fromJson(json.decode(str));

String resGetKurToJson(ResGetKur data) => json.encode(data.toJson());

class ResGetKur {
  ResGetKur({
    this.data,
  });

  Data? data;

  factory ResGetKur.fromJson(Map<String, dynamic> json) => ResGetKur(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.kurs,
  });

  List<Kur>? kurs;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        kurs: List<Kur>.from(json["kurs"].map((x) => Kur.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "kurs": List<dynamic>.from(kurs!.map((x) => x.toJson())),
      };
}

class Kur {
  Kur(
      {this.id,
      this.noTlp,
      this.name,
      this.nominal,
      this.longWork,
      this.noKtp,
      this.address,
      this.farmAddress,
      this.uploadKtp,
      this.uploadSelfieKtp,
      this.uploadKepemilikan,
      this.uploadPg,
      this.uploadRab,
      this.uploadBookMarriage,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.noKur,
      this.accountBank,
      this.agriculture,
      this.comments,
      this.note,
      this.penyerahanBank});

  String? id;
  String? noTlp;
  String? name;
  int? nominal;
  int? longWork;
  String? noKtp;
  String? address;
  String? farmAddress;
  String? uploadKtp;
  String? uploadSelfieKtp;
  String? uploadKepemilikan;
  String? uploadPg;
  String? uploadRab;
  String? uploadBookMarriage;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? noKur;
  AccountBank? accountBank;
  Agriculture? agriculture;
  List<Comment>? comments;
  dynamic? note;
  PenyerahanBank? penyerahanBank;

  factory Kur.fromJson(Map<String, dynamic> json) => Kur(
        id: json["id"],
        noTlp: json["noTlp"],
        name: json["name"],
        nominal: json["nominal"],
        longWork: json["longWork"],
        noKtp: json["noKtp"],
        address: json["address"],
        farmAddress: json["farmAddress"],
        uploadKtp: json["uploadKtp"],
        uploadSelfieKtp: json["uploadSelfieKtp"],
        uploadKepemilikan: json["uploadKepemilikan"],
        uploadPg: json["uploadPG"],
        uploadRab: json["uploadRAB"],
        uploadBookMarriage: json["uploadBookMarriage"] == null
            ? null
            : json["uploadBookMarriage"],
        status: json["status"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        noKur: json["noKur"],
        accountBank: json["accountBank"] == null
            ? null
            : AccountBank.fromJson(json["accountBank"]),
        agriculture: json["agriculture"] == null
            ? null
            : Agriculture.fromJson(json["agriculture"]),
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
        note: json["note"],
        penyerahanBank: json["penyerahanBank"] == null
            ? null
            : PenyerahanBank.fromJson(json["penyerahanBank"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "noTlp": noTlp,
        "name": name,
        "nominal": nominal,
        "longWork": longWork,
        "noKtp": noKtp,
        "address": address,
        "farmAddress": farmAddress,
        "uploadKtp": uploadKtp,
        "uploadSelfieKtp": uploadSelfieKtp,
        "uploadKepemilikan": uploadKepemilikan,
        "uploadPG": uploadPg,
        "uploadRAB": uploadRab,
        "uploadBookMarriage":
            uploadBookMarriage == null ? null : uploadBookMarriage,
        "status": status,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "noKur": noKur,
        "accountBank": accountBank == null ? null : accountBank!.toJson(),
        "agriculture": agriculture == null ? null : agriculture!.toJson(),
        "comments": List<dynamic>.from(comments!.map((x) => x.toJson())),
        "note": note,
        "penyerahanBank":
            penyerahanBank == null ? null : penyerahanBank!.toJson()
      };
}

class AccountBank {
  AccountBank({
    this.id,
    this.bank,
    this.nomorRekening,
    this.nameRekening,
  });

  String? id;
  Bank? bank;
  String? nomorRekening;
  String? nameRekening;

  factory AccountBank.fromJson(Map<String, dynamic> json) => AccountBank(
        id: json["id"],
        bank: Bank.fromJson(json["bank"]),
        nomorRekening: json["nomorRekening"],
        nameRekening: json["nameRekening"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bank": bank!.toJson(),
        "nomorRekening": nomorRekening,
        "nameRekening": nameRekening,
      };
}

class Bank {
  Bank({
    this.name,
  });

  String? name;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class Agriculture {
  Agriculture({
    this.id,
    this.growth,
    this.large,
    this.comodity,
  });

  String? id;
  int? growth;
  double? large;
  Comodity? comodity;

  factory Agriculture.fromJson(Map<String, dynamic> json) => Agriculture(
        id: json["id"],
        growth: json["growth"],
        large: json["large"].toDouble(),
        comodity: Comodity.fromJson(json["comodity"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "growth": growth,
        "large": large,
        "comodity": comodity!.toJson(),
      };
}

class Comodity {
  Comodity({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Comodity.fromJson(Map<String, dynamic> json) => Comodity(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class PenyerahanBank {
  PenyerahanBank(
      {this.id,
      this.name,
      this.bank,
      this.cabang,
      this.imagePenerima,
      this.statusPenyerahan,
      this.namaPetugas});

  String? id;
  String? name;
  Bank? bank;
  String? cabang;
  String? imagePenerima;
  String? statusPenyerahan;
  String? namaPetugas;

  factory PenyerahanBank.fromJson(Map<String, dynamic> json) => PenyerahanBank(
      id: json["id"],
      name: json["name"],
      bank: Bank.fromJson(json["bank"]),
      cabang: json["cabang"],
      imagePenerima: json["imagePenerima"],
      statusPenyerahan: json["statusPenyerahan"],
      namaPetugas: json["namaPetugas"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "bank": bank!.toJson(),
        "cabang": cabang,
        "imagePenerima": imagePenerima,
        "statusPenyerahan": statusPenyerahan,
        "namaPetugas": namaPetugas
      };
}

class Comment {
  Comment({
    this.id,
    this.text,
    this.type,
  });

  String? id;
  String? text;
  String? type;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        text: json["text"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "type": type,
      };
}
