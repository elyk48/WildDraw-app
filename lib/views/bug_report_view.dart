import 'package:cardgameapp/entities/bug_report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BugReportView extends StatefulWidget {

  const BugReportView({Key? key}) : super(key: key);

  @override
  _BugReportViewState createState() => _BugReportViewState();
}

class _BugReportViewState extends State<BugReportView> {
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  late BugReport _bugReport= BugReport.Empty();
  final String id=FirebaseAuth.instance.currentUser!.uid;
  final bool isAdmin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bug Report"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BugReportForm.newFrom(_keyForm,_bugReport),
            if(isAdmin)Column(
              children: [
              const Text("Other Reports",textScaleFactor: 3),reportBugsGrid()
            ]
            )
          ],
        ),
      ),
    );
  }
}
