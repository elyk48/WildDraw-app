import 'package:cardgameapp/controllers/publicationcontroller.dart';
import 'package:cardgameapp/entities/publication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PublicationView extends StatefulWidget {
  const PublicationView({Key? key}) : super(key: key);

  @override
  _PublicationViewState createState() => _PublicationViewState();
}
class _PublicationViewState extends State<PublicationView> {
  //late SharedPreferences prefs;
  late List<dynamic> _AllPubs=[];
  late Future<List> futurepubs;

  late Future<String> futureUsername;
  late String username= "";

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  final String id=FirebaseAuth.instance.currentUser!.uid;

  CollectionReference publications = FirebaseFirestore.instance.collection('publications');

  @override
  Widget build(BuildContext context) {
    return FBPublicationList();
  }
  FutureBuilder<List> FBPublicationList() {
    Publication pub = Publication.newPub("Bienvenue à esprit Méteo !", id, username);
    return FutureBuilder(
      future: futurepubs,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 25,15,15),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Images/publication_board.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: ShaderMask(
              shaderCallback: (Rect rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.purple, Colors.transparent, Colors.transparent, Colors.purple],
                  stops: [0.0001, 0.1, 0.9, 1.0], // 10% purple, 80% transparent, 10% purple
                ).createShader(rect);
              },
              blendMode: BlendMode.dstOut,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/Images/publication_form.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Form(
                        key: _keyForm,
                       child: Column(
                         children: [
                           Container(
                             padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                             child: TextFormField(
                               style: const TextStyle(
                                   color: Colors.black,
                                   fontFamily: 'Windy-Wood-Demo',
                                   fontSize: 30,
                                   decorationColor: Colors.black
                               ),
                               cursorColor: Colors.black54,
                               maxLength: 200,
                               enableInteractiveSelection: true,
                               keyboardType: TextInputType.multiline,
                               maxLines: null,
                               decoration: const InputDecoration(
                                 counterStyle: TextStyle(
                                     fontWeight: FontWeight.w600,
                                     fontSize: 20,
                                     fontFamily: 'Windy-Wood-Demo',
                                     color: Colors.black),
                                 enabledBorder: UnderlineInputBorder(
                                   borderSide: BorderSide(color: Colors.black),
                                 ),
                                 focusedBorder: UnderlineInputBorder(
                                   borderSide: BorderSide(color: Colors.black),
                                 ),
                                 labelStyle: TextStyle(
                                   color: Colors.black54,
                                   fontFamily: 'Windy-Wood-Demo',
                                 ),
                                 labelText: "Tell us what you think !",
                               ),
                               onSaved: (String? value) {
                                 pub.content = value!;
                                 print(pub.content);
                               },
                             ),
                           ),
                           SizedBox(
                             width: 380,
                             child: Container(
                               padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                               child: ElevatedButton(
                                 onPressed: () async{
                                   if (_keyForm.currentState!.validate()) {
                                     _keyForm.currentState!.save();
                                     if(pub.content != "" && pub.content!=null) {
                                       publicationController PC = await publicationController();
                                       PC.addPublication(pub);
                                       setState((){
                                         _AllPubs = <dynamic>[];
                                         futurepubs = getAllPubs(_AllPubs);
                                       });
                                     }
                                   }
                                 },
                                 child: const Text("Post"),
                               ),
                             ),
                           ),
                         ],
                       ),
                      ),
                    ),
                    if(!_AllPubs.isEmpty)GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _AllPubs.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Wrap(
                          children:[
                            PublicationCard(_AllPubs[index]["id_user"], _AllPubs[index]["id"],_AllPubs[index]["content"], _AllPubs[index]["likes"], _AllPubs[index]["postedOn"], _AllPubs[index]["username"]),
                            if(_AllPubs[index]["id_user"] == id) Column(
                              children: [
                                Container(
                                  width: 400,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red
                                    ),
                                      onPressed: ()async{
                                        await deletePublication(_AllPubs[index]["id"]);
                                        setState(() {
                                          _AllPubs = <dynamic>[];
                                          futurepubs =getAllPubs(_AllPubs);
                                        });
                                                   },
                                  child: const Text("Delete"),
                                  ),
                                ),
                                const SizedBox(height: 100),
                              ],
                            ),
                          ],
                        );
                      },
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          mainAxisExtent: 220
                      ),
                    ),if(_AllPubs.isEmpty)CircularProgressIndicator(),
                  ],
                ),
              ),
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
    futureUsername = getUsername(username);
    super.initState();
  }

  Future<String> getUsername(String l) async{
    QuerySnapshot querySnapshot;
    try{
    _fetch();
      querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      if(querySnapshot.docs.isNotEmpty)
      {
        for(var doc in querySnapshot.docs.toList())
        {
          if(doc.id == id)
          {
            l = doc["username"];
            setState(() {
              username = l;
              //print(username);
            });
            return username;
          }
        }
      }
    }catch(e){
      print(e);
    }
    return username;
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
  Future<void> _fetch() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance().then((value){return value;});
    username = prefs.getString("username")!;
    print("Username is : "+username);
  }
}
