import 'package:cardgameapp/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
 class  userController {
   late String _idGenerated;
   FirebaseFirestore? _instance;
   late String usercurrentId;


   CollectionReference users = FirebaseFirestore.instance.collection('users');

   Future<void> addUser(String email, String password, String username,
       String birthdate, String Address) {
     usercurrentId = FirebaseAuth.instance.currentUser!.uid;
     UserE user1 = UserE.NewUser(email, password, username, birthdate, Address);

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


     })

         .catchError((error) => print("Failed to add user : $error"));

     user1.id = usercurrentId;
     print(user1.id);

     return Userref;
   }



   Future<String>  _getUserData() async {

     SharedPreferences prefs = await SharedPreferences.getInstance();
     final String userid = FirebaseAuth.instance.currentUser!.uid;
     prefs.setString("userId", userid);

     return userid;
   }


 }