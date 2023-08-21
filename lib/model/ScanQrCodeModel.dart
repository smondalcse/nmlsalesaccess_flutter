import 'dart:convert';

ScanQrCodeModel scanQrCodeModelFromJson(String str) => ScanQrCodeModel.fromJson(json.decode(str));

String scanQrCodeModelToJson(ScanQrCodeModel data) => json.encode(data.toJson());

class ScanQrCodeModel {
  int? httpStatusCode;
  String? msg;
  bool? success;
  List<Datum>? data;

  ScanQrCodeModel({
    this.httpStatusCode,
    this.msg,
    this.success,
    this.data,
  });

  factory ScanQrCodeModel.fromJson(Map<String, dynamic> json) => ScanQrCodeModel(
    httpStatusCode: json["HttpStatusCode"],
    msg: json["Msg"],
    success: json["Success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "HttpStatusCode": httpStatusCode,
    "Msg": msg,
    "Success": success,
    "data": data != null ? List<dynamic>.from(data!.map((x) => x.toJson())) : [],
  };
}

class Datum {
  int? id;
  String? qrCode;
  String? mobileAppKey;
  String? loginEmpId;
  String? qrCodeDeviceInfoId;
  bool? status;
  String? entryDate;
  int? mobileBrowserHitcount;

  Datum({
    this.id,
    this.qrCode,
    this.mobileAppKey,
    this.loginEmpId,
    this.qrCodeDeviceInfoId,
    this.status,
    this.entryDate,
    this.mobileBrowserHitcount,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["ID"],
    qrCode: json["QRCode"],
    mobileAppKey: json["MobileAppKey"],
    loginEmpId: json["LoginEmpID"],
    qrCodeDeviceInfoId: json["QRCodeDeviceInfoID"],
    status: json["Status"],
    entryDate: json["EntryDate"],
    mobileBrowserHitcount: json["MobileBrowserHitcount"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "QRCode": qrCode,
    "MobileAppKey": mobileAppKey,
    "LoginEmpID": loginEmpId,
    "QRCodeDeviceInfoID": qrCodeDeviceInfoId,
    "Status": status,
    "EntryDate": entryDate,
    "MobileBrowserHitcount": mobileBrowserHitcount,
  };
}