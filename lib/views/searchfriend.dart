import 'package:cardgameapp/controllers/usercontroller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchFriend extends StatefulWidget {
  const SearchFriend({Key? key}) : super(key: key);

  @override
  _SearchFriendState createState() => _SearchFriendState();
}

class _SearchFriendState extends State<SearchFriend> {
  bool isLoading = false;
  userController userC = userController();
  late Map<String, dynamic> userMap = {};

  final TextEditingController _search = TextEditingController();

  void onSearch() async {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore
        .collection("users")
        .where("username", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(children: [
      Image.asset(
        "assets/Images/backboard.png",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fill,
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.black54,
          foregroundColor: Colors.amberAccent,
          title: const Text(
            "Search for a friend",
            style: TextStyle(
              fontFamily: 'Windy-Wood-Demo',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: isLoading
            ? const Center(
                child: Text(
                  "No user of that name found..",
                  style: TextStyle(
                    fontFamily: 'Windy-Wood-Demo',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    shadows: [
                      Shadow(
                          // bottomLeft
                          offset: Offset(-1.5, -1.5),
                          color: Colors.black),
                      Shadow(
                          // bottomRight
                          offset: Offset(1.5, -1.5),
                          color: Colors.black),
                      Shadow(
                          // topRight
                          offset: Offset(1.5, 1.5),
                          color: Colors.black),
                      Shadow(
                          // topLeft
                          offset: Offset(-1.5, 1.5),
                          color: Colors.black),
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  SizedBox(
                    height: size.height / 20,
                  ),
                  Container(
                    height: size.height / 14,
                    width: size.width,
                    alignment: Alignment.center,
                    child: Container(
                      height: size.height / 14,
                      width: size.width / 1.2,
                      child: TextFormField(
                        cursorColor: Colors.amber,
                        style: const TextStyle(
                          fontFamily: 'Windy-Wood-Demo',
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        controller: _search,
                        decoration: InputDecoration(
                          disabledBorder: InputBorder.none,
                          hintText: "Search friend",
                          hintStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide: const BorderSide(
                                color: Colors.black54, width: 10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide: const BorderSide(
                                color: Colors.black54, width: 10),
                          ),
                          labelStyle: new TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  SizedBox(
                    child: Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage("assets/Images/Scroll.png"),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.bottomRight,
                      )),
                      child: InkWell(
                        onTap: onSearch,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: const Center(
                            child: Text(
                              'Search',
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
                                fontSize: 14,
                              ),
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    height: 40,
                    width: 120,
                  ),
                  userMap.isNotEmpty
                      ? Container(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ///button

                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                child: IconButton(
                                  icon: Image.asset('assets/Images/plus.png'),
                                  iconSize: 60,
                                  onPressed: () async {
                                    userC.AddFriend(
                                        userMap["username"],
                                        userMap["Rank"],
                                        userMap["email"],
                                        userMap["level"],
                                        userMap["Id"]);
                                    _showAlert(context);
                                    // await Future.delayed(Duration(seconds: 2));
                                  },
                                ),
                              ),

                              /// quest data view
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    userMap["username"],
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'Windy-Wood-Demo',
                                        color: Colors.black54),
                                  ),
                                  Text(
                                    "Rank " + userMap["Rank"],
                                    textScaleFactor: 1.7,
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
                                        color: Colors.black54),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      : Container(
                          child: Text(""),
                        )
                ],
              ),
      ),
    ]);
  }
  void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              title: Text("Friend Added"),
              content: Text("Friend Added to your list !!"),
            ));
  }
}
