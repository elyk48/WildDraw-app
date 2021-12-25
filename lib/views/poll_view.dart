import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
/// main class for displaying polls for users to vote
class MyPollDisplay extends StatefulWidget {
  @override
  _MyPollDisplayState createState() => _MyPollDisplayState();
}

class _MyPollDisplayState extends State<MyPollDisplay> {
  @override
   late SharedPreferences sharedPrefs;

  late bool isAdmin = false;

  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black38,
      appBar: AppBar(
        title: Text("Polls"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 40,),
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
              )
          ),

        ],
      ),
      ///stream builder used for the stream of data
      ///widget based on the result of a Stream of data collected
      body: StreamBuilder(
        ///getting the stream of data from firebase store
          stream: FirebaseFirestore.instance.collection('poll').snapshots(),
          builder:(BuildContext context,AsyncSnapshot snapshot){
            ///testing if the snapshot has data
            if(!snapshot.hasData){
              return LinearProgressIndicator();
            }
            ///if it has data it rturn a listview builder which contains the polls
            else{
              return ListView.builder(
                ///the number of items in the snapshot..
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context,index){
                    ///getting a single poll using the index..
                    DocumentSnapshot mypoll=snapshot.data.docs[index];
                    ///geting the poll question..
                    String question=mypoll['question'];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                      decoration: BoxDecoration(border:Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),),
                      child: Column(children: <Widget>[
                        Container(

                          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.amber),
                            borderRadius: BorderRadius.circular(5),

                          ),
                          ///puting the question queried in a text widget
                          child: Text("$question",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                        ),
                        Container(
                          height: 74.0*mypoll['length'],
                          ///using another Streambuilder for the options
                          child: StreamBuilder(
                            ///stream builder used for the stream of data
                            ///widget based on the result of a Stream of data collected
                            stream: FirebaseFirestore.instance.collection('poll').doc('$question').collection('options').snapshots(),
                            ///passing the context and the snapshot
                            builder: (BuildContext context,AsyncSnapshot snapshot){
                               ///testing if the snapshot has data or not
                              if(!snapshot.hasData)
                                return LinearProgressIndicator();
                              else{
                                ///if yes it returns a listview that has the options data
                                return ListView.builder(
                                    physics: new NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder:(context,index){

                                      DocumentSnapshot myoptions=snapshot.data.docs[index];


                                      return Column(

                                        children: <Widget>[

                                          Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                            decoration: BoxDecoration(
                                              color: Colors.amberAccent,
                                              border: Border.all(color: Colors.black),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: ListTile(

                                              title: Text(myoptions['name'],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black)),
                                              trailing: Text(myoptions['votes'].toString(),style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black),textScaleFactor: 1.5),
                                              ///voting part (beta version)...
                                              onTap: (){
                                                String uid;
                                                int i=0;
                                                ///getting the currentuser uid

                                                uid=FirebaseAuth.instance.currentUser!.uid;

                                                  print(uid);
                                                   ///getting the document to set the vote of the user
                                                  var doc=FirebaseFirestore.instance.collection('poll').doc(question).collection('users').doc(uid);
                                                  doc.get().then((value){
                                                    ///testing if the user already voted
                                                    if(value.exists){

                                                      i=1;
                                                      print("$i");
                                                    }
                                                    ///if its not the case
                                                    else{
                                                      String qw=myoptions.id;
                                                      var doc2=FirebaseFirestore.instance.collection('poll').doc(question).collection('options').doc(qw);
                                                      print("qw");
                                                      ///updating the votes
                                                      doc2.update({'votes': 1+myoptions['votes']});
                                                      i=2;
                                                      print("$i");
                                                      ///setting the voted true for the currentuser and printing done when the task is completed
                                                      FirebaseFirestore.instance.collection('poll').doc(question).collection('users').doc(uid).set({
                                                        "votes":true,
                                                      }).whenComplete((){print("done");});
                                                    }
                                                  });

                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                );
                              }
                            }
                        ),
                        ),
                      ],),
                    );
                  }
              );
            }
          }
      ),

            /// a button that takes the admin where he can add a new poll..

          floatingActionButton: Container(
            child: isAdmin==true ? FloatingActionButton(
        backgroundColor: Colors.brown[100],
            child: Icon(Icons.add,color: Colors.black),
            onPressed:(){
              ///using the navigator to point the context to create poll route
              if(isAdmin==true)
              Navigator.pushNamed(context,'/createpoll');
            }
      ):null,
          ),
    );
  }


  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => isAdmin = prefs.getBool("isAdmin")!);
    });
  }
}