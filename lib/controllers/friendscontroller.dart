import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class  FriendsController {
  late String usercurrentId;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addFriend(String id) {
    usercurrentId = FirebaseAuth.instance.currentUser!.uid;
    Future<void> Friendref = users.doc(usercurrentId).collection("Friends").doc(usercurrentId).set({
      "Id":id,
    })
        .catchError((error) => print("Failed to add friend : $error"));
    print("friend Id  "+id);
    return Friendref;
  }
}