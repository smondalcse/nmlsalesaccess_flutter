import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static SharedPreferencesUtil? _instance;
  SharedPreferences? _prefs;

  static const String PREF_EMPID = "empId";
  static const String PREF_PASSWORD = "password";
  static const String PREF_MOBILE = "mobile";
  static const String PREF_FULLNAME = "fullName";
  static const String PREF_DEVICEID = "deviceId";

  SharedPreferencesUtil._();

  static SharedPreferencesUtil get instance {
    _instance ??= SharedPreferencesUtil._();
    return _instance!;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setEmpId(String value) async {
    await _prefs?.setString(PREF_EMPID, value);
  }
  String? getEmpId() {
    return _prefs?.getString(PREF_EMPID);
  }

  Future<void> setPassword(String value) async {
    await _prefs?.setString(PREF_PASSWORD, value);
  }
  String? getPassword() {
    return _prefs?.getString(PREF_PASSWORD);
  }

  Future<void> setMobile(String value) async {
    await _prefs?.setString(PREF_MOBILE, value);
  }
  String? getMobile() {
    return _prefs?.getString(PREF_MOBILE);
  }

  Future<void> setFullName(String value) async {
    await _prefs?.setString(PREF_FULLNAME, value);
  }
  String? getFullName() {
    return _prefs?.getString(PREF_FULLNAME);
  }

  Future<void> setDeviceId(String value) async {
    await _prefs?.setString(PREF_DEVICEID, value);
  }
  String? getDeviceId() {
    return _prefs?.getString(PREF_DEVICEID);
  }
}
