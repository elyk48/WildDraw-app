import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
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
  late String _imageLink =
      "https://firebasestorage.googleapis.com/v0/b/cardgameapp-1960b.appspot.com/o/Defaultimg.png?alt=media&token=f02be4f5-e70c-4c16-8f7a-52c70cd7b0b9";

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      //_image= image as FileImage;
    });
  }

  late final UserE user = UserE.NewUser(
      "email", "password", "username", "birthdate", "address", "image", false);
  userController userC = userController();

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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

              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: user.email, password: user.password.toString());
              user.id = await FirebaseAuth.instance.currentUser!.uid;
              Map<String, dynamic> userData = {
                "username": user.username,
                "uid": user.id
              };
              user.image = _imageLink;
              await userC.addUser(user.email, user.password, user.username,
                  user.birth, user.address, user.image);

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
            Navigator.pushReplacementNamed(context, "/singin");
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
              "Register",
              style: TextStyle(
                fontFamily: 'Windy-Wood-Demo',
                fontWeight: FontWeight.bold,
              ),
            ),
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
                    margin: const EdgeInsets.fromLTRB(40, 10, 40, 5),
                    child: const Text("WildDraw",
                        textScaleFactor: 3,
                        style: TextStyle(
                            fontFamily: 'Windy-Wood-Demo',
                            color: Colors.black,
                            shadows: [
                              Shadow(
                                  // bottomLeft
                                  offset: Offset(-1.5, -1.5),
                                  color: Colors.white),
                              Shadow(
                                  // bottomRight
                                  offset: Offset(1.5, -1.5),
                                  color: Colors.white),
                              Shadow(
                                  // topRight
                                  offset: Offset(1.5, 1.5),
                                  color: Colors.white),
                              Shadow(
                                  // topLeft
                                  offset: Offset(-1.5, 1.5),
                                  color: Colors.white),
                            ])),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.fromLTRB(40, 30, 40, 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.white54,
                    radius: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(_imageLink, scale: 1),
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
                      var _image = (await ImagePicker()
                          .pickImage(source: ImageSource.gallery));
                      FirebaseStorage fs = FirebaseStorage.instance;
                      Reference rootref = fs.ref();
                      Reference picFolderRef =
                          rootref.child("profilePics").child("image");
                      File file = File(_image!.path);
                      picFolderRef
                          .putFile(file)
                          .whenComplete(() => null)
                          .then((storageTask) async {
                        String Link = await storageTask.ref.getDownloadURL();
                        print("Image Uploaded");
                        setState(() {
                          _imageLink = Link;
                        });
                      });
                    },
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/Images/try.png"),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter),
                  ),
                  margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                  child: TextFormField(
                    cursorColor: Colors.amber,
                    style: const TextStyle(
                      fontFamily: 'Windy-Wood-Demo',
                      fontSize: 20,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      errorStyle: TextStyle(
                          fontFamily: 'Windy-Wood-Demo',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color:  Colors.limeAccent
                      ),
                      labelText: "Username",
                      hintText: 'username',
                      hintStyle: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Windy-Wood-Demo',
                          fontWeight: FontWeight.bold),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
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
                      user.username = value!;
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Username shouldn't be empty";
                      } else if (value.length < 5) {
                        return "Username Should be at least 5 Characters long";
                      } else {
                        return null;
                      }
                    },
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
                  child: TextFormField(
                    style: const TextStyle(
                      fontFamily: 'Windy-Wood-Demo',
                      fontSize: 20,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Colors.amber,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      errorStyle: TextStyle(
                          fontFamily: 'Windy-Wood-Demo',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color:  Colors.limeAccent
                      ),
                      labelText: "Email",
                      hintText: 'Email',
                      hintStyle: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Windy-Wood-Demo',
                          fontWeight: FontWeight.bold),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
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
                        return "Email address shouldn't be empty";
                      } else if (!RegExp(pattern).hasMatch(value)) {
                        return "Email address format incorrect";
                      } else {
                        return null;
                      }
                    },
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
                  child: TextFormField(
                    style: const TextStyle(
                      fontFamily: 'Windy-Wood-Demo',
                      fontSize: 20,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    obscureText: true,
                    cursorColor: Colors.amber,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      errorStyle: TextStyle(
                          fontFamily: 'Windy-Wood-Demo',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color:  Colors.limeAccent
                      ),
                      labelText: "Password",
                      hintText: "At least 5 characters long",
                      hintStyle: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Windy-Wood-Demo',
                          fontWeight: FontWeight.bold),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
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
                      user.password = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password shouldn't be empty";
                      } else if (value.length < 5) {
                        return "Password should be at least 5 characters long";
                      } else {
                        return null;
                      }
                    },
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
                  child: TextFormField(
                    style: const TextStyle(
                      fontFamily: 'Windy-Wood-Demo',
                      fontSize: 20,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    keyboardType: TextInputType.datetime,
                    cursorColor: Colors.amber,
                    decoration: const InputDecoration(
                      errorStyle: TextStyle(
                          fontFamily: 'Windy-Wood-Demo',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color:  Colors.limeAccent
                      ),
                      labelText: "Birth date",
                      hintText: 'exp:1998',
                      hintStyle: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Windy-Wood-Demo',
                          fontWeight: FontWeight.bold),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
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
                Container(
                  alignment: Alignment.topCenter,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/Images/try.png"),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter),
                  ),
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontFamily: 'Windy-Wood-Demo',
                      fontSize: 20,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Colors.amber,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      errorStyle: TextStyle(
                          fontFamily: 'Windy-Wood-Demo',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color:  Colors.limeAccent
                      ),
                      labelText: "Address",
                      hintText: 'Address',
                      hintStyle: TextStyle(
                          color: Colors.black87,
                          fontFamily: 'Windy-Wood-Demo',
                          fontWeight: FontWeight.bold),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
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
                      user.address = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Address shouldn't be empty";
                      } else if (value.length < 10) {
                        return "Address should at least be 10 characters long";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Validatebtn,
                    const SizedBox(
                      width: 30,
                    ),
                    Cancelbtn,
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }
}
