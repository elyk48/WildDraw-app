import 'package:cardgameapp/entities/bug_report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BugReportController {
  static CollectionReference bugReports = FirebaseFirestore.instance.collection('bugreport');

  static Future<BugReport> addBugReport(BugReport bugReport) async{
    DocumentReference docRef = await bugReports.add(
        {
          'id_user':bugReport.reporterId,
          'details':bugReport.details,
          'severity': bugReport.severity,
          'type': bugReport.type,
          'title': bugReport.title,
          'postedOn': bugReport.postedOn,
        }
    );
    bugReport.id = docRef.id;
    print(bugReport.id);
    return bugReport;
  }
  static Future<List> getAllReports(List<dynamic> l) async{
    QuerySnapshot querySnapshot;
    try{
      querySnapshot = await bugReports.get();
      if(querySnapshot.docs.isNotEmpty)
      {
        for(var doc in querySnapshot.docs.toList())
        {
          Map a = {"id": doc.id,"details":doc["details"],"reporterId":doc["id_user"],"postedOn":doc["postedOn"],"severity":doc["severity"],"type":doc["type"],"title":doc["title"]};
          l.add(a);
        }
        print(l);
        return l;
      }
    }catch(e){
      print(e);
    }
    return l;
  }



}