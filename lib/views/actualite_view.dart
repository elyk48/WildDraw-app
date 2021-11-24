import 'package:cardgameapp/entities/actualite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class actualiteView extends StatefulWidget {
  const actualiteView({Key? key}) : super(key: key);

  @override
  _actualiteViewState createState() => _actualiteViewState();
}

class _actualiteViewState extends State<actualiteView> {

  late List<dynamic> _AllActs=[];
  late Future<List> futureActs;
  CollectionReference actualites = FirebaseFirestore.instance.collection('actualites');
  late actualite act = actualite.newAct(id, "Test", "Yes", "Me");

  final String id="VGvmMwarbvUJtsjAzfvHR9tvfd72";
  final bool isAdmin = false;

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FBActualieList();
  }
  Future<List> getAllActs(List<dynamic> l) async{
    QuerySnapshot querySnapshot;
    try{

      querySnapshot = await actualites.get();
      if(querySnapshot.docs.isNotEmpty)
      {
        for(var doc in querySnapshot.docs.toList())
        {
          Map a = {"id": doc.id,"content":doc["content"],"id_user":doc["id_user"],"postedOn":doc["postedOn"],"author":doc["author"],"title":doc["title"]};
          l.add(a);
        }
        return _AllActs;
      }
    }catch(e){
      print(e);
    }
    return _AllActs;
  }
  @override
  void initState(){
    futureActs =  getAllActs(_AllActs);
    super.initState();
  }
  static Future<void> deleteActualite(String docId) async {
    CollectionReference actualites = FirebaseFirestore.instance.collection('actualites');
    DocumentReference documentReferencer = actualites.doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
  FutureBuilder<List> FBActualieList() {
    return FutureBuilder(
      future: futureActs,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return SingleChildScrollView(
            child: Column(
              children: [
                if(isAdmin)Form(
                  key: _keyForm,
                  child: Column(
                    children: [
                      TextFormField(
                        maxLines: null,
                        decoration: const InputDecoration(
                          labelText: "Title",
                        ),
                        onSaved: (String? value) {
                            act.title = value!;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 15,
                        decoration: const InputDecoration(
                          labelText: "Tell us what's new !",
                        ),
                        onSaved: (String? value) {
                            act.content = value!;
                        },
                      ),
                      SizedBox(
                        width: 380,
                        child: ElevatedButton(
                          onPressed: () async{
                            if (_keyForm.currentState!.validate()) {
                              _keyForm.currentState!.save();
                              /*if(pub.content != "" && pub.content!=null) {
                                publicationController PC = await publicationController();
                                PC.addPublication(pub);
                                setState(() {
                                  _AllPubs = <dynamic>[];
                                  futurepubs = getAllPubs(_AllPubs);
                                });
                              }*/
                              if(act.content != "" && act.title!=null && act.title != "" && act.content!=null)
                                {
                                  await addActualite(act);
                                  setState(() {
                                    _AllActs = <dynamic>[];
                                    futureActs = getAllActs(_AllActs);
                                  });
                                }
                            }
                          },
                          child: const Text("Publish"),

                        ),
                      ),
                    ],
                  ),

                ),

                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _AllActs.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Wrap(
                      children:[
                        ActualiteCard( _AllActs[index]["id"],_AllActs[index]["id_user"],_AllActs[index]["title"],_AllActs[index]["content"], _AllActs[index]["author"], _AllActs[index]["postedOn"]),
                        if(_AllActs[index]["id_user"] == id && isAdmin) ElevatedButton(
                          onPressed: ()async{
                            await deleteActualite(_AllActs[index]["id"]);
                            setState(() {
                              _AllActs = <dynamic>[];
                              futureActs =getAllActs(_AllActs);
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
                      mainAxisSpacing: 10,
                      mainAxisExtent: 50
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
  Future<actualite> addActualite(actualite act) async{
    DocumentReference docRef = await actualites.add(
        {
          'id_user':act.idUser,
          'author':act.author,
          'content': act.content,
          'title': act.title,
          'postedOn': act.postedOn,
        }
    );
    act.id = docRef.id;
    print(act.id);
    return act;
  }
}
