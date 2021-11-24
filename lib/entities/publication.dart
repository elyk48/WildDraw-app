import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PublicationCard extends StatelessWidget {
  late final String _id_user;
  late final String _id;
  late final String _content;
  late final int _likes;
  late final Timestamp _postedOn;
  late final String _username;

  PublicationCard(this._id_user, this._id, this._content, this._likes,
      this._postedOn, this._username);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {

        },
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_username),
                const SizedBox(
                  height: 10,
                ),
                Text(_content, textScaleFactor: 2)
              ],
            )
          ],
        ),
      ),
    );
  }

}
class Publicationform extends StatelessWidget {
  late final String _id_user;
  late final String _id;
  late final String _content;
  late final int _likes;
  late final Timestamp _postedOn;
  late final String _username;

  Publicationform(this._id_user, this._id, this._content, this._likes,
      this._postedOn, this._username);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return Publicationform(_id_user, _id, _content, _likes, _postedOn, _username);
              }
          ));
        },
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_username),
                const SizedBox(
                  height: 10,
                ),
                Text(_content, textScaleFactor: 2)
              ],
            )
          ],
        ),
      ),
    );
  }
}
class Publication {
  late String _id_user;
  late String _id;
  late String _content;
  late int _likes;
  late DateTime _postedOn;
  late String _username;


  Publication(this._id_user, this._id, this._content, this._likes,
      this._postedOn, this._username);

  String get id_user => _id_user;

  set id_user(String value) {
    _id_user = value;
  }

  Publication.newPub(String content,String idUser,String username)
{
  _username = username;
  _id_user = idUser;
  _content = content;
  _likes = 0;
  _postedOn = DateTime.now();
}

  Map toJson() => {
    'id': _id_user,
    'content': _content,
    'likes': _likes,
    'postenOn': _postedOn,
  };

  String get id => _id;

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  DateTime get postedOn => _postedOn;

  set postedOn(DateTime value) {
    _postedOn = value;
  }

  int get likes => _likes;

  set likes(int value) {
    _likes = value;
  }

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  set id(String value) {
    _id = value;
  }
}