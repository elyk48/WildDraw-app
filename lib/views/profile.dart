import 'dart:convert';

import 'package:cardgameapp/entities/user.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/usercontroller.dart';

class Profile extends StatefulWidget {
  static String tag = 'home-page';


  @override
  State<Profile> createState() => _ProfileState(


  );
}


class _ProfileState extends State<Profile> {
  var myId;
  var myEmail;

  var myUsername;

  var myRank;

  var mylevel ;
  var myaddress;
  var myBirthdate;
  var myImage;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    const lorem = Padding(
      padding: EdgeInsets.all(8.0),
    );
    final body = Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      padding: EdgeInsets.all(28.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [

          Colors.black54,
          Colors.amber,
          Colors.amberAccent,
          Colors.black54,
        ]),
      ),
      child: Column(
        children: <Widget>[lorem,
          Container(
            child: FutureBuilder(
              future: _fetchUser(),
              builder: (context,AsyncSnapshot snapshot){
                if (snapshot.connectionState != ConnectionState.done)
                  return Text("Loading data...Please wait");
                if(snapshot.data.image == null ||snapshot.data.image =="")
                  {
                    return const CircularProgressIndicator();
                  }
                else if(snapshot.hasData) {
                  return ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data.image,scale: 1),
                      radius: 100,
                    ),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40.0),
                                bottomRight: Radius.circular(40.0),
                                topLeft: Radius.circular(40.0),
                                bottomLeft: Radius.circular(40.0)),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.topLeft,
                          child: const Text("UserName :",
                            textScaleFactor: 1.2,style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ), Container(
                          padding: const EdgeInsets.all(5),
                          color: Colors.white60,
                          alignment: Alignment.topLeft,
                          child: Text(snapshot.data.username,
                            textScaleFactor: 1.2,style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20)),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.topLeft,
                          child: const Text("Level:",
                            textScaleFactor: 1.2,style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ), Container(
                          padding: const EdgeInsets.all(5),
                          color: Colors.white60,
                          alignment: Alignment.topLeft,
                          child: Text(snapshot.data.level,
                            textScaleFactor: 1.2,style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: Text("Rank : "+snapshot.data.Rank,
                            textScaleFactor: 1.2,style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),),
                        ),
                        Text("BirthYear : "+snapshot.data.birth,
                          textScaleFactor: 1.2,style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),),
                        Text("Address : "+snapshot.data.address,
                          textScaleFactor: 1.2,style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          verticalDirection : VerticalDirection.down,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton( child: const Text('Delete Account'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                                onPrimary: Colors.white,
                                shadowColor: Colors.black,
                                elevation: 6,
                              ),
                              onPressed: () {
                                deleteUser(myId);
                                Navigator.pushReplacementNamed(context,'/singin');
                              },),
                            ElevatedButton( child: Text('Edit Profile'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                onPrimary: Colors.white,
                                shadowColor: Colors.red,
                                elevation: 6,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, "/editProfile");
                              }
                              ,),
                          ],
                        ),
                      ],
                    )
                  ],
                );
                }
                else {
                  return const CircularProgressIndicator();
                }
              },

            ),
          ),


        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(

        title: Text("Profile"),
        backgroundColor: Colors.black54,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 40,),
          onPressed: () => Navigator.of(context).pushReplacementNamed("/home"),
        ),
      ),
      body: body,
      resizeToAvoidBottomInset: true,

    );
  }
  Future<UserE> _fetchUser() async {
    UserE user = UserE.NewUser("email", "password", "username", "birthdate", "address", "image", false);
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        user.id=ds.data()!["Id"];
        user.image=ds.data()!['image'];
        user.username=ds.data()!['username'];
        user.email = ds.data()!['email'];
        user.Rank = ds.data()!['Rank'];
        user.level = ds.data()!['level'];
        user.address = ds.data()!['address'];
        user.birth = ds.data()!['birthdate'];
        print(user.email);
        print(user.image);
      }).catchError((e) {
        print(e);
      });
    }
    return user;
  }
  updateUser(UserE user){
    var id=  FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("users").doc(id).set({
      "email": user.email,
      'password': user.password,
      'username': user.username,
      "birthdate": user.birth,
      "address": user.address,
      "Rank": user.Rank,
      "level": user.level,
      "id_Col": user.id_Col,
      "Id": id,
      "image":user.image,
    }).catchError((error) => print("Failed to update User  : $error"));
    FirebaseAuth.instance.currentUser!.updateEmail(user.email).catchError((error) => print("Failed to Update User Email  : $error"));
    FirebaseAuth.instance.currentUser!.updatePassword(user.password).catchError((error) => print("Failed to Update User password  : $error"));
  }

  deleteUser(docId){
    FirebaseFirestore.instance.collection("users").doc(docId).delete().catchError((e){
      print(e);
    });
    FirebaseAuth.instance.currentUser!.delete();



  }

}