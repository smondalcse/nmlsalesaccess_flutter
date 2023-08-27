import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScreen extends StatefulWidget {
  @override
  _QrCodeScreenState createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Sales QR Code'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: _buildQrView(context),
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
    setState(() {
      this.controller = controller;
    });

    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      // Handle the scanned data (e.g., navigate to a new screen with the data)
      _handleScanResult(scanData.code!);
    });
  }

  void _handleScanResult(String scanData) {
    // You can now use the scanData (QR code result) as needed
    print('Scanned QR Code: $scanData');

    // For example, navigate to a new screen with the scan result
    Navigator.pop(context, scanData); // Return the result to the previous screen
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
