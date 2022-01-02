import 'package:flutter/material.dart';
///Quest class
class Quest extends StatelessWidget {

late String _id;
late String _Qtitle;
late String _levelrange;
late String _Qdescription;

Quest(this._id, this._Qtitle, this._levelrange, this._Qdescription);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

String get Qdescription => _Qdescription;

  set Qdescription(String value) {
    _Qdescription = value;
  }

  String get levelrange => _levelrange;

  set levelrange(String value) {
    _levelrange = value;
  }

  String get Qtitle => _Qtitle;

  set Qtitle(String value) {
    _Qtitle = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  ///Named constructor

Quest.NewQuest(Qtitle, levelrange ,Qdescription){


    _Qtitle=Qtitle;
    _levelrange=levelrange;
    _Qdescription=Qdescription;

}

}