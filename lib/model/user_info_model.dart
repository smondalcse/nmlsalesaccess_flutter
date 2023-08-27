import 'dart:convert';

class UserInfoModel {
  String? empId;
  String? fullName;
  String? email;
  String? mobile;
  String? deviceName;
  String? deviceId;
  String? dept;
  String? design;

  UserInfoModel({
    required this.empId,
    this.fullName,
    this.email,
    this.mobile,
    this.deviceName,
    this.deviceId,
    this.dept,
    this.design,
  });
}
