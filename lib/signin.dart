
import 'package:cardgameapp/controllers/publicationcontroller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication_service.dart';
import 'entities/publication.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  static const String id="pzUhpd1PnmGUkEd9nUjl";
  static const String username="Anas";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: "Email",
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: "Password",
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthenticationService>().signIn(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
              Publication pub =  Publication.newPub("Helicopter !",id,username);
              publicationController PC = publicationController();
              Future<Publication> fp= PC.addPublication(pub);
            },
            child: const Text("Sign in"),
          )
        ],
      ),
    );
  }
}
