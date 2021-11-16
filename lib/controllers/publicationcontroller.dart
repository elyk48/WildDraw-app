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
            'postenOn': pub.postedOn,
          }
      );
    pub.id = docRef.id;
    print(pub.id);
    return pub;
  }
  }