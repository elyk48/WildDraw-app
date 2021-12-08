import 'dart:math';

import 'package:cardgameapp/entities/quest.dart';
import 'package:cardgameapp/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class  QuestController {
  late String _idGenerated;
  FirebaseFirestore? _instance;


  late String usercurrentId;
  CollectionReference DailyQuests = FirebaseFirestore.instance.collection('quests');

  Future<void> addQuest(  String Qtitle,
  String levelrange,
  String Qdescription) {
    Quest quest1 = Quest.NewQuest( Qtitle, levelrange, Qdescription);
    usercurrentId = FirebaseAuth.instance.currentUser!.uid;
    var rng = new Random();

    Future<void> Questref = DailyQuests.doc(rng.nextInt(10000).toString()).set({

      'QuestTitle': quest1.Qtitle ,
      'levelRange': quest1.levelrange,
      'Qdescription': quest1.Qdescription,



    })

        .catchError((error) => print("Failed to add user : $error"));



    return Questref;
  }



  Future<String>  _getUserData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userid = FirebaseAuth.instance.currentUser!.uid;
    prefs.setString("userId", userid);

    return userid;
  }


}