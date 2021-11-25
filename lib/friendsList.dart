
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class FriendsList extends StatefulWidget {
  const FriendsList({Key? key}) : super(key: key);

  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Friend's list"),

      ),

      body: Column(

        children: [

         Row(
children: [

      Padding(
      padding: EdgeInsets.symmetric(vertical: 20,horizontal:70),
        child: RaisedButton(
          color: Colors.black54,
          child: Text('AddFriend', style: TextStyle(color: Colors.amberAccent,fontSize: 15)),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
    ),
            onPressed: () {

            Navigator.pushReplacementNamed(context, "/searchfriends");
            }),


    )

],


         ),


        ],

      ),

    );
  }
}
