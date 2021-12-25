 import 'package:shared_preferences/shared_preferences.dart';

import 'entities/user.dart';

class Session{

  static late final String id;
  static late final String username;
  static late final bool isAdmin;

 static Future<void> setUser(UserE user) async
  {
    var prefs = await SharedPreferences.getInstance().then((value){return value;});
    user.id = prefs.getString("id")!;
    user.username = prefs.getString("username")!;
    user.isAdmin = prefs.getBool("isAdmin")!;
    print("From Session class Username is : "+user.username+" isAdmin: "+user.isAdmin.toString());
  }

}