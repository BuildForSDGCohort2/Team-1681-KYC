import 'package:flutter/material.dart';

class User {
  String id;
  String userId;
  String usercode;
  String firstname;
  String lastname;
  String email;
  String country;
  String phone;
  String state;
  String token;
  String avartar;
  String password;
  String street;
  String offlinecode;

  User({
    this.id,
    this.userId,
    this.usercode,
    @required this.email,
    @required this.firstname,
    @required this.lastname,
    this.password,
    this.country,
    this.phone,
    this.state,
    this.token,
    this.avartar,
    this.street,
    this.offlinecode,
  });

  factory User.fromJson(dynamic jsonData) => User(
        id: jsonData['id'],
        userId: jsonData['userId'],
        avartar: jsonData['avartar'],
        email: jsonData['email'],
        phone: jsonData['phone'],
        firstname: jsonData['firstname'],
        lastname: jsonData['lastname'],
        token: jsonData['token'],
        usercode: jsonData['usercode'],
        offlinecode: jsonData['offlinecode'],
      );

  Map<String, dynamic> toJson() => {
        "avartar": avartar,
        'email': email,
        "firstname": firstname,
        "lastname": lastname,
        "phone": phone,
        'password': password,
        "street": street,
        "offlinecode": offlinecode
      };
}
