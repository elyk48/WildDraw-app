
import 'package:cardgameapp/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/authentication_service.dart';

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

late String? _email;

late String? _password;

late UserE _user;

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 85,
        child: Image.asset('assets/Images/logoApp.png'),
      ),
    );


    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async{

    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      Map<String, dynamic> userData = {
        "username": _email,
        "password": _password
      };

   await context.read<AuthenticationService>().signIn(
        email:_email.toString(),
        password: _password.toString(),

      );

   final user =await context.read<AuthenticationService>().getUser();
   print(user!.uid.toString());
      SharedPreferences.setMockInitialValues({});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userId",user.uid.toString());
      UserE newUser = UserE(user.uid.toString(), "_username", "_email", "_password", "_birth", "_address", "_level", "_Rank", "_id_Col", "_image", false);
      _user = await getUser(newUser);
      prefs.setString("username",_user.username);
      prefs.setString("email",_user.email);
      prefs.setString("password",_user.password);
      prefs.setString("birthday",_user.birth);
      prefs.setString("address",_user.address);
      prefs.setString("level",_user.level);
      prefs.setString("rank",_user.Rank);
      prefs.setString("id_col",_user.id_Col);
      prefs.setBool("isAdmin",_user.isAdmin);
      /*print(prefs.getString("userId"));
      print(prefs.getString("username"));
      print(prefs.getBool("isAdmin"));*/
      Navigator.pushReplacementNamed(context, "/home");
    }


        },
        padding: EdgeInsets.all(12),
        color: Colors.black54,
        child: Text('Log In', style: TextStyle(color: Colors.amberAccent,fontSize: 15)),
      ),
    );

    final RegisterButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async{


          Navigator.pushReplacementNamed(context, "/signup");

        },
        padding: EdgeInsets.all(10),
        color: Colors.black54,
        child: Text('Register', style: TextStyle(color: Colors.amberAccent,fontSize: 15)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.amberAccent),
      ),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white70,
      body: Form(
        key: _keyForm,
        child: ListView(

          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(20,20,20,20),
          children: [
            SizedBox(height: 70),
               logo,
            SizedBox(height: 48.0),
            //email
            TextFormField(
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
                _email = value;
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Le username ne doit pas etre vide";
                } else if (value.length < 5) {
                  return "Le username doit avoir au moins 5 caractères";
                } else {
                  return null;
                }
              },

            ),
            SizedBox(height: 10.0),
//password
            TextFormField(
              autofocus: false,
              cursorColor: Colors.amber,
              obscureText: true,

              decoration:  InputDecoration(
                hintText: 'Password',
                contentPadding: EdgeInsets.fromLTRB(20.0, 20, 20.0, 10.0),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),
                  borderSide: const BorderSide(color: Colors.black54 ,width: 2.5),
                ),
                focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),
                  borderSide: const BorderSide(color: Colors.black54 ,width: 2.5),
                ),
                labelStyle: new TextStyle(color: Colors.black),
                labelText: "Password",
              ),
              onSaved: (String? value) {
                _password = value;
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Le username ne doit pas etre vide";
                } else if (value.length < 5) {
                  return "Le username doit avoir au moins 5 caractères";
                } else {
                  return null;
                }
              },
            ),
            SizedBox(height: 24.0),
            loginButton,
            RegisterButton,
            forgotLabel,
          ],
        ),
      ),
    );
  }
}
Future<UserE> getUser(UserE user) async{
  QuerySnapshot querySnapshot;
  try{

    querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    if(querySnapshot.docs.isNotEmpty)
    {
      for(var doc in querySnapshot.docs.toList())
      {
        if(doc.id == user.id)
          {
             user.username = doc["username"];
             user.id = doc["Id"];
             user.Rank = doc["Rank"];
             user.address = doc["address"];
             user.isAdmin= doc["isAdmin"];
             user.level = doc["level"];
             user.password = doc["password"];
             user.image= doc["image"];
             user.id_Col = doc["id_Col"];
             print(user.isAdmin.toString());
            return user;
          }
      }
    }
  }catch(e){
    print(e);
  }
  return user;
}