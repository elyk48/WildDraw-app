import 'package:cardgameapp/entities/publication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

const String id="pzUhpd1PnmGUkEd9nUjl";
const String username="Anas";
late String idGenerated;

class publicationController{
  CollectionReference publications = FirebaseFirestore.instance.collection('publications');
  Future<void> addPublication(){

          Publication pub =  Publication.newPub("Helicopter !",id,username);

           Future<void> pubref = publications.add({
             'id_user':pub.id_user,
             'username':pub.username,
             'content': pub.content,
             'likes': 0,
             'postenOn': pub.postedOn,
          })
              .then((value)async=> {
                print("Publication Added:"),
                idGenerated = value.id,

              })
              .catchError((error) => print("Failed to add Publication: $error"));

           pub.id = idGenerated;
          print(pub.id);

          return pubref;
  }

  }