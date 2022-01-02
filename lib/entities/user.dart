import 'dart:convert';

import 'dart:io';

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
  late String _image;
  late bool _isAdmin;


  bool get isAdmin => _isAdmin;

  set isAdmin(bool value) {
    _isAdmin = value;
  }

  UserE.Normal(this._id, this._username, this._email, this._password, this._birth,
      this._address, this._level, this._Rank, this._id_Col);

  UserE(this._id, this._username, this._email, this._password, this._birth, this._address, this._level, this._Rank, this._id_Col, this._image, this._isAdmin);

  String get image => _image;

  set image(String value) {
    _image = value;
  }

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

  UserE.NewUser(email ,password,username,birthdate,address, String image,isAdmin){
 _email=email;
 _password=password;
 _username=username;
 _birth=birthdate;
 _address=address;
_level="1";
_Rank="1";
_id_Col="1";
_image=image;
_isAdmin=isAdmin;
  }
  }






