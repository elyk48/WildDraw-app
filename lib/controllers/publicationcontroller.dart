import 'package:cardgameapp/entities/publication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
late String idGenerated;

class publicationController{
  CollectionReference publications = FirebaseFirestore.instance.collection('publications');
  Future<Publication> addPublication(Publication pub) async{
    DocumentReference docRef = await publications.add(
          {
            'id_user':pub.id_user,
            'username':pub.username,
            'content': pub.content,
            'likes': 0,
            'postedOn': pub.postedOn,
          }
      );
    pub.id = docRef.id;
    print(pub.id);
    return pub;
  }
    Future<List> getAllPubs() async{
     QuerySnapshot querySnapshot;
     List pubs=[];
     try{
       querySnapshot = await publications.get();
       if(querySnapshot.docs.isNotEmpty)
         {
           for(var doc in querySnapshot.docs.toList())
             {
               Map a = {"id": doc.id,"content":doc["content"],"id_user":doc["id_user"],"likes":doc["likes"],"postedOn":doc["postedOn"],"username":doc["username"]};
               pubs.add(a);
             }
           return pubs;
         }
     }catch(e){
       print(e);
     }
     return pubs;
    }




  }