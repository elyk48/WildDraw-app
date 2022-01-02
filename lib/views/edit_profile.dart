import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/user.dart';
import '../controllers/usercontroller.dart';
import '../session.dart';

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
  late String _imageLink =
      "https://firebasestorage.googleapis.com/v0/b/cardgameapp-1960b.appspot.com/o/Defaultimg.png?alt=media&token=f02be4f5-e70c-4c16-8f7a-52c70cd7b0b9";

  var myId;
  var myEmail;

  var myUsername;

  var myRank;
  var myPassword;
  var mylevel;

  var myaddress;
  var myBirthdate;
  var myImage;
  var isAdmin = false;

  late final UserE user = UserE.NewUser(
      "email", "password", "username", "birthdate", "address", "image", false);
  userController userC = userController();

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    showWaiting(BuildContext context) {
      // Create AlertDialog
      AlertDialog alert = const AlertDialog(
        actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        title: Text(
          "Uploading picture",
          textAlign: TextAlign.center,
        ),
        content: Text(
          "Give us a second while we're uploading the picture...",
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
              child: CircularProgressIndicator(
            color: Colors.pink,
          ))
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

    showQuickResult(BuildContext context) {
      // Create AlertDialog
      AlertDialog alert = const AlertDialog(
        actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        title: Text(
          "Notice",
          textAlign: TextAlign.center,
        ),
        content: Text(
          "Upload picture complete\nPlease press validate to confirm your changes",
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
              child: Icon(
            Icons.check_circle,
            size: 50,
            color: Colors.green,
          ))
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

//////////////Validate Button//////////
    final Validatebtn = SizedBox(
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/Images/Scroll.png"),
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        )),
        child: InkWell(
          onTap: () async {
            if (_keyForm.currentState!.validate()) {
              _keyForm.currentState!.save();
              user.image = _imageLink;
              await updateUser(user);
              _showAlert(context);
              await Future.delayed(Duration(seconds: 4));
              _keyForm.currentState!.reset();
              Navigator.pushReplacementNamed(context, "/singin");
            }
          },
          child: const Padding(
            padding: EdgeInsets.fromLTRB(43, 12, 12, 13),
            child: Text(
              'Validate',
              style: TextStyle(
                shadows: [
                  Shadow(
                      // bottomLeft
                      offset: Offset(-1.5, -1.5),
                      color: Colors.red),
                  Shadow(
                      // bottomRight
                      offset: Offset(1.5, -1.5),
                      color: Colors.amber),
                  Shadow(
                      // topRight
                      offset: Offset(1.5, 1.5),
                      color: Colors.amber),
                  Shadow(
                      // topLeft
                      offset: Offset(-1.5, 1.5),
                      color: Colors.red),
                ],
                color: Colors.black,
                fontFamily: 'Windy-Wood-Demo',
                fontSize: 15.5,
              ),
              textScaleFactor: 1.5,
            ),
          ),
        ),
      ),
      height: 50,
      width: 160,
    );
    /***************Cancel Button***************/
    final Cancelbtn = SizedBox(
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/Images/Scroll.png"),
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        )),
        child: InkWell(
          onTap: () {
            _keyForm.currentState!.reset();
            Navigator.pushReplacementNamed(context, "/profile");
          },
          child: const Padding(
            padding: EdgeInsets.fromLTRB(43, 12, 12, 13),
            child: Text(
              'Cancel',
              style: TextStyle(
                shadows: [
                  Shadow(
                      // bottomLeft
                      offset: Offset(-1.5, -1.5),
                      color: Colors.red),
                  Shadow(
                      // bottomRight
                      offset: Offset(1.5, -1.5),
                      color: Colors.amber),
                  Shadow(
                      // topRight
                      offset: Offset(1.5, 1.5),
                      color: Colors.amber),
                  Shadow(
                      // topLeft
                      offset: Offset(-1.5, 1.5),
                      color: Colors.red),
                ],
                color: Colors.black,
                fontFamily: 'Windy-Wood-Demo',
                fontSize: 15.5,
              ),
              textScaleFactor: 1.5,
            ),
          ),
        ),
      ),
      height: 50,
      width: 160,
    );

    return Stack(
      children: [
        Image.asset(
          "assets/Images/oldwood.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text(
              "Edit Your Profile",
              style: TextStyle(
                fontFamily: 'Windy-Wood-Demo',
              ),
            ),
            backgroundColor: Colors.black54,
            foregroundColor: Colors.amberAccent,
          ),
          body: Form(
            key: _keyForm,
            child: FutureBuilder(
                future: Session.setUser(user),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Text("Loading data...Please wait");
                  } else {
                    return ListView(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.fromLTRB(40, 30, 40, 10),
                          child: CircleAvatar(
                            backgroundColor: Colors.white54,
                            radius: 100,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(user.image, scale: 1),
                                radius: 100,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 65,
                          alignment: Alignment.topCenter,
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: IconButton(
                            icon: Image.asset("assets/Images/edit3.png"),
                            iconSize: 60,
                            onPressed: () async {
                              var _image = await ImagePicker().pickImage(
                                  source: ImageSource
                                      .gallery) /*.then((value) => showWaiting(context)))*/;
                              FirebaseStorage fs = FirebaseStorage.instance;
                              Reference rootref = fs.ref();
                              Reference picFolderRef =
                                  rootref.child("profilePics").child("image");
                              File file = File(_image!.path);
                              showWaiting(context);
                              picFolderRef
                                  .putFile(file)
                                  .whenComplete(() => null)
                                  .then((storageTask) async {
                                String Link = await storageTask.ref
                                    .getDownloadURL()
                                    .then((value) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog');
                                  return value;
                                });
                                print("Image Uploaded");
                                setState(() {
                                  showQuickResult(context);
                                  _imageLink = Link;
                                  user.image = Link;
                                });
                              });
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(40, 8, 8, 8),
                            child: TextFormField(
                              style: const TextStyle(
                                fontFamily: 'Windy-Wood-Demo',
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                              cursorColor: Colors.amber,
                              initialValue: user.username,
                              decoration: const InputDecoration(
                                labelText: "Username",
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Windy-Wood-Demo',
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                        // bottomLeft
                                        offset: Offset(-1.5, -1.5),
                                        color: Colors.red),
                                    Shadow(
                                        // bottomRight
                                        offset: Offset(1.5, -1.5),
                                        color: Colors.amber),
                                    Shadow(
                                        // topRight
                                        offset: Offset(1.5, 1.5),
                                        color: Colors.amber),
                                    Shadow(
                                        // topLeft
                                        offset: Offset(-1.5, 1.5),
                                        color: Colors.red),
                                  ],
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              onSaved: (String? value) {
                                user.username = value!;
                              },
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "The username must not be empty";
                                } else if (value.length < 5) {
                                  return "The username must have at least 5 characters";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/Images/try.png"),
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/Images/try.png"),
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter),
                          ),
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(40, 8, 8, 8),
                            child: TextFormField(
                              style: const TextStyle(
                                fontFamily: 'Windy-Wood-Demo',
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                              cursorColor: Colors.amber,
                              initialValue: user.email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: "Email",
                                hintText: 'Email',
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Windy-Wood-Demo',
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                        // bottomLeft
                                        offset: Offset(-1.5, -1.5),
                                        color: Colors.red),
                                    Shadow(
                                        // bottomRight
                                        offset: Offset(1.5, -1.5),
                                        color: Colors.amber),
                                    Shadow(
                                        // topRight
                                        offset: Offset(1.5, 1.5),
                                        color: Colors.amber),
                                    Shadow(
                                        // topLeft
                                        offset: Offset(-1.5, 1.5),
                                        color: Colors.red),
                                  ],
                                ),
                              ),
                              onSaved: (String? value) {
                                user.email = value!;
                              },
                              validator: (String? value) {
                                String pattern =
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                                if (value == null || value.isEmpty) {
                                  return "Email address must not be empty";
                                } else if (!RegExp(pattern).hasMatch(value)) {
                                  return "Email address is incorrect !";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(40, 8, 8, 8),
                            child: TextFormField(
                              style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Windy-Wood-Demo',
                                fontSize: 20,
                              ),
                              obscureText: true,
                              cursorColor: Colors.amber,
                              keyboardType: TextInputType.emailAddress,
                              initialValue: user.password,
                              decoration: const InputDecoration(
                                labelText: "Password",
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                        // bottomLeft
                                        offset: Offset(-1.5, -1.5),
                                        color: Colors.red),
                                    Shadow(
                                        // bottomRight
                                        offset: Offset(1.5, -1.5),
                                        color: Colors.amber),
                                    Shadow(
                                        // topRight
                                        offset: Offset(1.5, 1.5),
                                        color: Colors.amber),
                                    Shadow(
                                        // topLeft
                                        offset: Offset(-1.5, 1.5),
                                        color: Colors.red),
                                  ],
                                ),
                              ),
                              onSaved: (String? value) {
                                user.password = value!;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Password must not be empty";
                                } else if (value.length < 5) {
                                  return "Password must have at least 5 characters";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/Images/try.png"),
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(40, 8, 8, 8),
                            child: TextFormField(
                              style: const TextStyle(
                                fontFamily: 'Windy-Wood-Demo',
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                              keyboardType: TextInputType.datetime,
                              cursorColor: Colors.amber,
                              initialValue: user.birth,
                              decoration: const InputDecoration(
                                labelText: "Birth Year",
                                hintText: 'Birth date',
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                        // bottomLeft
                                        offset: Offset(-1.5, -1.5),
                                        color: Colors.red),
                                    Shadow(
                                        // bottomRight
                                        offset: Offset(1.5, -1.5),
                                        color: Colors.amber),
                                    Shadow(
                                        // topRight
                                        offset: Offset(1.5, 1.5),
                                        color: Colors.amber),
                                    Shadow(
                                        // topLeft
                                        offset: Offset(-1.5, 1.5),
                                        color: Colors.red),
                                  ],
                                ),
                              ),
                              onSaved: (String? value) {
                                user.birth = value!;
                              },
                              validator: (value) {
                                if (isNumeric(value!)) {
                                  if (value == null || value.isEmpty) {
                                    return "Birth Year shouldn't be empty";
                                  } else if (int.parse(value.toString()) >
                                      DateTime.now().year) {
                                    return "You aren't even born yet !";
                                  } else if (int.parse(value.toString()) < 1900) {
                                    return "No one that old exists";
                                  } else if (value.length > 4) {
                                    return "Incorrect year format, please type only the year";
                                  }
                                } else {
                                  return "Incorrect year format, please type only the year";
                                }
                              },
                            ),
                          ),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/Images/try.png"),
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(40, 8, 8, 8),
                            child: TextFormField(
                              style: const TextStyle(
                                fontFamily: 'Windy-Wood-Demo',
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                              maxLines: 2,
                              cursorColor: Colors.amber,
                              initialValue: user.address,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                labelText: "Address",
                                hintText: 'Address',
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  shadows: [
                                    Shadow(
                                        // bottomLeft
                                        offset: Offset(-1.5, -1.5),
                                        color: Colors.red),
                                    Shadow(
                                        // bottomRight
                                        offset: Offset(1.5, -1.5),
                                        color: Colors.amber),
                                    Shadow(
                                        // topRight
                                        offset: Offset(1.5, 1.5),
                                        color: Colors.amber),
                                    Shadow(
                                        // topLeft
                                        offset: Offset(-1.5, 1.5),
                                        color: Colors.red),
                                  ],
                                ),
                              ),
                              onSaved: (String? value) {
                                user.address = value!;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Address must not be empty";
                                } else if (value.length < 10) {
                                  return "Address must have at least  10 characters";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/Images/try.png"),
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
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
                }),
          ),
        ),
      ],
    );
    initState() {}
  }

  @override
  void initState() {
    super.initState();
    Session.setUser(user);
  }

  updateUser(UserE user) {
    var id = FirebaseAuth.instance.currentUser!.uid;
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
      "image": user.image,
      'isAdmin': user.isAdmin,
    }).catchError((error) => print("Failed to update User  : $error"));

    FirebaseAuth.instance.currentUser!
        .updateEmail(user.email)
        .catchError((error) => print("Failed to Update User Email  : $error"));
    FirebaseAuth.instance.currentUser!.updatePassword(user.password).catchError(
        (error) => print("Failed to Update User password  : $error"));
  }

  void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              title: Text("Confirm your identity"),
              content: Text(
                  "Please confirm your idendity by loging in again and we will update your profile"),
            ));
  }
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }
}
