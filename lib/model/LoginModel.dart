import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  int? httpStatusCode;
  String? msg;
  bool? success;
  List<Datum>? data;

  LoginModel({
    this.httpStatusCode,
    this.msg,
    this.success,
    this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    httpStatusCode: json["HttpStatusCode"],
    msg: json["Msg"],
    success: json["Success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "HttpStatusCode": httpStatusCode,
    "Msg": msg,
    "Success": success,
    "data":data!= null ? List<dynamic>.from(data!.map((x) => x.toJson())) : [],
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
  String? deptName;
  String? desName;
  String? deviceName;
  String? msg;
  int? islogin;
  String? otp;
  int? error;

  Datum({
    this.fullName,
    this.userType,
    this.businessUnitId,
    this.empId,
    this.email,
    this.mobile,
    this.roleId,
    this.roleName,
    this.deptName,
    this.desName,
    this.deviceName,
    this.msg,
    this.islogin,
    this.otp,
    this.error,
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
    deptName: json["DeptName"],
    desName: json["DesName"],
    deviceName: json["DeviceName"],
    msg: json["Msg"],
    islogin: json["Islogin"],
    otp: json["OTP"],
    error: json["Error"],
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
    "DeptName": deptName,
    "DesName": desName,
    "DeviceName": deviceName,
    "Msg": msg,
    "Islogin": islogin,
    "OTP": otp,
    "Error": error,
  };
}