import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiManager {
  static const String baseUrl = 'https://cs.nitolmotors.com.bd/appportal/api/nmlsalesaccess/';
  static const String methodLogin = '/login?';
  static const String methodOtpVerify = '/otpVerify?';
  static const String methodScanQRCode = '/scanQRCode?';
  static const String methodSaveMobileAppKey = '/saveMobileAppKey?';
  static const String methodSaveNewToken = '/saveNewToken?';
  static const String methodVersionCheck = '/VersionCheck?';

  static Future<http.Response> getLoginData(String params) async {
    final url = Uri.parse(baseUrl + methodLogin + params);
    print(url);
    final response = await http.post(url);
    return response;
  }

  static Future<http.Response> otpVerify(String params) async {
    final url = Uri.parse(baseUrl + methodOtpVerify + params);
    print(url);
    final response = await http.post(url);
    return response;
  }

  static Future<http.Response> scanQRCode(String params) async {
    final url = Uri.parse(baseUrl + methodScanQRCode + params);
    print(url);
    final response = await http.post(url);
    return response;
  }

  static Future<http.Response> saveMobileAppKey(String params) async {
    final url = Uri.parse(baseUrl + methodSaveMobileAppKey + params);
    print(url);
    final response = await http.post(url);
    return response;
  }

  static Future<http.Response> versionCheck(String params) async {
    final url = Uri.parse(baseUrl + methodVersionCheck + params);
    print(url);
    final response = await http.post(url);
    return response;
  }
}