import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ActualiteCard extends StatelessWidget {


  late final String _id;
  late final String _idUser;
  late final String _title;
  late final String _content;
  late final String _author;
  late final Timestamp _postedOn;

  ActualiteCard(this._id, this._idUser, this._title, this._content,
      this._author, this._postedOn);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return ActualiteDetails(_id, _idUser, _title, _content, _author, _postedOn);
              }
          ));
        },
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_title, textScaleFactor: 2),
                Text(_author),
                const SizedBox(
                  height: 5,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ActualiteDetails extends StatelessWidget {
  late final String _id;
  late final String _idUser;
  late final String _title;
  late final String _content;
  late final String _author;
  late final Timestamp _postedOn;


  ActualiteDetails(this._id, this._idUser, this._title, this._content,
      this._author, this._postedOn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
        Text(_title, textScaleFactor: 2),
        Text(_content, textScaleFactor: 3),
        Text("Written by: "+_author, textScaleFactor: 1),
    ],
    ),
    );

  }
}


class actualite{
  late String _id;
  late String _idUser;
  late String _title;
  late String _content;
  late String _author;
  late Timestamp _postedOn;

  actualite(this._id, this._idUser, this._title, this._content, this._author, this._postedOn);
  actualite.newAct(String idUser,String title,String content,String author)
  {
    _idUser = idUser;
    _title = title;
    _author = author;
    _content = content;
    _postedOn = Timestamp.now();
  }

  Timestamp get postedOn => _postedOn;

  set postedOn(Timestamp value) {
    _postedOn = value;
  }

  String get author => _author;

  set author(String value) {
    _author = value;
  }

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get idUser => _idUser;

  set idUser(String value) {
    _idUser = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}