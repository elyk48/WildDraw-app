
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
    return Scaffold(
      appBar: AppBar(

        title: Text("Friend's list"),

      ),

      body: Column(

        crossAxisAlignment:CrossAxisAlignment.center,


        children: [


          Padding(
            padding: EdgeInsets.symmetric(vertical: 20,horizontal:70),
            child: RaisedButton(
                color: Colors.black54,
                child: Text('AddFriend', style: TextStyle(color: Colors.amberAccent,fontSize: 15)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                onPressed: () {

                  Navigator.pushReplacementNamed(context, "/searchfriends");
                }),


          ),



          StreamBuilder(
            ///getting the stream of data from firebase store
              stream: FirebaseFirestore.instance.collection('users').doc(usercurrentId).collection("friends").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(!snapshot.hasData){
                  return LinearProgressIndicator();
                }
                else{
                  return ListView.builder(
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

                          child: SizedBox(
                            height: 150,
                            width: 100,
                            child: Card(
                              shadowColor: Colors.black,
                              child: Column(

                                children: [


                                  Row(


                                    children: [

                                      /// friend data view
                                      Column(
                                        children: [
                                          ///username
                                          Text("Username : "+friendUsername,textScaleFactor: 1.5,),
                                          ///Rank
                                          Text("Rank : " +friendRank),
                                          ///
                                          Text("Level : " +friendLevel),
                                        ],
                                      ),


                                    ],
                                  ),
                                  ///Delete button
                                  IconButton(
                                    icon: Image.asset('assets/Images/delete.png'),
                                    iconSize: 50,

                                    onPressed: () {
                                      userC.DeleteFriend(friendId);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                        );




                      }
                  );

                }
              }



          ),


        ],

      ),

    );
  }
}