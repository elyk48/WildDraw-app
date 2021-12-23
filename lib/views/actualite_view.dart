import 'package:cardgameapp/entities/actualite.dart';
import 'package:cardgameapp/entities/user.dart';
import 'package:cardgameapp/views/create_a_poll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class actualiteView extends StatefulWidget {
  const actualiteView({Key? key}) : super(key: key);

  @override
  _actualiteViewState createState() => _actualiteViewState();
}

class _actualiteViewState extends State<actualiteView> {

  late List<dynamic> _AllActs=[];
  late Future<List> futureActs;
  late Future<SharedPreferences> _futureprefs;


  late Future<String> futureUsername;
  final String id=FirebaseAuth.instance.currentUser!.uid;
  late String username="";
  late bool? isAdmin=false;
  CollectionReference actualites = FirebaseFirestore.instance.collection('actualites');
  late actualite act = actualite.newAct(id, "Test", "Yes", username);
  late FocusNode myFocusNode;



  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FBActualieList();
  }
  Future<List> getAllActs(List<dynamic> l) async{
    _fetch();
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
  Future<String> getUsername(String l) async{
    QuerySnapshot querySnapshot;
    try{

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

  Future<void> _fetch() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance().then((value){return value;});
    username = prefs.getString("username")!;
    isAdmin = prefs.getBool("isAdmin");
    print("Username is : "+username+" isAdmin: "+isAdmin.toString());
  }

  @override
  void initState() {
    futureActs =  getAllActs(_AllActs);
    futureUsername = getUsername(username);
    myFocusNode = FocusNode();
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
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Images/News.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
              children: [
                if(isAdmin!)Container(
                  padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
                  width: 320,
                  child: Form(
                    key: _keyForm,
                    child: Column(
                      children: [
                        TextFormField(
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Windy-Wood-Demo',
                              fontSize: 25,
                          ),
                          autofocus: false,
                          maxLines: 1,
                          maxLength: 20,
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'Windy-Wood-Demo',
                            ),
                            labelText: "Title",
                          ),
                          onSaved: (String? value) {
                            act.title = value!;
                          },
                        ),
                        TextFormField(
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Windy-Wood-Demo',
                            fontSize: 20,
                          ),
                          autofocus: false,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'Windy-Wood-Demo',
                            ),
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
                              myFocusNode.unfocus();
                              if (_keyForm.currentState!.validate()) {
                                _keyForm.currentState!.save();
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
                ),
                if(!isAdmin!)const SizedBox(height: 80),
                  if(!_AllActs.isEmpty)GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _AllActs.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Wrap(
                        children:[
                         Container(
                           child: Column(
                           children: [
                             if(_AllActs[index]["id_user"]==id)Dismissible(
                                 direction: DismissDirection.startToEnd,
                               key: Key(_AllActs[index]["id"]),
                                 child: ActualiteCard(
                                     _AllActs[index]["id"],
                                     _AllActs[index]["id_user"],
                                     _AllActs[index]["title"],
                                     _AllActs[index]["content"],
                                     _AllActs[index]["author"],
                                     _AllActs[index]["postedOn"]),
                               onDismissed: (direction) {
                         setState(() async {
                            showAlertDialog(context,_AllActs[index]["id"],index);

                         });
                         },
                               background: Container(
                                   //color: Colors.red,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/Images/Delete_Strip.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                   child: Container(
                                     padding: const EdgeInsets.fromLTRB(0, 0, 220, 0),
                                     child: const Center(
                                         child: Text("Delete",
                                               textScaleFactor: 3,
                                               style: TextStyle(color: Colors.white)
                                           ),

                                     ),
                                   )
                               ),
                             ),
                             if(_AllActs[index]["id_user"]!=id)ActualiteCard(
                                 _AllActs[index]["id"],
                                 _AllActs[index]["id_user"],
                                 _AllActs[index]["title"],
                                 _AllActs[index]["content"],
                                 _AllActs[index]["author"],
                                 _AllActs[index]["postedOn"]),
                           ],
                         ),),
                        ],
                      );
                    },
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 100
                    ),
                  ),if(_AllActs.isEmpty)CircularProgressIndicator(),
                ],
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
  showAlertDialog(BuildContext context,String id,int index) {
    // Create button
    Widget okButton = ElevatedButton(
      child: Text("Yes I wanna delete it"),
      onPressed: () {
        _AllActs.removeAt(index);
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {
          deleteActualite(id);
          _AllActs = <dynamic>[];
          futureActs =getAllActs(_AllActs);
        });
      },
    );
    Widget NoButton = ElevatedButton(
      child: Text("Nope"),
      onPressed: (){
        _AllActs.insert(index, ActualiteCard(
            _AllActs[index]["id"],
            _AllActs[index]["id_user"],
            _AllActs[index]["title"],
            _AllActs[index]["content"],
            _AllActs[index]["author"],
            _AllActs[index]["postedOn"]));

        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {
          _AllActs = <dynamic>[];
          futureActs =getAllActs(_AllActs);
        });
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("News"),
      content: Text("Are you sure you want to delete this ?"),
      actions: [
        okButton,NoButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
