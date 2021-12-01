import 'package:cardgameapp/entities/bug_report.dart';
import 'package:flutter/material.dart';

class BugReportView extends StatefulWidget {

  const BugReportView({Key? key}) : super(key: key);

  @override
  _BugReportViewState createState() => _BugReportViewState();


}

class _BugReportViewState extends State<BugReportView> {
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bug Report"),
      ),
      body: BugReportForm.newFrom(_keyForm),
    );
  }
}
