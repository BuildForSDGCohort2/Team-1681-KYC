import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:kyc_client/screen/scanbarcode.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class QRCodePage extends StatefulWidget {
  final Map<String, dynamic> encodedText;
  QRCodePage(this.encodedText);

  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  File _imageFile;
  ScreenshotController screenshotController = ScreenshotController();
  GlobalKey globalKey = GlobalKey();
  @override
  initState() {
    super.initState();
  }

  Widget _buildQRCodeSection(BuildContext context) {
    final double devWidth = MediaQuery.of(context).size.width;
    final double devHeight = MediaQuery.of(context).size.height;
    final double targetWidth = devWidth > 550.0 ? 500.0 : devWidth * 0.95;
    return Column(
      children: [
        Column(
          children: [
            Container(
              height: 65,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).accentColor,
                ]),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'My QR Code',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor,
              ]),
            ),
            child: ListView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 30, right: 30),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Please, Let the users scan the  ',
                            style: TextStyle(fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'QR Code',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              TextSpan(
                                text: ' Below!',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: InkWell(
                        onLongPress: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.white.withOpacity(.65),
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 150,
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Save / Share QR Code',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      FlatButton(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.save_alt),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text('Save to Gallery'),
                                            ],
                                          ),
                                          onPressed: () async {}),
                                      FlatButton(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.share),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text('Share'),
                                            ],
                                          ),
                                          onPressed: () {
                                            print('Share Image');
                                          }),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Container(
                          width: targetWidth * 0.85,
                          height: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            gradient: LinearGradient(
                              colors: [Colors.grey[300], Colors.white],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              QrImage(
                                data: jsonEncode(widget.encodedText),
                                version: QrVersions.auto,
                                size: 280,
                                gapless: true,
                                // backgroundColor: Colors.white,
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
                              Text(
                                'ERASW - WRWSA',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Here is my offline Entry Code!',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Please Scan To Add User Contact'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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
      body: SafeArea(child: _buildQRCodeSection(context)),
    );
  }
}
