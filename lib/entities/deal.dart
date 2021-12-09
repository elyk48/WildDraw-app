import 'dart:ffi';
import 'package:cardgameapp/entities/collection.dart';
import 'package:flutter/material.dart';

final String id="VGvmMwarbvUJtsjAzfvHR9tvfd72";
final bool isAdmin = true;



class DealView extends StatelessWidget {
  late Deal _deal;

  late Color color=Colors.black;

  DealView.Empty(this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
      decoration: BoxDecoration(
        color: color,
      ),
      child: Center(
        child: Stack(
            children:[const Center(child: CircularProgressIndicator()),Image.network("")]),
      ),
    );
  }
}

class Deal{
  late String _id;
  late String _idDealer;
  late String _idBuyer;
  //late Card _card;
  late Float _price;
  late bool _isClosed;

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get idDealer => _idDealer;

  set idDealer(String value) {
    _idDealer = value;
  }

  String get idBuyer => _idBuyer;

  set idBuyer(String value) {
    _idBuyer = value;
  }
/*
  Card get Card => _Card;

  set Card(Card value) {
    _Card = value;
  }
*/
  Float get price => _price;

  set price(Float value) {
    _price = value;
  }

  bool get isClosed => _isClosed;

  set isClosed(bool value) {
    _isClosed = value;
  }
}
