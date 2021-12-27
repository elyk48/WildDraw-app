import 'package:cardgameapp/entities/actualite.dart';
import 'package:cardgameapp/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cardgameapp/session.dart';

class actualiteView extends StatefulWidget {
  const actualiteView({Key? key}) : super(key: key);

  @override
  _actualiteViewState createState() => _actualiteViewState();
}

class _actualiteViewState extends State<actualiteView> {
  late List<dynamic> _AllActs = [];
  late Future<List> futureActs;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  UserE user = UserE.NewUser("email", "password", "username", "birthdate", "address", "image", false);


  CollectionReference actualites =
      FirebaseFirestore.instance.collection('actualites');
  late actualite act = actualite.newAct(user.id, "Test", "Yes", user.username);
  late FocusNode myFocusNode;

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FBActualieList();
  }

  Future<List> getAllActs(List<dynamic> l) async {
    QuerySnapshot querySnapshot;
    try {
      querySnapshot = await actualites.get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "content": doc["content"],
            "id_user": doc["id_user"],
            "postedOn": doc["postedOn"],
            "author": doc["author"],
            "title": doc["title"]
          };
          l.add(a);
        }
        return _AllActs;
      }
    } catch (e) {
      print(e);
    }
    return _AllActs;
  }
  @override
  void initState() {
    futureActs = getAllActs(_AllActs);
    myFocusNode = FocusNode();
    super.initState();
    Session.setUser(user);
  }

  static Future<void> deleteActualite(String docId) async {
    CollectionReference actualites =
        FirebaseFirestore.instance.collection('actualites');
    DocumentReference documentReferencer = actualites.doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }

  FutureBuilder<List> FBActualieList() {
    return FutureBuilder(
      future: futureActs,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Images/News.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: ShaderMask(
              shaderCallback: (Rect rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.purple,
                    Colors.transparent,
                    Colors.transparent,
                    Colors.purple
                  ],
                  stops: [
                    0.1,
                    0.1,
                    0.9,
                    1.0
                  ], // 10% purple, 80% transparent, 10% purple
                ).createShader(rect);
              },
              blendMode: BlendMode.dstOut,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (user.isAdmin)
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                        width: 320,
                        child: Form(
                          key: _keyForm,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _controller,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Windy-Wood-Demo',
                                    fontSize: 30,
                                    decorationColor: Colors.black),
                                cursorColor: Colors.black54,
                                autofocus: false,
                                maxLines: 1,
                                maxLength: 21,
                                decoration: const InputDecoration(
                                  counterStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      fontFamily: 'Windy-Wood-Demo',
                                      color: Colors.black),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: 'Windy-Wood-Demo',
                                  ),
                                  labelText: "Title",
                                ),
                                onSaved: (String? value) {
                                  act.title = value!;
                                },
                              ),
                              TextFormField(
                                controller: _controller2,
                                cursorColor: Colors.black54,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Windy-Wood-Demo',
                                  fontSize: 25,
                                ),
                                autofocus: false,
                                keyboardType: TextInputType.multiline,
                                maxLength: 500,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  counterStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      fontFamily: 'Windy-Wood-Demo',
                                      color: Colors.black),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: 'Windy-Wood-Demo',
                                  ),
                                  labelText: "Tell us what's new !",
                                ),
                                onSaved: (String? value) {
                                  act.content = value!;
                                },
                              ),
                              SizedBox(
                                width: 380,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    myFocusNode.unfocus();
                                    if (_keyForm.currentState!.validate()) {
                                      _keyForm.currentState!.save();
                                      if (act.content != "" &&
                                          act.title != null &&
                                          act.title != "" &&
                                          act.content != null) {
                                        await addActualite(act);
                                        setState(() {
                                          _AllActs = <dynamic>[];
                                          futureActs = getAllActs(_AllActs);
                                          _controller.clear();
                                          _controller2.clear();
                                        });
                                      }
                                    }
                                  },
                                  child: const Text("Publish"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (!user.isAdmin) const SizedBox(height: 80),
                    if (_AllActs.isNotEmpty)
                      GridView.builder(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _AllActs.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Wrap(
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    if (_AllActs[index]["id_user"] == user.id)
                                      Dismissible(
                                        direction: DismissDirection.startToEnd,
                                        key: Key(_AllActs[index]["id"]),
                                        child: ActualiteCard(
                                            _AllActs[index]["id"],
                                            _AllActs[index]["id_user"],
                                            _AllActs[index]["title"],
                                            _AllActs[index]["content"],
                                            _AllActs[index]["author"],
                                            _AllActs[index]["postedOn"]),
                                        onDismissed: (direction) {
                                          setState(() async {
                                            showAlertDialog(context,
                                                _AllActs[index]["id"], index);
                                          });
                                        },
                                        background: Container(
                                            //color: Colors.red,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/Images/Delete_Strip.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 220, 0),
                                              child: const Center(
                                                child: Text("Delete",
                                                    textScaleFactor: 3,
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            )),
                                      ),
                                    if (_AllActs[index]["id_user"] != user.id)
                                      ActualiteCard(
                                          _AllActs[index]["id"],
                                          _AllActs[index]["id_user"],
                                          _AllActs[index]["title"],
                                          _AllActs[index]["content"],
                                          _AllActs[index]["author"],
                                          _AllActs[index]["postedOn"]),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                crossAxisSpacing: 1,
                                mainAxisSpacing: 10,
                                mainAxisExtent: 80),
                      ),
                    if (_AllActs.isEmpty) CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<actualite> addActualite(actualite act) async {
    DocumentReference docRef = await actualites.add({
      'id_user': act.idUser,
      'author': act.author,
      'content': act.content,
      'title': act.title,
      'postedOn': act.postedOn,
    });
    act.id = docRef.id;
    print(act.id);
    return act;
  }

  showAlertDialog(BuildContext context, String id, int index) {
    // Create button
    Widget okButton = ElevatedButton(
      child: Text("Yes I wanna delete it"),
      onPressed: () {
        _AllActs.removeAt(index);
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {
          deleteActualite(id);
          _AllActs = <dynamic>[];
          futureActs = getAllActs(_AllActs);
        });
      },
    );
    Widget NoButton = ElevatedButton(
      child: Text("Nope"),
      onPressed: () {
        _AllActs.insert(
            index,
            ActualiteCard(
                _AllActs[index]["id"],
                _AllActs[index]["id_user"],
                _AllActs[index]["title"],
                _AllActs[index]["content"],
                _AllActs[index]["author"],
                _AllActs[index]["postedOn"]));

        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {
          _AllActs = <dynamic>[];
          futureActs = getAllActs(_AllActs);
        });
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("News"),
      content: Text("Are you sure you want to delete this ?"),
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
}
