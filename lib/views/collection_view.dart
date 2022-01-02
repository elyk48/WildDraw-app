import 'package:cardgameapp/entities/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CollectionView extends StatefulWidget {
  const CollectionView({Key? key}) : super(key: key);

  @override
  _CollectionViewState createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Rules and Cards",style: TextStyle(fontFamily: 'Windy-Wood-Demo',fontSize: 20,fontWeight: FontWeight.w600)),
      ),
        body: Collection()
    );
  }
}