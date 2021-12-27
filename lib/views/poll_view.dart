import 'package:cardgameapp/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../session.dart';

/// main class for displaying polls for users to vote
class MyPollDisplay extends StatefulWidget {
  @override
  _MyPollDisplayState createState() => _MyPollDisplayState();
}

class _MyPollDisplayState extends State<MyPollDisplay> {
  bool wait = false;

  @override
  late SharedPreferences sharedPrefs;
  UserE user = UserE.NewUser(
      "email", "password", "username", "birthdate", "address", "image", false);
  late bool isAdmin = false;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        title: Text("Polls"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 40,
          ),
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
        ],
      ),

      ///stream builder used for the stream of data
      ///widget based on the result of a Stream of data collected
      body: StreamBuilder(

          ///getting the stream of data from firebase store
          stream: FirebaseFirestore.instance.collection('poll').snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            ///testing if the snapshot has data
            if (!snapshot.hasData) {
              return LinearProgressIndicator();
            }

            ///if it has data it rturn a listview builder which contains the polls
            else if (snapshot.hasData) {
              return ListView(
                children: [
                  for (int i = 0; i < snapshot.data.docs.length; i++)
                    Column(
                      children: [
                        //Polls start from here
                        Card(
                          color: Colors.pink,
                          child: Text(
                            snapshot.data.docs[i]["question"],
                            textScaleFactor: 2,
                          ),
                        ),
                        //Text(snapshot.data.docs[i]["question"]),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('poll')
                                .doc(snapshot.data.docs[i].id)
                                .collection("options")
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot snapshot2) {
                              if(snapshot2.data != null) {
                                return Column(
                                children: [
                                  for (int j = 0;
                                      j < snapshot2.data.docs.length;
                                      j++)
                                    //Options[j]
                                    InkWell(
                                      child: Card(
                                        color: Colors.blue,
                                        child: Text(
                                            snapshot2.data.docs[j]["name"] +
                                                " Votes: " +
                                                snapshot2.data.docs[j]["votes"]
                                                    .toString(),
                                            textScaleFactor: 2),
                                      ),
                                      onTap: () async {
                                        if (!wait) {
                                          wait = true;
                                          //print(wait);
                                          var doc = FirebaseFirestore.instance
                                              .collection('poll')
                                              .doc(snapshot.data.docs[i].id)
                                              .collection('users')
                                              .doc(user.id);
                                          await doc.get().then((value) async {
                                            if (!value.exists) {
                                              var doc2 = FirebaseFirestore
                                                  .instance
                                                  .collection('poll')
                                                  .doc(snapshot.data.docs[i].id)
                                                  .collection('options')
                                                  .doc(snapshot2
                                                      .data.docs[j].id);
                                              await doc2.update({
                                                'votes': 1 +
                                                    snapshot2.data.docs[j]
                                                        ["votes"]
                                              });
                                              await FirebaseFirestore.instance
                                                  .collection('poll')
                                                  .doc(snapshot.data.docs[i].id)
                                                  .collection('users')
                                                  .doc(user.id)
                                                  .set({
                                                "vote":
                                                    snapshot2.data.docs[j].id,
                                              });
                                            } else if (snapshot2
                                                    .data.docs[j].id ==
                                                value
                                                    .data()!["vote"]
                                                    .toString()) {
                                              print("Same vote !");
                                              var doc2 = FirebaseFirestore
                                                  .instance
                                                  .collection('poll')
                                                  .doc(snapshot.data.docs[i].id)
                                                  .collection('options')
                                                  .doc(snapshot2
                                                      .data.docs[j].id);
                                              await doc2.update({
                                                'votes': snapshot2.data.docs[j]
                                                        ["votes"] -
                                                    1
                                              });
                                              await FirebaseFirestore.instance
                                                  .collection('poll')
                                                  .doc(snapshot.data.docs[i].id)
                                                  .collection('users')
                                                  .doc(user.id)
                                                  .delete();
                                            }
                                            /*else
                                           {
                                             var doc2 = FirebaseFirestore.instance.collection('poll').doc(snapshot.data.docs[i].id).collection('options').doc(snapshot2.data.docs[j].id);
                                             await doc2.update({
                                               'votes': value["votes"] -1
                                             });
                                             await FirebaseFirestore.instance.collection('poll').doc(snapshot.data.docs[i].id).collection('users').doc(user.id).set({
                                               "vote": snapshot2.data.docs[j].id,
                                             });
                                           }*/
                                            wait = false;
                                            //print(wait);
                                            //print(value.data()!["vote"].toString() + "//"+ snapshot2.data.docs[j].id.toString());
                                          });

                                          print("Option Chosen: " +
                                              snapshot2.data.docs[j]["name"]);
                                        }
                                      },
                                    )
                                ],
                              );
                              }
                              return const CircularProgressIndicator();
                            }),
                      ],
                    )
                ],
              );
            }
            return Text('Nothing found');
          }),

      /// a button that takes the admin where he can add a new poll..

      floatingActionButton: Container(
        child: isAdmin == true
            ? FloatingActionButton(
                backgroundColor: Colors.brown[100],
                child: Icon(Icons.add, color: Colors.black),
                onPressed: () {
                  ///using the navigator to point the context to create poll route
                  if (isAdmin == true)
                    Navigator.pushNamed(context, '/createpoll');
                })
            : null,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Session.setUser(user);
    SharedPreferences.getInstance().then((prefs) {
      setState(() => isAdmin = prefs.getBool("isAdmin")!);
    });
  }
}
