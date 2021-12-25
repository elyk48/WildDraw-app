import 'package:cardgameapp/controllers/publicationcontroller.dart';
import 'package:cardgameapp/entities/publication.dart';
import 'package:cardgameapp/entities/user.dart';
import 'package:cardgameapp/session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PublicationView extends StatefulWidget {
  const PublicationView({Key? key}) : super(key: key);

  @override
  _PublicationViewState createState() => _PublicationViewState();
}

class _PublicationViewState extends State<PublicationView> {
  //late SharedPreferences prefs;
  late List<dynamic> _AllPubs = [];
  late Future<List> futurepubs;

  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  UserE user = UserE.NewUser(
      "email", "password", "username", "birthdate", "address", "image", false);

  CollectionReference publications =
      FirebaseFirestore.instance.collection('publications');

  @override
  Widget build(BuildContext context) {
    return FBPublicationList();
  }

  FutureBuilder<List> FBPublicationList() {
    late Publication pub = Publication.newPub(
        "Bienvenue à esprit Méteo !", user.id, user.username);
    return FutureBuilder(
      future: futurepubs,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 25, 15, 15),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Images/publication_board.png"),
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
                    0.0001,
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
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage("assets/Images/publication_form.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Form(
                        key: _keyForm,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(15, 50, 15, 0),
                              child: TextFormField(
                                controller: _controller,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Windy-Wood-Demo',
                                    fontSize: 30,
                                    decorationColor: Colors.black),
                                cursorColor: Colors.black54,
                                maxLength: 200,
                                enableInteractiveSelection: true,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
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
                                  labelText: "Tell us what you think !",
                                ),
                                onSaved: (String? value) {
                                  pub.content = value!;

                                },
                              ),
                            ),
                            SizedBox(
                              width: 380,
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_keyForm.currentState!.validate()) {
                                      _keyForm.currentState!.save();
                                      if (pub.content != "" &&
                                          pub.content != null) {
                                        publicationController PC =
                                            await publicationController();
                                        PC.addPublication(pub);
                                        setState(() {
                                          _controller.clear();
                                          _AllPubs = <dynamic>[];
                                          futurepubs = getAllPubs(_AllPubs);
                                        });
                                      }
                                    }
                                  },
                                  child: const Text("Post"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_AllPubs.isNotEmpty)
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _AllPubs.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Wrap(
                            children: [
                              if (_AllPubs[index]["id_user"] == user.id)
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 15, 15),
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/Images/publication_form.png"),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  width: 400,
                                  child: (Column(children: [
                                    PublicationCard(
                                        _AllPubs[index]["id_user"],
                                        _AllPubs[index]["id"],
                                        _AllPubs[index]["content"],
                                        _AllPubs[index]["likes"],
                                        _AllPubs[index]["postedOn"],
                                        _AllPubs[index]["username"]),
                                    SizedBox(
                                      width: 400,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.red),
                                        onPressed: () async {
                                          await deletePublication(
                                              _AllPubs[index]["id"]);
                                          setState(() {
                                            _AllPubs = <dynamic>[];
                                            futurepubs = getAllPubs(_AllPubs);
                                          });
                                        },
                                        child: const Text("Delete"),
                                      ),
                                    ),
                                  ])),
                                )
                              else
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 15, 15),
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/Images/publication_form.png"),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  width: 400,
                                  child: (PublicationCard(
                                      _AllPubs[index]["id_user"],
                                      _AllPubs[index]["id"],
                                      _AllPubs[index]["content"],
                                      _AllPubs[index]["likes"],
                                      _AllPubs[index]["postedOn"],
                                      _AllPubs[index]["username"])),
                                )
                            ],
                          );
                        },
                      ),
                    if (_AllPubs.isEmpty) const CircularProgressIndicator(),
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

  @override
  void initState() {
    futurepubs = getAllPubs(_AllPubs);
    super.initState();
    Session.setUser(user);
  }

  Future<List> getAllPubs(List<dynamic> l) async {
    QuerySnapshot querySnapshot;
    try {
      querySnapshot = await publications.get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "content": doc["content"],
            "id_user": doc["id_user"],
            "likes": doc["likes"],
            "postedOn": doc["postedOn"],
            "username": doc["username"]
          };
          l.add(a);
        }
        return _AllPubs;
      }
    } catch (e) {
      print(e);
    }
    return _AllPubs;
  }

  static Future<void> deletePublication(String docId) async {
    CollectionReference publications =
        FirebaseFirestore.instance.collection('publications');
    DocumentReference documentReferencer = publications.doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}
