import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DailyQuests extends StatefulWidget {
  const DailyQuests({Key? key}) : super(key: key);

  @override
  _DailyQuestsState createState() => _DailyQuestsState();
}

class _DailyQuestsState extends State<DailyQuests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title: Text("Daily Quests"),
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

                  Navigator.pushReplacementNamed(context, "/createQuest");
                },
                child: Icon(
                  Icons.add,
                ),
              )
          ),
        ],
      ),

body:StreamBuilder(
    ///getting the stream of data from firebase store
    stream: FirebaseFirestore.instance.collection('quests').snapshots(),
  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    if(!snapshot.hasData){
      return LinearProgressIndicator();
    }
    else{
    return ListView.builder(
    ///the number of items in the snapshot..
    itemCount: snapshot.data.docs.length,
    itemBuilder: (context,index) {
      ///getting a single poll using the index..
      DocumentSnapshot myquest = snapshot.data.docs[index];

      ///geting the poll question..
      String question = myquest[''];
    });

    };


},
)

    );
  }
}
