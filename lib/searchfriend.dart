import 'package:flutter/material.dart';

class SearchFriend extends StatefulWidget {
  const SearchFriend({Key? key}) : super(key: key);

  @override
  _SearchFriendState createState() => _SearchFriendState();
}

class _SearchFriendState extends State<SearchFriend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search for a friend"),

      ),

    );
  }
}
