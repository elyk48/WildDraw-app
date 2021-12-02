import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyPollDisplay extends StatefulWidget {
  @override
  _MyPollDisplayState createState() => _MyPollDisplayState();
}

class _MyPollDisplayState extends State<MyPollDisplay> {
  @override

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
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {

                  Navigator.pushReplacementNamed(context, "/createpoll");
                },
                child: Icon(
                    Icons.add,
                ),
              )
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('poll').snapshots(),
          builder:(BuildContext context,AsyncSnapshot snapshot){
            if(!snapshot.hasData){
              return LinearProgressIndicator();
            }
            else{
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context,index){
                    DocumentSnapshot mypoll=snapshot.data.docs[index];
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
                            color: Colors.blueGrey,
                            border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(5),

                          ),
                          child: Text("$question",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                        ),
                        Container(
                          height: 74.0*mypoll['length'],                                          child: StreamBuilder(

                            stream: FirebaseFirestore.instance.collection('poll').doc('$question').collection('options').snapshots(),
                            builder: (BuildContext context,AsyncSnapshot snapshot){

                              if(!snapshot.hasData)
                                return LinearProgressIndicator();
                              else{
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
                                              color: Colors.amber[100],
                                              border: Border.all(color: Colors.black),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: ListTile(

                                              title: Text(myoptions['name']),
                                              trailing: Text(myoptions['votes'].toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                              onTap: (){
                                                String uid;
                                                int i=0;

                                                uid=FirebaseAuth.instance.currentUser!.uid;

                                                  print(uid);

                                                  var doc=FirebaseFirestore.instance.collection('poll').doc(question).collection('users').doc(uid);
                                                  doc.get().then((value){
                                                    if(value.exists){

                                                      i=1;
                                                      print("$i");
                                                    }else{
                                                      String qw=myoptions.id;
                                                      var doc2=FirebaseFirestore.instance.collection('poll').doc(question).collection('options').doc(qw);
                                                      print("qw");
                                                      doc2.update({'votes': 1+myoptions['votes']});
                                                      i=2;
                                                      print("$i");
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


      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,),
          onPressed:(){
            Navigator.pushNamed(context,'/pollCreate');
          }
      ),
    );
  }
}