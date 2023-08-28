import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nmlsalesaccess/model/login_model.dart';
import 'package:nmlsalesaccess/model/user_info_model.dart';
import 'dart:convert' as convert;
import '../model/otp_verify_model.dart';
import '../network/api_manager.dart';
import '../others/helper.dart';
import 'home_screen.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({Key? key, required this.userInfo}) : super(key: key);
  late UserInfoModel userInfo;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _otpTextField = TextEditingController();
  Helper helper = Helper();

  Future otpVerify() async {
    if (_otpTextField.text.toString().trim().isEmpty) {
      helper.showToast("Enter OTP.", context);
      return;
    }
    _otpVerifyData(widget.userInfo.empId.toString(), _otpTextField.text.toString().trim(), widget.userInfo.deviceId.toString(), widget.userInfo.deviceName.toString());
  }

  Future<void> _otpVerifyData(String? empID, String otp, String deviceID, String deviceName) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none){
      helper.showToast("No internet connection found.", context);
      return;
    }
    String params = "EmpID=$empID&Otp=$otp&DeviceID=$deviceID&DeviceName=$deviceName";
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator(
            color: Colors.blueAccent,
            backgroundColor: Colors.deepPurpleAccent,
          ));
        });
    final response = await ApiManager.otpVerify(params);
    if (response.statusCode == 200) {
      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      helper.printStatement(jsonResponse);
      OtpVerifyModel otpVerifyModel = OtpVerifyModel.fromJson(jsonResponse);
      if (otpVerifyModel.success == true) {
        Navigator.of(context).pop();

        UserInfoModel userInfo = UserInfoModel(empId: widget.userInfo.empId);
        userInfo.fullName = otpVerifyModel.data?.first.fullName;
        userInfo.email = otpVerifyModel.data?.first.email;
        userInfo.mobile = otpVerifyModel.data?.first.mobile;
        userInfo.deviceName = widget.userInfo.deviceName;
        userInfo.deviceId = widget.userInfo.deviceId;
        userInfo.dept = widget.userInfo.dept;
        userInfo.design = widget.userInfo.design;

        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          SystemNavigator.pop();
        }

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userInfo: userInfo),
          ),
        );

      } else {
        Navigator.of(context).pop();
        helper.showToast(otpVerifyModel.msg!, context);
      }
    } else {
      helper.printStatement('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: const Text("OTP Verification"),
        centerTitle: true,
      ),
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
                          const SizedBox(height: 100,),
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
                            height: 80,
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _otpTextField,
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
                                hintText: 'Enter OTP',
                                fillColor: Colors.white,
                                filled: true),
                          ),
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: () {
                              otpVerify();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Center(
                                child: Text('Verify Otp',
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

