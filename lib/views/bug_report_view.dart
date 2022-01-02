import 'package:cardgameapp/entities/bug_report.dart';
import 'package:cardgameapp/entities/user.dart';
import 'package:flutter/material.dart';

import '../session.dart';

class BugReportView extends StatefulWidget {
  const BugReportView({Key? key}) : super(key: key);

  @override
  _BugReportViewState createState() => _BugReportViewState();
}

class _BugReportViewState extends State<BugReportView> {
  UserE user = UserE.NewUser(
      "email", "password", "username", "birthdate", "address", "image", false);
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  late BugReport _bugReport = BugReport.Empty();

  @override
  void initState() {
    super.initState();
    Session.setUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bug Report"),
      ),
      body: FutureBuilder(
        future: Session.setUser(user),
        builder: (context, snapshot) {
          if (!snapshot.hasError) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  BugReportForm.newFrom(_keyForm, _bugReport),
                  if (user.isAdmin)
                    Column(children: [
                      const Text("Other Reports", textScaleFactor: 3),
                      reportBugsGrid()
                    ])
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
