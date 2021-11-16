import 'package:flutter/material.dart';

class UserE extends StatelessWidget {
  late String _id;
  late String _username;
  late String _email;
  late String _password;
  late String _birth;
  late String _address;
  late String _Level;
  late String _Rank;
  late String _id_Col;


  UserE(this._id, this._username, this._email, this._password, this._birth,
      this._address, this._Level, this._Rank, this._id_Col);

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

  String get Level => _Level;

  set Level(String value) {
    _Level = value;
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

  UserE.NewUser(email ,password,username){
 _email=email;
 _password=password;
 _username=username;

  }
}
