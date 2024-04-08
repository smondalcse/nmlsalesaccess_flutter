import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../model/scan_qr_code_model.dart';
import '../model/user_info_model.dart';
import '../network/api_manager.dart';
import 'dart:convert' as convert;
import 'dart:io';
import '../others/helper.dart';

class QrCodeScreen extends StatefulWidget {
  QrCodeScreen({Key? key, required this.userInfo}) : super(key: key);
  late UserInfoModel userInfo;

  @override
  _QrCodeScreenState createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String qrCode = "";
  Helper helper = Helper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Sales QR Code'),
      ),
      body: Stack(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Column(
              children: <Widget>[
                Container(
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
                      BorderRadius.all(Radius.circular(5))),
                  height: 120,
                  alignment: Alignment.center,
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      "1. Open NML Sales Software \n\n2. Login in desktop browser \n\n3. Point this mobile in front of Sales QR Code",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(204, 199, 199, 199),
                                Color.fromARGB(255, 146, 146, 146),
                              ],
                            ),
                            borderRadius:
                            BorderRadius.all(Radius.circular(5))),
                      ),
                      _buildQrView(context),
                    ],
                  )
                ),
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      controller?.resumeCamera();
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Center(
                          child: Text('Scan Again',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ),
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    try {

      this.controller = controller;
      controller.scannedDataStream.listen((scanData) {
        setState(() {
          controller.pauseCamera();
          _handleScanResult(scanData.code!);
        });
      });
      controller.pauseCamera();
      controller.resumeCamera();

      /*
      setState(() {
        this.controller = controller;
      });

      controller.resumeCamera();
      controller.scannedDataStream.listen((scanData) {
        // Handle the scanned data (e.g., navigate to a new screen with the data)
        controller.pauseCamera();
        _handleScanResult(scanData.code!);
      });
      */
    } catch (error) {
      helper.printStatement(error);
    }
  }

  Future<void> _handleScanResult(String scanData) async {

    setState((){
      qrCode = " = Scanned QR Code: $scanData";
    });

    // For example, navigate to a new screen with the scan result
   // Navigator.pop(context, scanData); // Return the result to the previous screen

    final deviceInfo = await helper.getDeviceDetails();
    scanQRCode(widget.userInfo.empId, deviceInfo[2], scanData);

  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> scanQRCode(String? empID, String deviceID, String? qrCode) async {
    try {

      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator(
              color: Colors.blueAccent,
              backgroundColor: Colors.deepPurpleAccent,
            ));
          });

      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        helper.showToast("No internet connection found.");
        return;
      }

      String params = "empID=$empID&deviceID=$deviceID&qrCode=$qrCode";
      final response = await ApiManager.scanQRCode(params);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
        helper.printStatement(jsonResponse);
        ScanQrCodeModel scanQrCodeModel =
        ScanQrCodeModel.fromJson(jsonResponse);

        if (scanQrCodeModel.success != true) {
          helper.showToast(scanQrCodeModel.msg!);
        } else {
          helper.showToast(scanQrCodeModel.msg!);
        }

      } else {
        Navigator.of(context).pop();
        helper.printStatement('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      helper.showToast("Error occurred.");
    }
  }

}