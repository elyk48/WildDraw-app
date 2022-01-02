import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/user.dart';
import '../controllers/usercontroller.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
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


  var myId;
  var myEmail;

  var myUsername;

  var myRank;
 var myPassword;
  var mylevel ;
  var myaddress;
  var myBirthdate;
  var myImage;
  var isAdmin=false;


  late final UserE user = UserE("1", "wak","wwwwwwwwwa","ffffff","1998","ffffff", "1", "4444", "2","44444444",isAdmin);
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


            user.image=_imageLink;
            await updateUser(user);

            _showAlert(context);
            await Future.delayed(Duration(seconds:4));

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
          Navigator.pushReplacementNamed(context, "/profile");

        },
        padding: EdgeInsets.all(20),
        color: Colors.black54,
        child: Text('Cancel', style: TextStyle(color: Colors.amberAccent,fontSize: 15)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: const Text("Edit Your Profile"),
        backgroundColor: Colors.black54,
        foregroundColor: Colors.amberAccent,
      ),
      body: Form(

        key: _keyForm,
        child:FutureBuilder(
future:  _fetch(),
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done)
        return Text("Loading data...Please wait");
     return ListView(

       children: [



         Container(
           alignment: Alignment.center,
           margin: const EdgeInsets.fromLTRB(40, 30, 40, 10),

           child: CircleAvatar(
             child: ClipOval(
               child:Image.network(myImage),

             ),
             radius: 100,

           ),
         ),


         Container(
           alignment: Alignment.center,

           margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
           child: FloatingActionButton(
             tooltip: 'Image',
             onPressed: () async {
               var rng = new Random();
               var _image= (await ImagePicker().pickImage(source: ImageSource.gallery))  ;
               FirebaseStorage fs =FirebaseStorage.instance;
               Reference rootref =fs.ref();
               Reference picFolderRef  =rootref.child("profilePics").child(rng.nextInt(1000).toString());
               File file =File(_image!.path);
               picFolderRef.putFile(file).whenComplete(() => null).then((storageTask) async {
                 String Link = await storageTask.ref.getDownloadURL();
                 print("Image Uploaded");
                 setState(() {
                   _imageLink= Link;
                   myImage=_imageLink;
                 });

               });

             },
             child: Icon(Icons.camera_alt,color: Colors.black,),

           ),

         ),

         Container(
           margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),
           child: TextFormField(
             cursorColor: Colors.amber,
initialValue: myUsername,
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
             initialValue: myEmail,
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
             initialValue: myPassword,
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
             initialValue: myBirthdate,

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
             initialValue: myaddress,
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
     );
    }
        ),
      ),
    );
  }


  _fetch() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        myId=ds.data()!["Id"];
        myUsername=ds.data()!['username'];
        myEmail = ds.data()!['email'];
        myRank = ds.data()!['Rank'];
        mylevel = ds.data()!['level'];
        myaddress = ds.data()!['address'];
        myBirthdate = ds.data()!['birthdate'];
        myImage=ds.data()!["image"];
        myPassword=ds.data()!["password"];
        isAdmin=ds.data()!["isAdmin"];

        print(myImage);
      }).catchError((e) {
        print(e);
      });
  }


  updateUser(UserE user){
    var id=  FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("users").doc(id).set({
      "email": user.email,
      'password': user.password,
      'username': user.username,
      "birthdate": user.birth,
      "address": user.address,
      "Rank": user.Rank,
      "level": user.level,
      "id_Col": user.id_Col,
      "Id": id,
      "image":user.image,
      'isAdmin':user.isAdmin,


    }).catchError((error) => print("Failed to update User  : $error"));

    FirebaseAuth.instance.currentUser!.updateEmail(user.email).catchError((error) => print("Failed to Update User Email  : $error"));
    FirebaseAuth.instance.currentUser!.updatePassword(user.password).catchError((error) => print("Failed to Update User password  : $error"));


  }


  void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Confirm your identity"),
          content: Text("Please confirm your idendity by loging in again and we will update your profile"),
        )
    );
  }
}
