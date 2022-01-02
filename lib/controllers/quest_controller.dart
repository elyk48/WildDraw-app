import 'dart:math';
import 'package:cardgameapp/entities/quest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuestController {
  late String _idGenerated;
  FirebaseFirestore? _instance;

  late String usercurrentId;
  CollectionReference DailyQuests =
      FirebaseFirestore.instance.collection('quests');

  ///a function to add the quests
  Future<void> addQuest(String Qtitle, String levelrange, String Qdescription) {
    ///creating a quest instance with the variables passed to the parameter
    Quest quest1 = Quest.NewQuest(Qtitle, levelrange, Qdescription);
    usercurrentId = FirebaseAuth.instance.currentUser!.uid;

    ///a random instance to generate a random id for the document
    var rng = Random();

    ///a future function to set the attributes in the doc ref
    Future<void> Questref = DailyQuests.doc(rng.nextInt(10000).toString()).set({
      'QuestTitle': quest1.Qtitle,
      'levelRange': quest1.levelrange,
      'Qdescription': quest1.Qdescription,
    }).catchError((error) => print("Failed to add user : $error"));
    return Questref;
  }
}
