import 'dart:convert';

import 'package:cardgameapp/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'controllers/usercontroller.dart';

class Profile extends StatefulWidget {
  static String tag = 'home-page';

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
 final String userid = FirebaseAuth.instance.currentUser!.uid;
 userController userC= userController();
  late final UserE user ;

 DocumentReference userRef = FirebaseFirestore.instance.collection("users").doc("VGvmMwarbvUJtsjAzfvHR9tvfd72");

  @override
  Widget build(BuildContext context) {

    final alucard = Hero(

      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(

          radius: 80,
          backgroundColor: Colors.black,
          backgroundImage: AssetImage('assets/Images/Default.png'),

        ),
      ),
    );

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
"aaaaaaaaaaaaa"
      ,
        style: TextStyle(fontSize: 28.0, color: Colors.white),
      ),
    );

    final lorem = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(

      "text"
      ),
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [

          Colors.black54,
          Colors.amber,
          Colors.amberAccent,
          Colors.black54,
        ]),
      ),
      child: Column(
        children: <Widget>[alucard, welcome, lorem,
          Container(
            child: FutureBuilder(
                future:userRef.get(),
                builder: ( BuildContext context, AsyncSnapshot snapshot)  {
                  if(snapshot.hasData){
                    Map<String,dynamic> user= snapshot.data.data();

                    print(user["username"]);

                    return Text("aaaaa");
                  }
                  if(snapshot.hasError){

                    return Text("error");
                  }
                  if(snapshot.connectionState == ConnectionState.waiting){

                    return Text("Loading");
                  }else
                  {
                    return CircularProgressIndicator();
                  }
                }


            ),
          ),
        
        
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile" ),
        backgroundColor: Colors.black54,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,size: 40,),
          onPressed: () => Navigator.of(context).pushReplacementNamed("/home"),
        ),
      ),
      body: body,
    );
  }
}
