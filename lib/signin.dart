import 'package:cardgameapp/views/reset_pass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  late var myId;
  late var myUsername;
  late var myPassword;
  late var myEmail;
  late var myImage = "";

  late var myRank;

  late var mylevel;

  late var myaddress;

  late var myBirthdate;
  late var isAdmin;
  late var DateR;
  late var rerolled = true;

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    showAlertDialog(BuildContext context,String Message) {
      // Create button
      Widget NoButton = ElevatedButton(
        child: const Text("ok"),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
      );
      // Create AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("Authentication"),
        content:  Text(Message),
        actions: [NoButton],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    showWaiting(BuildContext context) {
      // Create AlertDialog
      AlertDialog alert = const AlertDialog(
        actionsPadding: EdgeInsets.fromLTRB(0,0,0, 20),
        title: Text("Authentication"),
        content:  Text("Connection, please give us a second..."),
        actions: [Center(child: CircularProgressIndicator(color: Colors.pink,))],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 85,
        child: Image.asset('assets/Images/Logo Game.png'),
      ),
    );

    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          try {
            showWaiting(context);
            if (_keyForm.currentState!.validate()) {
              _keyForm.currentState!.save();

              await context.read<AuthenticationService>().signIn(
                    email: _email.toString(),
                    password: _password.toString(),
                  );

              CollectionReference users =
                  FirebaseFirestore.instance.collection('users');

              final user =
                  await context.read<AuthenticationService>().getUser();
              SharedPreferences prefs = await SharedPreferences.getInstance();

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .get()
                  .then((ds) {
                myId = ds.data()!["Id"];
                myUsername = ds.data()!['username'];
                myEmail = ds.data()!['email'];
                myRank = ds.data()!['Rank'];
                myPassword = ds.data()!['password'];
                mylevel = ds.data()!['level'];
                myaddress = ds.data()!['address'];
                myImage = ds.data()!['image'];
                myBirthdate = ds.data()!['birthdate'];
                isAdmin = ds.data()!["isAdmin"];
              }).catchError((e) {
                print(e);
              });

              await users
                  .doc(user.uid)
                  .collection("rerolled")
                  .doc(user.uid)
                  .get()
                  .then((ds) async {
                Timestamp date = await ds.data()!["LastRerolled"];
                DateR = date.toDate();
                rerolled = await ds.data()!["rerolled"];
              }).catchError((e) {
                print(e);
              });

              if (DateR != null) {
                DateTime now = DateTime.now();
                Duration timeDifference = now.difference(DateR);
                int hours = timeDifference.inHours;
                print(hours);
                if (hours >= 24) {
                  users.doc(user.uid).collection("rerolled").doc(user.uid).set({
                    "LastRerolled": DateR,
                    "rerolled": false,
                  });
                }
              }

              prefs.setString("id", myId);
              prefs.setString("email", myEmail);
              prefs.setString("rank", myRank);
              prefs.setString("level", mylevel);
              prefs.setString("password", myPassword);
              prefs.setString("address", myaddress);
              prefs.setString("birth", myBirthdate);
              prefs.setString("image", myImage);
              prefs.setBool("isAdmin", isAdmin);
              prefs.setString("username", myUsername);
              prefs.setString("rerolledDate", DateR.toString());
              prefs.setBool("rerolled", rerolled);

              Navigator.pushReplacementNamed(context, "/home");
            }
          } catch (e) {
            if(e.toString()=="Null check operator used on a null value")
              {
                showAlertDialog(context,"Wrong Email and/or Password, please try again");
              }
            else
              {
                showAlertDialog(context,"An Unknown Error has occurred please try again, later");
              }
          }

        },
        padding: const EdgeInsets.all(12),
        color: Colors.black54,
        child: const Text('Log In',
            style: TextStyle(color: Colors.amberAccent, fontSize: 15)),
      ),
    );

    final RegisterButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          Navigator.pushNamed(context, "/signup");
        },
        padding: const EdgeInsets.all(10),
        color: Colors.black54,
        child: const Text('Register',
            style: TextStyle(color: Colors.amberAccent, fontSize: 15)),
      ),
    );

    final forgotLabel = FlatButton(
        child: const Text(
          'Forgot password?',
          style: TextStyle(color: Colors.amberAccent),
        ),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Reset())));

    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      body: Container(
        child: Form(
          key: _keyForm,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            children: [
              const SizedBox(height: 70),
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: const Text(
                  "WildDraw",
                  textScaleFactor: 4,
                  style: TextStyle(
                      fontFamily: 'Windy-Wood-Demo', color: Colors.black),
                ),
              ),

              logo,
              const SizedBox(height: 48.0),
              //email
              TextFormField(
                cursorColor: Colors.black54,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: 'Email',
                  contentPadding:
                      const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide:
                        const BorderSide(color: Colors.black54, width: 4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide:
                        const BorderSide(color: Colors.black54, width: 4),
                  ),
                  labelStyle: const TextStyle(color: Colors.black),
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
              const SizedBox(height: 10.0),
              TextFormField(
                autofocus: false,
                cursorColor: Colors.amber,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  contentPadding:
                      const EdgeInsets.fromLTRB(20.0, 20, 20.0, 10.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide:
                        const BorderSide(color: Colors.black54, width: 4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide:
                        const BorderSide(color: Colors.black54, width: 4),
                  ),
                  labelStyle: const TextStyle(color: Colors.black),
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
              const SizedBox(height: 24.0),
              loginButton,
              RegisterButton,
              forgotLabel,
            ],
          ),
        ),
      ),
    );
  }
}
