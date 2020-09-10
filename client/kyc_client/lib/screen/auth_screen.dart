// import 'dart:async';
import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:kyc_client/db/databaseProvider.dart';
import 'package:kyc_client/screen/user_info.dart';
import 'package:provider/provider.dart';

enum AuthMode { login, signup }

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController smsCodeController = TextEditingController();
  AuthMode authMode = AuthMode.login;
  String countryCode = '+256';
  String selectedCountry = 'Uganda';

  Future validateUserPhone(
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
                      controller: smsCodeController,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId,
                                smsCode: smsCodeController.text.trim());

                        AuthResult result =
                            await _auth.signInWithCredential(credential);
                        FirebaseUser user = result.user;

                        if (user != null) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return AdditionalInfoPage(
                                phone: phoneController.text);
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

    final api = Provider.of<DatabaseProvider>(context, listen: false);
    api.checkConnectionStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Provider<DatabaseProvider>(
            create: (context) => DatabaseProvider.db,
            builder: (context, child) {
              final connStatus =
                  Provider.of<DatabaseProvider>(context).connectionStatus;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFF00B686),
                    Color(0xFF00838F),
                  ]),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      connStatus != 'Connected'
                          ? Column(
                              children: [
                                Text(connStatus),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            )
                          : SizedBox.shrink(),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 3.5,
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
                        child: MediaQuery.of(context).size.width > 500
                            ? Center(
                                child: Container(
                                  width: 400,
                                  height: 350,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: BuildAuthForm(
                                    countryCode: countryCode,
                                    phoneController: phoneController,
                                    authMode: authMode,
                                    passwordController: passwordController,
                                    selectedCountry: selectedCountry,
                                  ),
                                ),
                              )
                            : BuildAuthForm(
                                countryCode: countryCode,
                                phoneController: phoneController,
                                authMode: authMode,
                                passwordController: passwordController,
                                selectedCountry: selectedCountry,
                              ),
                      ),
                      Text('Powered By @EME-GEEKS')
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class BuildAuthForm extends StatefulWidget {
  BuildAuthForm({
    @required this.countryCode,
    @required this.phoneController,
    @required this.authMode,
    @required this.passwordController,
    @required this.selectedCountry,
  });

  String countryCode;
  TextEditingController phoneController;
  AuthMode authMode;
  TextEditingController passwordController;
  String selectedCountry;

  @override
  _BuildAuthFormState createState() => _BuildAuthFormState();
}

class _BuildAuthFormState extends State<BuildAuthForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidate: true,
      key: _formKey,
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
                      initialSelection: widget.countryCode,
                      showEnglishName: true,
                      onChanged: (code) {
                        setState(() {
                          widget.countryCode = code.dialCode;
                          widget.selectedCountry = code.name;
                        });
                      },
                    ),
                    width: 130,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: widget.phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(hintText: '771234567'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 9) {
                          return 'Invalid Phone Number!';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          widget.authMode == AuthMode.login
              ? Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: widget.passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Password',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty || value.length < 6) {
                          return 'Invalid Password';
                        }
                        return null;
                      },
                    ),
                  ],
                )
              : SizedBox.shrink(),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('I Would Like To '),
              FlatButton(
                onPressed: () {
                  setState(
                    () {
                      widget.authMode = widget.authMode == AuthMode.login
                          ? AuthMode.signup
                          : AuthMode.login;
                    },
                  );
                },
                child: Text(
                  '${widget.authMode == AuthMode.login ? 'Signup' : 'Login'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              // final connStatus =
              //     Provider.of<DatabaseProvider>(context)
              //         .connectionStatus;
              if (!_formKey.currentState.validate()) {
                return;
              }
              //  else if (connStatus == 'Unknown' ||
              //     connStatus == 'No Connection') {
              //   showDialog(
              //       barrierDismissible: false,
              //       context: context,
              //       builder: (context) {
              //         return AlertDialog(
              //           title: Text('Network Error'),
              //           content: Text(connStatus),
              //           actions: [
              //             FlatButton(
              //               onPressed: () {
              //                 Navigator.of(context).pop();
              //               },
              //               child: Text('OK'),
              //             )
              //           ],
              //         );
              //       });
              // }
              else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (contex) => AdditionalInfoPage(
                        phone: widget.phoneController.text,
                        countrycode: widget.countryCode,
                        country: widget.selectedCountry),
                  ),
                );
              }
            },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width / 2,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.black87,
                  Colors.black12,
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.authMode == AuthMode.login ? 'Login' : 'Signup',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              print('Forgotten Password');
            },
            child: Text('Forgot Password?'),
          )
        ],
      ),
    );
  }
}
