
import 'dart:convert';

OtpVerifyModel otpVerifyModelFromJson(String str) => OtpVerifyModel.fromJson(json.decode(str));

String otpVerifyModelToJson(OtpVerifyModel data) => json.encode(data.toJson());

class OtpVerifyModel {
  int? httpStatusCode;
  String? msg;
  bool? success;
  List<Datum>? data;

  OtpVerifyModel({
    this.httpStatusCode,
    this.msg,
    this.success,
    this.data,
  });

  factory OtpVerifyModel.fromJson(Map<String, dynamic> json) => OtpVerifyModel(
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
  String? fullName;
  String? userType;
  int? businessUnitId;
  String? empId;
  String? email;
  String? mobile;
  int? roleId;
  String? roleName;

  Datum({
    this.fullName,
    this.userType,
    this.businessUnitId,
    this.empId,
    this.email,
    this.mobile,
    this.roleId,
    this.roleName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    fullName: json["FullName"],
    userType: json["UserType"],
    businessUnitId: json["BusinessUnitID"],
    empId: json["EmpID"],
    email: json["Email"],
    mobile: json["Mobile"],
    roleId: json["RoleID"],
    roleName: json["RoleName"],
  );

  Map<String, dynamic> toJson() => {
    "FullName": fullName,
    "UserType": userType,
    "BusinessUnitID": businessUnitId,
    "EmpID": empId,
    "Email": email,
    "Mobile": mobile,
    "RoleID": roleId,
    "RoleName": roleName,
  };
}
