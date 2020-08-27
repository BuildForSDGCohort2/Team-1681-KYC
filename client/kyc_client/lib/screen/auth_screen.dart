import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:kyc_client/screen/home_screen.dart';

enum AuthMode { login, signup }

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController _phoneController = TextEditingController();
  AuthMode authMode = AuthMode.login;
  String _countryCode = '+256';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KYC'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Row(
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
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(hintText: '771234567'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: () {
                print('${_countryCode + "" + _phoneController.text}');
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (contex) => HomeScreen(),
                  ),
                );
              },
              child: Text('Signup'),
            )
          ],
        ),
      ),
    );
  }
}
