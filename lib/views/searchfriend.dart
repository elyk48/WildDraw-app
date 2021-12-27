import 'package:cardgameapp/controllers/usercontroller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search for a friend"),
      ),
      body: isLoading
          ? Center(
              child: const Text("No user of that name found.."),
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
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                        hintText: "Search friend",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                ElevatedButton(
                  onPressed: onSearch,
                  child: Text("Search"),
                ),
                userMap.isNotEmpty
                    ? Row(
                        children: [
                          ///reroll button
                          IconButton(
                            icon: Image.asset('assets/Images/Default.png'),
                            iconSize: 50,
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

                          /// quest data view
                          Column(
                            children: [
                              Text(userMap["username"]),
                              Text(userMap["Rank"]),
                            ],
                          )
                        ],
                      )

                    : Container(
                        child: Text("no match"),
                      )
              ],
            ),
    );
  }

  void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Friend Added"),
              content: Text("Friend Added to your list !!"),
            ));
  }
}
