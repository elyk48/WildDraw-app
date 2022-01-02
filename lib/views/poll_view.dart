import 'package:cardgameapp/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
    return Stack(children: <Widget>[
      Image.asset(
        "assets/Images/publication_board.png",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.black54,
          foregroundColor: Colors.amberAccent,
          title: const Text("Polls"),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed("/home"),
          ),
        ),

        ///stream builder used for the stream of data
        ///widget based on the result of a Stream of data collected
        body: Column(children: [
          Container(
            alignment: Alignment.center,
            child: const Text("Polls",
                textScaleFactor: 3,
                style: TextStyle(
                    fontFamily: 'Windy-Wood-Demo',
                    color: Colors.black,
                    shadows: [
                      Shadow(
                          // bottomLeft
                          offset: Offset(-1.5, -1.5),
                          color: Colors.white),
                      Shadow(
                          // bottomRight
                          offset: Offset(1.5, -1.5),
                          color: Colors.white),
                      Shadow(
                          // topRight
                          offset: Offset(1.5, 1.5),
                          color: Colors.white),
                      Shadow(
                          // topLeft
                          offset: Offset(-1.5, 1.5),
                          color: Colors.white),
                    ])),
          ),
          StreamBuilder(

              ///getting the stream of data from firebase store
              stream: FirebaseFirestore.instance.collection('poll').snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                ///testing if the snapshot has data
                if (!snapshot.hasData) {
                  return const LinearProgressIndicator();
                }

                ///if it has data it rturn a listview builder which contains the polls
                else if (snapshot.hasData) {
                  return Expanded(
                    child: ListView(
                      children: [
                        for (int i = 0; i < snapshot.data.docs.length; i++)
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage("assets/Images/News.png"),
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter,
                              ),
                              border: Border.all(color: Colors.amber),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              children: [
                                //Polls start from here
                                Card(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Text(
                                        snapshot.data.docs[i]["question"],
                                        textScaleFactor: 1.6,
                                        style: const TextStyle(
                                            shadows: [
                                              Shadow(
                                                  // bottomLeft
                                                  offset: Offset(-1.5, -1.5),
                                                  color: Colors.red),
                                              Shadow(
                                                  // bottomRight
                                                  offset: Offset(1.5, -1.5),
                                                  color: Colors.amber),
                                              Shadow(
                                                  // topRight
                                                  offset: Offset(1.5, 1.5),
                                                  color: Colors.amber),
                                              Shadow(
                                                  // topLeft
                                                  offset: Offset(-1.5, 1.5),
                                                  color: Colors.red),
                                            ],
                                            fontFamily: 'Windy-Wood-Demo',
                                            color: Colors.black)),
                                  ),
                                ),
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('poll')
                                        .doc(snapshot.data.docs[i].id)
                                        .collection("options")
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot2) {
                                      if (snapshot2.data != null) {
                                        return Column(
                                          children: [
                                            for (int j = 0;
                                                j < snapshot2.data.docs.length;
                                                j++)
                                              //Options[j]

                                              InkWell(
                                                child: Container(
                                                  child: Card(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(12),
                                                      child:
                                                          LinearPercentIndicator(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            140,
                                                        animation: true,
                                                        lineHeight: 30.0,
                                                        animationDuration: 2500,
                                                        percent: snapshot2.data
                                                                    .docs[j]
                                                                ["votes"] /
                                                            100,
                                                        center: Text(
                                                            snapshot2.data
                                                                        .docs[j]
                                                                    ["name"] +
                                                                "  " +
                                                                ((snapshot2.data.docs[j]["votes"] /
                                                                            100) *
                                                                        100)
                                                                    .toString(),
                                                            textScaleFactor:
                                                                1.5,
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Windy-Wood-Demo',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                                shadows: [
                                                                  Shadow(
                                                                      // bottomLeft
                                                                      offset: Offset(
                                                                          -1.5,
                                                                          -1.5),
                                                                      color: Colors
                                                                          .black54),
                                                                  Shadow(
                                                                      // bottomRight
                                                                      offset: Offset(
                                                                          1.5,
                                                                          -1.5),
                                                                      color: Colors
                                                                          .black54),
                                                                  Shadow(
                                                                      // topRight
                                                                      offset: Offset(
                                                                          1.5,
                                                                          1.5),
                                                                      color: Colors
                                                                          .black54),
                                                                  Shadow(
                                                                      // topLeft
                                                                      offset: Offset(
                                                                          -1.5,
                                                                          1.5),
                                                                      color: Colors
                                                                          .black54),
                                                                ])),
                                                        linearStrokeCap:
                                                            LinearStrokeCap
                                                                .roundAll,
                                                        progressColor:
                                                            const Color(
                                                                0xFF911A00),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  if (!wait) {
                                                    wait = true;
                                                    //print(wait);
                                                    var doc = FirebaseFirestore
                                                        .instance
                                                        .collection('poll')
                                                        .doc(snapshot
                                                            .data.docs[i].id)
                                                        .collection('users')
                                                        .doc(user.id);
                                                    await doc
                                                        .get()
                                                        .then((value) async {
                                                      if (!value.exists) {
                                                        var doc2 =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'poll')
                                                                .doc(snapshot
                                                                    .data
                                                                    .docs[i]
                                                                    .id)
                                                                .collection(
                                                                    'options')
                                                                .doc(snapshot2
                                                                    .data
                                                                    .docs[j]
                                                                    .id);
                                                        await doc2.update({
                                                          'votes': 1 +
                                                              snapshot2.data
                                                                      .docs[j]
                                                                  ["votes"]
                                                        });
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('poll')
                                                            .doc(snapshot.data
                                                                .docs[i].id)
                                                            .collection('users')
                                                            .doc(user.id)
                                                            .set({
                                                          "vote": snapshot2
                                                              .data.docs[j].id,
                                                        });
                                                      } else if (snapshot2.data
                                                              .docs[j].id ==
                                                          value
                                                              .data()!["vote"]
                                                              .toString()) {
                                                        print("Same vote !");
                                                        var doc2 =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'poll')
                                                                .doc(snapshot
                                                                    .data
                                                                    .docs[i]
                                                                    .id)
                                                                .collection(
                                                                    'options')
                                                                .doc(snapshot2
                                                                    .data
                                                                    .docs[j]
                                                                    .id);
                                                        await doc2.update({
                                                          'votes': snapshot2
                                                                      .data
                                                                      .docs[j]
                                                                  ["votes"] -
                                                              1
                                                        });
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('poll')
                                                            .doc(snapshot.data
                                                                .docs[i].id)
                                                            .collection('users')
                                                            .doc(user.id)
                                                            .delete();
                                                      }
                                                      wait = false;
                                                    });
                                                    print("Option Chosen: " +
                                                        snapshot2.data.docs[j]
                                                            ["name"]);
                                                  }
                                                },
                                              )
                                          ],
                                        );
                                      }
                                      return const CircularProgressIndicator();
                                    }),
                              ],
                            ),
                          )
                      ],
                    ),
                  );
                }
                return const Text('Nothing found');
              }),
        ]),

        /// a button that takes the admin where he can add a new poll..

        floatingActionButton: Container(
          child: isAdmin == true
              ? FloatingActionButton(
                  backgroundColor: Colors.brown[100],
                  child: const Icon(Icons.add, color: Colors.black),
                  onPressed: () {
                    ///using the navigator to point the context to create poll route
                    if (isAdmin == true) {
                      Navigator.pushNamed(context, '/createpoll');
                    }
                  })
              : null,
        ),
      ),
    ]);
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
