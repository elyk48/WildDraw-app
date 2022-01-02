import 'package:cardgameapp/controllers/usercontroller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({Key? key}) : super(key: key);

  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {

  userController userC= userController();
  String usercurrentId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

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

            title: Text("Friend's list"
            ,
              style: TextStyle(

                fontFamily: 'Windy-Wood-Demo',
                fontWeight: FontWeight.bold,

              ),
            ),

          ),

          body: Column(

            crossAxisAlignment:CrossAxisAlignment.center,


            children: [

              Container(
                
                    
                  child: const Text("Friend's List",textScaleFactor: 3,

                    style: TextStyle(

                     fontFamily: 'Windy-Wood-Demo',
                      fontWeight: FontWeight.bold,
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
                        ]


                    ),

                  ),
                margin: EdgeInsets.all(35),
                      

              ),

              SizedBox(
                height: 30,

              ),

              SizedBox(

                child: Container(

                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/Images/Scroll.png"),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      )),

                  child: InkWell(


                    onTap: (){

                      Navigator.pushNamed(context, "/searchfriends");

                    },
                    child:Padding(
                      padding: const EdgeInsets.fromLTRB(35, 12, 12, 13),
                      child: Text(
                        'Add Friend',

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
                        textScaleFactor: 1.5,
                      ),
                    ),
                  ),



                ),
                height: 60,
                width: 180,

              ),




              StreamBuilder(
                ///getting the stream of data from firebase store
                  stream: FirebaseFirestore.instance.collection('users').doc(usercurrentId).collection("friends").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if(!snapshot.hasData){
                      return LinearProgressIndicator();
                    }
                    else{
                      return Expanded(
                        child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              ///the number of items in the snapshot..
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context,index){

                                DocumentSnapshot friend = snapshot.data.docs[index];
                                String docId =friend.id;
                                String friendUsername = friend['username'];
                                String friendRank = friend['Rank'];
                                String friendLevel =friend["Level"];
                                String friendId =friend["Id"];

                                return Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,



                                  child: SizedBox(
                                    height: 170,
                                    width: 150,
                                    child: Container(
                                      decoration: BoxDecoration(


                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/Images/scrollPi.png"),
                                            fit: BoxFit.fitWidth,
                                            alignment: Alignment.topCenter,
                                          ),





                                      ),

                                      child: Card(
                                        shadowColor: Colors.black,
                                        child: Column(

                                          children: [



                                                /// friend data view
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    ///username


                                                       Container(
                                                        alignment: Alignment.topCenter,
                                                        child: Text(
                                                          friendUsername,
                                                          textScaleFactor: 1.4,
                                                          style: const TextStyle(

                                                            fontFamily: 'Windy-Wood-Demo',
                                                            color: Colors.black54,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),

                                                    ///Rank

                                                     Container(
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          "Rank "+friendRank,
                                                          textScaleFactor: 1,
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

                                                    ///
                                                    Container(

                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          "Level "+friendLevel,
                                                          textScaleFactor: 0.75,
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



                                            ///Delete button


                                            SizedBox(
                                              height: 10,
                                            ),

                                            SizedBox(

                                              child: Container(


                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/Images/Scroll.png"),
                                                      fit: BoxFit.fitWidth,
                                                      alignment: Alignment.bottomRight,
                                                    )),

                                                child: InkWell(


                                                  onTap: (){

                                                    userC.DeleteFriend(friendId);

                                                  },
                                                  child:Padding(
                                                    padding: const EdgeInsets.fromLTRB(35, 8, 12, 13),
                                                    child: Text(
                                                      'Remove',
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
                                                      textScaleFactor: 1.1,
                                                    ),
                                                  ),
                                                ),



                                              ),
                                              height: 35,
                                              width: 120,

                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                );





                              }
                          ),
                      );


                    }
                  }



              ),


            ],

          ),

        ),

      ]

    );
  }
}