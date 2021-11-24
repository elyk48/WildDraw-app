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
  final TextEditingController ContentController = TextEditingController();
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  final String id="VGvmMwarbvUJtsjAzfvHR9tvfd72";

  CollectionReference publications = FirebaseFirestore.instance.collection('publications');

  @override
  Widget build(BuildContext context) {
    return FBPublicationList();
  }
  FutureBuilder<List> FBPublicationList() {
    Publication pub = Publication.newPub("Bienvenue à esprit Méteo !", "VGvmMwarbvUJtsjAzfvHR9tvfd72", "Elyes Kabous");
    return FutureBuilder(
      future: futurepubs,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _keyForm,
                 child: Column(
                   children: [
                     TextFormField(
                       keyboardType: TextInputType.multiline,
                       maxLines: null,
                       decoration: const InputDecoration(
                         labelText: "Tell us what you think !",
                       ),
                       onSaved: (String? value) {
                         pub.content = value!;
                         print(pub.content);
                       },
                     ),
                     SizedBox(
                       width: 380,
                       child: ElevatedButton(
                         onPressed: () async{
                           if (_keyForm.currentState!.validate()) {
                             _keyForm.currentState!.save();
                             if(pub.content != "" && pub.content!=null) {
                               publicationController PC = await publicationController();
                               PC.addPublication(pub);
                               setState(() {
                                 _AllPubs = <dynamic>[];
                                 futurepubs = getAllPubs(_AllPubs);
                               });
                             }
                         }
                         },
                         child: const Text("Post"),

                       ),
                     ),
                   ],
                 ),

                ),

                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _AllPubs.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Wrap(
                      children:[
                        PublicationCard(_AllPubs[index]["id_user"], _AllPubs[index]["id"],_AllPubs[index]["content"], _AllPubs[index]["likes"], _AllPubs[index]["postedOn"], _AllPubs[index]["username"]),
                        if(_AllPubs[index]["id_user"] == id) ElevatedButton(
                            onPressed: ()async{
                              await deletePublication(_AllPubs[index]["id"]);
                              setState(() {
                                _AllPubs = <dynamic>[];
                                futurepubs =getAllPubs(_AllPubs);
                              });
                                         },
                        child: const Text("Delete"),
                    ),
                      ],
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      mainAxisExtent: 150
                  ),
                ),
              ],
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
    futurepubs =  getAllPubs(_AllPubs);
    super.initState();
  }
  Future<List> getAllPubs(List<dynamic> l) async{
    QuerySnapshot querySnapshot;
    try{

      querySnapshot = await publications.get();
      if(querySnapshot.docs.isNotEmpty)
      {
        for(var doc in querySnapshot.docs.toList())
        {
          Map a = {"id": doc.id,"content":doc["content"],"id_user":doc["id_user"],"likes":doc["likes"],"postedOn":doc["postedOn"],"username":doc["username"]};
          l.add(a);
        }
        return _AllPubs;
      }
    }catch(e){
      print(e);
    }
    return _AllPubs;
  }
  static Future<void> deletePublication(String docId) async {
    CollectionReference publications = FirebaseFirestore.instance.collection('publications');
    DocumentReference documentReferencer = publications.doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}
