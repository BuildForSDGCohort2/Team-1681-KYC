import 'package:flutter/material.dart';
import 'package:kyc_client/api/data_api.dart';
import 'package:kyc_client/api/repository.dart';
import 'package:kyc_client/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool isLogedin = false;
  User currentUser;

  void getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final firstname = pref.getString('firstname');
    final lastname = pref.getString('lastname');
    final usercode = pref.getString('usercode');
    final email = pref.getString('email');
    final country = pref.getString('country');
    final phone = pref.getString('phone');
    final state = pref.getString('state');
    final token = pref.getString('token');
    final avartar = pref.getString('avartar');
    final street = pref.getString('street');
    final offlinecode = pref.getString('offlinecode');

    if (firstname != null && lastname != null && email != null) {
      currentUser = User(
          email: email,
          firstname: firstname,
          lastname: lastname,
          avartar: avartar,
          country: country,
          offlinecode: offlinecode,
          phone: phone,
          state: state,
          token: token,
          street: street,
          usercode: usercode);
    }
    notifyListeners();
  }

  void registerUser(Map<String, dynamic> userData) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    KYCDataRepository api = KYCDataRepository();
    final user = await api.registerUser(userData);

    // Set the shared preferences
    pref.setString('firstname', user['firstname']);
    pref.setString('lastname', user['lastname']);
    pref.setString('usercode', user['usercode']);
    pref.setString('email', user['email']);
    pref.setString('country', user['country']);
    pref.setString('phone', user['phone']);
    pref.setString('state', user['state']);
    pref.setString('token', user['token']);
    pref.setString('avartar', user['avartar']);
    pref.setString('street', user['street']);
    pref.setString('offlinecode', user['offlinecode']);

    this.currentUser = User.fromJson(user);

    notifyListeners();
  }

  void loginUser(Map<String, dynamic> userData) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    KYCDataRepository api = KYCDataRepository();
    final user = await api.login(userData);
    pref.setString('token', user['token']);

    this.currentUser = User.fromJson(user);

    notifyListeners();
  }

  void logoutUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    currentUser = null;

    notifyListeners();
  }
}
