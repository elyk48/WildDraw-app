import 'package:cardgameapp/entities/quest.dart';
import 'package:flutter/material.dart';

import 'controllers/quest_controller.dart';
class CreateQuest extends StatefulWidget {
  const CreateQuest({Key? key}) : super(key: key);

  @override
  _CreateQuestState createState() => _CreateQuestState();
}

class _CreateQuestState extends State<CreateQuest> {
  late final Quest quest = new Quest(" Default","Default","Default","Default");
  QuestController QuestC= QuestController();
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    final Validatebtn = Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async{
          if (_keyForm.currentState!.validate()) {
            _keyForm.currentState!.save();


            await QuestC.addQuest(quest.Qtitle,quest.levelrange,quest.Qdescription);

            _keyForm.currentState!.reset();
            Navigator.pushReplacementNamed(context, "/DailyQuests");
          }
        },
        padding: EdgeInsets.all(20),
        color: Colors.black54,
        child: Text('Validate', style: TextStyle(color: Colors.amberAccent,fontSize: 15)),
      ),
    );


    final Cancelbtn = Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async{

          _keyForm.currentState!.reset();
          Navigator.pushReplacementNamed(context, "/DailyQuests");

        },
        padding: EdgeInsets.all(20),
        color: Colors.black54,
        child: Text('Cancel', style: TextStyle(color: Colors.amberAccent,fontSize: 15)),
      ),
    );


    return Scaffold(

      appBar: AppBar(

        title: Text("Add a Daily Quest!! "),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 40,),
          onPressed: () => Navigator.of(context).pushReplacementNamed("/DailyQuests"),
        ),
      ),

body:  Form(



    key: _keyForm,
    child: ListView(

      children: [

        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(40, 30, 40, 10),
          child: Text("Add your Quest !",textScaleFactor: 2),
        ),





        Container(
          margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),
          child: TextFormField(
            cursorColor: Colors.amber,

            keyboardType: TextInputType.text,
            decoration:  InputDecoration(
              labelText: "Quest Title",
              hintText: 'Quest Title',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),
                borderSide: const BorderSide(color: Colors.black54 ,width: 2.5),
              ),
              focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),
                borderSide: const BorderSide(color: Colors.black54 ,width: 2.5),
              ),
              labelStyle: new TextStyle(color: Colors.black),
            ),
            onSaved: (String? value) {
              quest.Qtitle = value!;
            },
            validator: (String? value) {
              if(value == null || value.isEmpty) {
                return "Le quest title ne doit pas etre vide";
              }
              else if(value.length < 5) {
                return "Le quest title doit avoir au moins 5 caractères";
              }
              else {
                return null;
              }
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),
          child: TextFormField(
            cursorColor: Colors.amber,

            keyboardType: TextInputType.text,
            decoration:  InputDecoration(
              labelText: "level range",
              hintText: 'level range quest',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),
                borderSide: const BorderSide(color: Colors.black54 ,width: 2.5),
              ),
              focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),
                borderSide: const BorderSide(color: Colors.black54 ,width: 2.5),
              ),
              labelStyle: new TextStyle(color: Colors.black),
            ),
            onSaved: (String? value) {
              quest.levelrange = value!;
            },
            validator: (String? value) {
              if(value == null || value.isEmpty) {
                return "Le quest title ne doit pas etre vide";
              }
              else if(value.length < 5) {
                return "Le quest title doit avoir au moins 5 caractères";
              }
              else {
                return null;
              }
            },
          ),
        ),


        Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
          child: TextFormField(
            maxLines: 4,
            cursorColor: Colors.amber,

            keyboardType: TextInputType.text,
            decoration:  InputDecoration(
              labelText: "Quest description",
              hintText: 'Quest description',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),
                borderSide: const BorderSide(color: Colors.black54 ,width: 2.5),
              ),
              focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),
                borderSide: const BorderSide(color: Colors.black54 ,width: 2.5),
              ),
              labelStyle: new TextStyle(color: Colors.black),
            ),
            onSaved: (String? value) {
              quest.Qdescription = value!;
            },
            validator: (value) {
              if(value == null || value.isEmpty) {
                return "La desc  ne doit pas etre vide";
              }
              else if(value.length < 20) {
                return "La desc doit avoir au moins 10 caractères";
              }
              else {
                return null;
              }
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Validatebtn,
            const SizedBox(
              width: 20,
            ),
            Cancelbtn,
          ],
        )
      ],
    ),





),


    );
  }
}
