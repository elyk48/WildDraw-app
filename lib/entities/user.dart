import 'dart:convert';

import 'package:flutter/material.dart';

class UserE extends StatelessWidget {
  late String _id;
  late String _username;
  late String _email;
  late String _password;
  late String _birth;
  late String _address;
  late String _level;
  late String _Rank;
  late String _id_Col;


  UserE(this._id, this._username, this._email, this._password, this._birth,
      this._address, this._level, this._Rank, this._id_Col, );

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  String get id_Col => _id_Col;

  set id_Col(String value) {
    _id_Col = value;
  }

  String get Rank => _Rank;

  set Rank(String value) {
    _Rank = value;
  }

  String get level => _level;

  set level(String value) {
    _level = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get birth => _birth;

  set birth(String value) {
    _birth = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  UserE.NewUser(email ,password,username,birthdate,address){
 _email=email;
 _password=password;
 _username=username;
 _birth=birthdate;
 _address=address;
_level="1000";
_Rank="0";
_id_Col="1";

  }



 /* factory UserE.fromJson(Map<String,dynamic> json){
    return UserE(
      _id : json["Id"],
      Rank :json["Rank"],
      address:json["address"],
      birth: json["birthdate"],
      email: json["email"],
      id_Col: json["id_Col"],
      level :json["level"],
      password: json["password"],
      username :json["username"],



    ); */

  }






