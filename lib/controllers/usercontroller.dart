import 'package:cardgameapp/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
 class  userController{
   late  String _idGenerated;
FirebaseFirestore? _instance;
late String usercurrentId;




  CollectionReference users = FirebaseFirestore.instance.collection('users');
   Future<void> addUser(String email, String password,String username ,String birthdate, String Address){
usercurrentId=FirebaseAuth.instance.currentUser!.uid;
     UserE user1 =  UserE.NewUser(email,password,username,birthdate,Address);

     Future<void> Userref = users.doc(usercurrentId).set({

       'email': user1.email,
       'password':user1.password,
       'username':user1.username,
       "birthdate":user1.birth,
       "address":user1.address,
       "Rank":user1.Rank,
       "level":user1.level,
       "id_Col":user1.id_Col,
       "Id":usercurrentId,



     })

         .catchError((error) => print("Failed to add user : $error"));

     user1.id = usercurrentId;
     print(user1.id);

     return Userref;
   }

   Future <void> getUserData()async {
    String userId= FirebaseAuth.instance.currentUser!.uid;
_instance =FirebaseFirestore.instance;
DocumentSnapshot snapshot =await users.doc(userId).get();
var data =snapshot .data() as Map;
   }


   }



