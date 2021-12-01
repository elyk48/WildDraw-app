import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BugReportForm extends StatefulWidget {
  late final GlobalKey<FormState> _keyForm;


  BugReportForm.newFrom(this._keyForm);

  @override
  State<BugReportForm> createState() => _BugReportFormState();
}

class _BugReportFormState extends State<BugReportForm> {
  late String _id;

  late String _reporterId;

  late String _title;

  late String _type;

  late int _severity;

  late String _details;

  late Timestamp _postedOn;

  String bug_type ="Functional error";
  String bug_severity ="Low";

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
                    _title = value!;
            },
          ),
            TextFormField(
              maxLength: 250,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: "Details",
              ),
              onSaved: (String? value) {
                _details= value!;
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
                    items: <String>["Functional error","Performance defect","Usability defect","Compatibility defect","Security defect"]
                        .map<DropdownMenuItem<String>>((String value) {
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
                DropdownButton(
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
                  items: <String>["Low","Medium","Major","Critical"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            ElevatedButton(
                onPressed:(){

            },
                child: const Text("Report"),
            )
          ],
        ),
    );
  }
}





class BugReport{
  late String _id;
  late String _reporterId;
  late String _title;
  late String _type;
  late int _severity;
  late String _details;
  late Timestamp _postedOn;

  BugReport(this._id, this._reporterId, this._title, this._type, this._severity,
      this._details, this._postedOn);

  Timestamp get postedOn => _postedOn;

  set postedOn(Timestamp value) {
    _postedOn = value;
  }

  String get details => _details;

  set details(String value) {
    _details = value;
  }

  int get severity => _severity;

  set severity(int value) {
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