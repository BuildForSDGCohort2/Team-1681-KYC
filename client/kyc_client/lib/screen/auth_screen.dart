import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:kyc_client/screen/user_info.dart';

enum AuthMode { login, signup }

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Check Connectivity
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _smsCodeController = TextEditingController();
  AuthMode authMode = AuthMode.login;
  String _countryCode = '+256';
  String _selectedCountry = 'Uganda';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        String wifiName, wifiBSSID, wifiIP;

        try {
          if (!kIsWeb && Platform.isIOS) {
            LocationAuthorizationStatus status =
                await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
                  await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              wifiName = await _connectivity.getWifiName();
            } else {
              wifiName = await _connectivity.getWifiName();
            }
          } else {
            wifiName = await _connectivity.getWifiName();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          wifiName = "Failed to get Wifi Name";
        }

        try {
          if (!kIsWeb && Platform.isIOS) {
            LocationAuthorizationStatus status =
                await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
                  await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              wifiBSSID = await _connectivity.getWifiBSSID();
            } else {
              wifiBSSID = await _connectivity.getWifiBSSID();
            }
          } else {
            wifiBSSID = await _connectivity.getWifiBSSID();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          wifiBSSID = "Failed to get Wifi BSSID";
        }

        try {
          wifiIP = await _connectivity.getWifiIP();
        } on PlatformException catch (e) {
          print(e.toString());
          wifiIP = "Failed to get Wifi IP";
        }

        setState(() {
          _connectionStatus = '$result\n'
              'Wifi Name: $wifiName\n'
              'Wifi BSSID: $wifiBSSID\n'
              'Wifi IP: $wifiIP\n';
        });
        break;
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  Future<bool> validateUserPhone(
    String phone,
    String country,
    String countrycode,
    BuildContext context,
  ) async {
    // first check that the number is not in the database, then proceed to this

    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        Navigator.of(context).pop();
        AuthResult result = await _auth.signInWithCredential(credential);

        FirebaseUser user = result.user;

        if (user != null) {
          // add the user to the local database
          // Navigate to the stepper to complet the profile

          // temporarily
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return AdditionalInfoPage(
                  phone: phone, country: country, countrycode: countrycode);
            }),
          );
        }
      },
      verificationFailed: (AuthException exception) {
        _displayError(context, exception);
      },
      codeSent: (String verificationId, [int forceResendingToken]) {
        // Sow a dilog box tht the user enters the code they recieved
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text('Enter Code'),
                content: Column(
                  children: [
                    TextField(
                      controller: _smsCodeController,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId,
                                smsCode: _smsCodeController.text.trim());

                        AuthResult result =
                            await _auth.signInWithCredential(credential);
                        FirebaseUser user = result.user;

                        if (user != null) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return AdditionalInfoPage(
                                phone: _phoneController.text);
                          }));
                        } else {
                          _displayError(context, 'Phone Verification Failed');
                        }
                      },
                      child: Text('Confirm'),
                    )
                  ],
                ),
              );
            });
      },
      codeAutoRetrievalTimeout: null,
    );
  }

  _displayError(context, error) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(error),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Retry',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFF00B686),
              Color(0xFF00838F),
            ]),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Column(
                    children: [
                      Text(
                        'KYC',
                        style: TextStyle(
                          fontSize: 45,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1.2,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Know Your Contacts',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ListView(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: CountryListPick(
                                    isShowFlag: true,
                                    isShowTitle: false,
                                    isShowCode: true,
                                    isDownIcon: false,
                                    initialSelection: _countryCode,
                                    showEnglishName: true,
                                    onChanged: (code) {
                                      setState(() {
                                        _countryCode = code.dialCode;
                                        _selectedCountry = code.name;
                                      });
                                    },
                                  ),
                                  width: 130,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Form(
                                    autovalidate: true,
                                    key: _formKey,
                                    child: TextFormField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                          hintText: '771234567'),
                                      validator: (value) {
                                        if (value.isEmpty || value.length < 9) {
                                          return 'Invalid Phone Number!';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RaisedButton(
                              onPressed: () {
                                if (!_formKey.currentState.validate()) {
                                  return;
                                } else {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (contex) => AdditionalInfoPage(
                                          phone: _phoneController.text,
                                          countrycode: _countryCode,
                                          country: _selectedCountry),
                                    ),
                                  );
                                  setState(() {
                                    _phoneController.text = '';
                                  });
                                }
                              },
                              child: Text('Signup'),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                print('Forgotten Password');
                              },
                              child: Text('Forgot Password?'),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
