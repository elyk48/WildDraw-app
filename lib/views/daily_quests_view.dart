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
  double _opacity = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Image.asset(
        "assets/Images/map.jpg",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.black54,
          foregroundColor: Colors.amberAccent,

          title: const Text(
            "Daily Quests",
            style: TextStyle(
              fontFamily: 'Windy-Wood-Demo',
              fontWeight: FontWeight.bold,
            ),
          ),

          ///a button to return to the home page
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 40,
            ),

            ///using the navigator to redirect the data to the hoem page
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed("/home"),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                child: const Text("Your Daily Quests",
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
              const SizedBox(
                height: 60,
              ),
              StreamBuilder(
                ///getting the stream of data from firebase store
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(usercurrentId)
                    .collection("quests")
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return const LinearProgressIndicator();
                  } else {
                    return Expanded(
                      child: ListView.builder(

                          ///the number of items in the snapshot..
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            ///getting a single quest using the index..
                            DocumentSnapshot myquest =
                                snapshot.data.docs[index];

                            ///geting the quest data
                            String docId = myquest.id;
                            String questTitle = myquest['QuestTitle'];
                            String level = myquest['levelRange'];
                            String Qdesc = myquest['Qdescription'];

                            ///the quest data view as a card
                            return Container(
                              child: AnimatedOpacity(
                                duration: Duration(microseconds: 300),
                                opacity: _opacity,
                                child: Card(
                                  semanticContainer: true,
                                  shadowColor: Colors.black,
                                  elevation: 10,
                                  borderOnForeground: true,
                                  margin: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/Images/try.png"),
                                              fit: BoxFit.fill,
                                              alignment: Alignment.topCenter,
                                            )),
                                        child: Row(
                                          children: [
                                            ///reroll button
                                            InkWell(
                                              child: Column(
                                                children: [const Text("Reroll",style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontFamily:
                                                    'Windy-Wood-Demo',
                                                    fontSize: 15.5,
                                                    decorationThickness:
                                                    4,
                                                    color:Colors.black87,
                                                    )),
                                                  IconButton(
                                                    icon: Image.asset(
                                                        'assets/Images/reroll.png'),
                                                    iconSize: 50,
                                                    onPressed: () async {
                                                      late String usercurrentId;
                                                      usercurrentId = FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid;
                                                      CollectionReference users =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users');
                                                      users
                                                          .doc(usercurrentId)
                                                          .collection("rerolled")
                                                          .doc(usercurrentId)
                                                          .get()
                                                          .then((value) async {
                                                        setState(() {
                                                          rerolled =
                                                              value.data()![
                                                                  "rerolled"];
                                                        });
                                                      });

                                                      if (rerolled == false) {
                                                        userC.Reroll(docId);
                                                      } else {
                                                        print(
                                                            "wait 24h before the next reroll");
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),

                                            /// quest data view
                                            Container(
                                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                verticalDirection:
                                                    VerticalDirection.down,
                                                children: [
                                                  ///Title
                                                  Text(questTitle,
                                                      textScaleFactor: 1.7,
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Windy-Wood-Demo',
                                                          color: Colors.white,
                                                          shadows: [
                                                            Shadow(
                                                                // bottomLeft
                                                                offset: Offset(
                                                                    -1.5, -1.5),
                                                                color: Colors
                                                                    .black),
                                                            Shadow(
                                                                // bottomRight
                                                                offset: Offset(
                                                                    1.5, -1.5),
                                                                color: Colors
                                                                    .black),
                                                            Shadow(
                                                                // topRight
                                                                blurRadius: 5,
                                                                offset: Offset(
                                                                    1.5, 1.5),
                                                                color: Colors
                                                                    .black),
                                                            Shadow(
                                                                // topLeft
                                                                offset: Offset(
                                                                    -1.5, 1.5),
                                                                color: Colors
                                                                    .black),
                                                          ])),

                                                  ///quest level
                                                  Text(level,
                                                      textScaleFactor: 1,
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Windy-Wood-Demo',
                                                          color: Colors.black,
                                                          shadows: [
                                                            Shadow(
                                                                // bottomLeft
                                                                offset: Offset(
                                                                    -1.5, -1.5),
                                                                color: Colors
                                                                    .yellow),
                                                            Shadow(
                                                                // bottomRight
                                                                offset: Offset(
                                                                    1.5, -1.5),
                                                                color: Colors
                                                                    .yellowAccent),
                                                            Shadow(
                                                                // topRight

                                                                offset: Offset(
                                                                    1.5, 1.5),
                                                                color: Colors
                                                                    .amberAccent),
                                                            Shadow(
                                                                // topLeft
                                                                offset: Offset(
                                                                    -1.5, 1.5),
                                                                color: Colors
                                                                    .amber),
                                                          ])),

                                                  ///quest decription
                                                  Text(Qdesc,
                                                      textScaleFactor: 1.4,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                          fontFamily:
                                                              'Windy-Wood-Demo',
                                                          fontSize: 15.5,
                                                          decorationThickness:
                                                              4,
                                                          color:
                                                              Color(0xFF911A00),
                                                          shadows: [
                                                            Shadow(
                                                                // bottomLeft
                                                                offset: Offset(
                                                                    -1.5, -1.5),
                                                                color: Colors
                                                                    .white10),
                                                            Shadow(
                                                                // bottomRight
                                                                offset: Offset(
                                                                    1.5, -1.5),
                                                                color: Colors
                                                                    .white10),
                                                          ])),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        floatingActionButton: Container(
          child: isAdmin == true
              ? FloatingActionButton(
                  backgroundColor: Colors.brown[100],
                  child: const Icon(Icons.add, color: Colors.black),
                  onPressed: () {
                    ///using the navigator to point the context to create poll route
                    if (isAdmin == true) {
                      Navigator.pushNamed(context, '/createQuest');
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
    users.doc(usercurrentId).collection("quests").get().then((value) async {
      Dlength = await value.size;

      if (Dlength != 4) {
        userC.addQuest2();
      } else {
        print("no");
      }
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
            _opacity = 1;
            rerolled = value.data()!["rerolled"];
          });
        });
      });
    });
  }
}
