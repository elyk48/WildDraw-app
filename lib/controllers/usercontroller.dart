import 'package:cardgameapp/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
 class  userController{
   late  String _idGenerated;






  CollectionReference users = FirebaseFirestore.instance.collection('users');
   Future<void> addUser(String email, String password,String username){

     UserE user1 =  UserE.NewUser(email,password,username);

     Future<void> Userref = users.add({

       'email': user1.email,
       'password':user1.password,
       'username':user1.username,

     })
         .then((value)async=> {
       print("user added"),
       _idGenerated = value.id,

     })
         .catchError((error) => print("Failed to add user : $error"));

     user1.id = _idGenerated;
     print(user1.id);

     return Userref;
   }




}