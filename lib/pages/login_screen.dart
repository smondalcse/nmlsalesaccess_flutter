import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nmlsalesaccess/model/user_info_model.dart';
import 'package:nmlsalesaccess/pages/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import '../model/login_model.dart';
import '../network/api_manager.dart';
import 'otp_screen.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _empID = TextEditingController();
  final _password = TextEditingController();
  bool _passwordVisible = true;
  String deviceName = "";

  @override
  void initState() {
    // TODO: implement initState
  //  setPrefValue();
    super.initState();
  }

  setPrefValue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState((){
      String empid = pref.getString('empid')!;
      String password = pref.getString('password')!;
    });

  }

  Future login() async {
    if (_empID.text.toString().trim().isEmpty) {
      showToast("Enter Employee ID.", context);
      return;
    }
    if (_password.text.toString().trim().isEmpty) {
      showToast("Enter Sales Password.", context);
      return;
    }
    final identifier = await getDeviceDetails();
    _fetchLoginData(_empID.text.toString().trim(), _password.text.toString().trim(), identifier);
  }

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
      print('Failed to get platform information');
    }

    return identifier;
  }

  Future<void> _fetchLoginData(String empID, String pass, String deviceID) async {

    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        showToast("No internet connection found.", context);
        return;
      }

      String params = "EmpID=$empID&Password=$pass&DeviceID=$deviceID";
      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
      final response = await ApiManager.getLoginData(params);
      if (response.statusCode == 200) {
        var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
        print(jsonResponse);
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

            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setString('empid', _empID.text.toString().trim());
            pref.setString('password', _password.text.toString().trim());

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
            showToast(msg!, context);
          }
        } else {
          // print(userModel.msg);
          Navigator.of(context).pop();
          showToast(userModel.msg!, context);
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      showToast("Error occurred.", context);
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
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Center(
                                child: Text('Login',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
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
}

void showToast(String msg, BuildContext context) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.indigo,
      textColor: Colors.white,
      fontSize: 13.0);
}
