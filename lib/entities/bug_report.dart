import 'package:cardgameapp/controllers/bugreportcontroller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BugReportForm extends StatefulWidget {
  late final GlobalKey<FormState> _keyForm;
  late BugReport _bugReport;

  BugReportForm.newFrom(this._keyForm,this._bugReport);

  @override
  State<BugReportForm> createState() => _BugReportFormState();
}

class _BugReportFormState extends State<BugReportForm> {

  String bug_type ="Functional error";
  String bug_severity ="Low";


  String idRep ="VGvmMwarbvUJtsjAzfvHR9tvfd72";

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
                widget._bugReport._details= value!;
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
                onPressed:()async{
                  if (widget._keyForm.currentState!.validate()) {
                    widget._keyForm.currentState!.save();
                    if(widget._bugReport.details!="" && widget._bugReport._title!="")
                    {
                      widget._bugReport._severity = bug_severity;
                      widget._bugReport._type = bug_type;
                      widget._bugReport._reporterId = idRep;
                      await BugReportController.addBugReport(widget._bugReport);
                      showAlertDialog(context);

                      setState(() {

                      });
                    }
                  }
                        },
                child: const Text("Report"),
            )
          ],
        ),
    );
  }
}
class reportBugsGrid extends StatefulWidget {
  late List<dynamic> _AllReports=[];
  late Future<List> _futureReports;


  @override
  _reportBugsGridState createState() => _reportBugsGridState();
}

class _reportBugsGridState extends State<reportBugsGrid> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget._futureReports,
        builder: (context, snapshot) {
          if(snapshot.hasData)
            {
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 200
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget._AllReports.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Wrap(
                      children:[
                        Text(widget._AllReports[index]),
                        //ReportCard(widget._AllReports[index]),
                        /*if(_AllActs[index]["id_user"] == id && isAdmin) ElevatedButton(
                          onPressed: ()async{
                            await deleteActualite(_AllActs[index]["id"]);
                            setState(() {
                              _AllActs = <dynamic>[];
                              futureActs =getAllActs(_AllActs);
                            });
                          },
                          child: const Text("Delete"),
                        ),*/
                      ],
                    );
                  }
              );
            }
          else if(snapshot.hasError)
            {
              return Text(snapshot.error.toString());
            }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
    );
  }

  @override
  void initState(){
    //
    widget._futureReports = BugReportController.getAllReports(widget._AllReports);
    super.initState();
  }
}
class ReportCard extends StatelessWidget {
  late BugReport _bugReport;


  ReportCard(this._bugReport);

  @override
  Widget build(BuildContext context) {
     return Card(
      child: InkWell(
        /*onTap: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return ActualiteDetails(_id, _idUser, _title, _content, _author, _postedOn);
              }
          ));
        },*/
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_bugReport._title, textScaleFactor: 2),
                Text(_bugReport._type),
                const SizedBox(
                  height: 5,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}





class BugReport{
  late String _id;
  late String _reporterId;
  late String _title;
  late String _type;
  late String _severity;
  late String _details;
  late Timestamp _postedOn;

  BugReport(this._id, this._reporterId, this._title, this._type, this._severity,
      this._details, this._postedOn);


  BugReport.Empty(){
    _id="";
    _reporterId="";
    _title="";
    _type="";
    _severity="";
    _details="";
    _postedOn=Timestamp.now();
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
    content: Text("Report has been sent, we will review it as soon as possible !"),
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