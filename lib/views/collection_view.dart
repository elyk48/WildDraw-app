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
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        title: const Text("Your Collection"),
      ),
        body: Collection()
    );
  }
}