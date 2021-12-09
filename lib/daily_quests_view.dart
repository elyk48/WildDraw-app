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
    itemCount: 3,
    itemBuilder: (context,index) {
      ///getting a single quest using the index..
      DocumentSnapshot myquest = snapshot.data.docs[index];

      ///geting the quest data
      String questTitle = myquest['QuestTitle'];
      String  level=myquest['levelRange'];
      String Qdesc=myquest['Qdescription'];

      return Container(

        child: SizedBox(
          height: 100,
          width: 100,
          child: Card(
            child: Column(

              children: [

                Row(


                  children: [
                    IconButton(
                      icon: Image.asset('assets/Images/reroll.png'),
                      iconSize: 50,
                      onPressed: () {
                        var length = snapshot.data.docs.length;
                        var rng = new Random();

                        myquest =  snapshot.data.docs[rng.nextInt(length)];
                        print(myquest.data().toString());
                        setState(() {

                           questTitle = myquest['QuestTitle'];
                            level=myquest['levelRange'];
                          Qdesc=myquest['Qdescription'];


                        });
                      },
                    ),

                    Column(
                      children: [

                        Text(questTitle,textScaleFactor: 1.5,),
                        Text(level),
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
