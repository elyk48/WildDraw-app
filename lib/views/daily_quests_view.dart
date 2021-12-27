import 'dart:math';

import 'package:cardgameapp/controllers/usercontroller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyQuests extends StatefulWidget {
  const DailyQuests({Key? key}) : super(key: key);

  @override
  _DailyQuestsState createState() => _DailyQuestsState();
}

///DailyQuests view
class _DailyQuestsState extends State<DailyQuests> {
  var isAdmin = false;
  late bool rerolled;
  userController userC = userController();
  String usercurrentId = FirebaseAuth.instance.currentUser!.uid;
  late var Dlength;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Quests"),

        ///a button to return to the home page
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 40,
          ),

          ///using the navigator to redirect the data to the hoem page
          onPressed: () => Navigator.of(context).pushReplacementNamed("/home"),
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )),

          ///a button to go the create quest view0
        ],
      ),
      body: StreamBuilder(
        ///getting the stream of data from firebase store
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(usercurrentId)
            .collection("quests")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return LinearProgressIndicator();
          } else {
            return ListView.builder(

                ///the number of items in the snapshot..
                itemCount: 4,
                itemBuilder: (context, index) {
                  ///getting a single quest using the index..
                  DocumentSnapshot myquest = snapshot.data.docs[index];

                  ///geting the quest data
                  String docId = myquest.id;
                  String questTitle = myquest['QuestTitle'];
                  String level = myquest['levelRange'];
                  String Qdesc = myquest['Qdescription'];

                  ///the quest data view as a card
                  return Container(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Card(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ///reroll button
                                IconButton(
                                  icon: Image.asset('assets/Images/reroll.png'),
                                  iconSize: 50,
                                  onPressed: () async {
                                    late String usercurrentId;
                                    usercurrentId =
                                        FirebaseAuth.instance.currentUser!.uid;
                                    CollectionReference users =
                                        FirebaseFirestore.instance
                                            .collection('users');
                                    users
                                        .doc(usercurrentId)
                                        .collection("rerolled")
                                        .doc(usercurrentId)
                                        .get()
                                        .then((value) async {
                                      setState(() {
                                        rerolled = value.data()!["rerolled"];
                                      });
                                    });

                                    if (rerolled == false) {
                                      userC.Reroll(docId);
                                    } else {
                                      print("wait 24h before the next reroll");
                                    }
                                  },
                                ),

                                /// quest data view
                                Column(
                                  children: [
                                    ///Title
                                    Text(
                                      questTitle,
                                      textScaleFactor: 1.5,
                                    ),

                                    ///quest level
                                    Text(level),

                                    ///quest decription
                                    Text(Qdesc),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      ),
      floatingActionButton: Container(
        child: isAdmin == true
            ? FloatingActionButton(
                backgroundColor: Colors.brown[100],
                child: Icon(Icons.add, color: Colors.black),
                onPressed: () {
                  ///using the navigator to point the context to create poll route
                  if (isAdmin == true)
                    Navigator.pushNamed(context, '/createQuest');
                })
            : null,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    users.doc(usercurrentId).collection("quests").get().then((value) async {
      Dlength = await value.size;

      if (Dlength != 4)
        userC.addQuest2();
      else
        print("no ");
    });

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        isAdmin = prefs.getBool("isAdmin")!;
        users
            .doc(usercurrentId)
            .collection("rerolled")
            .doc(usercurrentId)
            .get()
            .then((value) async {
          setState(() {
            rerolled = value.data()!["rerolled"];
          });
        });
      });
    });
  }
}
