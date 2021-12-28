import 'dart:convert';

import 'package:cardgameapp/entities/user.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/usercontroller.dart';
import '../session.dart';

class Profile extends StatefulWidget {
  static String tag = 'home-page';

  @override
  State<Profile> createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  UserE user = UserE.NewUser(
      "email", "password", "username", "birthdate", "address", "image", false);

  @override
  void initState() {
    super.initState();
    Session.setUser(user);
  }

  @override
  Widget build(BuildContext context) {
    showAlertDialog(BuildContext context, String id) {
      // Create button
      Widget okButton = ElevatedButton(
        child: const Text("Yes I want to delete my account"),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop('dialog');
          deleteUser(user.id);
          Navigator.pushReplacementNamed(
              context, '/singin');
        },
      );
      Widget NoButton = ElevatedButton(
        child: const Text("Nope I will think about it more.."),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
      );

      // Create AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("Account managment"),
        content: const Text("Are you sure you want to delete your account ?"),
        actions: [Center(child: okButton), Center(child: NoButton)],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    const lorem = Padding(
      padding: EdgeInsets.all(8.0),
    );
    final body = Container(
      width: MediaQuery.of(context).size.width,
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
        children: <Widget>[
          lorem,
          Container(
            child: FutureBuilder(
                future: Session.setUser(user),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Text("Loading data...Please wait");
                  } else {
                    return ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.image, scale: 1),
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
                          child: const Text(
                            "UserName :",
                            textScaleFactor: 1.2,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          color: Colors.white60,
                          alignment: Alignment.topLeft,
                          child: Text(
                            user.username,
                            textScaleFactor: 1.2,
                            style: const TextStyle(
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
                          child: const Text(
                            "Level:",
                            textScaleFactor: 1.2,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          color: Colors.white60,
                          alignment: Alignment.topLeft,
                          child: Text(
                            user.level,
                            textScaleFactor: 1.2,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                "Rank : " + user.Rank,
                                textScaleFactor: 1.2,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              "BirthYear : " + user.birth,
                              textScaleFactor: 1.2,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Address : " + user.address,
                              textScaleFactor: 1.2,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              verticalDirection: VerticalDirection.down,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  child: const Text('Delete Account'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.redAccent,
                                    onPrimary: Colors.white,
                                    shadowColor: Colors.black,
                                    elevation: 6,
                                  ),
                                  onPressed: () {
                                    showAlertDialog(context, user.id);
                                  },
                                ),
                                ElevatedButton(
                                  child: Text('Edit Profile'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.black,
                                    onPrimary: Colors.white,
                                    shadowColor: Colors.red,
                                    elevation: 6,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, "/editProfile");
                                  },
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    );
                  }
                }),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.black54,
      ),
      body: body,
      resizeToAvoidBottomInset: true,
    );
  }

  updateUser(UserE user) {
    var id = FirebaseAuth.instance.currentUser!.uid;
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
      "image": user.image,
    }).catchError((error) => print("Failed to update User  : $error"));
    FirebaseAuth.instance.currentUser!
        .updateEmail(user.email)
        .catchError((error) => print("Failed to Update User Email  : $error"));
    FirebaseAuth.instance.currentUser!.updatePassword(user.password).catchError(
        (error) => print("Failed to Update User password  : $error"));
  }

  deleteUser(docId) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
    FirebaseAuth.instance.currentUser!.delete();
  }
}
