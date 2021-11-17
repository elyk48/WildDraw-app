import 'package:cardgameapp/controllers/publicationcontroller.dart';
import 'package:cardgameapp/entities/publication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PublicationView extends StatefulWidget {
  const PublicationView({Key? key}) : super(key: key);

  @override
  _PublicationViewState createState() => _PublicationViewState();
}
class _PublicationViewState extends State<PublicationView> {
  late List<dynamic> _AllPubs=[];
  late Future<List> futurepubs;

  CollectionReference publications = FirebaseFirestore.instance.collection('publications');

  @override
  Widget build(BuildContext context) {
    Publication p = Publication.newPub(
        "Helicopter !", "VGvmMwarbvUJtsjAzfvHR9tvfd72", "ElyesKabous");

    return FBPublicationList();
  }
  FutureBuilder<List> FBPublicationList() {
    return FutureBuilder(
      future: futurepubs,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return GridView.builder(
            itemCount: _AllPubs.length,
            itemBuilder: (BuildContext context, int index) {
              return PublicationCard(_AllPubs[index]["id_user"], _AllPubs[index]["id"],_AllPubs[index]["content"], _AllPubs[index]["likes"], _AllPubs[index]["postedOn"], _AllPubs[index]["username"]);
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                mainAxisExtent: 130
            ),
          );
        }
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
  @override
  void initState(){
    futurepubs = getAllPubs();
    super.initState();
  }
  Future<List> getAllPubs() async{
    QuerySnapshot querySnapshot;
    try{
      querySnapshot = await publications.get();
      if(querySnapshot.docs.isNotEmpty)
      {
        for(var doc in querySnapshot.docs.toList())
        {
          Map a = {"id": doc.id,"content":doc["content"],"id_user":doc["id_user"],"likes":doc["likes"],"postedOn":doc["postedOn"],"username":doc["username"]};
          _AllPubs.add(a);
        }
        return _AllPubs;
      }
    }catch(e){
      print(e);
    }
    return _AllPubs;
  }
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
}
