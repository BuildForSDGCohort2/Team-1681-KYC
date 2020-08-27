import 'package:flutter/material.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanBarCode extends StatefulWidget {
  @override
  _ScanBarCodeState createState() => _ScanBarCodeState();
}

class _ScanBarCodeState extends State<ScanBarCode> {
  bool _flashOn = false;
  bool _frontCamera = false;
  GlobalKey _qrCodeKey = GlobalKey();
  QRViewController _qrcontroller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            QRView(
              key: _qrCodeKey,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.white,
              ),
              onQRViewCreated: (QRViewController controller) {
                this._qrcontroller = controller;
                controller.scannedDataStream.listen((val) {
                  if (mounted) {
                    _qrcontroller.dispose();
                    Navigator.pop(context, val);
                  }
                });
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 60),
                child: Text(
                  'Scan Resulting QR Code',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    color: Colors.white,
                    icon: Icon(
                      _flashOn ? Icons.flash_on : Icons.flash_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _flashOn = !_flashOn;
                        _qrcontroller.toggleFlash();
                      });
                      // _qrcontroller.toggleFlash();
                    },
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(
                      _frontCamera ? Icons.camera_front : Icons.camera_rear,
                    ),
                    onPressed: () {
                      setState(() {
                        _frontCamera = !_frontCamera;
                        _qrcontroller.flipCamera();
                      });
                      // _qrcontroller.flipCamera();
                    },
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
