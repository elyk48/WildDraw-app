import 'package:cardgameapp/entities/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionController{
  static late String id_Collection="UlCbxbeQqXjmhSAYMpIk";


  static CollectionReference CardCollection = FirebaseFirestore.instance.collection('CardCollection').doc(id_Collection).collection('Cards');
  static Future<List> getCollection(List<PlayCard> l) async{
    QuerySnapshot querySnapshot;
    try{
      querySnapshot = await CardCollection.get();
      if(querySnapshot.docs.isNotEmpty)
      {
        for(var doc in querySnapshot.docs.toList())
        {
          l.add(PlayCard(doc["CardUrl"],doc.id));
        }
        print(l);
        return l;
      }
    }catch(e){
      print(e);
    }
    return l;
  }

  static Future<String> getCardUrl(String cardID) async{
    QuerySnapshot querySnapshot;
    try{
      querySnapshot = await CardCollection.get();
      if(querySnapshot.docs.isNotEmpty)
      {
        for(var doc in querySnapshot.docs.toList())
        {
          if(doc.id == cardID)
            {
              return doc.id;
            }
        }
      }
    }catch(e){
      print(e);
    }
    return "";
  }



  static Future<String> getCollectionIdFromIdUser(String user_id) async{
    QuerySnapshot querySnapshot;
    try{
      querySnapshot = await FirebaseFirestore.instance.collection('CardCollection').get();
      if(querySnapshot.docs.isNotEmpty)
      {
        for(var doc in querySnapshot.docs.toList())
        {
          if(doc["idUser"]==user_id)
            {
              return doc.id;
            }
        }
      }
    }catch(e){
      print(e);
    }
    return "";
  }
}