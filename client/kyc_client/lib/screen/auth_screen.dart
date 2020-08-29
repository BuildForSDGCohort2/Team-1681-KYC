import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kyc_client/screen/home_screen.dart';
import 'package:kyc_client/screen/user_info.dart';

enum AuthMode { login, signup }

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _smsCodeController = TextEditingController();
  AuthMode authMode = AuthMode.login;
  String _countryCode = '+256';
  String _selectedCountry = 'Uganda';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<bool> validateUserPhone(
    String phone,
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
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            // return StepperProfile();
          }));
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              Center(
                child: Column(
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
                                _selectedCountry = code.name.toString();
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
                              decoration:
                                  InputDecoration(hintText: '771234567'),
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
                        }
                      },
                      child: Text('Signup'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
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
        ),
      ),
    );
  }
}
