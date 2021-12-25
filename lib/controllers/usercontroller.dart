import 'dart:math';

import 'package:cardgameapp/entities/quest.dart';
import 'package:cardgameapp/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
 class  userController {
   late String _idGenerated;
   FirebaseFirestore? _instance;
   late String usercurrentId;


   CollectionReference users = FirebaseFirestore.instance.collection('users');

   Future<void> addUser(String email, String password, String username,
       String birthdate, String Address, String image) {
     usercurrentId = FirebaseAuth.instance.currentUser!.uid;
     UserE user1 = UserE.NewUser(
         email,
         password,
         username,
         birthdate,
         Address,
         image,
         false);

     Future<void> Userref = users.doc(usercurrentId).set({

       'email': user1.email,
       'password': user1.password,
       'username': user1.username,
       "birthdate": user1.birth,
       "address": user1.address,
       "Rank": user1.Rank,
       "level": user1.level,
       "id_Col": user1.id_Col,
       "Id": usercurrentId,
       "image": user1.image,
       "isAdmin": user1.isAdmin
     })

         .catchError((error) => print("Failed to add user : $error"));

     user1.id = usercurrentId;
     print(user1.id);

     return Userref;
   }





   CollectionReference DailyQuests = FirebaseFirestore.instance.collection(
       'quests');

   ///a function to add the quests
   Future<void> addQuest2() async {
     Quest q1 = Quest("0", "0", "0", "0");
     Quest q2;
     Quest q3;
     Map<String, dynamic> a;

     ///creating a quest instance with the variables passed to the parameter

     usercurrentId = FirebaseAuth.instance.currentUser!.uid;
     CollectionReference users = FirebaseFirestore.instance.collection('users');

     ///a random instance to generate a random id for the document
     var rng = new Random();

     QuerySnapshot querySnapshot;
     List<Map<String, dynamic>> Quests = [];

     querySnapshot = await DailyQuests.get();

       for (var doc in querySnapshot.docs.toList()) {
      a = {


           "Qdescription": doc["Qdescription"],
           "QuestTitle": doc["QuestTitle"],
           "LevelRange": doc["levelRange"]
         };
      Quests.add(a);
       }

  var length =Quests.length;
       for (int i = 0; i < 4; i++) {

        Map<String,dynamic> w= Quests.elementAt(rng.nextInt(length));
        q1.Qtitle=w["QuestTitle"];
        q1.Qdescription=w["Qdescription"];
        q1.levelrange=w["LevelRange"];
        late var Dlength;

         Future<void> Questref = users.doc(usercurrentId).collection("quests").doc(rng.nextInt(10000).toString())
             .set({

           'QuestTitle': q1.Qtitle,
           'levelRange': q1.levelrange,
           'Qdescription': q1.Qdescription,


         })

             .catchError((error) => print("failed to add : $error"));
       }

       ///a future function to set the attributes in the doc ref

     }

   Future<void> Reroll(String docId)async {
     usercurrentId = FirebaseAuth.instance.currentUser!.uid;
     Quest q1 = Quest("0", "0", "0", "0");
     var rng = new Random();
     Map<String, dynamic> a;
     QuerySnapshot querySnapshot;
     List<Map<String, dynamic>> Quests = [];

     querySnapshot = await DailyQuests.get();

     for (var doc in querySnapshot.docs.toList()) {
       a = {


         "Qdescription": doc["Qdescription"],
         "QuestTitle": doc["QuestTitle"],
         "LevelRange": doc["levelRange"]
       };
       Quests.add(a);
     }
     var length =Quests.length;
     Map<String,dynamic> w= Quests.elementAt(rng.nextInt(length));
     q1.Qtitle=w["QuestTitle"];
     q1.Qdescription=w["Qdescription"];
     q1.levelrange=w["LevelRange"];
     users.doc(usercurrentId).collection("quests").doc(docId).set({

       'QuestTitle': q1.Qtitle,
       'levelRange': q1.levelrange,
       'Qdescription': q1.Qdescription,


     });

   }

   Future<void> AddFriend(String username,String Rank,String Email,String level ,String uid) async {
     usercurrentId = FirebaseAuth.instance.currentUser!.uid;
     CollectionReference users = FirebaseFirestore.instance.collection('users');

     users.doc(usercurrentId).collection("friends").doc(uid).set({
       "Id":uid,
       "username":username,
       "email":Email,
       "Rank":Rank,
       "Level":level,


     }) .catchError((error) => print("failed to add : $error"));


   }

   Future<void> DeleteFriend (String id)async {
     usercurrentId = await FirebaseAuth.instance.currentUser!.uid;
     FirebaseFirestore.instance.collection("users").doc(usercurrentId).collection("friends").doc(id).delete().catchError((e){
       print("friend deleted");
     });

 }


   }
