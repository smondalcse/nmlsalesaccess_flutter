import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:nmlsalesaccess/model/user_info_model.dart';
import 'package:nmlsalesaccess/pages/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import '../model/login_model.dart';
import '../network/api_manager.dart';
import '../others/helper.dart';
import '../others/shared_preferences_util.dart';
import 'otp_screen.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  Helper helper = Helper();
  final _empID = TextEditingController();
  final _password = TextEditingController();
  bool _passwordVisible = true;
  String deviceName = "";

  // static const String PREF_EMPID = "empId";
  // static const String PREF_PASSWORD = "password";

  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

  Future login() async {
    if (_empID.text.toString().trim().isEmpty) {
      helper.showToast("Enter Employee ID.", context);
      return;
    }
    if (_password.text.toString().trim().isEmpty) {
      helper.showToast("Enter Sales Password.", context);
      return;
    }
  //  final identifier = await getDeviceDetails();
    final deviceInfo = await helper.getDeviceDetails();
    deviceName = deviceInfo[0];
    _fetchLoginData(_empID.text.toString().trim(), _password.text.toString().trim(), deviceInfo[2]);
  }
/*
  Future<String> getDeviceDetails() async {

    String deviceVersion = "", identifier = "";

    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if(Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = "${build.brand} ${build.model}";
        deviceVersion = build.version.toString();
        identifier = build.androidId;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor;
      }
    } on PlatformException {
      helper.printStatement('Failed to get platform information');
    }

    return identifier;
  }
*/
  Future<void> _fetchLoginData(String empID, String pass, String deviceID) async {

    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        helper.showToast("No internet connection found.", context);
        return;
      }

      String params = "EmpID=$empID&Password=$pass&DeviceID=$deviceID";
      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator(
              color: Colors.blueAccent,
              backgroundColor: Colors.deepPurpleAccent,
            ));
          });
      final response = await ApiManager.getLoginData(params);
      if (response.statusCode == 200) {
        var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
        helper.printStatement(jsonResponse);
        LoginModel userModel = LoginModel.fromJson(jsonResponse);

        if (userModel.success == true) {
          if (userModel.data?.first.islogin == 1){
            Navigator.of(context).pop();

            UserInfoModel userInfo = UserInfoModel(empId: _empID.text.toString().trim());
            userInfo.fullName = userModel.data?.first.fullName;
            userInfo.email = userModel.data?.first.email;
            userInfo.mobile = userModel.data?.first.mobile;
            userInfo.deviceName = deviceName;
            userInfo.deviceId = deviceID;
            userInfo.dept = userModel.data?.first.deptName;
            userInfo.design = userModel.data?.first.desName;

            saveIntoSharedPreference(_empID.text.toString().trim(), _password.text.toString().trim(), userInfo.fullName!, userInfo.mobile!, userInfo.deviceId!);

            if (userModel.data?.first.otp == "true") {

              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OTPScreen(userInfo: userInfo),
                ),
              );
            } else {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(userInfo: userInfo),
                ),
              );
            }
          } else {
            Navigator.of(context).pop();
            String? msg = userModel.data?.first.msg.toString();
            helper.showToast(msg!, context);
          }
        } else {
          // helper.printStatement(userModel.msg);
          Navigator.of(context).pop();
          helper.showToast(userModel.msg!, context);
        }
      } else {
        helper.printStatement('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      helper.showToast("Error occurred.", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 25,178,238),
                        Color.fromARGB(255, 21,236,229)
                      ],
                    )),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 50,),
                          Image.asset( 'images/app_icon.png',
                            height: 100,
                            width: 100,),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "NML Sales Access",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _empID,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.indigo),
                                    borderRadius:
                                    BorderRadius.circular(12)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.deepPurple),
                                    borderRadius:
                                    BorderRadius.circular(12)),
                                hintText: 'Emp ID',
                                fillColor: Colors.white,
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.only(top: 15, bottom: 15), /// add padding to adjust icon
                                  child: Icon(Icons.lock),
                                ),
                                filled: true),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                              obscureText: _passwordVisible,
                              controller: _password,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      const BorderSide(color: Colors.indigo),
                                      borderRadius: BorderRadius.circular(12)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.deepPurple),
                                      borderRadius: BorderRadius.circular(12)),
                                  hintText: 'Sales Password',
                                  fillColor: Colors.white,
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(top: 15, bottom: 15), // add padding to adjust icon
                                    child: Icon(Icons.person),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                  filled: true)),
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: () {
                              login();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(17),
                              decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Center(
                                child: Text('Login',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveIntoSharedPreference(String empId, String password, String fullName, String mobile, String deviceId) async {
    await SharedPreferencesUtil.instance.init();
    SharedPreferencesUtil.instance.setEmpId(empId);
    SharedPreferencesUtil.instance.setPassword(password);
    SharedPreferencesUtil.instance.setFullName(fullName);
    SharedPreferencesUtil.instance.setMobile(mobile);
    SharedPreferencesUtil.instance.setDeviceId(deviceId);
  }

  void getSharedPref() async {
    await SharedPreferencesUtil.instance.init();
    String empId = SharedPreferencesUtil.instance.getEmpId() ?? "";
    String password = SharedPreferencesUtil.instance.getPassword() ?? "";
    _empID.text = empId;
    _password.text = password;
  }
}

