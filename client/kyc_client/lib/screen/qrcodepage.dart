import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kyc_client/screen/scanbarcode.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodePage extends StatefulWidget {
  final Map<String, dynamic> encodedText;
  QRCodePage(this.encodedText);

  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  @override
  initState() {
    super.initState();
  }

  Widget _buildQRCodeSection(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Please, Let the ridder scan the  ',
                        children: <TextSpan>[
                          TextSpan(
                              text: 'QR Code',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  ' Below, and after, Scan their resulant Code!'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                QrImage(
                  data: jsonEncode(widget.encodedText),
                  version: QrVersions.auto,
                  size: 280,
                  gapless: true,
                  // embeddedImage: AssetImage('assets/images/head.jpg'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: Size(40, 40),
                  ),
                  errorStateBuilder: (cxt, err) {
                    return Container(
                      child: Center(
                        child: Text(
                          "Uh oh! Something went wrong...",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () => _openQRCodeScanner(context),
                      child: Text('Scan Complete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future _openQRCodeScanner(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ScanBarCode();
        },
      ),
    );
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Destination'),
      ),
      body: SafeArea(child: _buildQRCodeSection(context)),
    );
  }
}
