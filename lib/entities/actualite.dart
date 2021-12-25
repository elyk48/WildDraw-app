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
    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Card(

          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ActualiteDetails(_id, _idUser, _title, _content, _author, _postedOn);
                  }
              ));
            },
            child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Images/Scroll.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(30,10, 10,0),
                          child: Text(_title, textScaleFactor: 2,
                            style: const TextStyle(
                                fontFamily: 'Windy-Wood-Demo',
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          )
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(40, 0, 0, 10),
                          child: Text("'"+_author+"'",textScaleFactor: 1.5,style: const TextStyle(
                              fontFamily: 'Windy-Wood-Demo',
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(65, 2, 11, 1)),
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
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
    const double textSize = 18;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.fromLTRB(40,0, 40, 60),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Images/News_details.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: ShaderMask(
              shaderCallback: (Rect rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.purple, Colors.transparent, Colors.transparent, Colors.purple],
                  stops: [0.1, 0.1, 0.98, 1], // 10% purple, 80% transparent, 10% purple
                ).createShader(rect);
              },
              blendMode: BlendMode.dstOut,
              child: ListView(
                children: [
                   Column(
                    children: [
                      const SizedBox(height: 80,),
                    Text(_title, textScaleFactor: 3, textAlign: TextAlign.center, style: const TextStyle(
                        color: Color.fromRGBO(142, 4, 14, 1),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Windy-Wood-Demo',
                        fontSize: textSize,
                        decorationColor: Colors.black
                    ),),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(_content, textScaleFactor: 1.5, textAlign: TextAlign.center, style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Windy-Wood-Demo',
                        fontSize: textSize,
                        decorationColor: Colors.black
                    ),),
                      const SizedBox(
                        height: 20,
                      ),
                    Text("Written by "+_author, textScaleFactor: 1.5, textAlign: TextAlign.center, style: const TextStyle(
                        color: Color.fromRGBO(55, 54, 48, 1),
                        fontFamily: 'Windy-Wood-Demo',
                        fontSize: textSize,
                        decorationColor: Colors.black
                    ),),
                      Text("On the "+_postedOn.toDate().toString(), textScaleFactor: 1, textAlign: TextAlign.center, style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Windy-Wood-Demo',
                          fontSize: textSize+5,
                          decorationColor: Colors.black
                      ),),
      ],
      ),
    ],
              ),
            ),
          ),
        ),
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