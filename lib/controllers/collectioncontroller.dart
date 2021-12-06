import 'package:cardgameapp/entities/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionController{
  static late String id_Collection="UlCbxbeQqXjmhSAYMpIk";


  static CollectionReference CardCollection = FirebaseFirestore.instance.collection('CardCollection').doc(id_Collection).collection('Cards');
  static Future<List> getCollection(List<Card> l) async{
    QuerySnapshot querySnapshot;
    try{
      querySnapshot = await CardCollection.get();
      if(querySnapshot.docs.isNotEmpty)
      {
        for(var doc in querySnapshot.docs.toList())
        {
          l.add(Card(doc["CardUrl"],doc.id));
        }
        print(l);
        return l;
      }
    }catch(e){
      print(e);
    }
    return l;
  }
}