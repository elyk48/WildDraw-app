import 'package:cardgameapp/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../session.dart';

class Profile extends StatefulWidget {
  static String tag = 'Profile-page';

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
          Navigator.pushReplacementNamed(context, '/singin');
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
        title: const Text("Delete Account"),
        content: const Text("Are you sure you want to delete your account ?"),
        actions: [okButton, NoButton],
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
    final body = Column(
      children: <Widget>[
        lorem,
        FutureBuilder(
            future: Session.setUser(user),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Text("Loading data...Please wait");
              } else {
                return Expanded(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2.5,
                        padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/Images/scrollP.png"),
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.topCenter),
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white54,
                              radius: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(user.image, scale: 1),
                                  radius: 100,
                                ),
                              ),
                            ),
                            Text(
                              user.username,
                              textScaleFactor: 1.2,
                              style: const TextStyle(
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
                                ],
                                fontFamily: 'Windy-Wood-Demo',
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        verticalDirection: VerticalDirection.up,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //alignment: Alignment.topCenter,
                          Image.asset(
                            "assets/Images/magic3.png",
                            scale: 15,
                            colorBlendMode: BlendMode.color,
                          ),

                          Image.asset(
                            "assets/Images/magic_book.png",
                            scale: 12,
                            colorBlendMode: BlendMode.color,
                          ),
                          Image.asset("assets/Images/magic1.png",
                              scale: 15, colorBlendMode: BlendMode.color),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2.5,
                        padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/Images/scrollP.png"),
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.topCenter),
                        ),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          "Level " + user.level,
                                          textScaleFactor: 1.2,
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
                                            color: Colors.black54,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          "Rank " + user.Rank,
                                          textScaleFactor: 1.2,
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
                                            color: Colors.black54,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                    thickness: 1.2,
                                    indent: 50,
                                    endIndent: 50,
                                    color: Colors.black54),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    "BirthYear : " + user.birth,
                                    textScaleFactor: 1.2,
                                    style: const TextStyle(
                                      fontFamily: 'Windy-Wood-Demo',
                                      color: Colors.black54,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Divider(
                                    thickness: 1.2,
                                    indent: 50,
                                    endIndent: 50,
                                    color: Colors.black54),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 5, 5),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Address : ",
                                        textScaleFactor: 1,
                                        style: TextStyle(
                                          fontFamily: 'Windy-Wood-Demo',
                                          color: Colors.black54,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        user.address,
                                        textScaleFactor: 1,
                                        style: const TextStyle(
                                          fontFamily: 'Windy-Wood-Demo',
                                          color: Colors.black54,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                verticalDirection: VerticalDirection.down,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                        image: AssetImage(
                                            "assets/Images/Scroll.png"),
                                        fit: BoxFit.fitWidth,
                                        alignment: Alignment.topCenter,
                                      )),
                                      child: InkWell(
                                        onTap: () {
                                          showAlertDialog(context, user.id);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              28, 12, 12, 13),
                                          child: Text(
                                            'Delete Account',
                                            style: TextStyle(
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
                                              color: Colors.black,
                                              fontFamily: 'Windy-Wood-Demo',
                                              fontSize: 15.5,
                                            ),
                                            textScaleFactor: 1.1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    height: 50,
                                    width: 160,
                                  ),
                                  SizedBox(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                        image: AssetImage(
                                            "assets/Images/Scroll.png"),
                                        fit: BoxFit.fitWidth,
                                        alignment: Alignment.topCenter,
                                      )),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, "/editProfile");
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              35, 12, 12, 13),
                                          child: Text(
                                            'Edit Profile',
                                            style: TextStyle(
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
                                              color: Colors.black,
                                              fontFamily: 'Windy-Wood-Demo',
                                              fontSize: 15.5,
                                            ),
                                            textScaleFactor: 1.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    height: 50,
                                    width: 160,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
      ],
    );

    return Stack(children: [
      Image.asset(
        "assets/Images/oldwood.jpg",
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
            "Profile",
            style: TextStyle(
                fontFamily: 'Windy-Wood-Demo', fontWeight: FontWeight.bold),
            textScaleFactor: 1,
          ),
        ),
        body: body,
        resizeToAvoidBottomInset: true,
      ),
    ]);
  }

  ///User Functions
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
