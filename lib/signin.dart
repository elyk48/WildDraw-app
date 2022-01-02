import 'package:cardgameapp/views/reset_pass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/authentication_service.dart';
import 'entities/user.dart';

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
  late var pressed = false;

  UserE userConnected = UserE.NewUser("dummy@dumb.du", "dumb123", "Dummy", "1969", "Dumb,Dumb,Dumb,Dumb,dumb", "https://firebasestorage.googleapis.com/v0/b/cardgameapp-1960b.appspot.com/o/Defaultimg.png?alt=media&token=f02be4f5-e70c-4c16-8f7a-52c70cd7b0b9",false);

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  @override
  void initState() {
    SharedPreferences.getInstance().then((value){
      if(value.getString("id")==null)
      {
        value.setString("id", "");
        value.setString("email", "");
        value.setString("rank", "");
        value.setString("address", "");
        value.setString("birth", "");
        value.setBool("isAdmin", false);
        value.setString("username", "");
        value.setString("rerolledDate", "");
        value.setString("password", "");
        value.setBool("rerolled", false);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    showAlertDialog(BuildContext context,String Message) {
      // Create button
      Widget NoButton = ElevatedButton(
        child: const Text("Ok"),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
      );
      // Create AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("Authentication",textAlign: TextAlign.center,),
        content:  Text(Message,textAlign: TextAlign.center),
        actions: [Center(child: NoButton)],
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
        actionsPadding: EdgeInsets.fromLTRB(0,0,0,10),
        title: Text("Authentication",textAlign: TextAlign.center,),
        content:  Text("Connection, please give us a second...\nClick away if you'd like",textAlign: TextAlign.center,),
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
            if(!pressed){showWaiting(context);
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
              Navigator.of(context, rootNavigator: true).pop('dialog');
              Navigator.pushReplacementNamed(context, "/home");
            }}
          } catch (e) {
            if(e.toString()=="Null check operator used on a null value")
              {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                showAlertDialog(context,"Wrong Email and/or Password, please try again");
              }
            else
              {
                showAlertDialog(context,"An Unknown Error has occurred please try again, later");
              }
          }

        },
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
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _keyForm,
        child: Stack(
          children:[ Container( decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Images/Login page.png"),
              fit: BoxFit.cover,
            ),
          ),),
            Column(
              children: [
                const SizedBox(height: 366),
                //email
                Container(
                  padding: const EdgeInsets.fromLTRB(70, 0, 50, 0),
                  child: TextFormField(
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Windy-Wood-Demo',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        decorationColor: Colors.black),
                    cursorColor: Colors.black54,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: "Email",
                      labelStyle: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.w600),
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
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Windy-Wood-Demo',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      decorationColor: Colors.black),
                  autofocus: false,
                  cursorColor: Colors.black,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.fromLTRB(70, 0, 50, 0),
                    labelStyle: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.w600),
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
                loginButton,
                RegisterButton,
                forgotLabel,
              ],
            ),]
        ),
      ),
    );
  }
}
