import 'dart:convert';

import 'package:cardgameapp/entities/user.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/usercontroller.dart';

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


    final lorem = Padding(
      padding: EdgeInsets.all(8.0),

    );

    final body = Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
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
        children: <Widget>[alucard, lorem,
          Container(
            child: FutureBuilder(
              future: _fetch(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done)
                  return Text("Loading data...Please wait");
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(

                      children: [

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40.0),
                                bottomRight: Radius.circular(40.0),
                                topLeft: Radius.circular(40.0),
                                bottomLeft: Radius.circular(40.0)),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(5),

                          alignment: Alignment.topLeft,
                          child: Text("UserName :",
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
                          child: Text("$myUsername",
                            textScaleFactor: 1.2,style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              fontWeight: FontWeight.bold,
                              ),
                          ),

                        ),
                        SizedBox(
                        width:10 ,

                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20)),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(5),

                          alignment: Alignment.topLeft,
                          child: Text("Level:",
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
                          child: Text("$mylevel",
                            textScaleFactor: 1.2,style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),

                        ),

                      ],

                    ),

                    SizedBox(
                      height: 30 ,

                    ),
                   Column(

                     children: [

                       Container(
                         padding: const EdgeInsets.all(5),


                         child: Text("Rank : $myRank",

                           textScaleFactor: 1.2,style: TextStyle(
                             color: Colors.white,
                             fontSize: 20,
                             fontWeight: FontWeight.bold,
                           ),),

                       ),
                       SizedBox(
                         height: 30 ,

                       ),
                       Container(
                         child: Text("BirthYear : $myBirthdate",

                           textScaleFactor: 1.2,style: TextStyle(
                             color: Colors.white,
                             fontSize: 17,
                             fontWeight: FontWeight.bold,
                           ),),

                       ),
                       SizedBox(
                         height: 30 ,

                       ),
                       Container(
                         child: Text("Addess : $myaddress",
                           textScaleFactor: 1.2,style: TextStyle(
                             color: Colors.white,
                             fontSize: 16,
                             fontWeight: FontWeight.bold,
                           ),),

                       ),
                       SizedBox(
                         height: 100,

                       ),
                       Row(
                         mainAxisSize: MainAxisSize.max,
                         verticalDirection : VerticalDirection.down,
                         crossAxisAlignment: CrossAxisAlignment.center,

                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [

                           ElevatedButton( child: Text('Delete Account'),
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
                           SizedBox(
                             width: 20,

                           ),
                           ElevatedButton( child: Text('Edit Profile'),
                             style: ElevatedButton.styleFrom(
                               primary: Colors.black,
                               onPrimary: Colors.white,
                               shadowColor: Colors.red,
                               elevation: 6,
                             ),
                             onPressed: () {
        Navigator.pushReplacementNamed(context, "/editProfile");
                             }
                             ,),



                         ],


                       ),

                     ],


                   )


                  ],


                );
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
    );
  }





  _fetch() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
            myId=ds.data()!["Id"];
        myUsername=ds.data()!['username'];
        myEmail = ds.data()!['email'];
        myRank = ds.data()!['Rank'];
        mylevel = ds.data()!['level'];
        myaddress = ds.data()!['address'];
        myBirthdate = ds.data()!['birthdate'];

        print(myEmail);
      }).catchError((e) {
        print(e);
      });
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