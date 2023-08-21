import 'dart:convert';

VersionCheckModel versionCheckModelFromJson(String str) => VersionCheckModel.fromJson(json.decode(str));

String versionCheckModelToJson(VersionCheckModel data) => json.encode(data.toJson());

class VersionCheckModel {
  int? httpStatusCode;
  String? msg;
  bool? success;
  List<Datum>? data;

  VersionCheckModel({
    this.httpStatusCode,
    this.msg,
    this.success,
    this.data,
  });

  factory VersionCheckModel.fromJson(Map<String, dynamic> json) => VersionCheckModel(
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
  String? appName;
  String? versionCode;
  String? versionName;
  String? updateMessage;
  String? apkUpdateDate;
  String? action;

  Datum({
    this.id,
    this.appName,
    this.versionCode,
    this.versionName,
    this.updateMessage,
    this.apkUpdateDate,
    this.action,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["ID"],
    appName: json["AppName"],
    versionCode: json["VersionCode"],
    versionName: json["VersionName"],
    updateMessage: json["UpdateMessage"],
    apkUpdateDate: json["ApkUpdateDate"],
    action: json["Action"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "AppName": appName,
    "VersionCode": versionCode,
    "VersionName": versionName,
    "UpdateMessage": updateMessage,
    "ApkUpdateDate": apkUpdateDate,
    "Action": action,
  };
}
