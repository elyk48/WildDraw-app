import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Reset extends StatefulWidget {
  const Reset({Key? key}) : super(key: key);

  @override
  _ResetState createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  late String _email;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password "),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: ('Email'),
              ),
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton(
                onPressed: () {
                  auth.sendPasswordResetEmail(email: _email);
                  Navigator.of(context).pop();
                },
                child: const Text("Send request"),
              )
            ],
          )
        ],
      ),
    );
  }
}
