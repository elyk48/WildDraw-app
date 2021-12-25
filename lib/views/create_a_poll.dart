import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
///poll form model.
class MyPollForm{
  List<String> optionsData=[];
  late List<String> optionsDataFinal;
  late String question,optionField;
  ///getter for the option Text
  String getOptionText(){
    optionField="Option";
    return optionField;
  }
  ///function to for setting data
  setData2(){
    int _number=optionsData.length;
    String uid;
    String name;
///getting the current user Uid.
    uid =FirebaseAuth.instance.currentUser!.uid;
///getting the current user name.
      name="admin";
      ///getting document ref of the quetions form the firestore database
      DocumentReference ds=FirebaseFirestore.instance.collection('poll').doc(question);
      ///creating a map to use it for sending data to the firestore
      Map<String,dynamic> polls ={
        "question":this.question,
        "uid":uid,
        "name":name,
        "length":_number,
      };
      ///setting data to the document
      ds.set(polls).whenComplete((){
        print("Task completed");
      });
      ///creating a collection  for each option to a certain question and setting the value of its votes to 0
      for(int i=0;i<_number;i++){

        FirebaseFirestore.instance.collection('poll').doc(question).collection('options').doc().set({
          "name":optionsData[i],
          "votes":0,
        });
      }



  }


}

///creating an instance of the mypollform class
var user=new MyPollForm();
/// class for the Add view
class MyPollCreate2 extends StatefulWidget {
  @override
  _MyPollCreate2State createState() => _MyPollCreate2State();
}

class _MyPollCreate2State extends State<MyPollCreate2> {
  ///Global key to access and access the current state
  final _formkey=GlobalKey<FormState>();

  int optionCount=2;
  @override
  void initState() {
    super.initState();
    ///a stores how much options in the form
    int a=user.optionsData.length;
///the remove range set to remove options
    user.optionsData.removeRange(0, a);

  }
  @override
  Widget build(BuildContext context) {
    List<Widget> options =List.generate(optionCount, (int i)=>InputWidget(i));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Create a Poll"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 40,),
          onPressed: () => Navigator.of(context).pushReplacementNamed("/poll"),
        ),
        actions: <Widget>[
          Icon(Icons.poll),
        ],
      ),

      body: Container(

        decoration: BoxDecoration(

        ),
        child: Form(
          key:_formkey,
          child: Column(children: <Widget>[
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*.1,0,MediaQuery.of(context).size.width*.1,0),

              child: TextFormField(
                decoration: InputDecoration(hintText: " Whats your question ?? "),
                validator: (value){
                  if(value!.isEmpty){
                    return 'empty';
                  }
                  return null;
                },
                onChanged: (value){
                  user.question=value;
                },
              ),
            ),
            Column(
              children: options,
            ),

            Row(children: <Widget>[
              Container(
                child: Expanded(
                  ///the button to add an option
                  child: FlatButton(
                    color:Colors.blueGrey,
                    child: Text("Add an Option",style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      setState(() {
                        ///testing on max 5 options
                        if(optionCount<5){
                          ///optioncount ++ when adding an option
                          optionCount++;
                        }
                      });
                    },
                  ),
                ),
              ),
              Container(
                child: Expanded(
                  ///the button to remove an option
                  child: FlatButton(
                      color:Colors.blueGrey[300],
                      child: Text("Remove an Option",style: TextStyle(color: Colors.white),),
                      onPressed: (){
                        // if(user.optionCount>2)
                        // user.optionCount--;
                        setState((){
                          ///minimum 2 options by question
                          if(optionCount>2){
                            ///optioncount -- when removing an option
                            optionCount--;
                          }
                        },);}
                  ),
                ),
              ),

            ],),
            Container(
              alignment: Alignment.center,
              child: FlatButton(
                color: Colors.blue[400],
                child:Text("Submit",style: TextStyle(color:Colors.white),) ,
                onPressed: (){
                  setState(() {
                    if(_formkey.currentState!.validate()){
                      _formkey.currentState!.save() ;
                      ///calling the setdata function after the validation of the form..
                      user.setData2();
                      Navigator.pushReplacementNamed(context, "/poll");
                    }
                  });

                },
              ),)

          ],
          ),
        ),
      ),
    );
  }
}
//////////////////////////////////////////

///class used for inputs
class InputWidget extends StatefulWidget {
  InputWidget(this.count) : super();
  final count;
  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      ///getting the information about the size of the device and scaling it accordingly
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*.15, 0, MediaQuery.of(context).size.width*.15,0),
      width: MediaQuery.of(context).size.width,
      child:  TextFormField(
          decoration: InputDecoration(hintText: "${user.getOptionText()}"),
          validator: (value){
            ///testing the user input text
            if(value!.isEmpty){
              return 'empty text !!!!';
            }
            return null;
          },
          onSaved: (value){
///add  the text value when the form is saved !!
            user.optionsData.add(value!);

          }
      ),
    );
  }
}