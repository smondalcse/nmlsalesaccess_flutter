import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nmlsalesaccess/model/scan_qr_code_model.dart';
import 'package:nmlsalesaccess/model/version_check_model.dart';
import 'package:nmlsalesaccess/pages/qr_code_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/save_mobile_app_key_model.dart';
import '../model/user_info_model.dart';
import 'dart:io';
import 'dart:convert' as convert;
import '../network/api_manager.dart';
import '../others/helper.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.userInfo}) : super(key: key);

  late UserInfoModel userInfo;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _name = "",
      _empID = "",
      _mobile = "",
      _design = "",
      _dept = "",
      _activeDevice = "";

  Helper helper = Helper();

  @override
  void initState() {
    super.initState();
    checkVersion();
    setParamsValues();
  }

  setParamsValues() async {
    setState(() {
      _name = widget.userInfo.fullName!;
      _empID = widget.userInfo.empId!;
      _mobile = widget.userInfo.mobile!;
      _design = widget.userInfo.design!;
      _dept = widget.userInfo.dept!;
      _activeDevice = widget.userInfo.deviceName!;
    });
  }

  Future qrcodeScan() async {
    try {

      //String scanResult = await

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => QrCodeScreen(userInfo: widget.userInfo)),
      // );

      var cameraStatus = await Permission.camera.status;
      if (cameraStatus.isGranted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QrCodeScreen(userInfo: widget.userInfo)),
        );
      } else {
        var isGrant = await Permission.camera.request();
        if (isGrant.isGranted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QrCodeScreen(userInfo: widget.userInfo)),
          );
        }
      }
    } catch (error) {
      helper.showToast("Error occurred.");
    }
  }

  Future openNMLSalesInWeb(String? url) async {
    try {
      final Uri uri = Uri.parse(url!);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch Sale Software.');
      }
    } catch (error) {
      helper.showToast("Error occurred.");
    }
  }

  Future<void> saveMobileAppKey() async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        helper.showToast("No internet connection found.");
        return;
      }

      const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      Random _rnd = Random();
      String getRandomString(int length) =>
          String.fromCharCodes(Iterable.generate(
              length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

      final mobileAppKey = getRandomString(30);

      final deviceInfo = await helper.getDeviceDetails();
      final identifier = deviceInfo[2];
      String? empID = widget.userInfo.empId;
      String params =
          "EmpID=$empID&Mobileappkey=$mobileAppKey&deviceID=$identifier";
      final response = await ApiManager.saveMobileAppKey(params);
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        helper.printStatement(jsonResponse);
        SaveMobileAppKeyModel saveMobileAppKeyModel =
            SaveMobileAppKeyModel.fromJson(jsonResponse);

        if (saveMobileAppKeyModel.success != true) {
          helper.showToast(saveMobileAppKeyModel.msg!);
        } else {
          openNMLSalesInWeb(saveMobileAppKeyModel.data?.first.salesUrl);
        }
      } else {
        helper.printStatement('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      helper.showToast("Error occurred.");
    }
  }

  Future checkVersion() async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        helper.showToast("No internet connection found.");
        return;
      }

      const appName = "NMLSalesAccess", version = "1.5";
      String params = "AppName=$appName&Version=$version";
      final response = await ApiManager.versionCheck(params);
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        helper.printStatement(jsonResponse);
        VersionCheckModel versionCheckModel =
            VersionCheckModel.fromJson(jsonResponse);
        if (versionCheckModel.success == true) {
          helper.showToast("Please Update your app.");
        }
      } else {
        helper.printStatement('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      helper.showToast("Error occurred.");
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
                    Color.fromARGB(255, 25, 178, 238),
                    Color.fromARGB(255, 21, 236, 229)
                  ],
                )),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Image.asset(
                          'images/app_icon.png',
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "NML Sales Access",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                            child: Container(
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color.fromARGB(204, 255, 255, 255),
                                        Color.fromARGB(255, 229, 255, 255),
                                      ],
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          const Text("Name"),
                                          const Text(":"),
                                          const SizedBox(width: 5),
                                          Text(_name)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text("Emp ID"),
                                          const Text(":"),
                                          const SizedBox(width: 5),
                                          Text(_empID)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text("Mobile"),
                                          const Text(":"),
                                          const SizedBox(width: 5),
                                          Text(_mobile)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text("Desig"),
                                          const Text(":"),
                                          const SizedBox(width: 5),
                                          Text(_design)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text("Dept"),
                                          const Text(":"),
                                          const SizedBox(width: 5),
                                          Text(_dept)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text("Active Device"),
                                          const Text(":"),
                                          const SizedBox(width: 5),
                                          Text(_activeDevice)
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => qrcodeScan(),
                          child: SizedBox(
                            height: 130,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 10, 30, 10),
                              child: Container(
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.lightBlueAccent,
                                        Colors.blueAccent
                                      ],
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          30, 0, 0, 0),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        child: Image.asset(
                                          'images/qr_code.png',
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    const Text(
                                      "Scan Qr Code",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => saveMobileAppKey(),
                          child: SizedBox(
                            height: 130,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 10, 30, 10),
                              child: Container(
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.lightBlueAccent,
                                        Colors.blueAccent
                                      ],
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          30, 0, 0, 0),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        child: Image.asset(
                                          'images/web.png',
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "NML Sales",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          "Open Sales in web",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}