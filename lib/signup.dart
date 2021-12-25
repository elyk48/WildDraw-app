import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'entities/user.dart';
import 'controllers/usercontroller.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late String? _id;
  late String? _username;
  late String? _email;
  late String? _password;
  late String? _birth;
  late String? _address;
  late String? _Level;
  late String? _Rank;
  late String? _id_Col;
  late File _image;
  late String _imageLink="https://firebasestorage.googleapis.com/v0/b/cardgameapp-1960b.appspot.com/o/Defaultimg.png?alt=media&token=f02be4f5-e70c-4c16-8f7a-52c70cd7b0b9";

  Future getImage()  async {

    final   image= await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      //_image= image as FileImage;
    });

  }


  late final UserE user = new UserE.NewUser("email" ,"password","username","birthdate","address","image",false);
  userController userC= userController();

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {


//////////////Validate Button//////////
    final Validatebtn = Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async{
          if (_keyForm.currentState!.validate()) {
            _keyForm.currentState!.save();

            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: user.email,
                password: user.password.toString());
            user.id =await FirebaseAuth.instance.currentUser!.uid;
            Map<String, dynamic> userData = {
              "username": user.username,
              "uid" :user.id
            };
            user.image=_imageLink;
            await userC.addUser(user.email, user.password, user.username,user.birth,user.address,user.image);

            _keyForm.currentState!.reset();
            Navigator.pushReplacementNamed(context, "/singin");
          }
        },
        padding: EdgeInsets.all(20),
        color: Colors.black54,
        child: Text('Validate', style: TextStyle(color: Colors.amberAccent,fontSize: 15)),
      ),
    );


    /***************Cancel Button***************/
    final Cancelbtn = Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async{

          _keyForm.currentState!.reset();
          Navigator.pushReplacementNamed(context, "/singin");

        },
        padding: EdgeInsets.all(20),
        color: Colors.black54,
        child: Text('Cancel', style: TextStyle(color: Colors.amberAccent,fontSize: 15)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.black54,
        foregroundColor: Colors.amberAccent,
      ),
      body: Form(

        key: _keyForm,
        child: ListView(

          children: [

            SizedBox(

              child: Container(

                alignment: Alignment.topCenter,
                margin: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: Text("WildDraw",textScaleFactor: 3,style:TextStyle(fontFamily:'Windy-Wood-Demo',color: Colors.black,) ),
              ),
            ),

            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(40, 30, 40, 10),

              child: CircleAvatar(
                  backgroundImage:NetworkImage(_imageLink),
                radius: 100,

              ),
            ),


            Container(
              height: 70,
              width: 50,
              alignment: Alignment.center,

              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: FloatingActionButton(
                backgroundColor:  Colors.brown.shade200,
                tooltip: 'Image',
                onPressed: () async {

                  var _image= (await ImagePicker().pickImage(source: ImageSource.gallery))  ;
                  FirebaseStorage fs =FirebaseStorage.instance;
                  Reference rootref =fs.ref();
                  Reference picFolderRef  =rootref.child("profilePics").child("image");
                  File file =File(_image!.path);
                  picFolderRef.putFile(file).whenComplete(() => null).then((storageTask) async {
                    String Link = await storageTask.ref.getDownloadURL();
                    print("Image Uploaded");
                    setState(() {
                      _imageLink= Link;

                    });

                  });

                },
                child: Icon(Icons.camera_alt,color: Colors.black),

              ),

            ),

            Container(
              margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),
              child: TextFormField(
                cursorColor: Colors.amber,

                keyboardType: TextInputType.text,
                decoration:  InputDecoration(
                  labelText: "Username",
                  hintText: 'username',
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
                  user.username = value!;
                },
                validator: (String? value) {
                  if(value == null || value.isEmpty) {
                    return "Le username ne doit pas etre vide";
                  }
                  else if(value.length < 5) {
                    return "Le username doit avoir au moins 5 caractères";
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                cursorColor: Colors.amber,

                keyboardType: TextInputType.emailAddress,
                decoration:  InputDecoration(
                  labelText: "Email",
                  hintText: 'Email',
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
                  user.email = value!;
                },
                validator: (String? value) {
                  String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                  if(value == null || value.isEmpty) {
                    return "L'adresse email ne doit pas etre vide";
                  }
                  else if(!RegExp(pattern).hasMatch(value)) {
                    return "L'adresse email est incorrecte";
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                obscureText: true,
                cursorColor: Colors.amber,

                keyboardType: TextInputType.emailAddress,
                decoration:  InputDecoration(
                  labelText: "Password",

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
                  user.password = value!;
                },
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return "Le mot de passe ne doit pas etre vide";
                  }
                  else if(value.length < 5) {
                    return "Le mot de passe doit avoir au moins 5 caractères";
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                keyboardType: TextInputType.datetime,
                cursorColor: Colors.amber,


                decoration:  InputDecoration(
                  labelText: "Birth date",
                  hintText: 'Birth date',
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
                  user.birth = value!;
                },
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return "L'année de naissance ne doit pas etre vide";
                  }
                  else if(int.parse(value.toString()) > 2021) {
                    return "L'année de naissance est incorrecte";
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
                  labelText: "Address",
                  hintText: 'Address',
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
                  user.address = value!;
                },
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return "L'adresse email ne doit pas etre vide";
                  }
                  else if(value.length < 20) {
                    return "Le mot de passe doit avoir au moins 10 caractères";
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