import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DailyQuests extends StatefulWidget {
  const DailyQuests({Key? key}) : super(key: key);

  @override
  _DailyQuestsState createState() => _DailyQuestsState();
}

///DailyQuests view
class _DailyQuestsState extends State<DailyQuests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title: Text("Daily Quests"),
        ///a button to return to the home page
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 40,),
          ///using the navigator to redirect the data to the hoem page
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
          ///a button to go the create quest view
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
               ///using the navigator to redirect the data to the create quest view
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
    itemCount: 3,
    itemBuilder: (context,index) {
      ///getting a single quest using the index..
      DocumentSnapshot myquest = snapshot.data.docs[index];

      ///geting the quest data
      String questTitle = myquest['QuestTitle'];
      String  level=myquest['levelRange'];
      String Qdesc=myquest['Qdescription'];
///the quest data view as a card
      return Container(

        child: SizedBox(
          height: 100,
          width: 100,
          child: Card(
            child: Column(

              children: [

                Row(


                  children: [
                    ///reroll button
                    IconButton(
                      icon: Image.asset('assets/Images/reroll.png'),
                      iconSize: 50,

                      onPressed: () {
                        ///storing the number of docs inside the snapshot
                        var length = snapshot.data.docs.length;
                        ///Random instance
                        var rng = new Random();
                        /// getting a random quest
                        myquest =  snapshot.data.docs[rng.nextInt(length)];
                        ///testing the values
                        print(myquest.data().toString());
                        ///set state to save the new values
                        setState(() {
                           ///fetching data from the snapshot
                           questTitle = myquest['QuestTitle'];
                            level=myquest['levelRange'];
                          Qdesc=myquest['Qdescription'];


                        });
                      },
                    ),
               /// quest data view
                    Column(
                      children: [
                   ///Title
                        Text(questTitle,textScaleFactor: 1.5,),
                        ///quest level
                        Text(level),
                        ///quest decription
                        Text(Qdesc),
                      ],
                    )

                  ],
                )
          ],
            ),
          ),
        ),

      );
    });

    }


},
)

    );
  }
}
