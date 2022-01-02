import 'package:cardgameapp/controllers/bugreportcontroller.dart';
import 'package:cardgameapp/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../session.dart';

class BugReportForm extends StatefulWidget {
  late final GlobalKey<FormState> _keyForm;
  late BugReport _bugReport;

  BugReportForm.newFrom(this._keyForm, this._bugReport);

  @override
  State<BugReportForm> createState() => _BugReportFormState();
}

class _BugReportFormState extends State<BugReportForm> {
  UserE user = UserE.NewUser(
      "email", "password", "username", "birthdate", "address", "image", false);
  String bug_type = "Functional error";
  String bug_severity = "Low";

  @override
  void initState() {
    Session.setUser(user);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._keyForm,
      child: Column(
        children: [
          TextFormField(
            maxLength: 50,
            maxLines: 1,
            decoration: const InputDecoration(
              labelText: "Title",
            ),
            onSaved: (String? value) {
              widget._bugReport._title = value!;
            },
          ),
          TextFormField(
            maxLength: 200,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: "Details",
            ),
            onSaved: (String? value) {
              widget._bugReport._details = value!;
            },
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              const Text("What kind of bug ?"),
              const SizedBox(
                width: 10,
              ),
              DropdownButton(
                value: bug_type,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.blue),
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    bug_type = newValue!;
                  });
                },
                items: <String>[
                  "Functional error",
                  "Visual Defect",
                  "Performance defect",
                  "Usability defect",
                  "Compatibility defect",
                  "Security defect"
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              const Text("What's the severity Level ?"),
              const SizedBox(
                width: 10,
              ),
              Container(
                child: DropdownButton(
                  value: bug_severity,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.blue),
                  underline: Container(
                    height: 2,
                    color: Colors.blue,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      bug_severity = newValue!;
                    });
                  },
                  items: <String>["Low", "Medium", "Major", "Critical"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              if (widget._keyForm.currentState!.validate()) {
                widget._keyForm.currentState!.save();
                if (widget._bugReport.details != "" &&
                    widget._bugReport._title != "") {
                  widget._bugReport._severity = bug_severity;
                  widget._bugReport._type = bug_type;
                  widget._bugReport._reporterId = user.id;
                  await BugReportController.addBugReport(widget._bugReport);
                  showAlertDialog(context);
                  setState(() {});
                }
              }
            },
            child: const Text("Report"),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class reportBugsGrid extends StatefulWidget {
  UserE user = UserE.NewUser(
      "email", "password", "username", "birthdate", "address", "image", false);
  late List<dynamic> _AllReports = [];
  late Future<List> _futureReports;

  @override
  _reportBugsGridState createState() => _reportBugsGridState();
}

class _reportBugsGridState extends State<reportBugsGrid> {

  Future<void> showAlertDialogDelete(BuildContext context, String id, int index) async{
    // Create button
    Widget okButton = ElevatedButton(
      child: const Text("Yes I wanna Close it"),
      onPressed: () {
        if(index>1)
          widget._AllReports.removeAt(index+1);
        else if(index==1)
          widget._AllReports.removeAt(0);
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {
          BugReportController.deleteBugReport(widget._AllReports[index]["id"]);
          widget._AllReports = <dynamic>[];
          widget._futureReports = BugReportController.getAllReports(widget._AllReports);
        });
      },
    );
    Widget NoButton = ElevatedButton(
      child: Text("Nope"),
      onPressed: (){
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {
          widget._AllReports = <dynamic>[];
          widget._futureReports = BugReportController.getAllReports(widget._AllReports);
        });
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Report"),
      content: const Text("Are you sure you want to close this report ?"),
      actions: [okButton, NoButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget._futureReports,
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          else if (snapshot.hasData) {
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget._AllReports.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Wrap(
                    children: [
                      Dismissible(
                        direction: DismissDirection.startToEnd,
                        key: Key(widget._AllReports[index]["id"]),
                        child: Container(
                          width: 400,
                          color: Colors.black26,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(
                                height: 10,
                                thickness: 3,
                                indent: 0,
                                endIndent: 0,
                                color: Colors.black,
                              ),
                              Text(widget._AllReports[index]["title"],
                                  textScaleFactor: 1.65),
                              Text(widget._AllReports[index]["type"],
                                  textScaleFactor: 1.25),
                              if (widget._AllReports[index]["severity"] ==
                                  "Medium")
                                Text(
                                  widget._AllReports[index]["severity"],
                                  textScaleFactor: 1.25,
                                  style: const TextStyle(
                                    color: Colors.purple,
                                  ),
                                ),
                              if (widget._AllReports[index]["severity"] ==
                                  "Critical")
                                Text(
                                  widget._AllReports[index]["severity"],
                                  textScaleFactor: 1.25,
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              if (widget._AllReports[index]["severity"] ==
                                  "Low")
                                Text(
                                  widget._AllReports[index]["severity"],
                                  textScaleFactor: 1.25,
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              if (widget._AllReports[index]["severity"] ==
                                  "Major")
                                Text(
                                  widget._AllReports[index]["severity"],
                                  textScaleFactor: 1.25,
                                  style: const TextStyle(
                                    color: Colors.orange,
                                  ),
                                ),
                              Text(widget._AllReports[index]["details"]),
                              const Divider(
                                height: 10,
                                thickness: 3,
                                indent: 0,
                                endIndent: 0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        onDismissed: (direction) {
                          setState(() async{
                           await showAlertDialogDelete(context,widget._AllReports[index]["id"],index);
                          });
                        },
                        background: Container(
                            color: Colors.red,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 0, 220, 0),
                              child: const Center(
                                  child: Text("Close Report",
                                      textScaleFactor: 2.5, textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white))),
                            )),
                      )
                    ],
                  );
                });
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Center(
              child: Column(
                children: const [
                  Text("Fetching Data..."),
                  SizedBox(
                    height: 5,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        });
  }

  @override
  void initState() {
    widget._futureReports = BugReportController.getAllReports(widget._AllReports);
    Session.setUser(widget.user);
    super.initState();
  }
}

class BugReport {
  late String _id;
  late String _reporterId;
  late String _title;
  late String _type;
  late String _severity;
  late String _details;
  late Timestamp _postedOn;

  BugReport(this._id, this._reporterId, this._title, this._type, this._severity,
      this._details, this._postedOn);

  BugReport.Empty() {
    _id = "";
    _reporterId = "";
    _title = "";
    _type = "";
    _severity = "";
    _details = "";
    _postedOn = Timestamp.now();
  }

  Timestamp get postedOn => _postedOn;

  set postedOn(Timestamp value) {
    _postedOn = value;
  }

  String get details => _details;

  set details(String value) {
    _details = value;
  }

  String get severity => _severity;

  set severity(String value) {
    _severity = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get reporterId => _reporterId;

  set reporterId(String value) {
    _reporterId = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = ElevatedButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
      Navigator.pushReplacementNamed(context, "/navTab");
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Report"),
    content:
        Text("Report has been sent, we will review it as soon as possible !"),
    actions: [
      okButton,
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